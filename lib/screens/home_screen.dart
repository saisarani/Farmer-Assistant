import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather/weather_screen.dart';
import 'market/market_screen.dart';
import 'schemes/schemes_screen.dart';
import 'diary/diary_screen.dart';
import 'assistant/assistant_screen.dart';
import 'disease/disease_detection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Farm background image from internet
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1a2e1a), Color(0xFF4a8c4a)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          // Dark overlay for readability
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCC0d1f0d),
                    Color(0xAA1a3a1a),
                    Color(0x881a3a1a),
                    Color(0xDD0d1f0d),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: -50, right: -50,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 70, right: 10,
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  _buildWeatherHero(),
                  _buildAiSuggestionCard(context),
                  const SizedBox(height: 20),
                  _buildSectionLabel('Quick Access'),
                  const SizedBox(height: 12),
                  _buildQuickGrid(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rythu Sahayak.',
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.white60, size: 12),
                  const SizedBox(width: 3),
                  Text(
                    'Guntur, Andhra Pradesh',
                    style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getFormattedDate(),
                style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '33',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.w300,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      '°C',
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Partly Cloudy · Guntur',
                style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              children: [
                const Icon(Icons.grain_rounded, color: Colors.white, size: 28),
                const SizedBox(height: 6),
                Text('Rain 60%',
                    style: GoogleFonts.dmSans(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.arrow_upward_rounded, color: Colors.white70, size: 12),
                    Text(' 33°',
                        style: GoogleFonts.dmSans(color: Colors.white70, fontSize: 12)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_downward_rounded, color: Colors.white70, size: 12),
                    Text(' 24°',
                        style: GoogleFonts.dmSans(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  Widget _buildAiSuggestionCard(BuildContext context) {
    final suggestions = [
      _Suggestion(Icons.eco_rounded, 'Sow Rice Seeds', 'Perfect weather for sowing today'),
      _Suggestion(Icons.water_drop_rounded, 'Irrigate Fields', 'Soil moisture is low in plot B'),
      _Suggestion(Icons.bug_report_rounded, 'Check for Pests', 'Pest risk detected this week'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Today's AI Suggestion",
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const AssistantScreen())),
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...suggestions.map((s) => _suggestionTile(s)),
          ],
        ),
      ),
    );
  }

  Widget _suggestionTile(_Suggestion s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(s.icon, color: Colors.white, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.title,
                      style: GoogleFonts.dmSans(
                          color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(s.subtitle,
                      style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38, size: 13),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white60,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildQuickGrid(BuildContext context) {
    final items = [
  	_GridItem('Weather', Icons.cloud_rounded, '60% rain today', WeatherScreen()),
  	_GridItem('Market', Icons.bar_chart_rounded, '₹2,350 Rice/qtl', MarketScreen()),
  	_GridItem('Schemes', Icons.account_balance_rounded, '6 schemes open', SchemesScreen()),
  	_GridItem('Farm Diary', Icons.menu_book_rounded, "Add today's note", DiaryScreen()),
        _GridItem('Disease AI', Icons.biotech_rounded, 'Scan crop disease', DiseaseDetectionScreen()),
];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
        children: items.map((item) => _buildGridCard(context, item)).toList(),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, _GridItem item) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => item.screen)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: Colors.white, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: GoogleFonts.dmSans(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(item.subtitle,
                    style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Suggestion {
  final IconData icon;
  final String title;
  final String subtitle;
  const _Suggestion(this.icon, this.title, this.subtitle);
}

class _GridItem {
  final String title;
  final IconData icon;
  final String subtitle;
  final Widget screen;
  const _GridItem(this.title, this.icon, this.subtitle, this.screen);
}