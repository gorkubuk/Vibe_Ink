import 'package:flutter/material.dart';
import 'dart:math';
import 'package:home_widget/home_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MoodApp());
}

class MoodApp extends StatelessWidget {
  const MoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibe Ink',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      home: const QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  // 1. GENEL LİSTE (Her gün çıkabilecekler)
  final List<String> generalQuotes = [
    "All our dreams can come true, if we have the courage to pursue them. —Walt Disney",
    "The secret of getting ahead is getting started. —Mark Twain",
    "Focus on being productive instead of busy. —Tim Ferriss",
    "Everything you can imagine is real. —Pablo Picasso",
    "Do one thing every day that scares you. —Eleanor Roosevelt",
    "It’s no use going back to yesterday, because I was a different person then. —Lewis Carroll",
    "Happiness is not something ready made. It comes from your own actions. —Dalai Lama XIV",
    "Whatever you are, be a good one. —Abraham Lincoln",
    "Impossible is just an opinion. —Paulo Coelho",
    "Magic is believing in yourself. If you can make that happen, you can make anything happen. —Johann Wolfgang Von Goethe",
    "If something is important enough, even if the odds are stacked against you, you should still do it. —Elon Musk",
    "Hold the vision, trust the process.",
    "The glass is refillable.",
    "Invest in your dreams. Grind now. Shine later.",
    "Hustle in silence and let your success make the noise.",
    "We are what we repeatedly do. Excellence, then, is not an act, but a habit. —Aristotle",
    "Great things are done by a series of small things brought together. —Vincent Van Gogh",
    "The hard days are what make you stronger. —Aly Raisman",
    "Keep your eyes on the stars, and your feet on the ground. —Theodore Roosevelt",
    "Work hard in silence, let your success be the noise. —Frank Ocean",
    "The only difference between ordinary and extraordinary is that little extra. —Jimmy Johnson",
    "The miracle is not that we do this work, but that we are happy to do it. —Mother Teresa",
    "If you work on something a little bit every day, you end up with something that is massive. —Kenneth Goldsmith",
    "Amateurs sit around and wait for inspiration. The rest of us just get up and go to work. —Stephen King",
    "Nothing will work unless you do. —Maya Angelou",
    "Don’t limit your challenges. Challenge your limits.",
    "Start where you are. Use what you have. Do what you can. —Arthur Ashe",
    "Dreams don’t work unless you do. —John C. Maxwell",
    "Go the extra mile. It’s never crowded there. —Dr. Wayne D. Dyer",
    "Make each day your masterpiece. —John Wooden",
    "Begin anywhere. —John Cage",
    "I never lose. Either I win or learn. —Nelson Mandela",
    "Today is your opportunity to build the tomorrow you want. —Ken Poirot",
    "I didn’t get there by wishing for it, but by working for it. —Estée Lauder",
    "If you can dream it, you can do it. —Walt Disney",
    "You never know what you can do until you try. —William Cobbett",
    "The world is full of nice people. If you can’t find one, be one. —Nishan Panwar",
    "I can and I will. Watch me. —Carrie Green",
    "A winner is a dreamer who never gives up. —Nelson Mandela",
    "Only do what your heart tells you. —Princess Diana",
    "Done is better than perfect. —Sheryl Sandberg",
    "If your dreams don’t scare you, they are too small. —Richard Branson",
    "What hurts you blesses you. —Rumi",
    "Be the change you want to see in the world. —Mahatma Gandhi",
    "The best way to predict your future is to create it. —Abraham Lincoln",
    "Don’t watch the clock; do what it does. Keep going. —Sam Levenson",
    "Falling down is how we grow. Staying down is how we die. —Brian Vaszily",
    "Opportunity does not knock, it presents itself when you beat down the door. —Kyle Chandler",
    "Never let anyone treat you like you’re regular glue. You’re glitter glue."
  ];

