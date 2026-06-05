import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../models/scan_result.dart';

class DiseaseInfoScreen extends StatefulWidget {
  final DiseaseInfo disease;
  const DiseaseInfoScreen({super.key, required this.disease});

  @override
  State<DiseaseInfoScreen> createState() => _DiseaseInfoScreenState();
}

class _DiseaseInfoScreenState extends State<DiseaseInfoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Color get _severityColor {
    switch (widget.disease.severity) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.amber;
      case 'Low': return Colors.blue;
      default: return AppTheme.primaryLight;
    }
  }

  double get _severityPercent {
    switch (widget.disease.severity) {
      case 'Critical': return 1.0;
      case 'High': return 0.75;
      case 'Medium': return 0.5;
      case 'Low': return 0.25;
      default: return 0.1;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [_buildHeader()],
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildSymptomsTab(),
                  _buildTreatmentTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryDark, _severityColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 28),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle)),
                    Container(
                      width: 62, height: 62,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: Icon(
                        widget.disease.name == 'Healthy' ? Icons.eco : Icons.coronavirus_outlined,
                        color: Colors.white, size: 32,
                      ),
                    ),
                  ],
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 10),
                Text(widget.disease.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: _severityColor, size: 13),
                      const SizedBox(width: 4),
                      Text('${widget.disease.severity} Severity', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primary,
        unselectedLabelColor: AppTheme.textGrey,
        indicatorColor: AppTheme.primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(icon: Icon(Icons.info_outline, size: 18), text: 'Overview'),
          Tab(icon: Icon(Icons.warning_amber_outlined, size: 18), text: 'Symptoms'),
          Tab(icon: Icon(Icons.medical_services_outlined, size: 18), text: 'Treatment'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [Icon(Icons.description_outlined, color: AppTheme.primary, size: 18), SizedBox(width: 8), Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark))]),
                const SizedBox(height: 12),
                Text(widget.disease.description, style: const TextStyle(fontSize: 13, color: AppTheme.textGrey, height: 1.7)),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [Icon(Icons.bar_chart, color: AppTheme.primary, size: 18), SizedBox(width: 8), Text('Severity Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark))]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: _severityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: _severityColor.withOpacity(0.4))),
                      child: Text(widget.disease.severity, style: TextStyle(color: _severityColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        lineHeight: 10,
                        percent: _severityPercent,
                        backgroundColor: Colors.grey.shade100,
                        progressColor: _severityColor,
                        barRadius: const Radius.circular(6),
                        animation: true,
                        animationDuration: 1000,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.disease.severity == 'Critical'
                      ? 'Immediate action required. Can cause total crop loss.'
                      : widget.disease.severity == 'High'
                          ? 'Urgent treatment needed to prevent spread.'
                          : widget.disease.severity == 'Medium'
                              ? 'Monitor closely and apply preventive measures.'
                              : 'Low impact. Standard prevention recommended.',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textGrey, height: 1.5),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSymptomsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.orange.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.withOpacity(0.2))),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade700, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('Watch for these signs on the banana leaf.', style: TextStyle(fontSize: 12, color: Colors.orange.shade800))),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 14),
          ...widget.disease.symptoms.asMap().entries.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
            child: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
                  child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.4))),
              ],
            ),
          ).animate(delay: (e.key * 60).ms).fadeIn().slideX(begin: 0.1, end: 0)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTreatmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.primary.withOpacity(0.2))),
            child: const Row(
              children: [
                Icon(Icons.medical_services_outlined, color: AppTheme.primary, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text('Follow these steps for effective treatment.', style: TextStyle(fontSize: 12, color: AppTheme.primary))),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 14),
          ...widget.disease.treatments.asMap().entries.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), shape: BoxShape.circle),
                  child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Step ${e.key + 1}', style: const TextStyle(fontSize: 10, color: AppTheme.textGrey, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(e.value, style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(delay: (e.key * 60).ms).fadeIn().slideX(begin: 0.1, end: 0)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
