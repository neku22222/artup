import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/dm_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const ArtUpApp());
}

class ArtUpApp extends StatelessWidget {
  const ArtUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtUp',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Screens (keep alive when switching)
  static const List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    SizedBox.shrink(), // placeholder – upload is a modal-style screen
    DMScreen(),
    SettingsScreen(),
  ];

  // App bar configs per tab
  static const List<_TabConfig> _tabConfigs = [
    _TabConfig(title: 'ArtUp', showLogo: true, showNotif: true),
    _TabConfig(title: 'Discover', showLogo: false, showNotif: false),
    _TabConfig(title: 'New Post', showLogo: false, showNotif: false),
    _TabConfig(title: 'ArtUp', showLogo: true, showNotif: false, showCompose: true),
    _TabConfig(title: 'ArtUp', showLogo: true, showNotif: false),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      // Upload — push as a new route so it has its own scroll area
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const _UploadPage(),
          fullscreenDialog: true,
        ),
      );
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _tabConfigs[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        centerTitle: true,
        title: cfg.showLogo
            ? Text(
                'ArtUp',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: AppColors.peach,
                ),
              )
            : Text(
                cfg.title,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark,
                ),
              ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
        actions: [
          if (cfg.showNotif)
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.peach),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Notifications'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),
          if (cfg.showCompose)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.peach),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('New message'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.warmWhite,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', index: 0, currentIndex: _currentIndex, onTap: _onTabTapped),
                _NavItem(icon: Icons.search_outlined, activeIcon: Icons.search, label: 'Search', index: 1, currentIndex: _currentIndex, onTap: _onTabTapped),
                _UploadNavButton(onTap: () => _onTabTapped(2)),
                _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'DM', index: 3, currentIndex: _currentIndex, onTap: _onTabTapped),
                _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', index: 4, currentIndex: _currentIndex, onTap: _onTabTapped),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabConfig {
  final String title;
  final bool showLogo;
  final bool showNotif;
  final bool showCompose;
  const _TabConfig({required this.title, required this.showLogo, this.showNotif = false, this.showCompose = false});
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon, required this.activeIcon, required this.label,
    required this.index, required this.currentIndex, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? activeIcon : icon,
                color: isActive ? AppColors.peach : AppColors.muted, size: 24),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.dmSans(
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.peach : AppColors.muted,
                )),
          ],
        ),
      ),
    );
  }
}

class _UploadNavButton extends StatelessWidget {
  final VoidCallback onTap;
  const _UploadNavButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.peach, AppColors.amber],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.peach.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }
}

// Upload as a full-page modal route
class _UploadPage extends StatelessWidget {
  const _UploadPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.dark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('New Post',
            style: GoogleFonts.dmSans(
                fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.dark)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: const UploadScreen(),
    );
  }
}
