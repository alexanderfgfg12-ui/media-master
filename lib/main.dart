import 'package:flutter/material.dart';

void main() => runApp(const MediaMasterApp());

class MediaMasterApp extends StatelessWidget {
  const MediaMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF0B0F19);
    const panel = Color(0xFF151C2B);
    const accent = Color(0xFF8EA5FF);
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
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  static const pages = <Widget>[
    HomeScreen(),
    LinkConverterScreen(),
    MusicPlayerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.link_rounded), label: 'رابط وتحويل'),
          NavigationDestination(icon: Icon(Icons.headphones_rounded), label: 'الموسيقى'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
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
              Icon(Icons.graphic_eq_rounded, size: 38, color: Color(0xFFB8C6FF)),
              SizedBox(height: 18),
              Text('Media Master', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'مشغل موسيقى بسيط وأداة لتنزيل وتحويل الوسائط من روابط الإنترنت المسموح بها.',
                style: TextStyle(height: 1.6, color: Colors.white.withValues(alpha: 0.86)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('الأدوات الأساسية', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const _FeatureCard(
          icon: Icons.link_rounded,
          title: 'تنزيل وتحويل عبر رابط',
          description: 'ألصق رابطاً من مصدر يدعم التنزيل المصرح به، ثم اختر الصيغة.',
        ),
        const SizedBox(height: 10),
        const _FeatureCard(
          icon: Icons.headphones_rounded,
          title: 'مشغل الموسيقى',
          description: 'تشغيل الملفات الصوتية الموجودة على هاتفك والاستماع إليها.',
        ),
        const SizedBox(height: 20),
        const _NoticeCard(),
      ],
    );
  }
}

class LinkConverterScreen extends StatefulWidget {
  const LinkConverterScreen({super.key});

  @override
  State<LinkConverterScreen> createState() => _LinkConverterScreenState();
}

class _LinkConverterScreenState extends State<LinkConverterScreen> {
  final controller = TextEditingController();
  String format = 'MP4';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const formats = ['MP4', 'MP3', 'AAC', 'WAV', 'M4A', 'MOV', 'WebM'];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('تنزيل وتحويل من رابط', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          'أدخل رابط المحتوى الذي تملك حق تنزيله أو الذي تسمح منصته بالتنزيل عبر أداة خارجية.',
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
        const SizedBox(height: 22),
        TextField(
          controller: controller,
          keyboardType: TextInputType.url,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            hintText: 'https://example.com/video',
            labelText: 'رابط الفيديو أو الصوت',
            prefixIcon: const Icon(Icons.link_rounded),
            filled: true,
            fillColor: const Color(0xFF151C2B),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 18),
        const Text('صيغة الملف الناتج', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: format,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF151C2B),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          items: formats.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: (value) {
            if (value != null) setState(() => format = value);
          },
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () {
            final uri = Uri.tryParse(controller.text.trim());
            final valid = uri != null &&
                (uri.scheme == 'https' || uri.scheme == 'http') &&
                uri.host.isNotEmpty;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(valid
                    ? 'تم إدخال رابط صحيح شكلياً. دعم المصدر والتنزيل والتحويل سيُضاف ويُختبر في المرحلة التالية.'
                    : 'يرجى إدخال رابط إنترنت صحيح يبدأ بـ http أو https.'),
              ),
            );
          },
          icon: const Icon(Icons.download_rounded),
          label: const Text('فحص الرابط'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
        ),
        const SizedBox(height: 18),
        const _NoticeCard(),
        const SizedBox(height: 12),
        const Text(
          'لن يتجاوز التطبيق حماية المنصات أو قيودها، ولن ينزّل محتوى خاصاً أو محمياً دون تصريح.',
          style: TextStyle(color: Colors.white54, height: 1.5, fontSize: 12),
        ),
      ],
    );
  }
}

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('مشغل الموسيقى', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          'مشغل صوتي عادي لملفات الموسيقى الموجودة على هاتفك.',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF151C2B),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 58,
                backgroundColor: Color(0xFF273B78),
                child: Icon(Icons.music_note_rounded, size: 58, color: Color(0xFFB8C6FF)),
              ),
              SizedBox(height: 18),
              Text('لا توجد أغنية قيد التشغيل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              SizedBox(height: 8),
              Text('سيظهر هنا اسم الأغنية والفنان ومدة التشغيل.', style: TextStyle(color: Colors.white54), textAlign: TextAlign.center),
              SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.skip_previous_rounded, size: 34, color: Colors.white38),
                  SizedBox(width: 28),
                  Icon(Icons.play_circle_fill_rounded, size: 62, color: Color(0xFF8EA5FF)),
                  SizedBox(width: 28),
                  Icon(Icons.skip_next_rounded, size: 34, color: Colors.white38),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('اختيار ملفات الصوت سيُفعّل عند إضافة مشغل الصوت الفعلي.')),
          ),
          icon: const Icon(Icons.library_music_rounded),
          label: const Text('اختيار ملفات الموسيقى'),
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
        const SizedBox(height: 12),
        const Text(
          'الصيغ المستهدفة: MP3 وAAC وWAV وM4A. تشغيل الخلفية والتحكم من شاشة القفل سيُضافان مع محرك الصوت.',
          style: TextStyle(color: Colors.white54, height: 1.5, fontSize: 12),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.icon, required this.title, required this.description});

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF151C2B),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF273B78),
          child: Icon(icon, color: const Color(0xFFB8C6FF)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(description, style: const TextStyle(height: 1.4)),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF202A40),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF39496D)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFFB8C6FF)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'التطبيق لا يحتوي على معرض صور أو تنزيل فيديوهات شخصية من الهاتف. التنزيل من الإنترنت يعتمد على دعم المصدر وحقوق المحتوى.',
              style: TextStyle(height: 1.5, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
