import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/weather/weather_screen.dart';
import 'screens/market/market_screen.dart';
import 'screens/schemes/schemes_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  await Hive.openBox('diaryBox');

  runApp(const RythuSahayakApp());
}


class RythuSahayakApp extends StatelessWidget {
  const RythuSahayakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rythu Sahayak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A5C2A),
          primary: const Color(0xFF1A5C2A),
          secondary: const Color(0xFF3D9E4A),
          surface: const Color(0xFFF5F2EB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F2EB),
        textTheme: GoogleFonts.dmSansTextTheme().copyWith(
          displayLarge: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
          titleLarge: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
          bodyMedium: GoogleFonts.dmSans(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1A5C2A),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE8E3D9), width: 1),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF1A5C2A),
          unselectedItemColor: Color(0xFF8A9C7E),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
home: Center(
	child: ConstrainedBox(
		constraints: const BoxConstraints(maxWidth: 430),
    		child: const MainNavigation(),
  ),
),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    WeatherScreen(),
    MarketScreen(),
    SchemesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE8E3D9), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.cloud_rounded), label: 'Weather'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Market'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_rounded), label: 'Schemes'),
          ],
        ),
      ),
    );
  }
}