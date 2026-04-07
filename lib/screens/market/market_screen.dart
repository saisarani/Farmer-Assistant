import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Grains', 'Vegetables', 'Fruits'];

  final List<_CropPrice> _allCrops = [
    _CropPrice('Rice', 'Guntur APMC', 2350, 2280, '🌾', 'Grains'),
    _CropPrice('Maize', 'Tenali Market', 1820, 1900, '🌽', 'Grains'),
    _CropPrice('Red Chilli', 'Guntur APMC', 15200, 14800, '🌶', 'Vegetables'),
    _CropPrice('Tomato', 'Vijayawada', 1200, 900, '🍅', 'Vegetables'),
    _CropPrice('Onion', 'Tenali Market', 1450, 1600, '🧅', 'Vegetables'),
    _CropPrice('Cotton', 'Guntur APMC', 6800, 6950, '🌿', 'Grains'),
    _CropPrice('Banana', 'Eluru Market', 2200, 2100, '🍌', 'Fruits'),
    _CropPrice('Mango', 'Vijayawada', 4500, 4200, '🥭', 'Fruits'),
  ];

  List<_CropPrice> get _filteredCrops {
    if (_selectedTab == 0) return _allCrops;
    return _allCrops.where((c) => c.category == _tabs[_selectedTab]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1a3a1a)),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xDD0d1f0d), Color(0xAA1a3a1a), Color(0x881a3a1a), Color(0xDD0d1f0d)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildSummaryRow(),
                const SizedBox(height: 14),
                _buildTabs(),
                const SizedBox(height: 10),
                Expanded(child: _buildCropList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Market Prices', style: GoogleFonts.dmSans(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              Text('Guntur APMC', style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
            child: Text('Mon, 5 Apr', style: GoogleFonts.dmSans(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    final risers = _allCrops.where((c) => c.currentPrice >= c.previousPrice).length;
    final fallers = _allCrops.length - risers;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _summaryCard('↑ Risers', '$risers', const Color(0x337fff7f), const Color(0xFF7fff7f)),
          const SizedBox(width: 8),
          _summaryCard('↓ Fallers', '$fallers', const Color(0x33ff9090), const Color(0xFFff9090)),
          const SizedBox(width: 8),
          _summaryCard('Markets', '4', Colors.white.withOpacity(0.15), Colors.white),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: GoogleFonts.dmSans(
                fontSize: 20, fontWeight: FontWeight.w700, color: textColor)),
            Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: textColor.withOpacity(0.75))),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = _selectedTab == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? Colors.white : Colors.white.withOpacity(0.20)),
              ),
              child: Text(_tabs[i], style: GoogleFonts.dmSans(
                fontSize: 13, fontWeight: FontWeight.w500,
                color: selected ? const Color(0xFF1a3a1a) : Colors.white70,
              )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCropList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: _filteredCrops.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _cropCard(_filteredCrops[i]),
    );
  }

  Widget _cropCard(_CropPrice crop) {
    final isUp = crop.currentPrice >= crop.previousPrice;
    final diff = (crop.currentPrice - crop.previousPrice).abs();
    final pct = (diff / crop.previousPrice * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(crop.emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(crop.name, style: GoogleFonts.dmSans(
                    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                Text(crop.market, style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white60)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${crop.currentPrice}/q', style: GoogleFonts.dmSans(
                  fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isUp
                      ? const Color(0x337fff7f)
                      : const Color(0x33ff9090),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      size: 11,
                      color: isUp ? const Color(0xFF7fff7f) : const Color(0xFFff9090),
                    ),
                    const SizedBox(width: 2),
                    Text('$pct%', style: GoogleFonts.dmSans(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: isUp ? const Color(0xFF7fff7f) : const Color(0xFFff9090),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CropPrice {
  final String name, market, emoji, category;
  final int currentPrice, previousPrice;
  const _CropPrice(this.name, this.market, this.currentPrice, this.previousPrice, this.emoji, this.category);
}