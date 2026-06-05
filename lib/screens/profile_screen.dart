import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'landing_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsOn = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow().animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 18),
                  _buildAchievements().animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 18),
                  _buildSectionLabel('Account Settings'),
                  const SizedBox(height: 10),
                  _buildSettingsCard([
                    _SettingItem(icon: Icons.person_outline, label: 'Edit Profile', color: AppTheme.primary,
                      onTap: () => _showEditProfile(context)),
                    _SettingItem(icon: Icons.notifications_outlined, label: 'Notifications', color: Colors.orange,
                      isSwitch: true, switchVal: _notificationsOn, onSwitch: (v) => setState(() => _notificationsOn = v)),
                    _SettingItem(icon: Icons.language_outlined, label: 'Language', color: Colors.blue, trailing: 'English',
                      onTap: () => _showLanguagePicker(context)),
                    _SettingItem(icon: Icons.dark_mode_outlined, label: 'Dark Mode', color: Colors.purple,
                      isSwitch: true, switchVal: _darkMode, onSwitch: (v) => setState(() => _darkMode = v)),
                  ]).animate().fadeIn(delay: 250.ms),
                  const SizedBox(height: 16),
                  _buildSectionLabel('About App'),
                  const SizedBox(height: 10),
                  _buildSettingsCard([
                    _SettingItem(icon: Icons.info_outline, label: 'About BananaGuard', color: AppTheme.primary,
                      onTap: () => _showAbout(context)),
                    _SettingItem(icon: Icons.star_border_rounded, label: 'Rate the App', color: Colors.amber,
                      onTap: () => _showRate(context)),
                    _SettingItem(icon: Icons.share_outlined, label: 'Share App', color: Colors.teal,
                      onTap: () => _shareApp(context)),
                    _SettingItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', color: Colors.grey,
                      onTap: () => _showPrivacy(context)),
                  ]).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 16),
                  _buildLogoutButton(context).animate().fadeIn(delay: 350.ms),
                  const SizedBox(height: 14),
                  Center(
                    child: Column(
                      children: [
                        Text('BananaGuard v1.0.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text('Built for Banana Leaf Disease Detection', style: TextStyle(color: Colors.grey.shade300, fontSize: 10)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 230,
      pinned: true,
      automaticallyImplyLeading: false,
      title: const Text('My Profile'),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryDark, Color(0xFF388E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                Stack(
                  children: [
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white38, width: 3),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ClipOval(child: Image.asset('assets/images/app_icon.png', fit: BoxFit.contain)),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        width: 26, height: 26,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
                        child: const Icon(Icons.edit, size: 14, color: AppTheme.primary),
                      ),
                    ),
                  ],
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 10),
                const Text('BananaGuard User', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                  child: const Text('user@bananaguard.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          _StatItem(value: '12', label: 'Total\nScans', icon: Icons.document_scanner_outlined, color: AppTheme.primary),
          _buildDivider(),
          _StatItem(value: '3', label: 'Diseases\nFound', icon: Icons.coronavirus_outlined, color: Colors.orange),
          _buildDivider(),
          _StatItem(value: '9', label: 'Healthy\nLeaves', icon: Icons.eco, color: Colors.green),
          _buildDivider(),
          _StatItem(value: '91%', label: 'Accuracy\nRate', icon: Icons.analytics_outlined, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(height: 40, width: 1, color: Colors.grey.shade100);

  Widget _buildAchievements() {
    final badges = [
      _Badge(Icons.star, 'First Scan', Colors.amber, true),
      _Badge(Icons.local_fire_department, '5 Scans', Colors.orange, true),
      _Badge(Icons.workspace_premium, '10 Scans', Colors.purple, true),
      _Badge(Icons.eco, 'Eco Hero', Colors.green, false),
      _Badge(Icons.share, 'Sharer', Colors.blue, false),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Achievements'),
        const SizedBox(height: 10),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: badges.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final b = badges[i];
              return Column(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: b.unlocked ? b.color.withOpacity(0.12) : Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: Border.all(color: b.unlocked ? b.color.withOpacity(0.4) : Colors.grey.shade200, width: 2),
                    ),
                    child: Icon(b.icon, color: b.unlocked ? b.color : Colors.grey.shade300, size: 24),
                  ).animate(delay: (i * 80).ms).scale(curve: Curves.elasticOut),
                  const SizedBox(height: 6),
                  Text(b.label, style: TextStyle(fontSize: 9, color: b.unlocked ? AppTheme.textDark : Colors.grey.shade400, fontWeight: FontWeight.w600)),
                  if (!b.unlocked) Text('Locked', style: TextStyle(fontSize: 8, color: Colors.grey.shade300)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
      ],
    );
  }

  Widget _buildSettingsCard(List<_SettingItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                leading: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: item.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                title: Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textDark)),
                trailing: item.isSwitch
                    ? Transform.scale(
                        scale: 0.8,
                        child: Switch(value: item.switchVal ?? false, onChanged: item.onSwitch, activeColor: AppTheme.primary),
                      )
                    : item.trailing != null
                        ? Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(item.trailing!, style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, color: AppTheme.textGrey, size: 18),
                          ])
                        : const Icon(Icons.chevron_right, color: AppTheme.textGrey, size: 20),
                onTap: item.isSwitch ? null : item.onTap,
              ),
              if (!isLast) const Divider(height: 1, indent: 68, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    final nameCtrl = TextEditingController(text: 'BananaGuard User');
    final emailCtrl = TextEditingController(text: 'user@bananaguard.com');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!'), backgroundColor: AppTheme.primary)); },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Select Language'),
        children: ['English', 'Filipino', 'Cebuano'].map((lang) => SimpleDialogOption(
          onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Language set to $lang'), backgroundColor: AppTheme.primary)); },
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(lang, style: const TextStyle(fontSize: 15))),
        )).toList(),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          ClipOval(child: Image.asset('assets/images/app_icon.png', width: 28, height: 28)),
          const SizedBox(width: 8),
          const Text('BananaGuard'),
        ]),
        content: const Text('BananaGuard v1.0.0\n\nAI-powered banana leaf disease detection app. Helps farmers identify and treat banana plant diseases using machine learning and image recognition.\n\nDeveloped for agricultural support.', style: TextStyle(height: 1.5)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _showRate(BuildContext context) {
    int _stars = 5;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Rate BananaGuard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How would you rate our app?'),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => GestureDetector(
                onTap: () => setSt(() => _stars = i + 1),
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Icon(i < _stars ? Icons.star_rounded : Icons.star_border_rounded, color: Colors.amber, size: 36)),
              ))),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thanks for your $_stars-star rating!'), backgroundColor: Colors.amber.shade700)); },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _shareApp(BuildContext context) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share feature coming soon! App link copied.'),
        backgroundColor: Colors.teal,
        action: SnackBarAction(label: 'OK', textColor: Colors.white, onPressed: () {}),
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'BananaGuard Privacy Policy\n\n'
            '1. Data Collection: We collect images you upload for disease analysis only.\n\n'
            '2. Data Storage: Images are processed locally and not stored on external servers.\n\n'
            '3. Personal Information: We do not collect or share personal information with third parties.\n\n'
            '4. Usage Data: Anonymous usage statistics may be collected to improve app performance.\n\n'
            '5. Contact: For privacy concerns, contact us at privacy@bananaguard.app',
            style: TextStyle(height: 1.5, fontSize: 13),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(children: [
            Icon(Icons.logout, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Text('Logout', style: TextStyle(fontSize: 17)),
          ]),
          content: const Text('Are you sure you want to logout from BananaGuard?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LandingScreen()), (r) => false,
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatItem({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textGrey, height: 1.3), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Badge {
  final IconData icon;
  final String label;
  final Color color;
  final bool unlocked;
  const _Badge(this.icon, this.label, this.color, this.unlocked);
}

class _SettingItem {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSwitch;
  final bool? switchVal;
  final ValueChanged<bool>? onSwitch;
  final String? trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.color,
    this.isSwitch = false,
    this.switchVal,
    this.onSwitch,
    this.trailing,
    this.onTap,
  });
}
