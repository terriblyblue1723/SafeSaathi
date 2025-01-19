import 'package:flutter/material.dart';
import 'dart:async';

class EscapeTechniques extends StatefulWidget {
  const EscapeTechniques({Key? key}) : super(key: key);

  @override
  State<EscapeTechniques> createState() => _EscapeTechniquesState();
}

class _EscapeTechniquesState extends State<EscapeTechniques> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Escape Techniques': 'Escape Techniques',
      'Identify Exits': 'Identify Exits',
      'Always be aware of your surroundings and identify possible exits.': 'Always be aware of your surroundings and identify possible exits.',
      'Create Distance': 'Create Distance',
      'Put as much distance between you and the attacker as possible.': 'Put as much distance between you and the attacker as possible.',
      'Use Obstacles': 'Use Obstacles',
      'Use furniture or other obstacles to block the attacker\'s path.': 'Use furniture or other obstacles to block the attacker\'s path.',
      'Call for Help': 'Call for Help',
      'Yell for help to attract attention and deter the attacker.': 'Yell for help to attract attention and deter the attacker.',
      'Stay Calm': 'Stay Calm',
      'Keep a clear mind to make quick decisions during an escape.': 'Keep a clear mind to make quick decisions during an escape.',
      'Step': 'Step',
    },
    { // Hindi
      'Escape Techniques': 'भागने की तकनीकें',
      'Identify Exits': 'निकास की पहचान करें',
      'Always be aware of your surroundings and identify possible exits.': 'हमेशा अपने चारों ओर के वातावरण के प्रति जागरूक रहें और संभावित निकास की पहचान करें।',
      'Create Distance': 'दूरी बनाएं',
      'Put as much distance between you and the attacker as possible.': 'हमलावर और अपने बीच जितनी संभव हो सके दूरी बनाएं।',
      'Use Obstacles': 'अवरोधों का उपयोग करें',
      'Use furniture or other obstacles to block the attacker\'s path.': 'हमलावर के रास्ते को अवरुद्ध करने के लिए फर्नीचर या अन्य अवरोधों का उपयोग करें।',
      'Call for Help': 'मदद के लिए चिल्लाएं',
      'Yell for help to attract attention and deter the attacker.': 'ध्यान आकर्षित करने और हमलावर को रोकने के लिए मदद के लिए चिल्लाएं।',
      'Stay Calm': 'शांत रहें',
      'Keep a clear mind to make quick decisions during an escape.': 'भागने के दौरान त्वरित निर्णय लेने के लिए स्पष्ट दिमाग रखें।',
      'Step': 'चरण',
    },
    { // Marathi
      'Escape Techniques': 'पळून जाण्याच्या तंत्रे',
      'Identify Exits': 'निघण्याचे मार्ग ओळखा',
      'Always be aware of your surroundings and identify possible exits.': 'तुमच्या आजुबाजुच्या गोष्टींचा नेहमी विचार करा आणि संभाव्य निघण्याचे मार्ग ओळखा.',
      'Create Distance': 'अंतर तयार करा',
      'Put as much distance between you and the attacker as possible.': 'तुम्ही आणि हल्लेखोर यांच्यात जितकी शक्य असेल तितकी अंतर ठेवा.',
      'Use Obstacles': 'अवरोधांचा वापर करा',
      'Use furniture or other obstacles to block the attacker\'s path.': 'हल्लेखोराच्या मार्गात अडथळे आणण्यासाठी फर्निचर किंवा इतर अडथळ्यांचा वापर करा.',
      'Call for Help': 'मदतीसाठी हाका द्या',
      'Yell for help to attract attention and deter the attacker.': 'ध्यान आकर्षित करण्यासाठी आणि हल्लेखोराला थांबवण्यासाठी मदतीसाठी हाका द्या.',
      'Stay Calm': 'शांत रहा',
      'Keep a clear mind to make quick decisions during an escape.': 'पळून जाताना त्वरित निर्णय घेण्यासाठी स्पष्ट मन ठेवा.',
      'Step': 'चरण',
    },
  ];

  String getTranslatedText(String text) {
    return translations[currentLanguageIndex][text] ?? text;
  }

  @override
  void initState() {
    super.initState();
    _startSlideshow();
  }

  void _startSlideshow() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _totalSteps - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, String>> steps = [
    {
      'title': "Identify Exits",
      'description': "Always be aware of your surroundings and identify possible exits.",
      'imagePath': "assets/images/identify_exits.webp",
    },
    {
      'title': "Create Distance",
      'description': "Put as much distance between you and the attacker as possible.",
      'imagePath': "assets/images/s2.jpg",
    },
    {
      'title': "Use Obstacles",
      'description': "Use furniture or other obstacles to block the attacker's path.",
      'imagePath': "assets/images/s3.jpg",
    },
    {
      'title': "Call for Help",
      'description': "Yell for help to attract attention and deter the attacker.",
      'imagePath': "assets/images/call_for_help.png",
    },
    {
      'title': "Stay Calm",
      'description': "Keep a clear mind to make quick decisions during an escape.",
      'imagePath': "assets/images/s1.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double headerImageHeight = isLandscape ? screenSize.height * 0.3 : screenSize.height * 0.25;
    final double contentPadding = screenSize.width * 0.04;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: screenSize.height * 0.08,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, size: screenSize.width * 0.06),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    currentLanguageIndex = (currentLanguageIndex + 1) % translations.length; // Cycle through languages
                  });
                },
                child: Text(
                  currentLanguageIndex == 0 ? 'हिंदी' : currentLanguageIndex == 1 ? 'मराठी' : 'EN',
                  style: TextStyle(
                    color: Colors.white ,fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: 'escape_techniques_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/SD4.jpg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: headerImageHeight,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: contentPadding),
 child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(contentPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.shade100,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        getTranslatedText('Escape Techniques'),
                        style: TextStyle(
                          fontSize: screenSize.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isLandscape ? screenSize.height * 0.7 : screenSize .height * 0.5,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemCount: steps.length,
                          itemBuilder: (context, index) {
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: _currentPage == index ? 1.0 : 0.5,
                              child: Padding(
                                padding: EdgeInsets.all(contentPadding),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.shade100,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(contentPadding),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${getTranslatedText('Step')} ${index + 1}: ${getTranslatedText(steps[index]['title']!)}",
                                          style: TextStyle(
                                            fontSize: screenSize.width * 0.045,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(height: contentPadding),
                                        AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset(
                                              steps[index]['imagePath']!,
 fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: contentPadding),
                                        Text(
                                          getTranslatedText(steps[index]['description']!),
                                          style: TextStyle(
                                            fontSize: screenSize.width * 0.04,
                                            color: Colors.grey.shade700,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: contentPadding,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: contentPadding),
                            color: Colors.white.withOpacity(0.8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_left, size: screenSize.width * 0.06),
                                  onPressed: () {
                                    if (_currentPage > 0) {
                                      _pageController.previousPage(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    steps.length,
                                    (index) => Container(
                                      margin: EdgeInsets.symmetric(horizontal: contentPadding * 0.25),
                                      width: screenSize.width * 0.02,
                                      height: screenSize.width * 0.02,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentPage == index ? Colors.red : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_right, size: screenSize.width * 0.06),
                                  onPressed: () {
                                    if (_currentPage < steps.length - 1) {
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}