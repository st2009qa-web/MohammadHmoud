// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

// التطبيق الرئيسي
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'اكتشف الأردن',
      home: HomePage(),
    );
  }
}

// الصفحة الرئيسية
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void navigate(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget button(String text, BuildContext context, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(220, 50),
          backgroundColor: Colors.deepOrange,
          shadowColor: Colors.deepOrangeAccent,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => navigate(context, page),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget mainImage(String path) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepOrange,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          path,
          width: 100,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "اكتشف الأردن",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 4,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.orange.shade50,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mainImage("assets/images/petra.webp"),
                  mainImage("assets/images/dead-sea.webp"),
                  mainImage("assets/images/aqaba.jpg"),
                ],
              ),
              const SizedBox(height: 30),
              button("فيديو تعريفي", context, const VideoPage()),
              button("المعالم السياحية", context, const AttractionsPage()),
              button("اختبار سياحي", context, const QuizPage()),
              button("تقييم التطبيق", context, const RatePage()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// صفحة المعالم السياحية
class AttractionsPage extends StatelessWidget {
  const AttractionsPage({super.key});

  final List<Map<String, String>> attractions = const [
    {
      "name": "البتراء",
      "desc": "مدينة أثرية مشهورة بواجهاتها المنحوتة في الصخور.",
      "image": "assets/images/petra.webp"
    },
    {
      "name": "البحر الميت",
      "desc": "أدنى نقطة على سطح الأرض وملوحة عالية.",
      "image": "assets/images/dead-sea.webp"
    },
    {
      "name": "العقبة",
      "desc": "مدينة سياحية على البحر الأحمر.",
      "image": "assets/images/aqaba.jpg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المعالم السياحية"),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        itemCount: attractions.length,
        itemBuilder: (context, index) {
          var a = attractions[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                a["image"]!,
                width: 60,
                fit: BoxFit.cover,
              ),
              title: Text(
                a["name"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(a["desc"]!),
            ),
          );
        },
      ),
    );
  }
}

// صفحة الفيديو
class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("فيديو تعريفي"),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: VideoPlayerWidget(),
      ),
    );
  }
}

// صفحة الاختبار مع صوت التشجيع
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
    {
      "q": "أين تقع البتراء؟",
      "options": ["الأردن", "مصر", "سوريا", "تركيا"],
      "answer": "الأردن"
    },
    {
      "q": "ما أدنى نقطة على سطح الأرض؟",
      "options": ["البحر الأحمر", "البحر الميت", "المحيط", "بحر العرب"],
      "answer": "البحر الميت"
    },
    {
      "q": "أين تقع العقبة؟",
      "options": ["شمال الأردن", "جنوب الأردن", "شرق الأردن", "غرب الأردن"],
      "answer": "جنوب الأردن"
    }
  ];

  void playCheer() async {
    await player.play(AssetSource('sounds/cheer.mp3'));
  }

  void answer(String selected) {
    if (selected == questions[questionIndex]["answer"]) {
      score++;
      playCheer(); // صوت الإجابة الصحيحة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("إجابة صحيحة ✅")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("إجابة خاطئة ❌")),
      );
    }

    setState(() {
      questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questionIndex >= questions.length) {
      if (!playedEndSound) {
        playCheer(); // صوت نهاية الاختبار
        playedEndSound = true;
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text("النتيجة"),
          backgroundColor: Colors.deepOrange,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🎉 أحسنت! 🎉",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "نتيجتك $score / ${questions.length}",
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    questionIndex = 0;
                    score = 0;
                    playedEndSound = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                child: const Text("إعادة الاختبار"),
              )
            ],
          ),
        ),
      );
    }

    var q = questions[questionIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختبار سياحي"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              q["q"].toString(),
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...(q["options"] as List<String>).map((option) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {
                    answer(option);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  child: Text(option),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

// صفحة التقييم
class RatePage extends StatefulWidget {
  const RatePage({super.key});

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  int rating = 0;

  Widget star(int number) {
    return IconButton(
      icon: Icon(
        Icons.star,
        color: rating >= number ? Colors.orange : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          rating = number;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تقييم التطبيق"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "قيّم التطبيق",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [star(1), star(2), star(3), star(4), star(5)],
            ),
          ],
        ),
      ),
    );
  }
}

// صفحة الفيديو
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
    controller = VideoPlayerController.asset("assets/videos/jordan.mp4")
      ..initialize().then((value) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                )
              : const Text("تعذر التشغيل"),
        ),
        Center(
          child: IconButton(
            style: ElevatedButton.styleFrom(shape: const CircleBorder()),
            onPressed: () async {
              controller.value.isPlaying ? controller.pause() : controller.play();
            },
            icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          ),
        ),
      ],
    );
  }
}