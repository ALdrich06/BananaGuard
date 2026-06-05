import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  static const List<_TipCategory> _categories = [
    _TipCategory(
      icon: Icons.shield_outlined,
      color: Color(0xFF2E7D32),
      title: 'Prevention',
      tips: [
        _Tip('Water at the base, not the leaves', 'Watering from above can spread fungal spores. Always water at the soil level.'),
        _Tip('Space plants properly', 'Overcrowded plants have poor airflow which promotes fungal growth. Keep 2–3m between plants.'),
        _Tip('Remove infected leaves immediately', 'Cut and dispose of infected leaves far from the farm. Never compost them.'),
        _Tip('Use disease-resistant varieties', 'When possible, plant Cavendish or FHIA hybrids known for disease resistance.'),
        _Tip('Sanitize tools between plants', 'Dip cutting tools in 10% bleach solution to prevent spreading disease.'),
      ],
    ),
    _TipCategory(
      icon: Icons.water_drop_outlined,
      color: Color(0xFF1565C0),
      title: 'Irrigation',
      tips: [
        _Tip('Water deeply but infrequently', 'Deep watering encourages deep root growth and drought resilience.'),
        _Tip('Best time to water: early morning', 'Morning watering allows leaves to dry during the day, reducing disease risk.'),
        _Tip('Check soil moisture before watering', 'Insert finger 2 inches into soil — water only if dry at that depth.'),
        _Tip('Avoid waterlogged soil', 'Standing water causes root rot. Ensure good drainage in your field.'),
      ],
    ),
    _TipCategory(
      icon: Icons.eco_outlined,
      color: Color(0xFF558B2F),
      title: 'Soil & Nutrition',
      tips: [
        _Tip('Test soil pH regularly', 'Bananas thrive at pH 5.5–7.0. Adjust with lime (too acidic) or sulfur (too alkaline).'),
        _Tip('Apply potassium-rich fertilizer', 'Potassium strengthens cell walls and improves disease resistance.'),
        _Tip('Use organic mulch', '5cm layer of mulch retains moisture, suppresses weeds, and adds nutrients as it decomposes.'),
        _Tip('Avoid excess nitrogen', 'Too much nitrogen promotes lush soft growth that is more susceptible to disease.'),
      ],
    ),
    _TipCategory(
      icon: Icons.bug_report_outlined,
      color: Color(0xFFE65100),
      title: 'Pest Control',
      tips: [
        _Tip('Monitor weekly for early signs', 'Walk through your field every week and inspect leaves, especially undersides.'),
        _Tip('Use neem oil for soft-bodied pests', 'Neem oil is organic and effective against aphids, mites, and scale insects.'),
        _Tip('Install yellow sticky traps', 'Traps catch flying insects and help monitor pest population levels.'),
        _Tip('Introduce beneficial insects', 'Ladybugs and parasitic wasps naturally control many banana pests.'),
      ],
    ),
    _TipCategory(
      icon: Icons.wb_sunny_outlined,
      color: Color(0xFFF57F17),
      title: 'Seasonal Care',
      tips: [
        _Tip('Provide shade during extreme heat', 'Young plants need 50% shade cloth when temperatures exceed 35°C.'),
        _Tip('Protect from strong winds', 'Use windbreaks or stake plants to prevent leaf tearing which invites disease.'),
        _Tip('Harvest at the right time', 'Harvest when fingers are plump but still green. Over-ripe fruits attract pests.'),
        _Tip('Dry season: increase watering frequency', 'During drought, water every 2–3 days to prevent stress.'),
      ],
    ),
  ];

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
            title: const Text('Farming Tips'),
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
                          child: const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFD740), size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Farming Tips & Guide', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Best practices for banana farming', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _CategorySection(category: _categories[i])
                    .animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.1, end: 0),
                childCount: _categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatefulWidget {
  final _TipCategory category;
  const _CategorySection({required this.category});

  @override
  State<_CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: const Radius.circular(18), bottom: Radius.circular(_expanded ? 0 : 18)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(color: cat.color.withOpacity(0.12), borderRadius: BorderRadius.circular(13)),
                    child: Icon(cat.icon, color: cat.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cat.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark)),
                        Text('${cat.tips.length} tips', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_down_rounded, color: cat.color, size: 26),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                const Divider(height: 1, indent: 16, endIndent: 16),
                ...cat.tips.asMap().entries.map((e) => _TipTile(tip: e.value, color: cat.color, index: e.key, total: cat.tips.length)),
              ],
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

class _TipTile extends StatelessWidget {
  final _Tip tip;
  final Color color;
  final int index, total;
  const _TipTile({required this.tip, required this.color, required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        border: index < total - 1 ? Border(bottom: BorderSide(color: Colors.grey.shade100)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Center(child: Text('${index + 1}', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textDark)),
                const SizedBox(height: 3),
                Text(tip.body, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCategory {
  final IconData icon;
  final Color color;
  final String title;
  final List<_Tip> tips;
  const _TipCategory({required this.icon, required this.color, required this.title, required this.tips});
}

class _Tip {
  final String title, body;
  const _Tip(this.title, this.body);
}
