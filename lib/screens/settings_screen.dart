import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models.dart';
import '../services/supabase_service.dart';
import '../widgets/common_widgets.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ProfileModel? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await profileService.getMyProfile();
    if (mounted) setState(() { _profile = p; _loading = false; });
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Log out', style: TextStyle(color: AppColors.errorRed))),
        ],
      ),
    );
    if (confirmed == true) await authService.logout();
    // AuthState listener in main.dart will navigate to login automatically
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator(color: AppColors.peach))
        : SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Profile card
              GestureDetector(
                onTap: _profile != null
                    ? () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProfileScreen(userId: _profile!.id)))
                    : null,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(children: [
                    UserAvatar(url: _profile?.avatarUrl ?? '', size: 56),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_profile?.fullName.isNotEmpty == true ? _profile!.fullName : 'Your Name',
                            style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark)),
                        Text('@${_profile?.handle ?? ''}',
                            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                        const SizedBox(height: 8),
                        Row(children: [
                          _statItem('${_profile?.postsCount ?? 0}', 'Works'),
                          const SizedBox(width: 14),
                          _statItem('${_profile?.followersCount ?? 0}', 'Followers'),
                          const SizedBox(width: 14),
                          _statItem('${_profile?.followingCount ?? 0}', 'Following'),
                        ]),
                      ]),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.muted, size: 18),
                  ]),
                ),
              ),

              _sectionLabel('Account'),
              _settingsGroup(context, [
                _Row(icon: '👤', iconBg: const Color(0xFFFDE8D8), label: 'Your Profile',
                    onTap: () => _profile != null ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProfileScreen(userId: _profile!.id))) : null),
                _Row(icon: '🔒', iconBg: const Color(0xFFDFF0E4), label: 'Security & Password',
                    onTap: () => _snack('Security settings')),
                _Row(icon: '🔗', iconBg: const Color(0xFFE0EEFF), label: 'Linked Accounts',
                    onTap: () => _snack('Linked accounts')),
              ]),

              _sectionLabel('Preferences'),
              _settingsGroup(context, [
                _Row(icon: '🔔', iconBg: const Color(0xFFFFF0D8), label: 'Notifications',
                    onTap: () => _snack('Notifications')),
                _Row(icon: '🖥️', iconBg: const Color(0xFFEDE0FF), label: 'Display Settings',
                    onTap: () => _snack('Display settings')),
                _Row(icon: '🌐', iconBg: const Color(0xFFE0EEFF), label: 'Language', value: 'English',
                    onTap: () => _snack('Language')),
              ]),

              _sectionLabel('Support'),
              _settingsGroup(context, [
                _Row(icon: '❓', iconBg: const Color(0xFFF0F0F0), label: 'Help & Support',
                    onTap: () => _snack('Help')),
                _Row(icon: '⭐', iconBg: const Color(0xFFF0F0F0), label: 'Credits',
                    onTap: () => _snack('Credits')),
                _Row(icon: '🚪', iconBg: const Color(0xFFFFEEEE), label: 'Log Out',
                    labelColor: AppColors.errorRed, showArrow: false, onTap: _logout),
              ]),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('ArtUp v1.0.0',
                    style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
              ),
            ]),
          );
  }

  Widget _statItem(String v, String l) => Column(children: [
    Text(v, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.dark)),
    Text(l, style: GoogleFonts.dmSans(fontSize: 9, color: AppColors.muted)),
  ]);

  Widget _sectionLabel(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
    child: Text(t.toUpperCase(),
        style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
  );

  Widget _settingsGroup(BuildContext context, List<_Row> rows) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border)),
      child: Column(children: rows.asMap().entries.map((e) {
        final i = e.key; final row = e.value;
        return Column(children: [
          InkWell(
            onTap: row.onTap,
            borderRadius: BorderRadius.vertical(
              top: i == 0 ? const Radius.circular(16) : Radius.zero,
              bottom: i == rows.length - 1 ? const Radius.circular(16) : Radius.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(children: [
                Container(width: 32, height: 32,
                    decoration: BoxDecoration(color: row.iconBg, borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center,
                    child: Text(row.icon, style: const TextStyle(fontSize: 16))),
                const SizedBox(width: 12),
                Expanded(child: Text(row.label,
                    style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500,
                        color: row.labelColor ?? AppColors.dark))),
                if (row.value != null)
                  Text(row.value!, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                if (row.showArrow) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, color: AppColors.muted, size: 18),
                ],
              ]),
            ),
          ),
          if (i < rows.length - 1)
            const Divider(height: 1, thickness: 1, color: AppColors.border, indent: 14, endIndent: 14),
        ]);
      }).toList()),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
  }
}

class _Row {
  final String icon, label;
  final Color iconBg;
  final Color? labelColor;
  final String? value;
  final bool showArrow;
  final VoidCallback? onTap;
  const _Row({required this.icon, required this.iconBg, required this.label,
      this.labelColor, this.value, this.showArrow = true, this.onTap});
}
