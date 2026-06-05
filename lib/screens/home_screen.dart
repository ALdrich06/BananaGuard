import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/scan_result.dart';
import '../services/database_service.dart';
import 'scan_screen.dart';
import 'disease_info_screen.dart';
import 'history_screen.dart';
import 'tips_screen.dart';
import 'disease_library_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;
  const HomeScreen({super.key, this.onProfileTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _scanCount = 0;
  int _healthyCount = 0;
  double _avgConfidence = 0.0;
  ScanResult? _latestScan;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final scanCount = await DatabaseService.instance.getScanCount();
      final healthyCount = await DatabaseService.instance.getHealthyCount();
      final avgConf = await DatabaseService.instance.getAverageConfidence();
      final latest = await DatabaseService.instance.getLatestScan();
      
      setState(() {
        _scanCount = scanCount;
        _healthyCount = healthyCount;
        _avgConfidence = avgConf;
        _latestScan = latest;
      });
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get _greetingIcon {
    final hour = DateTime.now().hour;
    if (hour < 12) return '🌅';
    if (hour < 17) return '☀️';
    return '🌙';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${(diff.inDays / 7).floor()} weeks ago';
  }

  List<DiseaseInfo> get _filteredDiseases => diseaseDatabase
      .where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  Color _severityColor(String s) {
    switch (s) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.amber;
      case 'Low': return Colors.blue;
      default: return AppTheme.primaryLight;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildScanHero().animate().fadeIn(delay: 150.ms).slideY(begin: 0.2, end: 0),
                _buildRecentScan().animate().fadeIn(delay: 300.ms),
                _buildTipOfDay().animate().fadeIn(delay: 350.ms),
                _buildQuickActions().animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 210,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A3A1A), AppTheme.primaryDark, Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(top: -30, right: -30, child: Container(width: 140, height: 140, decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle))),
              Positioned(bottom: -20, left: -20, child: Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), shape: BoxShape.circle))),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Row 1: Logo badge only
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 20, height: 20, child: ClipOval(child: Image.asset('assets/images/app_icon.png', fit: BoxFit.contain))),
                            const SizedBox(width: 6),
                            const Text('BananaGuard', style: TextStyle(color: AppTheme.primaryDark, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0),
                      // Row 2: Greeting (left) + Bell + Avatar (right) — same line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$_greetingIcon $_greeting!', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.2))
                                  .animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
                              const SizedBox(height: 2),
                              const Text('Check your banana leaves today.', style: TextStyle(color: Colors.white70, fontSize: 12))
                                  .animate().fadeIn(delay: 200.ms),
                            ],
                          ),
                          Row(
                            children: [
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: 36, height: 36,
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: Colors.white24, width: 1.5)),
                                      child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 18),
                                    ),
                                  ),
                                  Positioned(top: 5, right: 5, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle))),
                                ],
                              ).animate().fadeIn(delay: 150.ms).scale(curve: Curves.elasticOut),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: widget.onProfileTap,
                                child: Container(
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFA7F3D0), width: 2),
                                    boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.4), blurRadius: 8, spreadRadius: 1)],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: ClipOval(child: Image.asset('assets/images/app_icon.png', fit: BoxFit.contain)),
                                  ),
                                ),
                              ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.elasticOut, duration: 600.ms),
                            ],
                          ),
                        ],
                      ),
                      // Row 3: Mini stats strip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MiniStat(icon: Icons.document_scanner_outlined, value: '$_scanCount', label: 'Scans'),
                            Container(width: 1, height: 24, color: Colors.white24),
                            _MiniStat(icon: Icons.eco, value: '$_healthyCount', label: 'Healthy'),
                            Container(width: 1, height: 24, color: Colors.white24),
                            _MiniStat(icon: Icons.analytics_outlined, value: '${(_avgConfidence * 100).toStringAsFixed(0)}%', label: 'Accuracy'),
                            Container(width: 1, height: 24, color: Colors.white24),
                            _MiniStat(icon: Icons.circle, value: '', label: 'AI Active', isOnline: true),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          _StatMini(value: '12', label: 'Total Scans', icon: Icons.document_scanner_outlined, color: AppTheme.primary),
          const SizedBox(width: 10),
          _StatMini(value: '9', label: 'Healthy', icon: Icons.eco, color: Colors.green),
          const SizedBox(width: 10),
          _StatMini(value: '91%', label: 'Accuracy', icon: Icons.analytics_outlined, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildScanHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanScreen())),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(color: AppTheme.primary.withOpacity(0.45), blurRadius: 16, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('AI Powered Detection', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Scan Banana\nLeaf Now',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Detect disease in seconds using\nyour camera or gallery.',
                      style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt, color: AppTheme.primary, size: 16),
                          SizedBox(width: 6),
                          Text('Start Scanning', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), duration: 1500.ms),
                  Container(
                    width: 68, height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.document_scanner, color: Colors.white, size: 34),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentScan() {
    if (_latestScan == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Recent Scan', icon: Icons.history),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: const Center(
                child: Text('No scans yet', style: TextStyle(color: AppTheme.textGrey)),
              ),
            ),
          ],
        ),
      );
    }

    final diseaseInfo = diseaseDatabase.firstWhere(
      (d) => d.name == _latestScan!.diseaseName,
      orElse: () => diseaseDatabase.first,
    );
    final color = Color(diseaseInfo.colorCode);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SectionHeader(title: 'Recent Scan', icon: Icons.history),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                child: const Text('View All', style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: _latestScan!.imagePath.isNotEmpty && File(_latestScan!.imagePath).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.file(File(_latestScan!.imagePath), fit: BoxFit.cover),
                          )
                        : Icon(
                            _latestScan!.diseaseName == 'Healthy' ? Icons.eco : Icons.coronavirus_outlined,
                            color: color,
                            size: 28,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_latestScan!.diseaseName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 15)),
                        const SizedBox(height: 3),
                        Text(
                          '${_formatDate(_latestScan!.dateScanned)} • ${(_latestScan!.confidence * 100).toStringAsFixed(0)}% confidence',
                          style: const TextStyle(color: AppTheme.textGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.withOpacity(0.4)),
                    ),
                    child: const Text('High', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right, color: AppTheme.textGrey, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipOfDay() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TipsScreen())),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade700, Colors.amber.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
                child: const Icon(Icons.lightbulb, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tip of the Day', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    SizedBox(height: 3),
                    Text('Water banana plants at the base to avoid wetting leaves and spreading disease.', style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(icon: Icons.document_scanner_rounded, label: 'Scan Now', color: AppTheme.primary,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanScreen()))),
      _QuickAction(icon: Icons.menu_book_rounded, label: 'Disease Library', color: const Color(0xFF6A1B9A),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DiseaseLibraryScreen()))),
      _QuickAction(icon: Icons.history_rounded, label: 'View History', color: const Color(0xFF1565C0),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()))),
      _QuickAction(icon: Icons.lightbulb_rounded, label: 'Tips & Guide', color: const Color(0xFFF57F17),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TipsScreen()))),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Quick Actions', icon: Icons.grid_view_rounded),
          const SizedBox(height: 12),
          Row(
            children: actions.asMap().entries.map((e) {
              final a = e.value;
              return Expanded(
                child: GestureDetector(
                  onTap: a.onTap,
                  child: Container(
                    margin: EdgeInsets.only(left: e.key == 0 ? 0 : 8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: a.color.withOpacity(0.12), shape: BoxShape.circle),
                          child: Icon(a.icon, color: a.color, size: 22),
                        ),
                        const SizedBox(height: 7),
                        Text(a.label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: a.color, height: 1.2)),
                      ],
                    ),
                  ),
                ).animate(delay: (e.key * 60).ms).fadeIn().slideY(begin: 0.1, end: 0),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
      ],
    );
  }
}

class _StatMini extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatMini({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textGrey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _DiseaseCard extends StatelessWidget {
  final DiseaseInfo disease;
  final Color severityColor;
  const _DiseaseCard({required this.disease, required this.severityColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseInfoScreen(disease: disease))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: Color(disease.colorCode).withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Color(disease.colorCode).withOpacity(0.25)),
              ),
              child: Icon(
                disease.name == 'Healthy' ? Icons.eco : Icons.coronavirus_outlined,
                color: Color(disease.colorCode), size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(disease.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 14)),
                  const SizedBox(height: 3),
                  Text(
                    disease.description.length > 65 ? '${disease.description.substring(0, 65)}...' : disease.description,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textGrey, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: severityColor.withOpacity(0.4)),
                  ),
                  child: Text(disease.severity, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: severityColor)),
                ),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right, color: AppTheme.textGrey, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isOnline;
  const _MiniStat({required this.icon, required this.value, required this.label, this.isOnline = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isOnline)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF69F0AE), shape: BoxShape.circle)),
              const SizedBox(width: 4),
              const Text('Live', style: TextStyle(color: Color(0xFF69F0AE), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          )
        else
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
      ],
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});
}
