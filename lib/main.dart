import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

const ink = Color(0xFF090D18);
const panel = Color(0xFF141B2D);
const violet = Color(0xFF9277FF);
const cyan = Color(0xFF54D6D0);
const muted = Color(0xFF9AA7C2);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Render the first frame immediately; optional audio-service setup must
  // never prevent the interface from appearing.
  runApp(const MediaMasterApp());
  _initializeBackgroundAudio();
}

Future<void> _initializeBackgroundAudio() async {
  try {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.mediamaster.audio',
      androidNotificationChannelName: 'Music Player',
      androidNotificationOngoing: true,
    );
  } catch (error, stackTrace) {
    debugPrint('Background audio initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class MediaMasterApp extends StatelessWidget {
  const MediaMasterApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Music Player & Video Downloader',
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ink,
      colorScheme: ColorScheme.fromSeed(seedColor: violet, brightness: Brightness.dark, surface: panel),
      useMaterial3: true,
    ),
    home: const MainNavigation(),
  );
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      body: SafeArea(child: IndexedStack(index: index, children: const [HomeScreen(), LinkToolScreen(), MusicPlayerScreen()])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        backgroundColor: const Color(0xFF101729),
        indicatorColor: violet.withValues(alpha: .22),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.link_rounded), label: 'الرابط'),
          NavigationDestination(icon: Icon(Icons.headphones_rounded), label: 'الموسيقى'),
        ],
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(22),
    children: [
      const Row(children: [
        Icon(Icons.graphic_eq_rounded, color: cyan, size: 34),
        SizedBox(width: 10),
        Expanded(child: Text('MUSIC PLAYER & VIDEO DOWNLOADER', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: .5, fontSize: 13))),
      ]),
      const SizedBox(height: 30),
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(colors: [Color(0xFF493B91), Color(0xFF14253A)], begin: Alignment.topRight, end: Alignment.bottomLeft),
        ),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('صوتك، ببساطة', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
          SizedBox(height: 10),
          Text('مشغل موسيقى لملفاتك الصوتية، وأداة للتعامل مع روابط الوسائط المباشرة المسموح بتنزيلها.', style: TextStyle(height: 1.7, color: Color(0xFFD9DDF2))),
        ]),
      ),
      const SizedBox(height: 22),
      const _Feature(icon: Icons.headphones_rounded, title: 'مشغل الموسيقى', detail: 'اختر ملفات الصوت من هاتفك واستمع إليها، حتى في الخلفية.'),
      const SizedBox(height: 12),
      const _Feature(icon: Icons.link_rounded, title: 'تنزيل عبر رابط مباشر', detail: 'احفظ ملفات الوسائط التي يسمح مصدرها بالتنزيل.'),
      const SizedBox(height: 20),
      const Text('لا صور، لا معرض فيديو، لا حسابات، ولا قاعدة بيانات.', style: TextStyle(color: cyan, height: 1.6)),
      const SizedBox(height: 8),
      const Text('التطبيق مجاني حالياً. لا يتصل بخادم ولا يرفع ملفاتك.', style: TextStyle(color: muted, height: 1.6)),
    ],
  );
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.title, required this.detail});
  final IconData icon;
  final String title;
  final String detail;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20)),
    child: Row(children: [
      Icon(icon, color: cyan, size: 30),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 5),
        Text(detail, style: const TextStyle(color: muted, height: 1.5, fontSize: 12)),
      ])),
    ]),
  );
}

class LinkToolScreen extends StatefulWidget {
  const LinkToolScreen({super.key});
  @override
  State<LinkToolScreen> createState() => _LinkToolScreenState();
}

class _LinkToolScreenState extends State<LinkToolScreen> {
  final controller = TextEditingController();
  bool busy = false;
  double progress = 0;
  String message = 'يدعم هذا الإصدار روابط الملفات المباشرة فقط، وليس روابط صفحات المنصات.';
  @override
  void dispose() { controller.dispose(); super.dispose(); }

