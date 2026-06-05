import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _floatController;
  late AnimationController _pulseController;

  final List<_OnboardData> _pages = [
    _OnboardData(
      icon: Icons.eco_rounded,
      iconColor: const Color(0xFF76FF03),
      iconBgColor: const Color(0xFF33691E),
      title: 'Welcome to\nBananaGuard',
      subtitle: 'Smart AI-powered banana leaf disease detection. Protect your harvest with just one photo.',
      color1: const Color(0xFF1A3A1A),
      color2: const Color(0xFF1B5E20),
      features: ['AI-Powered Detection', 'Instant Results', 'Free to Use'],
    ),
    _OnboardData(
      icon: Icons.document_scanner_rounded,
      iconColor: const Color(0xFF00E5FF),
      iconBgColor: const Color(0xFF006064),
      title: 'Scan &\nDetect',
      subtitle: 'Point your camera at any banana leaf — our AI instantly identifies diseases with high accuracy.',
      color1: const Color(0xFF1B3A30),
      color2: const Color(0xFF1B5E20),
      features: ['Camera or Gallery', 'High Accuracy', 'Offline Capable'],
    ),
    _OnboardData(
      icon: Icons.medical_services_rounded,
      iconColor: const Color(0xFFFFD740),
      iconBgColor: const Color(0xFF6D4C00),
      title: 'Get Expert\nTreatment',
      subtitle: 'Receive step-by-step treatment recommendations and save your crops before it\'s too late.',
      color1: const Color(0xFF1B3320),
      color2: const Color(0xFF2E7D32),
      features: ['Treatment Steps', 'Disease Library', 'Scan History'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: ScaleTransition(scale: Tween(begin: 0.96, end: 1.0).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)), child: child),
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) {
              HapticFeedback.selectionClick();
              setState(() => _currentPage = i);
            },
            itemBuilder: (_, i) => _OnboardPage(
              data: _pages[i],
              floatController: _floatController,
              pulseController: _pulseController,
            ),
          ),
          // Top logo bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                          padding: const EdgeInsets.all(4),
                          child: ClipOval(child: Image.asset('assets/images/app_icon.png', fit: BoxFit.contain)),
                        ),
                        const SizedBox(width: 8),
                        const Text('BananaGuard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
                    if (_currentPage < _pages.length - 1)
                      GestureDetector(
                        onTap: _goToLogin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
                          child: const Text('Skip', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.2, end: 0),
                  ],
                ),
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.45)],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 44),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 28 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? Colors.white : Colors.white30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 28),
                  if (_currentPage < _pages.length - 1)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 450), curve: Curves.easeInOutCubic),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white38),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Next →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _goToLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primaryDark,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login_rounded, size: 18),
                                  SizedBox(width: 6),
                                  Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity, height: 56,
                      child: ElevatedButton(
                        onPressed: _goToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryDark,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.rocket_launch_rounded, size: 20),
                            SizedBox(width: 10),
                            Text('Let\'s Get Started!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ).animate().scale(curve: Curves.elasticOut, duration: 600.ms),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardData {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title, subtitle;
  final Color color1, color2;
  final List<String> features;
  const _OnboardData({required this.icon, required this.iconColor, required this.iconBgColor, required this.title, required this.subtitle, required this.color1, required this.color2, required this.features});
}

class _OnboardPage extends StatelessWidget {
  final _OnboardData data;
  final AnimationController floatController;
  final AnimationController pulseController;
  const _OnboardPage({required this.data, required this.floatController, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [data.color1, data.color2, const Color(0xFF388E3C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(top: -60, right: -60, child: Container(width: 220, height: 220, decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle))),
          Positioned(top: 80, left: -80, child: Container(width: 180, height: 180, decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), shape: BoxShape.circle))),
          Positioned(bottom: 200, right: -40, child: Container(width: 120, height: 120, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 80, 28, 160),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated icon stack
                  AnimatedBuilder(
                    animation: floatController,
                    builder: (_, __) => Transform.translate(
                      offset: Offset(0, -8 * floatController.value),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: pulseController,
                            builder: (_, __) => Container(
                              width: 170 + 12 * pulseController.value,
                              height: 170 + 12 * pulseController.value,
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                            ),
                          ),
                          Container(width: 140, height: 140, decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), shape: BoxShape.circle)),
                          Container(
                            width: 110, height: 110,
                            decoration: BoxDecoration(
                              color: data.iconBgColor,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: data.iconColor.withOpacity(0.5), blurRadius: 24, spreadRadius: 4)],
                            ),
                            child: Icon(data.icon, size: 54, color: data.iconColor),
                          ),
                        ],
                      ),
                    ),
                  ).animate().scale(duration: 800.ms, curve: Curves.elasticOut).fadeIn(duration: 400.ms),
                  const SizedBox(height: 40),
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2, letterSpacing: -0.5),
                  ).animate().fadeIn(delay: 150.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 14),
                  Text(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.6),
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
                    children: data.features.asMap().entries.map((e) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF69F0AE), size: 14),
                          const SizedBox(width: 5),
                          Text(e.value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ).animate(delay: (400 + e.key * 100).ms).fadeIn().slideY(begin: 0.2, end: 0)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