  // 2. PAZARTESİ ÖZEL LİSTESİ
  final List<String> mondayQuotes = [
    "It’s Monday … time to motivate and make dreams and goals happen. Let’s go! —Heather Stillufsen",
    "It was a Monday and they walked on a tightrope to the sun. —Marcus Zusak",
    "Goodbye, blue Monday. —Kurt Vonnegut",
    "When life gives you Monday, dip it in glitter and sparkle all day. —Ella Woodword",
    "Monday c’est Mon Day.",
    "All Motivation Mondays need are a little more coffee and a lot more mascara.",
    "I’m alive, motivated, and ready to slay the day. #MONSLAY",
    "One day or day one. You decide."
  ];

  // 3. CUMA ÖZEL LİSTESİ
  final List<String> fridayQuotes = [
    "Friday sees more smiles than any other day of the workweek! —Kate Summers",
    "Every Friday, I like to high-five myself for getting through another week. —Nanea Hoffman",
    "Make Friday a day to celebrate work well done. —Byron Pulsifer",
    "It’s Friday morning, mankind! Good vibe, don’t frown! —Napz Cherub Pellazo",
    "Don’t worry about letting the dogs out. It’s Friday! —Anthony T. Hincks",
    "Fridays are the hardest in some ways: you’re so close to freedom. —Lauren Oliver"
  ];

  final List<Color> neonColors = [
    Colors.greenAccent,
    Colors.cyanAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.yellowAccent,
    Colors.orangeAccent,
    Colors.redAccent,
  ];

  String currentQuote = "Vibe Ink'e Hoşgeldin!";
  Color currentColor = Colors.cyanAccent;
  
  // AdMob reklamları
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  int _quoteChangeCount = 0;
  
  // Test Ad Unit IDs - Replace with your actual Ad Unit IDs from AdMob
  static const String _bannerAdUnitId = 'ca-app-pub-3940259942542244/6300978111';
  static const String _interstitialAdUnitId = 'ca-app-pub-3940259942542244/1033173712';

  @override
  void initState() {
    super.initState();
    // Widget'ı başlat
    _initHomeWidget();
    // Reklamları yükle
    _loadBannerAd();
    _loadInterstitialAd();
    // Uygulama açılır açılmaz ilk sözü seçsin
    changeQuote();
  }
  
  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }
  
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, err) {
          print('Banner ad failed to load: $err');
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }
  
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // Yeni reklam yükle
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              print('Interstitial ad failed to show: $err');
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          print('Interstitial ad failed to load: $err');
        },
      ),
    );
  }
  
  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd?.show();
    }
  }

  Future<void> _initHomeWidget() async {
    // Android için app group ID gerekli değil
  }

  void changeQuote() {
    setState(() {
      // Bugün hangi gün?
      int weekday = DateTime.now().weekday;

      // Havuzu oluştur
      List<String> activePool = [...generalQuotes]; // Önce genelleri al

      if (weekday == DateTime.monday) {
        activePool.addAll(mondayQuotes); // Pazartesi ise ekle
      } else if (weekday == DateTime.friday) {
        activePool.addAll(fridayQuotes); // Cuma ise ekle
      }

      // Rastgele seç
      currentQuote = activePool[Random().nextInt(activePool.length)];
      currentColor = neonColors[Random().nextInt(neonColors.length)];
      
      // Widget'ı güncelle
      _updateWidget();
      
      // Her 5 quote değişiminde interstitial reklam göster
      _quoteChangeCount++;
      if (_quoteChangeCount % 5 == 0) {
        _showInterstitialAd();
      }
    });
  }

  Future<void> _updateWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>('quote', currentQuote);
      await HomeWidget.updateWidget(
        androidName: 'HomeWidgetProvider',
      );
    } catch (e) {
      // Widget güncelleme hatası - sessizce devam et
      print('Widget güncelleme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      currentQuote,
                      key: ValueKey(currentQuote), // Animasyon için gerekli
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28, // Uzun sözler sığsın diye biraz küçülttüm
                        fontWeight: FontWeight.bold,
                        color: currentColor,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: currentColor.withOpacity(0.5),
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: changeQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Change Mood",
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                ),
              ),
              // Banner reklam
              if (_bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}