  Future<void> download() async {
    final uri = Uri.tryParse(controller.text.trim());
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      setState(() => message = 'أدخل رابط HTTPS صالحاً.');
      return;
    }
    final name = uri.pathSegments.isEmpty ? 'media-download' : uri.pathSegments.last;
    final safeName = name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'حفظ الملف',
      fileName: safeName.isEmpty ? 'media-download' : safeName,
    );
    if (path == null) return;
    setState(() { busy = true; progress = 0; message = 'جارٍ التنزيل...'; });
    try {
      await Dio().download(
        uri.toString(),
        path,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) setState(() => progress = received / total);
        },
        options: Options(followRedirects: true, receiveTimeout: const Duration(minutes: 5)),
      );
      if (mounted) setState(() => message = 'اكتمل التنزيل. تم حفظ الملف في المكان الذي اخترته.');
    } catch (_) {
      if (mounted) setState(() => message = 'تعذر تنزيل الرابط. قد لا يكون رابط ملف مباشر أو قد يمنع المصدر التنزيل.');
      try { await File(path).delete(); } catch (_) {}
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const _Heading(title: 'تنزيل عبر رابط', subtitle: 'ألصق رابط ملف صوتي أو فيديو مباشر يسمح مصدره بالتنزيل.'),
    const SizedBox(height: 22),
    Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('رابط الملف المباشر', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            hintText: 'https://example.com/audio.mp3',
            filled: true,
            fillColor: ink,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: busy ? null : download,
          icon: const Icon(Icons.download_rounded),
          label: Text(busy ? 'جارٍ التنزيل' : 'تنزيل الملف'),
          style: FilledButton.styleFrom(backgroundColor: violet, minimumSize: const Size.fromHeight(50)),
        ),
        if (busy) ...[
          const SizedBox(height: 14),
          LinearProgressIndicator(value: progress == 0 ? null : progress, color: cyan),
        ],
        const SizedBox(height: 14),
        Text(message, style: const TextStyle(color: muted, height: 1.5, fontSize: 12)),
      ]),
    ),
    const SizedBox(height: 16),
    const Text('روابط صفحات YouTube وTikTok وغيرها ليست روابط ملفات مباشرة. لا يتم تجاوز قيود المنصات أو DRM.', style: TextStyle(color: cyan, height: 1.6, fontSize: 12)),
  ]);
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});
  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final player = AudioPlayer();
  List<PlatformFile> tracks = [];
  bool loading = false;

  @override
  void dispose() { player.dispose(); super.dispose(); }

  Future<void> chooseMusic() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio, allowMultiple: true, withData: false);
    if (result == null) return;
    final valid = result.files.where((f) => f.path != null).toList();
    if (valid.isEmpty) return;
    setState(() { tracks = valid; loading = true; });
    try {
      final sources = valid.map((f) => AudioSource.uri(
        Uri.file(f.path!),
        tag: MediaItem(id: f.path!, title: f.name),
      )).toList();
      await player.setAudioSource(ConcatenatingAudioSource(children: sources));
      await player.play();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح أحد الملفات الصوتية.')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String durationText(Duration? d) {
    final seconds = (d ?? Duration.zero).inSeconds;
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<int?>(
    stream: player.currentIndexStream,
    builder: (context, snapshot) {
      final selected = snapshot.data ?? 0;
      final title = tracks.isNotEmpty && selected < tracks.length ? tracks[selected].name : 'لا توجد أغنية';
      return ListView(padding: const EdgeInsets.all(20), children: [
        const _Heading(title: 'مشغل الموسيقى', subtitle: 'مكتبتك الصوتية على هاتفك، دون صور أو فيديو.'),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(colors: [Color(0xFF34306B), Color(0xFF142B39)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Column(children: [
            Container(
              width: 170, height: 170,
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [violet, cyan])),
              child: const Icon(Icons.music_note_rounded, size: 95, color: ink),
            ),
            const SizedBox(height: 22),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            StreamBuilder<Duration?>(
              stream: player.durationStream,
              builder: (context, d) => StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, p) {
                  final duration = d.data ?? Duration.zero;
                  final position = p.data ?? Duration.zero;
                  final max = duration.inMilliseconds;
                  return Column(children: [
                    Slider(
                      value: max <= 0 ? 0 : position.inMilliseconds.clamp(0, max).toDouble(),
                      max: max <= 0 ? 1 : max.toDouble(),
                      onChanged: max <= 0 ? null : (v) => player.seek(Duration(milliseconds: v.round())),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(durationText(position), style: const TextStyle(color: muted, fontSize: 11)),
                      Text(durationText(duration), style: const TextStyle(color: muted, fontSize: 11)),
                    ]),
                  ]);
                },
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, state) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(onPressed: tracks.isEmpty ? null : () => player.seekToPrevious(), icon: const Icon(Icons.skip_previous_rounded, size: 34)),
                IconButton(
                  onPressed: tracks.isEmpty ? null : () => player.playing ? player.pause() : player.play(),
                  icon: Icon(player.playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded, size: 60, color: const Color(0xFFE9E4FF)),
                ),
                IconButton(onPressed: tracks.isEmpty ? null : () => player.seekToNext(), icon: const Icon(Icons.skip_next_rounded, size: 34)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(onPressed: loading ? null : chooseMusic, icon: const Icon(Icons.library_music_rounded), label: const Text('اختيار ملفات الموسيقى')),
        const SizedBox(height: 14),
        if (tracks.isNotEmpty) ...[
          Text('قائمة التشغيل (${tracks.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...List.generate(tracks.length, (i) => ListTile(
            dense: true,
            leading: Icon(i == selected ? Icons.equalizer_rounded : Icons.music_note_rounded, color: i == selected ? cyan : muted),
            title: Text(tracks[i].name, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () async { await player.seek(Duration.zero, index: i); await player.play(); },
          )),
        ],
      ]);
    },
  );
}

class _Heading extends StatelessWidget {
  const _Heading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('MUSIC PLAYER & VIDEO DOWNLOADER', style: TextStyle(color: cyan, fontSize: 10, letterSpacing: .5, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
    const SizedBox(height: 6),
    Text(subtitle, style: const TextStyle(color: muted, fontSize: 12, height: 1.5)),
  ]);
}
