import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/scan_result.dart';
import 'disease_info_screen.dart';

class DiseaseLibraryScreen extends StatefulWidget {
  const DiseaseLibraryScreen({super.key});

  @override
  State<DiseaseLibraryScreen> createState() => _DiseaseLibraryScreenState();
}

class _DiseaseLibraryScreenState extends State<DiseaseLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSeverity = 'All';

  final List<String> _severities = ['All', 'Critical', 'High', 'Medium', 'Low'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DiseaseInfo> get _filtered => diseaseDatabase.where((d) {
    final matchName = d.name.toLowerCase().contains(_searchQuery.toLowerCase());
    final matchSev = _selectedSeverity == 'All' || d.severity == _selectedSeverity;
    return matchName && matchSev;
  }).toList();

  Color _severityColor(String s) {
    switch (s) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.amber;
      case 'Low': return Colors.blue;
      default: return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            automaticallyImplyLeading: false,
            title: const Text('Disease Library'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A3A1A), AppTheme.primaryDark, Color(0xFF388E3C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 14),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                          child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Disease Library', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('${diseaseDatabase.length} diseases in database', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search diseases...',
                      prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); })
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      hintStyle: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),
                  // Severity filter chips
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _severities.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final s = _severities[i];
                        final isSelected = _selectedSeverity == s;
                        final color = s == 'All' ? AppTheme.primary : _severityColor(s);
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSeverity = s),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected ? color : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? color : Colors.grey.shade200),
                              boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 6)] : [],
                            ),
                            child: Text(s, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade600, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 14),
                  // Result count
                  Row(
                    children: [
                      Text('${_filtered.length} result${_filtered.length != 1 ? 's' : ''}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          if (_filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text('No diseases found', style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
                    Text('Try a different search term', style: TextStyle(color: Colors.grey.shade300, fontSize: 13)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final d = _filtered[i];
                    final color = Color(d.colorCode);
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseInfoScreen(disease: d))),
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
                              width: 52, height: 52,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: color.withOpacity(0.3)),
                              ),
                              child: Icon(Icons.coronavirus_outlined, color: color, size: 26),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark)),
                                  const SizedBox(height: 3),
                                  Text(d.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                        child: Text(d.severity, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(Icons.healing_outlined, size: 12, color: Colors.grey.shade400),
                                      const SizedBox(width: 3),
                                      Text('${d.treatments.length} treatments', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                                      const SizedBox(width: 8),
                                      Icon(Icons.warning_amber_outlined, size: 12, color: Colors.grey.shade400),
                                      const SizedBox(width: 3),
                                      Text('${d.symptoms.length} symptoms', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppTheme.textGrey),
                          ],
                        ),
                      ).animate(delay: (i * 50).ms).fadeIn().slideX(begin: 0.05, end: 0),
                    );
                  },
                  childCount: _filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
