import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Persistent bottom-navigation shell that hosts the four root tabs using
/// [IndexedStack] so each tab's scroll/widget state is preserved.
class MainNavigationShell extends StatefulWidget {
  /// Tab index to make active initially (for "Explore Shows" deep links).
  final int initialIndex;

  const MainNavigationShell({super.key, this.initialIndex = 0});

  /// Expose the shell state so nested widgets can switch tabs.
  static MainNavigationShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainNavigationShellState>();

  @override
  State<MainNavigationShell> createState() => MainNavigationShellState();
}

class MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        // Tab bodies are injected by the router.
        children: _tabBodies,
      ),
      bottomNavigationBar: _BottomBar(
        currentIndex: _currentIndex,
        onTap: switchTab,
      ),
    );
  }
}

// Imported lazily to avoid circular imports.
List<Widget> get _tabBodies {
  // These are set up in main.dart via _TabRegistry.
  return _TabRegistry.bodies;
}

/// Singleton registry so main.dart can inject tab bodies at startup.
class _TabRegistry {
  static List<Widget> bodies = const [
    _PlaceholderTab('Home'),
    _PlaceholderTab('Search'),
    _PlaceholderTab('Watchlist'),
    _PlaceholderTab('Profile'),
  ];
}

/// Call this once in main.dart before runApp to register actual screens.
void registerTabBodies(List<Widget> bodies) {
  _TabRegistry.bodies = bodies;
}

class _PlaceholderTab extends StatelessWidget {
  final String name;
  const _PlaceholderTab(this.name);
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(name, style: const TextStyle(color: Colors.white)));
}

class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_rounded),
            activeIcon: Icon(Icons.favorite_rounded),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
