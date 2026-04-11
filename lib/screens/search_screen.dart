import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets/common_widgets.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  int _activeFilter = 0;
  final List<String> _filters = ['All', '2D', '3D', 'Photography', 'Sketch', 'Digital', 'Oil Paint'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: AppSearchBar(hint: 'Search artists, styles, tags…', controller: _ctrl),
          ),

          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => AppFilterChip(
                label: _filters[i],
                isActive: _activeFilter == i,
                onTap: () => setState(() => _activeFilter = i),
              ),
            ),
          ),

          // Section label
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              'TRENDING TAGS',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1),
            ),
          ),

          // Trending grid
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: SampleData.trendingTags.length,
              itemBuilder: (_, i) => TrendingTagCard(
                tag: SampleData.trendingTags[i],
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Browsing ${SampleData.trendingTags[i].tag}'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
