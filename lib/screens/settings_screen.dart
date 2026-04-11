import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.peachLight, width: 3),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: 'https://i.pravatar.cc/56?img=60',
                      width: 56, height: 56, fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Name',
                          style: GoogleFonts.dmSans(
                              fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark)),
                      Text('@yourhandle',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _statItem('248', 'Works'),
                          const SizedBox(width: 14),
                          _statItem('1.4k', 'Followers'),
                          const SizedBox(width: 14),
                          _statItem('312', 'Following'),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _snack(context, 'Edit profile'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.peachPale,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.peachLight, width: 1.5),
                    ),
                    child: Text('Edit',
                        style: GoogleFonts.dmSans(
                            fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.peach)),
                  ),
                ),
              ],
            ),
          ),

          // Account section
          _sectionLabel('Account'),
          _settingsGroup(context, [
            _SettingsRowData(icon: '👤', iconBg: const Color(0xFFFDE8D8), label: 'Your Profile'),
            _SettingsRowData(icon: '🔒', iconBg: const Color(0xFFDFF0E4), label: 'Security & Password'),
            _SettingsRowData(icon: '🔗', iconBg: const Color(0xFFE0EEFF), label: 'Linked Accounts'),
          ]),

          // Preferences section
          _sectionLabel('Preferences'),
          _settingsGroup(context, [
            _SettingsRowData(icon: '🔔', iconBg: const Color(0xFFFFF0D8), label: 'Notifications'),
            _SettingsRowData(icon: '🖥️', iconBg: const Color(0xFFEDE0FF), label: 'Display Settings'),
            _SettingsRowData(icon: '🌐', iconBg: const Color(0xFFE0EEFF), label: 'Language', value: 'English'),
          ]),

          // Support section
          _sectionLabel('Support'),
          _settingsGroup(context, [
            _SettingsRowData(icon: '❓', iconBg: const Color(0xFFF0F0F0), label: 'Help & Support'),
            _SettingsRowData(icon: '⭐', iconBg: const Color(0xFFF0F0F0), label: 'Credits'),
            _SettingsRowData(
              icon: '🚪',
              iconBg: const Color(0xFFFFEEEE),
              label: 'Log Out',
              labelColor: AppColors.errorRed,
              showArrow: false,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) => Column(
        children: [
          Text(value,
              style: GoogleFonts.dmSans(
                  fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.dark)),
          Text(label,
              style: GoogleFonts.dmSans(fontSize: 9, color: AppColors.muted)),
        ],
      );

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
              fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1),
        ),
      );

  Widget _settingsGroup(BuildContext context, List<_SettingsRowData> rows) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final i = entry.key;
          final row = entry.value;
          return Column(
            children: [
              InkWell(
                onTap: () => _snack(context, row.label),
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: i == rows.length - 1 ? const Radius.circular(16) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(color: row.iconBg, borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: Text(row.icon, style: const TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(row.label,
                            style: GoogleFonts.dmSans(
                                fontSize: 13, fontWeight: FontWeight.w500,
                                color: row.labelColor ?? AppColors.dark)),
                      ),
                      if (row.value != null)
                        Text(row.value!,
                            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                      if (row.showArrow) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: AppColors.muted, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
              if (i < rows.length - 1)
                const Divider(height: 1, thickness: 1, color: AppColors.border, indent: 14, endIndent: 14),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
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

class _SettingsRowData {
  final String icon;
  final Color iconBg;
  final String label;
  final Color? labelColor;
  final String? value;
  final bool showArrow;

  const _SettingsRowData({
    required this.icon,
    required this.iconBg,
    required this.label,
    this.labelColor,
    this.value,
    this.showArrow = true,
  });
}
