// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'اكتشف الأردن',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Cairo', // تأكد من إضافة خط Cairo في pubspec.yaml لنتيجة أجمل
      ),
      home: const HomePage(),
    );
  }
}

// ---------------- الصفحة الرئيسية ----------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  // زر متجاوب مع أقصى عرض
  Widget modernButton(String text, IconData icon, BuildContext context, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400), // يمنع تمدد الزر بشكل مبالغ فيه على التابلت
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 60),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            shadowColor: Colors.deepOrangeAccent.withOpacity(0.5),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          icon: Icon(icon, size: 28),
          label: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          onPressed: () => navigate(context, page),
        ),
      ),
    );
  }

  Widget mainImage(String path, double screenWidth) {
    // نجعل حجم الصورة ديناميكياً بناءً على حجم الشاشة، مع وضع حد أقصى
    double imageSize = screenWidth > 600 ? 150 : (screenWidth / 3.5) - 10;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          path,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة الحالي
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("اكتشف الأردن", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center( // Center لوضع المحتوى في المنتصف في الشاشات الكبيرة
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // استخدمنا Wrap بدلاً من Row لمنع الـ Overflow في الشاشات الصغيرة جداً
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    mainImage("assets/images/petra.webp", screenWidth),
                    mainImage("assets/images/dead-sea.webp", screenWidth),
                    mainImage("assets/images/aqaba.jpg", screenWidth),
                  ],
                ),
                const SizedBox(height: 40),
                modernButton("فيديو تعريفي", Icons.play_circle_fill, context, const VideoPage()),
                modernButton("المعالم السياحية", Icons.map, context, const AttractionsPage()),
                modernButton("اختبار سياحي", Icons.quiz, context, const QuizPage()),
                modernButton("تقييم التطبيق", Icons.star_rate, context, const RatePage()),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- صفحة المعالم السياحية (متجاوبة: List للموبايل / Grid للتابلت) ----------------
class AttractionsPage extends StatelessWidget {
  const AttractionsPage({super.key});

  final List<Map<String, String>> attractions = const [
    {"name": "البتراء", "desc": "مدينة أثرية مشهورة بواجهاتها المنحوتة في الصخور الوردية.", "image": "assets/images/petra.webp"},
    {"name": "البحر الميت", "desc": "أدنى نقطة على سطح الأرض، يتميز بمياهه العلاجية وملوحته العالية.", "image": "assets/images/dead-sea.webp"},
    {"name": "العقبة", "desc": "المنفذ البحري الوحيد للأردن، وتتميز بشعابها المرجانية الساحرة.", "image": "assets/images/aqaba.jpg"}
  ];

  Widget attractionCard(Map<String, String> a) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
            child: Image.asset(a["image"]!, width: 120, height: double.infinity, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(a["name"]!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  const SizedBox(height: 5),
                  Text(a["desc"]!, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(title: const Text("المعالم السياحية", style: TextStyle(color: Colors.white)), backgroundColor: Colors.deepOrange),
      // LayoutBuilder يقرر شكل العرض بناءً على المساحة المتاحة
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) {
            // شاشات كبيرة (تابلت أو ويب) -> عرض شبكي (Grid)
            return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عمودين
                childAspectRatio: 2.5, // نسبة العرض للطول للبطاقة
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: attractions.length,
              itemBuilder: (context, index) => attractionCard(attractions[index]),
            );
          } else {
            // شاشات صغيرة (موبايل) -> عرض قائمة (List)
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: attractions.length,
              itemBuilder: (context, index) => SizedBox(height: 120, child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: attractionCard(attractions[index]),
              )),
            );
          }
        },
      ),
    );
  }
}

// ---------------- صفحة الاختبار ----------------
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final player = AudioPlayer();
  bool playedEndSound = false;
  int questionIndex = 0;
  int score = 0;

  final List<Map<String, Object>> questions = [
    {"q": "أين تقع مدينة البتراء الأثرية؟", "options": ["الأردن", "مصر", "سوريا", "تركيا"], "answer": "الأردن"},
    {"q": "ما هي أدنى نقطة على سطح الأرض؟", "options": ["البحر الأحمر", "البحر الميت", "المحيط الهادئ", "بحر العرب"], "answer": "البحر الميت"},
    {"q": "أين تقع مدينة العقبة؟", "options": ["شمال الأردن", "جنوب الأردن", "شرق الأردن", "غرب الأردن"], "answer": "جنوب الأردن"}
  ];

  void answer(String selected) {
    if (selected == questions[questionIndex]["answer"]) {
      score++;
      player.play(AssetSource('sounds/cheer.mp3'));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("إجابة صحيحة! ✅"), backgroundColor: Colors.green.shade600));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("إجابة خاطئة ❌"), backgroundColor: Colors.red.shade600));
    }
    setState(() => questionIndex++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(title: Text(questionIndex >= questions.length ? "النتيجة" : "اختبار سياحي", style: const TextStyle(color: Colors.white)), backgroundColor: Colors.deepOrange),
      body: Center( // توسيط المحتوى للتابلت
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // تقييد العرض
          child: questionIndex >= questions.length ? _buildResult() : _buildQuiz(),
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (!playedEndSound) { player.play(AssetSource('sounds/cheer.mp3')); playedEndSound = true; }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.emoji_events, size: 120, color: Colors.amber),
        const SizedBox(height: 20),
        Text("نتيجتك: $score / ${questions.length}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () => setState(() { questionIndex = 0; score = 0; playedEndSound = false; }),
          icon: const Icon(Icons.refresh),
          label: const Text("إعادة الاختبار"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
        )
      ],
    );
  }

  Widget _buildQuiz() {
    var q = questions[questionIndex];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
            child: Text(q["q"].toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 40),
          ...(q["options"] as List<String>).map((option) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: ElevatedButton(
              onPressed: () => answer(option),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18), backgroundColor: Colors.white, foregroundColor: Colors.deepOrange,
                side: const BorderSide(color: Colors.deepOrange, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(option, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ))
        ],
      ),
    );
  }
}

// ---------------- صفحة التقييم ----------------
class RatePage extends StatefulWidget {
  const RatePage({super.key});

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  final player = AudioPlayer();
  int rating = 0;

  void evaluateRating(int number) async {
    setState(() => rating = number);
    if (number >= 4) {
      await player.play(AssetSource('sounds/cheer.mp3'));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("شكراً لك! 💖"), backgroundColor: Colors.green.shade600));
    }
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة لتغيير حجم النجوم
    double starSize = MediaQuery.of(context).size.width > 500 ? 60 : 45;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(title: const Text("تقييم التطبيق", style: TextStyle(color: Colors.white)), backgroundColor: Colors.deepOrange),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("ما رأيك في التطبيق؟", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(5, (index) {
                    int starNumber = index + 1;
                    return IconButton(
                      icon: Icon(Icons.star, size: starSize, color: rating >= starNumber ? Colors.amber : Colors.grey.shade300),
                      onPressed: () => evaluateRating(starNumber),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- صفحة الفيديو ----------------
class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("الأردن في فيديو", style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800), // يمنع الفيديو من أخذ مساحة ضخمة على متصفح الويب
          child: const VideoPlayerWidget(),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset("assets/videos/jordan.mp4")..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.deepOrange.withOpacity(0.3), blurRadius: 20)]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
                  GestureDetector(
                    onTap: () => setState(() => controller.value.isPlaying ? controller.pause() : controller.play()),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                      padding: const EdgeInsets.all(20),
                      child: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 50),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const CircularProgressIndicator(color: Colors.deepOrange);
  }
}