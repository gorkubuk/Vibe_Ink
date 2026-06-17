import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

const List<String> _genel = [
  'Her yeni gün, yeni bir başlangıçtır.',
  'Başarı, her gün küçük adımlar atmaktan doğar.',
  'Hayallerini küçümseme, büyük işler küçük adımlarla başlar.',
  'Kendine inan, gerisini zaman halleder.',
  'Zorluklara gülümse; onlar seni daha güçlü yapar.',
  'Her deneme, başarıya bir adım daha yakındır.',
  'Hedeflerine odaklan, engeller kenara çekilir.',
  'Hayat kısa, hayallerin büyük olsun.',
  'Bugünün çalışması, yarının başarısıdır.',
  'En uzun yolculuk bile tek bir adımla başlar.',
  'Kendini geliştirmek için hiç geç değil.',
  'Karanlık ne kadar derin olursa olsun, sabah mutlaka gelir.',
  'İyi bir gün, iyi bir kararla başlar.',
  'Sen de yapabilirsin; sadece başla.',
  'Başarı bir tesadüf değil, bir alışkanlıktır.',
  'Geleceğini şekillendiren tek kişi sensin.',
  'Her fırtına bir gökkuşağıyla biter.',
  'Asıl güç, tekrar ayağa kalkmaktır.',
  'Yıldızlar karanlıkta parlar.',
  'Motivasyon seni başlatır, alışkanlık seni götürür.',
  'Dün geçti, yarın gelecek — bugün senin.',
  'Küçük adımlar, büyük mesafeler aşar.',
  'En iyi zaman şimdi.',
  'Hayal et, inan, başar.',
  'Yorulduğunda dur, ama vazgeçme.',
];

const List<String> _pazartesi = [
  'Pazartesi yeni bir haftanın ilk sayfasıdır. Güzel yaz!',
  'Haftaya güçlü başla, sonunu güzel getir.',
  'Yeni hafta, yeni fırsatlar. Hazır mısın?',
  'Pazartesi enerjisiyle her şey mümkün!',
];

const List<String> _cuma = [
  'Haftayı başarıyla tamamladın, kendini kutla!',
  'Cuma enerjisiyle her şey mümkün.',
  'Hafta sonu kapıda, kazananlar burada!',
  'Bugün iyi bitti, yarın daha iyi başlar.',
];

const List<Color> _renkler = [
  Color(0xFF10b981),
  Color(0xFF06b6d4),
  Color(0xFFa855f7),
  Color(0xFFec4899),
  Color(0xFFeab308),
  Color(0xFFf97316),
  Color(0xFFef4444),
];

List<String> _havuz(int weekday) {
  final pool = List<String>.from(_genel);
  if (weekday == DateTime.monday) pool.addAll(_pazartesi);
  if (weekday == DateTime.friday) pool.addAll(_cuma);
  return pool;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidget.setAppGroupId('group.vibeink');
  runApp(const VibeInkApp());
}

class VibeInkApp extends StatelessWidget {
  const VibeInkApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Vibe Ink',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: const QuotePage(),
      );
}

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});
  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage>
    with SingleTickerProviderStateMixin {
  late List<String> _pool;
  late int _idx;
  late Color _renk;
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    final now = DateTime.now();
    final gun = now.difference(DateTime(now.year, 1, 1)).inDays;
    _pool = _havuz(now.weekday);
    _idx = gun % _pool.length;
    _renk = _renkler[gun % _renkler.length];
    _ctrl.forward();
    _widgetGuncelle();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _widgetGuncelle() async {
    final hex = '#${_renk.value.toRadixString(16).padLeft(8, '0')}';
    await HomeWidget.saveWidgetData<String>('quote', _pool[_idx]);
    await HomeWidget.saveWidgetData<String>('color', hex);
    await HomeWidget.updateWidget(androidName: 'HomeWidgetProvider');
  }

  void _degistir() {
    _ctrl.reset();
    setState(() {
      _idx = (_idx + 1) % _pool.length;
      _renk = _renkler[(_renkler.indexOf(_renk) + 1) % _renkler.length];
    });
    _ctrl.forward();
    _widgetGuncelle();
  }

  @override
  Widget build(BuildContext context) {
    final quote = _pool[_idx];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'VIBE INK',
                style: TextStyle(
                    fontSize: 12, letterSpacing: 5, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 52),
              FadeTransition(
                opacity: _fade,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF1a1a2e),
                    boxShadow: [
                      BoxShadow(
                          color: _renk.withOpacity(0.25),
                          blurRadius: 40,
                          spreadRadius: 4)
                    ],
                    border: Border.all(
                        color: _renk.withOpacity(0.35), width: 1.5),
                  ),
                  child: Text(
                    quote,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.65,
                      color: _renk,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(color: _renk.withOpacity(0.7), blurRadius: 10)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 52),
              GestureDetector(
                onTap: _degistir,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                        colors: [_renk.withOpacity(0.75), _renk]),
                    boxShadow: [
                      BoxShadow(
                          color: _renk.withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  child: const Text(
                    'Değiştir',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}