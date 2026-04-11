import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  int _visibility = 0; // 0=Public 1=Followers 2=Private
  String _category = '2D Illustration';
  final List<String> _tags = ['#2D', '#Portrait', '#DigitalArt'];
  final List<String> _categories = [
    '2D Illustration', '3D / CGI', 'Photography',
    'Traditional / Oil Paint', 'Sketch / Line Art', 'Animation / GIF',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload zone
          GestureDetector(
            onTap: () => _snack('File picker would open here'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: AppColors.peachPale,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.peachLight, width: 2,
                    style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  const Text('🖼️', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text('Upload Your Artwork',
                      style: GoogleFonts.dmSans(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.brown)),
                  const SizedBox(height: 3),
                  Text('JPG, PNG, GIF, MP4 · Max 50MB',
                      style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          _label('Title'),
          const SizedBox(height: 5),
          TextField(
            style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.dark),
            decoration: const InputDecoration(hintText: 'Name your work…'),
          ),
          const SizedBox(height: 14),

          // Description
          _label('Description'),
          const SizedBox(height: 5),
          TextField(
            maxLines: 3,
            style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.dark),
            decoration: const InputDecoration(
              hintText: 'Share your process, inspiration, tools used…',
            ),
          ),
          const SizedBox(height: 14),

          // Tags
          _label('Tags'),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ..._tags.map((tag) => _tagChip(tag)),
              GestureDetector(
                onTap: () => _snack('Add a tag…'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.peachLight, width: 1.5,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('+ Add tag',
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.peach)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Visibility
          _label('Visibility'),
          const SizedBox(height: 5),
          Row(
            children: [
              _visBtn('🌍 Public', 0),
              const SizedBox(width: 8),
              _visBtn('👥 Followers', 1),
              const SizedBox(width: 8),
              _visBtn('🔒 Private', 2),
            ],
          ),
          const SizedBox(height: 14),

          // Category
          _label('Category'),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _category,
                isExpanded: true,
                style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.dark),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Post button
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.peach, AppColors.amber],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.peach.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _snack('Artwork posted! 🎉'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Post Artwork',
                    style: GoogleFonts.dmSans(
                        fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text.toUpperCase(),
        style: GoogleFonts.dmSans(
            fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 0.5),
      );

  Widget _tagChip(String tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.peachPale,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.peachLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tag, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.brown)),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => setState(() => _tags.remove(tag)),
              child: Text('✕',
                  style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.muted)),
            ),
          ],
        ),
      );

  Widget _visBtn(String label, int index) => Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _visibility = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: _visibility == index ? AppColors.peach : AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _visibility == index ? AppColors.peach : AppColors.border,
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _visibility == index ? Colors.white : AppColors.muted,
              ),
            ),
          ),
        ),
      );

  void _snack(String msg) {
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
