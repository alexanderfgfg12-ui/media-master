import 'package:flutter/material.dart';

void main() {
  runApp(const MediaMasterApp());
}

class MediaMasterApp extends StatelessWidget {
  const MediaMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF0B0F19);
    const panel = Color(0xFF151C2B);
    const accent = Color(0xFF6C8CFF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Media Master',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
          surface: panel,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeDashboard(),
      const _FeaturePage(
        icon: Icons.transform_rounded,
        title: 'تحويل الوسائط',
        description: 'تحويل ملفات الصوت والفيديو من جهازك. سنضيف اختيار الصيغ والمعالجة في المرحلة التالية.',
      ),
      const _FeaturePage(
        icon: Icons.library_music_rounded,
        title: 'مشغل الموسيقى',
        description: 'مساحة مخصصة لتشغيل ملفاتك الصوتية محلياً، مع دعم الخلفية لاحقاً.',
      ),
      const _FeaturePage(
        icon: Icons.folder_rounded,
        title: 'ملفاتي',
        description: 'إدارة الملفات المحلية ومشاركتها وحفظ النسخ المحوّلة.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.graphic_eq_rounded, color: Color(0xFF8EA5FF)),
            SizedBox(width: 10),
            Text('Media Master', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF0B0F19),
      ),
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setState(() => selectedIndex = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.sync_rounded), label: 'تحويل'),
          NavigationDestination(icon: Icon(Icons.music_note_rounded), label: 'الموسيقى'),
          NavigationDestination(icon: Icon(Icons.folder_open_rounded), label: 'ملفاتي'),
        ],
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF273B78), Color(0xFF17213D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('كل وسائطك في مكان واحد', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('أدوات بسيطة لإدارة ملفات الصوت والفيديو على هاتفك.'),
              SizedBox(height: 18),
              Icon(Icons.auto_awesome_rounded, size: 42, color: Color(0xFFB8C6FF)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('الأدوات', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const _ToolTile(icon: Icons.download_rounded, title: 'مصادر الفيديو', subtitle: 'الوصول إلى خيارات المصادر المسموح بها'),
        const _ToolTile(icon: Icons.video_file_rounded, title: 'تحويل الفيديو والصوت', subtitle: 'MP4 و MP3 وصيغ أخرى — قيد التطوير'),
        const _ToolTile(icon: Icons.headphones_rounded, title: 'مشغل الموسيقى', subtitle: 'تشغيل ملفاتك الصوتية المحلية'),
        const _ToolTile(icon: Icons.folder_copy_rounded, title: 'إدارة الملفات', subtitle: 'تصفح الملفات وحفظها ومشاركتها'),
        const SizedBox(height: 18),
        const Text(
          'الإصدار الأولي: الواجهة الأساسية جاهزة، والوظائف الفعلية ستُضاف وتُختبر تدريجياً.',
          style: TextStyle(color: Colors.white60, height: 1.5),
        ),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF151C2B),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF273B78),
          child: Icon(icon, color: const Color(0xFFB8C6FF)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _FeaturePage extends StatelessWidget {
  const _FeaturePage({required this.icon, required this.title, required this.description});

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: const Color(0xFF8EA5FF)),
            const SizedBox(height: 18),
            Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, height: 1.6)),
          ],
        ),
      ),
    );
  }
}
