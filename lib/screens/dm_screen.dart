import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models.dart';
import '../widgets/common_widgets.dart';
import '../theme/app_theme.dart';

class DMScreen extends StatelessWidget {
  const DMScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recent = SampleData.chats.where((c) => c.unreadCount > 0 || c.time.contains('m') || c.time.contains('h')).toList();
    final earlier = SampleData.chats.where((c) => c.unreadCount == 0 && !c.time.contains('m') && !c.time.contains('h')).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: AppSearchBar(hint: 'Search conversations…'),
        ),
        Expanded(
          child: ListView(
            children: [
              _divider('Recent'),
              ...recent.map((c) => _ChatTile(chat: c)),
              _divider('Earlier'),
              ...earlier.map((c) => _ChatTile(chat: c)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider(String label) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
              fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1),
        ),
      );
}

class _ChatTile extends StatelessWidget {
  final ChatModel chat;
  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening chat with ${chat.name}…'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar with online dot
            Stack(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: chat.avatarUrl,
                    width: 46, height: 46, fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.border, width: 46, height: 46),
                    errorWidget: (_, __, ___) => Container(color: AppColors.border, width: 46, height: 46,
                        child: const Icon(Icons.person, color: AppColors.muted)),
                  ),
                ),
                if (chat.isOnline)
                  Positioned(
                    bottom: 1, right: 1,
                    child: Container(
                      width: 11, height: 11,
                      decoration: BoxDecoration(
                        color: AppColors.onlineGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cream, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chat.name,
                      style: GoogleFonts.dmSans(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark)),
                  const SizedBox(height: 2),
                  Text(chat.preview,
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Time + badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat.time,
                    style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.muted)),
                const SizedBox(height: 4),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.peach,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: GoogleFonts.dmSans(
                          fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
