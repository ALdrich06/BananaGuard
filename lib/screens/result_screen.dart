import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../models/scan_result.dart';
import 'disease_info_screen.dart';
import 'scan_screen.dart';

class ResultScreen extends StatelessWidget {
  final ScanResult result;
  const ResultScreen({super.key, required this.result});

  Color get _severityColor {
    switch (result.severity) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.amber;
      case 'Low': return Colors.blue;
      default: return AppTheme.primaryLight;
    }
  }

  DiseaseInfo get _diseaseInfo => diseaseDatabase.firstWhere(
      (d) => d.name == result.diseaseName, orElse: () => diseaseDatabase.last);

  bool get _isHealthy => result.diseaseName == 'Healthy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildConfidenceGauge().animate().fadeIn(delay: 100.ms).scale(delay: 100.ms),
                  const SizedBox(height: 14),
                  _buildDiseaseCard().animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 14),
                  _buildTreatmentSteps().animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 14),
                  _buildMetaRow().animate().fadeIn(delay: 350.ms),
                  const SizedBox(height: 20),
                  _buildActionButtons(context).animate().fadeIn(delay: 400.ms),
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
    return SliverAppBar(
      expandedHeight: 210,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sharing result...'), duration: Duration(seconds: 1)),
            );
          },
        ),
      ],
      title: const Text('Scan Result'),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHealthy
                  ? [const Color(0xFF1B5E20), AppTheme.primary]
                  : [const Color(0xFF4A0000), _severityColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1500.ms),
                    Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
                      child: Icon(
                        _isHealthy ? Icons.eco : Icons.coronavirus_outlined,
                        color: Colors.white, size: 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  result.diseaseName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isHealthy ? Icons.check_circle : Icons.warning_rounded,
                        color: Colors.white, size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _isHealthy ? 'No Disease Detected' : '${result.severity} Risk Level',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
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

  Widget _buildConfidenceGauge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 52,
            lineWidth: 8,
            percent: result.confidence,
            animation: true,
            animationDuration: 1200,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: _isHealthy ? AppTheme.primary : _severityColor,
            backgroundColor: Colors.grey.shade100,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(result.confidence * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _isHealthy ? AppTheme.primary : _severityColor),
                ),
                const Text('AI Score', style: TextStyle(fontSize: 9, color: AppTheme.textGrey)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Confidence Level', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 15)),
                const SizedBox(height: 6),
                Text(
                  result.confidence >= 0.9 ? 'Very High Confidence' : result.confidence >= 0.75 ? 'High Confidence' : 'Moderate Confidence',
                  style: TextStyle(color: _isHealthy ? AppTheme.primary : _severityColor, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text('Based on MobileNet AI analysis of detected leaf patterns.', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.4)),
                const SizedBox(height: 10),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 6,
                  percent: result.confidence,
                  backgroundColor: Colors.grey.shade100,
                  progressColor: _isHealthy ? AppTheme.primary : _severityColor,
                  barRadius: const Radius.circular(4),
                  animation: true,
                  animationDuration: 1200,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              const Text('Disease Information', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          Text(_diseaseInfo.description, style: const TextStyle(fontSize: 13, color: AppTheme.textGrey, height: 1.6)),
          if (!_isHealthy) ...[
            const SizedBox(height: 14),
            const Text('Key Symptoms', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 13)),
            const SizedBox(height: 8),
            ..._diseaseInfo.symptoms.take(3).map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6, height: 6, margin: const EdgeInsets.only(top: 5, right: 8),
                    decoration: BoxDecoration(color: _severityColor, shape: BoxShape.circle),
                  ),
                  Expanded(child: Text(s, style: const TextStyle(fontSize: 12, color: AppTheme.textGrey, height: 1.4))),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildTreatmentSteps() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services_outlined, color: _isHealthy ? AppTheme.primary : _severityColor, size: 18),
              const SizedBox(width: 8),
              Text(
                _isHealthy ? 'Maintenance Tips' : 'Recommended Treatments',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._diseaseInfo.treatments.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: (_isHealthy ? AppTheme.primary : _severityColor).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${e.key + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _isHealthy ? AppTheme.primary : _severityColor)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.value, style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.4, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMetaRow() {
    return Row(
      children: [
        _MetaChip(icon: Icons.access_time, label: 'Scanned', value: 'Just now', color: Colors.blue),
        const SizedBox(width: 10),
        _MetaChip(icon: Icons.security, label: 'Severity', value: result.severity, color: _severityColor),
        const SizedBox(width: 10),
        _MetaChip(icon: Icons.model_training, label: 'Model', value: 'MobileNet', color: Colors.purple),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DiseaseInfoScreen(disease: _diseaseInfo)),
            ),
            icon: const Icon(Icons.menu_book_outlined, color: Colors.white),
            label: const Text('Full Disease Information', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ScanScreen()),
                ),
                icon: const Icon(Icons.camera_alt_outlined, color: AppTheme.primary, size: 18),
                label: const Text('Scan Again', style: TextStyle(color: AppTheme.primary, fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                icon: const Icon(Icons.home_outlined, color: AppTheme.textGrey, size: 18),
                label: const Text('Home', style: TextStyle(color: AppTheme.textGrey, fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _MetaChip({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textGrey)),
          ],
        ),
      ),
    );
  }
}
