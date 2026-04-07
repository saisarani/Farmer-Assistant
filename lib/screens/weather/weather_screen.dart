import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  Future<Map<String, dynamic>> fetchWeather() async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Guntur&appid=89fceda9228bd40e191a17a9ddcb604e&units=metric',
      ),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Farm background image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1a3a1a)),
            ),
          ),
          // Dark overlay
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildCurrentWeatherCard(),
                  const SizedBox(height: 20),
                  _buildSectionLabel('TODAY\'S HOURLY'),
                  const SizedBox(height: 10),
                  _buildHourlyScroll(),
                  const SizedBox(height: 20),
                  _buildSectionLabel('7-DAY FORECAST'),
                  const SizedBox(height: 10),
                  _buildForecastList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
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
              Text('Weather', style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.white60, size: 12),
                  const SizedBox(width: 3),
                  Text('Guntur, AP', style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 12)),
                ],
              ),
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
            child: Text(
              _getFormattedDate(),
              style: GoogleFonts.dmSans(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  Widget _buildCurrentWeatherCard() {
    return FutureBuilder(
      future: fetchWeather(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: Colors.white),
          ));
        }
        if (snapshot.hasError) {
          return _buildStaticWeatherCard();
        }
        final data = snapshot.data as Map<String, dynamic>;
        final temp = data['main']['temp'].toStringAsFixed(0);
        final condition = data['weather'][0]['main'];
        final humidity = data['main']['humidity'];
        final windSpeed = data['wind']['speed'];

        return _buildWeatherCardContent(temp, condition, humidity.toString(), windSpeed.toString());
      },
    );
  }

  Widget _buildStaticWeatherCard() {
    return _buildWeatherCardContent('33', 'Partly Cloudy', '72', '12');
  }

  Widget _buildWeatherCardContent(String temp, String condition, String humidity, String wind) {
    IconData weatherIcon;
    if (condition.toLowerCase().contains('rain')) {
      weatherIcon = Icons.grain_rounded;
    } else if (condition.toLowerCase().contains('cloud')) {
      weatherIcon = Icons.cloud_rounded;
    } else if (condition.toLowerCase().contains('thunder')) {
      weatherIcon = Icons.thunderstorm_rounded;
    } else {
      weatherIcon = Icons.wb_sunny_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(weatherIcon, color: Colors.white, size: 56),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(temp, style: GoogleFonts.dmSans(
                    color: Colors.white, fontSize: 72, fontWeight: FontWeight.w300, height: 1)),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('°C', style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 28, fontWeight: FontWeight.w300)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(condition, style: GoogleFonts.dmSans(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 20),
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.15),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(Icons.water_drop_rounded, '$humidity%', 'Humidity'),
                _statItem(Icons.air_rounded, '$wind km/h', 'Wind'),
                _statItem(Icons.grain_rounded, '60%', 'Rain'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 6),
        Text(value, style: GoogleFonts.dmSans(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        Text(label, style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(label, style: GoogleFonts.dmSans(
          fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white60, letterSpacing: 1.2)),
    );
  }

  Widget _buildHourlyScroll() {
    final hours = [
      _Hourly('6 AM', Icons.wb_sunny_rounded, 27),
      _Hourly('9 AM', Icons.wb_cloudy_rounded, 29),
      _Hourly('12 PM', Icons.cloud_rounded, 31),
      _Hourly('3 PM', Icons.thunderstorm_rounded, 30),
      _Hourly('6 PM', Icons.grain_rounded, 28),
      _Hourly('9 PM', Icons.cloud_rounded, 26),
    ];

    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: hours.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => Container(
          width: 68,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.30),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(hours[i].time, style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 10)),
              Icon(hours[i].icon, size: 22, color: Colors.white),
              Text('${hours[i].temp}°', style: GoogleFonts.dmSans(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForecastList() {
    final forecasts = [
      _Forecast('Today', Icons.cloud_rounded, 33, 24, 60),
      _Forecast('Tue', Icons.thunderstorm_rounded, 29, 22, 85),
      _Forecast('Wed', Icons.grain_rounded, 27, 21, 75),
      _Forecast('Thu', Icons.wb_sunny_rounded, 34, 23, 20),
      _Forecast('Fri', Icons.wb_cloudy_rounded, 32, 22, 35),
      _Forecast('Sat', Icons.wb_sunny_rounded, 35, 24, 10),
      _Forecast('Sun', Icons.cloud_rounded, 31, 22, 45),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.18)),
        ),
        child: Column(
          children: forecasts.asMap().entries.map((e) {
            final isLast = e.key == forecasts.length - 1;
            final f = e.value;
            final isRainy = f.rainChance >= 50;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                border: isLast ? null : Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.10)),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 46,
                    child: Text(f.day, style: GoogleFonts.dmSans(
                        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                  Icon(f.icon, color: Colors.white70, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isRainy
                            ? Colors.blue.withOpacity(0.20)
                            : Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${f.rainChance}% rain',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: isRainy ? const Color(0xFF90c8ff) : Colors.white60,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${f.low}°', style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 13)),
                  const SizedBox(width: 10),
                  Text('${f.high}°', style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Forecast {
  final String day;
  final IconData icon;
  final int high, low, rainChance;
  const _Forecast(this.day, this.icon, this.high, this.low, this.rainChance);
}

class _Hourly {
  final String time;
  final IconData icon;
  final int temp;
  const _Hourly(this.time, this.icon, this.temp);
}