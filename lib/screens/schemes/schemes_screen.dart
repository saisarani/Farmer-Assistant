import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Central', 'State', 'Loans'];

  final List<_Scheme> _schemes = [
    _Scheme(
      name: 'PM-KISAN',
      description: '₹6,000/year income support to eligible farmer families in 3 installments of ₹2,000 each.',
      icon: '₹',
      iconBg: const Color(0x337fff7f),
      tag: 'Central',
      tagBg: const Color(0x22ffffff),
      tagColor: Colors.white70,
      deadline: 'Open',
      applyUrl: 'https://pmkisan.gov.in',
      eligibility: [
        'Small and marginal farmers',
        'Must own cultivable land',
        'Valid Aadhaar card required',
        'Linked bank account needed',
      ],
    ),
    _Scheme(
      name: 'Rythu Bandhu',
      description: '₹10,000/acre per season investment support directly to farmers in Andhra Pradesh.',
      icon: '🌾',
      iconBg: const Color(0x33ffcc55),
      tag: 'State (AP)',
      tagBg: const Color(0x33ffcc55),
      tagColor: const Color(0xFFffcc55),
      deadline: 'Open',
      applyUrl: 'https://rythubandhu.telangana.gov.in',
      eligibility: [
        'AP resident farmer',
        'Must own agricultural land',
        'Pattadar Passbook required',
        'Registered in AP Farmer database',
      ],
    ),
    _Scheme(
      name: 'PMFBY',
      description: 'Crop insurance scheme that protects farmers against losses due to natural calamities.',
      icon: '🛡',
      iconBg: const Color(0x3390c8ff),
      tag: 'Central',
      tagBg: const Color(0x3390c8ff),
      tagColor: const Color(0xFF90c8ff),
      deadline: 'Mar 31',
      applyUrl: 'https://pmfby.gov.in',
      eligibility: [
        'All farmers growing notified crops',
        'Loanee farmers enrolled automatically',
        'Non-loanee farmers can apply voluntarily',
        'Valid land records required',
      ],
    ),
    _Scheme(
      name: 'KCC Loan',
      description: 'Short-term credit at 4% interest rate for crop production, post-harvest expenses and more.',
      icon: '💳',
      iconBg: const Color(0x33cc90ff),
      tag: 'Loans',
      tagBg: const Color(0x33cc90ff),
      tagColor: const Color(0xFFcc90ff),
      deadline: 'Open',
      applyUrl: 'https://www.nabard.org/content1.aspx?id=580',
      eligibility: [
        'All farmers including tenant farmers',
        'SHG or Joint Liability Groups',
        'Valid ID and address proof',
        'Land ownership or lease documents',
      ],
    ),
    _Scheme(
      name: 'Soil Health Card',
      description: 'Free soil testing and crop-wise nutrient recommendations for better yield.',
      icon: '🌱',
      iconBg: const Color(0x337fff7f),
      tag: 'Central',
      tagBg: const Color(0x22ffffff),
      tagColor: Colors.white70,
      deadline: 'Open',
      applyUrl: 'https://soilhealth.dac.gov.in',
      eligibility: [
        'All farmers with agricultural land',
        'Apply at nearest Krishi Vigyan Kendra',
        'Aadhaar card required',
        'Free of cost scheme',
      ],
    ),
    _Scheme(
      name: 'AP Micro Irrigation',
      description: 'Subsidy up to 90% for drip and sprinkler irrigation systems for water conservation.',
      icon: '💧',
      iconBg: const Color(0x3390c8ff),
      tag: 'State (AP)',
      tagBg: const Color(0x33ffcc55),
      tagColor: const Color(0xFFffcc55),
      deadline: 'Apr 15',
      applyUrl: 'https://apagrisnet.gov.in',
      eligibility: [
        'AP resident farmer',
        'Minimum 0.5 acre land holding',
        'Water source availability required',
        'Apply through Agriculture Department',
      ],
    ),
  ];

  List<_Scheme> get _filtered {
    if (_selectedTab == 0) return _schemes;
    return _schemes.where((s) => s.tag.contains(_tabs[_selectedTab])).toList();
  }

  void _showSchemeDetails(BuildContext context, _Scheme scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1a3a1a),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: scheme.iconBg, borderRadius: BorderRadius.circular(14)),
                  child: Center(child: Text(scheme.icon, style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scheme.name, style: GoogleFonts.dmSans(
                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          _pill(scheme.tag, scheme.tagBg, scheme.tagColor),
                          const SizedBox(width: 6),
                          _pill(
                            scheme.deadline == 'Open' ? '✓ Open' : '⏰ ${scheme.deadline}',
                            scheme.deadline == 'Open' ? const Color(0x337fff7f) : const Color(0x33ff9090),
                            scheme.deadline == 'Open' ? const Color(0xFF7fff7f) : const Color(0xFFff9090),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('About', style: GoogleFonts.dmSans(
                color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
            const SizedBox(height: 6),
            Text(scheme.description, style: GoogleFonts.dmSans(
                color: Colors.white, fontSize: 13, height: 1.5)),
            const SizedBox(height: 16),
            Text('Eligibility', style: GoogleFonts.dmSans(
                color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
            const SizedBox(height: 8),
            ...scheme.eligibility.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF7fff7f), size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e, style: GoogleFonts.dmSans(color: Colors.white70, fontSize: 13))),
                ],
              ),
            )),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(scheme.applyUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text('Apply Now →', style: GoogleFonts.dmSans(
                        color: const Color(0xFF1a3a1a), fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w500, color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=800&q=80',
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
                _buildInfoBanner(),
                const SizedBox(height: 12),
                _buildTabs(),
                const SizedBox(height: 10),
                Expanded(child: _buildSchemeList()),
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
              Text('Govt Schemes', style: GoogleFonts.dmSans(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              Text('6 active schemes for Guntur', style: GoogleFonts.dmSans(
                  color: Colors.white60, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '6 active schemes available for Guntur farmers. Tap any scheme to check eligibility!',
                style: GoogleFonts.dmSans(color: Colors.white, fontSize: 12, height: 1.4),
              ),
            ),
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

  Widget _buildSchemeList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _schemeCard(_filtered[i]),
    );
  }

  Widget _schemeCard(_Scheme s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.38),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: s.iconBg, borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(s.icon, style: const TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name, style: GoogleFonts.dmSans(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _pill(s.tag, s.tagBg, s.tagColor),
                        const SizedBox(width: 6),
                        _pill(
                          s.deadline == 'Open' ? '✓ Open' : '⏰ ${s.deadline}',
                          s.deadline == 'Open' ? const Color(0x337fff7f) : const Color(0x33ff9090),
                          s.deadline == 'Open' ? const Color(0xFF7fff7f) : const Color(0xFFff9090),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(s.description, style: GoogleFonts.dmSans(
              color: Colors.white60, fontSize: 12, height: 1.5)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showSchemeDetails(context, s),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.20)),
              ),
              child: Center(
                child: Text('Check Eligibility & Apply', style: GoogleFonts.dmSans(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Scheme {
  final String name, description, icon, tag, deadline, applyUrl;
  final Color iconBg, tagBg, tagColor;
  final List<String> eligibility;

  const _Scheme({
    required this.name,
    required this.description,
    required this.icon,
    required this.iconBg,
    required this.tag,
    required this.tagBg,
    required this.tagColor,
    required this.deadline,
    required this.applyUrl,
    required this.eligibility,
  });
}