import 'package:flutter/material.dart';

void main() => runApp(const MediaMasterApp());

const ink = Color(0xFF090D18);
const panel = Color(0xFF141B2D);
const panelLight = Color(0xFF1B2540);
const violet = Color(0xFF9277FF);
const cyan = Color(0xFF54D6D0);
const muted = Color(0xFF9AA7C2);

class MediaMasterApp extends StatelessWidget {
  const MediaMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Media Master',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ink,
        colorScheme: ColorScheme.fromSeed(
          seedColor: violet,
          brightness: Brightness.dark,
          surface: panel,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onOpenConverter: () => setState(() => index = 1),
        onOpenMusic: () => setState(() => index = 2),
      ),
      const LinkConverterScreen(),
      const MusicPlayerScreen(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(child: pages[index]),
        bottomNavigationBar: NavigationBar(
          height: 72,
          backgroundColor: const Color(0xFF101729),
          indicatorColor: violet.withValues(alpha: 0.22),
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_rounded),
              selectedIcon: Icon(Icons.grid_view_rounded, color: Color(0xFFBFB2FF)),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.downloading_rounded),
              selectedIcon: Icon(Icons.downloading_rounded, color: Color(0xFFBFB2FF)),
              label: 'التنزيل',
            ),
            NavigationDestination(
              icon: Icon(Icons.headphones_rounded),
              selectedIcon: Icon(Icons.headphones_rounded, color: Color(0xFFBFB2FF)),
              label: 'الموسيقى',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onOpenConverter,
    required this.onOpenMusic,
    super.key,
  });

  final VoidCallback onOpenConverter;
  final VoidCallback onOpenMusic;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(colors: [violet, cyan]),
              ),
              child: const Icon(Icons.graphic_eq_rounded, color: ink, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MEDIA MASTER', style: TextStyle(fontSize: 16, letterSpacing: 1.4, fontWeight: FontWeight.w900)),
                  SizedBox(height: 2),
                  Text('كل ما تحتاجه لصوتك وفيديوهاتك', style: TextStyle(color: muted, fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF172B32),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: cyan.withValues(alpha: 0.25)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, size: 7, color: cyan),
                  SizedBox(width: 6),
                  Text('جاهز', style: TextStyle(fontSize: 11, color: cyan, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF493B91), Color(0xFF242D5A), Color(0xFF14253A)],
            ),
            boxShadow: [
              BoxShadow(color: violet.withValues(alpha: 0.16), blurRadius: 28, offset: const Offset(0, 12)),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: -22,
                top: -26,
                child: Icon(Icons.graphic_eq_rounded, size: 150, color: Colors.white.withValues(alpha: 0.055)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('صوتك. محتواك. بطريقتك.', style: TextStyle(fontSize: 11, color: Color(0xFFE2DEFF))),
                  ),
                  const SizedBox(height: 18),
                  const Text('Media Master', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  const Text(
                    'استمع إلى موسيقاك، ونزّل المحتوى المتاح عبر الروابط وحوّله إلى الصيغة التي تريدها.',
                    style: TextStyle(color: Color(0xFFD9DDF2), height: 1.6, fontSize: 13),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onOpenConverter,
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('ابدأ بتنزيل أو تحويل'),
                      style: FilledButton.styleFrom(
                        foregroundColor: ink,
                        backgroundColor: const Color(0xFFE7E3FF),
                        minimumSize: const Size.fromHeight(49),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Row(
          children: [
            Text('أدواتك الأساسية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Spacer(),
            Text('بسيطة وسريعة', style: TextStyle(color: muted, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 14),
        _ActionTile(
          icon: Icons.link_rounded,
          iconColor: cyan,
          tag: 'VIDEO & AUDIO',
          title: 'تنزيل وتحويل عبر رابط',
          description: 'الصق الرابط، اختر الصيغة، واحفظ النتيجة.',
          onTap: onOpenConverter,
        ),
        const SizedBox(height: 12),
        _ActionTile(
          icon: Icons.equalizer_rounded,
          iconColor: violet,
          tag: 'MUSIC PLAYER',
          title: 'مشغل الموسيقى',
          description: 'مكتبتك الصوتية في مكان واحد مع تجربة استماع أنيقة.',
          onTap: onOpenMusic,
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: cyan, size: 21),
              SizedBox(width: 11),
              Expanded(
                child: Text(
                  'خصوصيتك أولاً: لا حسابات ولا رفع لملفاتك الشخصية. التنزيل متاح فقط للمصادر والمحتوى المسموح به.',
                  style: TextStyle(color: muted, fontSize: 11, height: 1.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.tag,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String tag;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: panel,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tag, style: TextStyle(color: iconColor, fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(color: muted, fontSize: 11, height: 1.4)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded, color: muted),
            ],
          ),
        ),
      ),
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
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        const _PageHeading(eyebrow: 'DOWNLOAD & CONVERT', title: 'حوّل رابطك بسهولة', subtitle: 'ألصق رابط المحتوى، ثم اختر الصيغة المناسبة لك.'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.language_rounded, color: cyan),
                  SizedBox(width: 9),
                  Text('رابط المحتوى', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 13),
              TextField(
                controller: controller,
                keyboardType: TextInputType.url,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'https://example.com/video',
                  hintStyle: const TextStyle(color: Color(0xFF68748E), fontSize: 12),
                  filled: true,
                  fillColor: ink,
                  prefixIcon: const Icon(Icons.link_rounded, color: muted),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: violet)),
                ),
              ),
              const SizedBox(height: 22),
              const Text('اختر صيغة الإخراج', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 9,
                children: formats.map((item) {
                  final selected = item == format;
                  return ChoiceChip(
                    label: Text(item),
                    selected: selected,
                    onSelected: (_) => setState(() => format = item),
                    selectedColor: violet,
                    backgroundColor: ink,
                    labelStyle: TextStyle(color: selected ? Colors.white : muted, fontWeight: FontWeight.w700, fontSize: 12),
                    side: BorderSide(color: selected ? violet : Colors.white12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    final uri = Uri.tryParse(controller.text.trim());
                    final valid = uri != null && (uri.scheme == 'https' || uri.scheme == 'http') && uri.host.isNotEmpty;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(valid
                          ? 'الرابط صحيح شكلياً. سيتم تفعيل التنزيل والتحويل بعد إضافة محرك المصادر.'
                          : 'أدخل رابطاً صحيحاً يبدأ بـ http أو https.')),
                    );
                  },
                  icon: const Icon(Icons.bolt_rounded),
                  label: const Text('فحص الرابط'),
                  style: FilledButton.styleFrom(
                    backgroundColor: violet,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(53),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _InfoStrip(),
      ],
    );
  }
}

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        const _PageHeading(eyebrow: 'YOUR MUSIC SPACE', title: 'عِش الموسيقى', subtitle: 'مشغل أنيق لمكتبتك الموسيقية على الهاتف.'),
        const SizedBox(height: 26),
        Container(
          padding: const EdgeInsets.fromLTRB(22, 25, 22, 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF34306B), Color(0xFF1B2444), Color(0xFF142B39)],
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFF9D83FF), Color(0xFF4DCDC7)]),
                  boxShadow: [BoxShadow(color: violet.withValues(alpha: 0.24), blurRadius: 35, spreadRadius: 2)],
                ),
                child: const Icon(Icons.music_note_rounded, size: 100, color: Color(0xFF10172B)),
              ),
              const SizedBox(height: 25),
              const Text('لا توجد أغنية قيد التشغيل', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 7),
              const Text('اختر موسيقاك وابدأ الاستماع', style: TextStyle(color: Color(0xFFB9C2DD), fontSize: 12)),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Text('00:00', style: TextStyle(color: Color(0xFFB9C2DD), fontSize: 10)),
                  const Expanded(child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: LinearProgressIndicator(value: 0, minHeight: 4, backgroundColor: Colors.white24, color: cyan),
                  )),
                  const Text('00:00', style: TextStyle(color: Color(0xFFB9C2DD), fontSize: 10)),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shuffle_rounded, color: Color(0xFFB9C2DD), size: 21),
                  SizedBox(width: 24),
                  Icon(Icons.skip_previous_rounded, color: Colors.white, size: 33),
                  SizedBox(width: 22),
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: Color(0xFFE9E4FF),
                    child: Icon(Icons.play_arrow_rounded, color: Color(0xFF29204F), size: 37),
                  ),
                  SizedBox(width: 22),
                  Icon(Icons.skip_next_rounded, color: Colors.white, size: 33),
                  SizedBox(width: 24),
                  Icon(Icons.repeat_rounded, color: Color(0xFFB9C2DD), size: 21),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('سيتم تفعيل اختيار وتشغيل الملفات الصوتية في مرحلة تطوير المشغل.')),
          ),
          icon: const Icon(Icons.library_music_rounded),
          label: const Text('افتح مكتبة الموسيقى'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFDCD5FF),
            side: const BorderSide(color: Color(0xFF6657A8)),
            minimumSize: const Size.fromHeight(53),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        const SizedBox(height: 13),
        const Center(child: Text('MP3  •  AAC  •  WAV  •  M4A', style: TextStyle(color: muted, fontSize: 11, letterSpacing: 1))),
      ],
    );
  }
}

class _PageHeading extends StatelessWidget {
  const _PageHeading({required this.eyebrow, required this.title, required this.subtitle});

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow, style: const TextStyle(color: cyan, fontSize: 10, letterSpacing: 1.6, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(color: muted, fontSize: 12, height: 1.5)),
      ],
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF172B32),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: cyan.withValues(alpha: 0.17)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined, color: cyan, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'يعمل التنزيل فقط مع المصادر التي تسمح بذلك والمحتوى الذي تملك حق استخدامه. لا يتم تجاوز الحماية أو الوصول إلى المحتوى الخاص.',
              style: TextStyle(color: Color(0xFFB6C9CC), fontSize: 11, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
