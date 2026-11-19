import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

const ink = Color(0xFF17132B);
const purple = Color(0xFF7656E8);
const lilac = Color(0xFFECE7FF);
const paper = Color(0xFFF7F6FB);
const muted = Color(0xFF817D91);
const mint = Color(0xFFB9F1DF);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The audio service must be ready before any AudioPlayer is created.
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.mediamaster.audio',
    androidNotificationChannelName: 'Music playback',
    androidNotificationOngoing: true,
  );
  runApp(const MediaMasterApp());
}

class MediaMasterApp extends StatelessWidget {
  const MediaMasterApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Music Player & Video Downloader',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: Brightness.light),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(backgroundColor: paper, foregroundColor: ink, elevation: 0),
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
      body: SafeArea(child: IndexedStack(index: index, children: const [HomeScreen(), MusicPlayerScreen(), LinkToolScreen()])),
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        backgroundColor: Colors.white,
        indicatorColor: lilac,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.headphones_rounded), label: 'الموسيقى'),
          NavigationDestination(icon: Icon(Icons.download_rounded), label: 'التنزيل'),
        ],
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
    children: [
      Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.graphic_eq_rounded, color: mint)),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('MUSIC STUDIO', style: TextStyle(color: muted, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w800)),
          Text('مرحباً بك', style: TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w900)),
        ])),
        const Icon(Icons.more_horiz_rounded, color: ink, size: 28),
      ]),
      const SizedBox(height: 28),
      Container(
        height: 190,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFF30245E), Color(0xFF7656E8), Color(0xFFB6A5FF)]),
        ),
        child: Stack(children: [
          const Positioned(left: -8, bottom: -34, child: Icon(Icons.graphic_eq_rounded, size: 155, color: Color(0x33FFFFFF))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('موسيقاك.\nبأسلوبك.', style: TextStyle(color: Colors.white, fontSize: 30, height: 1.15, fontWeight: FontWeight.w900)),
            const Spacer(),
            const Text('استمع إلى ملفاتك واحفظ الوسائط المسموح بها', style: TextStyle(color: Color(0xFFEDE8FF), fontSize: 11)),
          ]),
        ]),
      ),
      const SizedBox(height: 28),
      const Text('ماذا تريد أن تفعل؟', style: TextStyle(color: ink, fontSize: 19, fontWeight: FontWeight.w900)),
      const SizedBox(height: 14),
      _HomeAction(
        icon: Icons.headphones_rounded, tint: purple, title: 'مشغل الموسيقى',
        detail: 'افتح ملفاتك الصوتية وأنشئ قائمة تشغيل',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MusicPlayerScreen())),
      ),
      const SizedBox(height: 12),
      _HomeAction(
        icon: Icons.file_download_outlined, tint: const Color(0xFF188A72), title: 'تنزيل الوسائط',
        detail: 'نزّل ملفاً من رابط مباشر يدعم التنزيل',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LinkToolScreen())),
      ),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFEAF7F2), borderRadius: BorderRadius.circular(18)),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.shield_outlined, color: Color(0xFF188A72)),
          SizedBox(width: 10),
          Expanded(child: Text('ملفاتك تبقى على هاتفك. لا حسابات ولا رفع إلى خوادم. التنزيل متاح للروابط المباشرة المصرح بها فقط.', style: TextStyle(color: Color(0xFF37685C), height: 1.55, fontSize: 12))),
        ]),
      ),
    ],
  );
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({required this.icon, required this.tint, required this.title, required this.detail, required this.onTap});
  final IconData icon;
  final Color tint;
  final String title;
  final String detail;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(children: [
          Container(width: 50, height: 50, decoration: BoxDecoration(color: tint.withValues(alpha: .10), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: tint, size: 27)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 5),
            Text(detail, style: const TextStyle(color: muted, fontSize: 11)),
          ])),
          const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: muted),
        ]),
      ),
    ),
  );
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});
  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late final AudioPlayer player;
  List<PlatformFile> tracks = [];
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.playerStateStream.listen((_) { if (mounted) setState(() {}); });
    player.playbackEventStream.listen((_) {}, onError: (Object e, StackTrace st) {
      if (mounted) setState(() => error = 'تعذر تشغيل هذا الملف الصوتي.');
    });
  }

  @override
  void dispose() { player.dispose(); super.dispose(); }

  Future<void> chooseMusic() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio, allowMultiple: true, withData: false);
      if (result == null) return;
      final valid = result.files.where((f) => f.path != null).toList();
      if (valid.isEmpty) {
        setState(() => error = 'لم أتمكن من الوصول إلى الملفات المختارة. جرّب اختيارها من تطبيق الملفات.');
        return;
      }
      setState(() { loading = true; error = null; tracks = valid; });
      final source = ConcatenatingAudioSource(children: valid.map((f) => AudioSource.uri(
        Uri.file(f.path!), tag: MediaItem(id: f.path!, title: f.name),
      )).toList());
      await player.setAudioSource(source, initialIndex: 0);
      // Do not await play(): its Future completes when playback ends.
      unawaited(player.play());
    } catch (e) {
      if (mounted) setState(() => error = 'تعذر فتح الملفات: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String time(Duration? d) {
    final s = (d ?? Duration.zero).inSeconds;
    return '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<int?>(
    stream: player.currentIndexStream,
    builder: (context, snap) {
      final current = snap.data ?? 0;
      final title = tracks.isNotEmpty && current < tracks.length ? tracks[current].name : 'اختر موسيقاك';
      return ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 30), children: [
        const _PageTitle(title: 'مشغل الموسيقى', subtitle: 'كل ما تحب سماعه، في مكان واحد.'),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
          child: Column(children: [
            Container(
              width: 205, height: 205,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF34265F), Color(0xFF987EFF), Color(0xFFD9CEFF)]),
                boxShadow: [BoxShadow(color: purple.withValues(alpha: .20), blurRadius: 28, offset: const Offset(0, 14))],
              ),
              child: const Icon(Icons.music_note_rounded, size: 112, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 17)),
            const SizedBox(height: 5),
            Text(tracks.isEmpty ? 'مكتبتك الصوتية' : 'المسار ${current + 1} من ${tracks.length}', style: const TextStyle(color: muted, fontSize: 11)),
            const SizedBox(height: 16),
            StreamBuilder<Duration?>(
              stream: player.durationStream,
              builder: (context, ds) => StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, ps) {
                  final duration = ds.data ?? Duration.zero;
                  final position = ps.data ?? Duration.zero;
                  final max = duration.inMilliseconds;
                  return Column(children: [
                    Slider(
                      value: max == 0 ? 0 : position.inMilliseconds.clamp(0, max).toDouble(),
                      max: max == 0 ? 1 : max.toDouble(),
                      activeColor: purple, inactiveColor: lilac,
                      onChanged: max == 0 ? null : (v) => player.seek(Duration(milliseconds: v.round())),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(time(position), style: const TextStyle(color: muted, fontSize: 10)),
                      Text(time(duration), style: const TextStyle(color: muted, fontSize: 10)),
                    ]),
                  ]);
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(onPressed: tracks.isEmpty ? null : () => player.seekToPrevious(), icon: const Icon(Icons.skip_previous_rounded, color: ink, size: 34)),
              const SizedBox(width: 18),
              Container(
                width: 66, height: 66,
                decoration: const BoxDecoration(color: purple, shape: BoxShape.circle),
                child: IconButton(
                  onPressed: tracks.isEmpty ? null : () => player.playing ? player.pause() : unawaited(player.play()),
                  icon: Icon(player.playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 38),
                ),
              ),
              const SizedBox(width: 18),
              IconButton(onPressed: tracks.isEmpty ? null : () => player.seekToNext(), icon: const Icon(Icons.skip_next_rounded, color: ink, size: 34)),
            ]),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: FilledButton.icon(
              onPressed: loading ? null : chooseMusic,
              icon: const Icon(Icons.add_rounded),
              label: Text(loading ? 'جارٍ فتح الملفات...' : 'اختيار ملفات الموسيقى'),
              style: FilledButton.styleFrom(backgroundColor: ink, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(50)),
            )),
            if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.red, fontSize: 12))),
          ]),
        ),
        const SizedBox(height: 22),
        Row(children: [
          const Expanded(child: Text('قائمة التشغيل', style: TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 17))),
          Text('${tracks.length} ملف', style: const TextStyle(color: muted, fontSize: 11)),
        ]),
        const SizedBox(height: 10),
        if (tracks.isEmpty)
          const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: Text('لم تتم إضافة أي أغنية بعد', style: TextStyle(color: muted))))
        else
          ...List.generate(tracks.length, (i) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: lilac, borderRadius: BorderRadius.circular(12)), child: Icon(i == current ? Icons.volume_up_rounded : Icons.music_note_rounded, color: purple)),
              title: Text(tracks[i].name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w700)),
              subtitle: Text(i == current ? 'يتم تشغيله الآن' : 'ملف صوتي', style: const TextStyle(color: muted, fontSize: 10)),
              onTap: () async { await player.seek(Duration.zero, index: i); unawaited(player.play()); },
            ),
          )),
      ]);
    },
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
  String message = 'يدعم روابط الملفات المباشرة عبر HTTPS فقط.';
  CancelToken? cancelToken;

  @override
  void dispose() { controller.dispose(); cancelToken?.cancel(); super.dispose(); }

  Future<void> download() async {
    final uri = Uri.tryParse(controller.text.trim());
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty || uri.host.contains(' ')) {
      setState(() => message = 'أدخل رابط HTTPS صحيحاً لملف مباشر.');
      return;
    }
    final rawName = uri.pathSegments.isEmpty ? '' : uri.pathSegments.last;
    final filename = rawName.isEmpty ? 'media-download' : rawName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    setState(() { busy = true; progress = 0; message = 'جارٍ تنزيل الملف...'; });
    cancelToken = CancelToken();
    String? tempPath;
    try {
      final dir = await getTemporaryDirectory();
      tempPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_$filename';
      final response = await Dio().download(
        uri.toString(), tempPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) { if (mounted && total > 0) setState(() => progress = received / total); },
        options: Options(
          followRedirects: true,
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(seconds: 30),
          validateStatus: (status) => status != null && status >= 200 && status < 300,
        ),
      );
      if (response.statusCode == null || response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('HTTP ${response.statusCode}');
      }
      if (!mounted) return;
      final saved = await FlutterFileDialog.saveFile(params: SaveFileDialogParams(sourceFilePath: tempPath, fileName: filename));
      if (!mounted) return;
      setState(() => message = saved == null ? 'تم التنزيل، لكنك ألغيت اختيار مكان الحفظ.' : 'تم حفظ الملف بنجاح.');
    } on DioException catch (e) {
      if (mounted) setState(() => message = e.type == DioExceptionType.cancel ? 'تم إلغاء التنزيل.' : 'فشل التنزيل: تحقق من أن الرابط يفتح ملفاً مباشراً ويسمح بالوصول.');
    } catch (e) {
      if (mounted) setState(() => message = 'تعذر حفظ الملف. جرّب رابطاً مباشراً آخر.');
    } finally {
      if (tempPath != null) { try { await File(tempPath).delete(); } catch (_) {} }
      if (mounted) setState(() { busy = false; cancelToken = null; });
    }
  }

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 30), children: [
    const _PageTitle(title: 'تنزيل الوسائط', subtitle: 'احفظ الملفات التي يسمح مصدرها بتنزيلها.'),
    const SizedBox(height: 22),
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 58, height: 58, decoration: BoxDecoration(color: const Color(0xFFE7F6F1), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.download_rounded, color: Color(0xFF188A72), size: 30)),
        const SizedBox(height: 18),
        const Text('رابط الملف', style: TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 17)),
        const SizedBox(height: 7),
        const Text('الصق رابط HTTPS مباشر ينتهي بملف صوت أو فيديو، أو يعيده الخادم كملف قابل للتنزيل.', style: TextStyle(color: muted, height: 1.6, fontSize: 12)),
        const SizedBox(height: 18),
        TextField(
          controller: controller,
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            hintText: 'https://example.com/video.mp4',
            hintStyle: const TextStyle(fontSize: 11, color: Color(0xFFAAA6B5)),
            filled: true, fillColor: paper,
            prefixIcon: const Icon(Icons.link_rounded, color: purple),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: FilledButton.icon(
          onPressed: busy ? null : download,
          icon: const Icon(Icons.file_download_outlined),
          label: Text(busy ? 'جارٍ التنزيل...' : 'تنزيل وحفظ الملف'),
          style: FilledButton.styleFrom(backgroundColor: purple, minimumSize: const Size.fromHeight(52)),
        )),
        if (busy) ...[
          const SizedBox(height: 16),
          LinearProgressIndicator(value: progress == 0 ? null : progress, color: purple, backgroundColor: lilac, borderRadius: BorderRadius.circular(10)),
          Align(alignment: Alignment.centerLeft, child: Text('${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(color: muted, fontSize: 10))),
          TextButton.icon(onPressed: () => cancelToken?.cancel(), icon: const Icon(Icons.close_rounded), label: const Text('إلغاء التنزيل')),
        ],
        const SizedBox(height: 12),
        Text(message, style: const TextStyle(color: muted, fontSize: 11, height: 1.5)),
      ]),
    ),
    const SizedBox(height: 16),
    Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFFFF4E6), borderRadius: BorderRadius.circular(17)),
      child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.info_outline_rounded, color: Color(0xFFB87928), size: 20),
        SizedBox(width: 9),
        Expanded(child: Text('روابط صفحات YouTube وTikTok وInstagram ليست روابط ملفات مباشرة. لا يتجاوز التطبيق الحماية أو DRM أو شروط المنصات.', style: TextStyle(color: Color(0xFF805B2B), fontSize: 11, height: 1.6))),
      ]),
    ),
  ]);
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('MUSIC STUDIO', style: TextStyle(color: purple, fontSize: 10, letterSpacing: 1.7, fontWeight: FontWeight.w900)),
    const SizedBox(height: 8),
    Text(title, style: const TextStyle(color: ink, fontSize: 26, fontWeight: FontWeight.w900)),
    const SizedBox(height: 6),
    Text(subtitle, style: const TextStyle(color: muted, fontSize: 12, height: 1.5)),
  ]);
}
