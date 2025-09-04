import 'package:attandance_simple/core/presentation/screen/info_ekskul_screen.dart';
import 'package:attandance_simple/core/presentation/screen/profile_screen.dart';
import 'package:attandance_simple/core/presentation/screen/race_screen.dart';
import 'package:flutter/material.dart';
import 'package:attandance_simple/core/component/color_component.dart';

// Halaman root per tab
import 'package:attandance_simple/core/presentation/screen/home_screen.dart';
import 'package:attandance_simple/core/presentation/screen/studi_screen.dart';
import 'package:attandance_simple/core/presentation/screen/studi_ekskul_screen.dart';
import 'package:attandance_simple/core/presentation/screen/setting_screen.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});
  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int _index = 0;

  // Satu navigator per tab
  final _tabNavKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  // --- ROUTE FACTORY PER TAB ---

  Route _homeRoutes(RouteSettings s) {
    switch (s.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: s,
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: s,
        );
      // tambah route lain khusus tab Home di sini
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: s,
        );
    }
  }

  Route _studiRoutes(RouteSettings s) {
    switch (s.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const StudiScreen(),
          settings: s,
        );
      // case '/studi/detail': return MaterialPageRoute(builder: (_) => const StudiDetailScreen(), settings: s);
      default:
        return MaterialPageRoute(
          builder: (_) => const StudiScreen(),
          settings: s,
        );
    }
  }

  Route _ekskulRoutes(RouteSettings s) {
    switch (s.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const InfoEkskulScreen(),
          settings: s,
        );
      case '/ekskul':
        return MaterialPageRoute(
          builder: (_) => const StudiEkskulScreen(),
          settings: s,
        );
        case '/lomba':
        return MaterialPageRoute(
          builder: (_) => const RaceScreen(),
          settings: s,
        );
      // case '/ekskul/detail':  return MaterialPageRoute(builder: (_) => const EkskulDetailScreen(), settings: s);
      default:
        return MaterialPageRoute(
          builder: (_) => const InfoEkskulScreen(),
          settings: s,
        );
    }
  }

  Route _settingRoutes(RouteSettings s) {
    switch (s.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SettingScreen(),
          settings: s,
        );
      // case '/setting/akun':    return MaterialPageRoute(builder: (_) => const SettingAkunScreen(), settings: s);
      default:
        return MaterialPageRoute(
          builder: (_) => const SettingScreen(),
          settings: s,
        );
    }
  }

  Widget _buildTabNavigator({
    required int tabIndex,
    required RouteFactory onGenerateRoute,
  }) {
    return Navigator(
      key: _tabNavKeys[tabIndex],
      onGenerateRoute: onGenerateRoute,
    );
  }

  // Tombol back Android: pop dulu di tab aktif, kalau habis baru keluar / pindah tab
  Future<bool> _onWillPop() async {
    final nav = _tabNavKeys[_index].currentState!;
    if (nav.canPop()) {
      nav.pop();
      return false;
    }
    if (_index != 0) {
      setState(() => _index = 0);
      return false;
    }
    return true; // benar-benar keluar app
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: ColorComponent.bgColor,
        body: IndexedStack(
          index: _index,
          children: [
            _buildTabNavigator(tabIndex: 0, onGenerateRoute: _homeRoutes),
            _buildTabNavigator(tabIndex: 1, onGenerateRoute: _studiRoutes),
            _buildTabNavigator(tabIndex: 2, onGenerateRoute: _ekskulRoutes),
            _buildTabNavigator(tabIndex: 3, onGenerateRoute: _settingRoutes),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorComponent.bgColor,
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedItemColor: ColorComponent.iconColor,
          unselectedItemColor: ColorComponent.boldText,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Students'),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_kabaddi),
              label: 'Ekskul',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
