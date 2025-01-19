import 'package:flutter/material.dart';
import 'dart:async';

class MartialArtsBasics extends StatefulWidget {
  const MartialArtsBasics({Key? key}) : super(key: key);

  @override
  State<MartialArtsBasics> createState() => _MartialArtsBasicsState();
}

class _MartialArtsBasicsState extends State<MartialArtsBasics> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Martial Arts Basics': 'Martial Arts Basics',
      'Stance': 'Stance',
      'Learn the basic stances to maintain balance and readiness.': 'Learn the basic stances to maintain balance and readiness.',
      'Basic Punch': 'Basic Punch',
      'Practice the proper technique for delivering a punch.': 'Practice the proper technique for delivering a punch.',
      'Kicking Techniques': 'Kicking Techniques',
      'Understand the fundamentals of various kicking techniques.': 'Understand the fundamentals of various kicking techniques.',
      'Blocking': 'Blocking',
      'Learn how to effectively block incoming attacks.': 'Learn how to effectively block incoming attacks.',
      'Footwork': 'Footwork',
      'Master the footwork necessary for effective movement.': 'Master the footwork necessary for effective movement.',
      'Step': 'Step',
    },
    { // Hindi
      'Martial Arts Basics': 'मार्शल आर्ट्स के मूलभूत सिद्धांत',
      'Stance': 'स्थिति',
      'Learn the basic stances to maintain balance and readiness.': 'संतुलन और तत्परता बनाए रखने के लिए मूलभूत स्थितियों को सीखें।',
      'Basic Punch': 'मूल पंच',
      'Practice the proper technique for delivering a punch.': 'पंच देने की सही तकनीक का अभ्यास करें।',
      'Kicking Techniques': 'लात मारने की तकनीकें',
      'Understand the fundamentals of various kicking techniques.': 'विभिन्न लात मारने की तकनीकों के मूल सिद्धांतों को समझें।',
      'Blocking': 'ब्लॉकिंग',
      'Learn how to effectively block incoming attacks.': 'आने वाले हमलों को प्रभावी ढंग से रोकना सीखें।',
      'Footwork': 'फुटवर्क',
      'Master the footwork necessary for effective movement.': 'प्रभावी आंदोलन के लिए आवश्यक फुटवर्क में महारत हासिल करें।',
      'Step': 'चरण',
    },
    { // Marathi
      'Martial Arts Basics': 'मार्शल आर्ट्सचे मूलभूत तत्त्व',
      'Stance': 'स्थिती',
      'Learn the basic stances to maintain balance and readiness.': 'संतुलन आणि तत्परता राखण्यासाठी मूलभूत स्थिती शिकणे.',
      'Basic Punch': 'मूल पंच',
      'Practice the proper technique for delivering a punch.': 'पंच देण्यासाठी योग्य तंत्राचा अभ्यास करा.',
      'Kicking Techniques': 'लात मारण्याच्या तंत्रे',
      'Understand the fundamentals of various kicking techniques.': 'विभिन्न लात मारण्याच्या तंत्रांचे मूलभूत ज्ञान मिळवा.',
      'Blocking': 'ब्लॉकिंग',
      'Learn how to effectively block incoming attacks.': 'आगामी हल्ले प्रभावीपणे कसे थांबवायचे ते शिका.',
      'Footwork': 'फुटवर्क',
      'Master the footwork necessary for effective movement.': 'प्रभावी हालचालीसाठी आवश्यक फुटवर्कमध्ये प्रावीणता मिळवा.',
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
      'title': "Stance",
      'description': "Learn the basic stances to maintain balance and readiness.",
      'imagePath': "assets/images/stance.jpg",
    },
    {
      'title': "Basic Punch",
      'description': "Practice the proper technique for delivering a punch.",
      'imagePath': "assets/images/basic_punch.jpg",
    },
    {
      'title': "Kicking Techniques",
      'description': "Understand the fundamentals of various kicking techniques.",
      'imagePath': "assets/images/kicking_techniques.jpg",
    },
    {
      'title': "Blocking",
      'description': "Learn how to effectively block incoming attacks.",
      'imagePath': "assets/images/blocking.webp",
    },
    {
      'title': "Footwork",
      'description': "Master the footwork necessary for effective movement.",
      'imagePath': "assets/images/footwork.jpg",
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
                    color: Colors.white,
                    fontSize: screenSize.width * 0.04,
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
                    tag: 'martial_arts_basics_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/SD5.jpg",
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
                        getTranslatedText('Martial Arts Basics'),
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
                    height: isLandscape ? screenSize.height * 0.7 : screenSize.height * 0.5,
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