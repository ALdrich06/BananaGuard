import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/scan_result.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}


class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filter = 'All';
  final List<String> _filters = ['All', 'Diseased', 'Healthy', 'Critical'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ScanResult> get _filteredHistory {
    return _mockHistory.where((r) {
      final matchesSearch = r.diseaseName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _filter == 'All'
          ? true
          : _filter == 'Diseased'
              ? r.diseaseName != 'Healthy'
              : _filter == 'Healthy'
                  ? r.diseaseName == 'Healthy'
                  : r.severity == _filter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  final List<ScanResult> _mockHistory = [
    ScanResult(
      diseaseName: 'Black Sigatoka',
      confidence: 0.91,
      imagePath: '',
      dateScanned: DateTime.now().subtract(const Duration(days: 1)),
      severity: 'High',
    ),
    ScanResult(
      diseaseName: 'Healthy',
      confidence: 0.97,
      imagePath: '',
      dateScanned: DateTime.now().subtract(const Duration(days: 3)),
      severity: 'None',
    ),
    ScanResult(
      diseaseName: 'Yellow Sigatoka',
      confidence: 0.85,
      imagePath: '',
      dateScanned: DateTime.now().subtract(const Duration(days: 5)),
      severity: 'Medium',
    ),
    ScanResult(
      diseaseName: 'Panama Disease',
      confidence: 0.78,
      imagePath: '',
      dateScanned: DateTime.now().subtract(const Duration(days: 7)),
      severity: 'Critical',
    ),
  ];

  Color _severityColor(String severity) {
    switch (severity) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.amber;
      case 'Low': return Colors.blue;
      default: return AppTheme.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredHistory;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Scan History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => _confirmClear(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          _buildSummaryBar(),
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) => _HistoryCard(
                      result: filtered[i],
                      severityColor: _severityColor(filtered[i].severity),
                    ).animate(delay: (i * 70).ms).fadeIn().slideX(begin: 0.1, end: 0),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search scan history...',
              prefixIcon: const Icon(Icons.search, color: AppTheme.primary, size: 20),
              filled: true,
              fillColor: AppTheme.background,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintStyle: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((f) {
                final isSelected = _filter == f;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppTheme.primary : Colors.grey.shade300),
                    ),
                    child: Text(f, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppTheme.textGrey)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar() {
    final diseaseCount = _mockHistory.where((r) => r.diseaseName != 'Healthy').length;
    final healthyCount = _mockHistory.where((r) => r.diseaseName == 'Healthy').length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppTheme.background,
      child: Row(
        children: [
          _SummaryChip(label: 'Total', value: '${_mockHistory.length}', color: AppTheme.primary),
          const SizedBox(width: 10),
          _SummaryChip(label: 'Diseased', value: '$diseaseCount', color: Colors.orange),
          const SizedBox(width: 10),
          _SummaryChip(label: 'Healthy', value: '$healthyCount', color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.folder_open_outlined, size: 52, color: AppTheme.primaryLight),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1500.ms),
          const SizedBox(height: 20),
          const Text('No scan history yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 8),
          const Text('Start scanning banana leaves!',
              style: TextStyle(color: AppTheme.textGrey)),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to delete all scan history?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _mockHistory.clear());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ScanResult result;
  final Color severityColor;

  const _HistoryCard({
    required this.result,
    required this.severityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: severityColor.withOpacity(0.3)),
          ),
          child: Icon(
            result.diseaseName == 'Healthy'
                ? Icons.eco
                : Icons.coronavirus_outlined,
            color: severityColor,
            size: 26,
          ),
        ),
        title: Text(
          result.diseaseName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              DateFormat('MMM dd, yyyy • hh:mm a').format(result.dateScanned),
              style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: severityColor.withOpacity(0.4)),
              ),
              child: Text(
                result.severity,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: severityColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(result.confidence * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
        ],
      ),
    );
  }
}
