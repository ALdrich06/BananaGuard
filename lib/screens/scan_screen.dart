import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../theme/app_theme.dart';
import '../models/scan_result.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  int _step = 0; // 0=select, 1=preview, 2=analyzing
  late AnimationController _scanAnimController;

  @override
  void initState() {
    super.initState();
    _scanAnimController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
  }

  @override
  void dispose() {
    _scanAnimController.dispose();
    super.dispose();
  }

  void _pickImage() => setState(() => _step = 1);

  Future<void> _analyzeImage() async {
    setState(() => _step = 2);
    await Future.delayed(const Duration(seconds: 3));
    final rand = Random();
    final picked = diseaseDatabase[rand.nextInt(diseaseDatabase.length)];
    final result = ScanResult(
      diseaseName: picked.name,
      confidence: 0.70 + rand.nextDouble() * 0.28,
      imagePath: '',
      dateScanned: DateTime.now(),
      severity: picked.severity,
    );
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(result: result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Scan Banana Leaf'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStepIndicator().animate().fadeIn(),
            const SizedBox(height: 20),
            _buildImageArea().animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),
            if (_step == 0) _buildPickerButtons().animate().fadeIn(delay: 150.ms),
            if (_step == 1) _buildConfirmArea().animate().fadeIn().scale(),
            if (_step == 2) _buildAnalyzingCard().animate().fadeIn(),
            const SizedBox(height: 20),
            if (_step < 2) _buildTipsCard().animate().fadeIn(delay: 200.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Select Image', 'Preview', 'Analyzing'];
    return Row(
      children: steps.asMap().entries.map((e) {
        final i = e.key;
        final isActive = _step == i;
        final isDone = _step > i;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: isDone ? AppTheme.primary : isActive ? AppTheme.primary : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        boxShadow: isActive ? [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 8)] : [],
                      ),
                      child: Icon(
                        isDone ? Icons.check : i == 0 ? Icons.photo_library_outlined : i == 1 ? Icons.preview_outlined : Icons.analytics_outlined,
                        color: isDone || isActive ? Colors.white : Colors.grey.shade400,
                        size: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(e.value, style: TextStyle(fontSize: 10, color: isActive ? AppTheme.primary : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                  ],
                ),
              ),
              if (i < steps.length - 1)
                Container(height: 2, width: 20, color: _step > i ? AppTheme.primary : Colors.grey.shade200),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageArea() {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _step >= 1 ? AppTheme.primary.withOpacity(0.6) : Colors.grey.shade200,
          width: _step >= 1 ? 2 : 1,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: _step == 0 ? _buildEmptyImageState() : _step == 1 ? _buildPreviewState() : _buildScanningState(),
      ),
    );
  }

  Widget _buildEmptyImageState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.08), shape: BoxShape.circle),
          child: const Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppTheme.primaryLight),
        ),
        const SizedBox(height: 14),
        const Text('No image selected', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 15)),
        const SizedBox(height: 4),
        Text('Tap a button below to select', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('JPG, PNG supported', style: TextStyle(color: AppTheme.textGrey, fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildPreviewState() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade900, Colors.green.shade700, Colors.green.shade500],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(Icons.eco, size: 100, color: Colors.white24),
          ),
        ),
        Positioned(
          bottom: 12, left: 12, right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF69F0AE), size: 16),
                SizedBox(width: 6),
                Text('Image ready for analysis', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanningState() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade900, Colors.green.shade700],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: const Center(child: Icon(Icons.eco, size: 100, color: Colors.white24)),
        ),
        Container(color: Colors.black38),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _scanAnimController,
                builder: (_, __) => Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF69F0AE).withOpacity(0.8), width: 3),
                    boxShadow: [BoxShadow(color: const Color(0xFF69F0AE).withOpacity(0.3 * _scanAnimController.value), blurRadius: 20, spreadRadius: 5)],
                  ),
                  child: const Icon(Icons.document_scanner, color: Color(0xFF69F0AE), size: 36),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Analyzing Leaf...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              const Text('AI is detecting disease patterns', style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 16),
              const SizedBox(width: 120, child: LinearProgressIndicator(color: Color(0xFF69F0AE), backgroundColor: Colors.white24)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPickerButtons() {
    return Row(
      children: [
        Expanded(
          child: _PickerButton(
            icon: Icons.photo_library_outlined,
            label: 'Gallery',
            subtitle: 'Choose a photo',
            color: Colors.blue,
            onTap: _pickImage,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PickerButton(
            icon: Icons.camera_alt_outlined,
            label: 'Camera',
            subtitle: 'Take a photo',
            color: AppTheme.primary,
            onTap: _pickImage,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmArea() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _analyzeImage,
            icon: const Icon(Icons.analytics_outlined, color: Colors.white),
            label: const Text('Analyze for Disease', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: AppTheme.primaryDark,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _step = 0),
            icon: const Icon(Icons.refresh, color: AppTheme.primary),
            label: const Text('Choose Different Image', style: TextStyle(color: AppTheme.primary)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.primary),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzingCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          CircularProgressIndicator(color: Color(0xFF69F0AE), strokeWidth: 3),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Processing...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 3),
                Text('This may take a few seconds', style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    final tips = [
      _Tip(Icons.wb_sunny_outlined, Colors.amber, 'Good lighting gives better results'),
      _Tip(Icons.center_focus_strong, AppTheme.primary, 'Focus directly on the affected area'),
      _Tip(Icons.crop_free, Colors.blue, 'Keep the entire leaf within the frame'),
      _Tip(Icons.blur_off, Colors.red, 'Avoid blurry or dark images'),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, color: AppTheme.primary, size: 18),
              SizedBox(width: 8),
              Text('Tips for best results', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(color: t.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(t.icon, color: t.color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(t.text, style: const TextStyle(fontSize: 13, color: AppTheme.textGrey))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _Tip {
  final IconData icon;
  final Color color;
  final String text;
  const _Tip(this.icon, this.color, this.text);
}

class _PickerButton extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _PickerButton({required this.icon, required this.label, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
            Text(subtitle, style: const TextStyle(color: AppTheme.textGrey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class Tip {
  final IconData icon;
  final Color color;
  final String text;
  Tip({required this.icon, required this.color, required this.text});
}
