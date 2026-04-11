import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stories
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: SampleData.stories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => StoryRing(story: SampleData.stories[i]),
            ),
          ),

          // Recommended
          SectionHeader(title: 'Recommended for you', actionLabel: 'See all', onAction: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 4 / 3,
              ),
              itemCount: 4,
              itemBuilder: (_, i) => ArtworkCard(
                artwork: SampleData.recommended[i],
                onTap: () => _showSnack(context, 'Opening ${SampleData.recommended[i].title}…'),
              ),
            ),
          ),

          // Creators to follow
          SectionHeader(title: 'Creators to follow', actionLabel: 'Browse', onAction: () {}),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
              itemCount: SampleData.creators.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => CreatorCard(creator: SampleData.creators[i]),
            ),
          ),

          // Explore
          SectionHeader(title: 'Explore', actionLabel: 'See all', onAction: () {}),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 4 / 3,
              ),
              itemCount: 2,
              itemBuilder: (_, i) => ArtworkCard(
                artwork: SampleData.recommended[i + 4],
                onTap: () => _showSnack(context, 'Opening ${SampleData.recommended[i + 4].title}…'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
