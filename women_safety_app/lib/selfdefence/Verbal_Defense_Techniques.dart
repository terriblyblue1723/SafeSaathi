import 'package:flutter/material.dart';
import 'dart:async';

class VerbalDefenseTechniques extends StatefulWidget {
  const VerbalDefenseTechniques({Key? key}) : super(key: key);

  @override
  State<VerbalDefenseTechniques> createState() => _VerbalDefenseTechniquesState();
}

class _VerbalDefenseTechniquesState extends State<VerbalDefenseTechniques> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Verbal Defense Techniques': 'Verbal Defense Techniques',
      'Use a Firm Voice': 'Use a Firm Voice',
      'Speak clearly and assertively to convey confidence.': 'Speak clearly and assertively to convey confidence.',
      'Set Boundaries': 'Set Boundaries',
      'Clearly state what behavior is unacceptable.': 'Clearly state what behavior is unacceptable.',
      'Use Humor': 'Use Humor',
      'Defuse a tense situation with humor to disarm the attacker.': 'Defuse a tense situation with humor to disarm the attacker.',
      'Stay Calm': 'Stay Calm',
      'Maintain composure to think clearly and respond effectively.': 'Maintain composure to think clearly and respond effectively.',
      'Seek Help': 'Seek Help',
      'Always look for opportunities to get help from others.': 'Always look for opportunities to get help from others.',
      'Step': 'Step',
    },
    { // Hindi
      'Verbal Defense Techniques': 'मौखिक रक्षा तकनीकें',
      'Use a Firm Voice': 'एक मजबूत आवाज़ का उपयोग करें',
      'Speak clearly and assertively to convey confidence.': 'आत्मविश्वास व्यक्त करने के लिए स्पष्ट और आत्मविश्वास से बोलें।',
      'Set Boundaries': 'सीमाएँ निर्धारित करें',
      'Clearly state what behavior is unacceptable.': 'स्पष्ट रूप से बताएं कि कौन सा व्यवहार अस्वीकार्य है।',
      'Use Humor': 'हास्य का उपयोग करें',
      'Defuse a tense situation with humor to disarm the attacker.': 'हमलावर को निरस्त्र करने के लिए तनावपूर्ण स्थिति को हास्य से कम करें।',
      'Stay Calm': 'शांत रहें',
      'Maintain composure to think clearly and respond effectively.': 'स्पष्टता से सोचने और प्रभावी ढंग से प्रतिक्रिया देने के लिए संयम बनाए रखें।',
      'Seek Help': 'मदद मांगें',
      'Always look for opportunities to get help from others.': 'हमेशा दूसरों से मदद पाने के अवसरों की तलाश करें।',
      'Step': 'चरण',
    },
    { // Marathi
      'Verbal Defense Techniques': 'मौखिक संरक्षण तंत्र',
      'Use a Firm Voice': 'एक ठाम आवाज वापरा',
      'Speak clearly and assertively to convey confidence.': 'आत्मविश्वास व्यक्त करण्यासाठी स्पष्ट आणि ठामपणे बोला.',
      'Set Boundaries': 'सीमांचे निर्धारण करा',
      'Clearly state what behavior is unacceptable.': 'काय वर्तन अस्वीकार्य आहे हे स्पष्टपणे सांगा.',
      'Use Humor': 'हास्याचा वापर करा',
      'Defuse a tense situation with humor to disarm the attacker.': 'हल्लेखोराला निरस्त्र करण्यासाठी ताणतणावाची परिस्थिती हास्याने कमी करा.',
      'Stay Calm': 'शांत रहा',
      'Maintain composure to think clearly and respond effectively.': 'स्पष्टपणे विचार करण्यासाठी आणि प्रभावीपणे प्रतिसाद देण्यासाठी संयम ठेवा.',
      'Seek Help': 'मदतीसाठी मागणी करा',
      'Always look for opportunities to get help from others.': 'नेहमी इतरांकडून मदतीसाठी संधी शोधा.',
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
      'title': "Use a Firm Voice",
      'description': "Speak clearly and assertively to convey confidence.",
      'imagePath': "assets/images/firm_voice.png",
    },
    {
      'title': "Set Boundaries",
      'description': "Clearly state what behavior is unacceptable.",
      'imagePath': "assets/images/set_boundaries.png",
    },
    {
      'title': "Use Humor",
      'description': "Defuse a tense situation with humor to disarm the attacker.",
      'imagePath': "assets/images/use_humor.png",
    },
    {
      'title': "Stay Calm",
      'description': "Maintain composure to think clearly and respond effectively.",
      'imagePath': "assets/images/stay_calm.png",
    },
    {
      'title': "Seek Help",
      'description': "Always look for opportunities to get help from others.",
      'imagePath': "assets/images/s1.jpg",
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
                    tag: 'verbal_defense_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/SD6.jpg",
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
                        getTranslatedText('Verbal Defense Techniques'),
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