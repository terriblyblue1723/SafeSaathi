import 'package:flutter/material.dart';
import 'dart:async';


class MenstrualEmergency extends StatefulWidget {
  const MenstrualEmergency({Key? key}) : super(key: key);

  @override
  State<MenstrualEmergency> createState() => _MenstrualEmergencyState();
}

class _MenstrualEmergencyState extends State<MenstrualEmergency> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  bool isHindi = false; // Language toggle state

  // Hindi translations
  final Map<String, String> translations = {
    'Menstrual Emergency Response': 'मासिक धर्म आपातकालीन प्रतिक्रिया',
    'Track Your Cycle': 'अपने चक्र को ट्रैक करें',
    'Keep track of your menstrual cycle to understand the symptoms that may arise during your period.':
    'अपने मासिक धर्म चक्र को ट्रैक करें ताकि आप उन लक्षणों को समझ सकें जो आपके पीरियड के दौरान उत्पन्न हो सकते हैं।',
    'Pain Management': 'दर्द प्रबंधन',
    'Use heating pads or take over-the-counter pain relief medication to reduce cramps and discomfort.':
    'संकुचन और असुविधा को कम करने के लिए हीटिंग पैड का उपयोग करें या ओवर-द-काउंटर दर्द निवारक दवा लें।',
    'Stay Hydrated': 'हाइड्रेटेड रहें',
    'Drink plenty of water to help ease bloating and prevent dehydration, which can worsen cramps.':
    'फूलने को कम करने और निर्जलीकरण से बचने के लिए बहुत सारा पानी पिएं, जो संकुचन को बढ़ा सकता है।',
    'Seek Medical Help': 'चिकित्सा सहायता प्राप्त करें',
    'If your symptoms worsen or if you\'re unable to manage the pain, don\'t hesitate to consult with a healthcare provider.':
    'यदि आपके लक्षण बिगड़ते हैं या यदि आप दर्द को प्रबंधित करने में असमर्थ हैं, तो स्वास्थ्य सेवा प्रदाता से परामर्श करने में संकोच न करें।',
    'Rest and Relax': 'आराम करें और विश्राम करें',
    'Make sure to rest, avoid overexerting yourself, and practice relaxation techniques like deep breathing.':
    'आराम करें, अधिक मेहनत करने से बचें, और गहरी सांस लेने जैसी विश्राम तकनीकों का अभ्यास करें।',
    'Step': 'चरण',
  };

  String getTranslatedText(String text) {
    if (!isHindi) return text;
    return translations[text] ?? text;
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
      'title': "Track Your Cycle",
      'description': "Keep track of your menstrual cycle to understand the symptoms that may arise during your period.",
      'imagePath': "assets/firstaid/MenstrualEmergency/ME1.jpeg",
    },
    {
      'title': "Pain Management",
      'description': "Use heating pads or take over-the-counter pain relief medication to reduce cramps and discomfort.",
      'imagePath': "assets/firstaid/MenstrualEmergency/ME2.jpeg",
    },
    {
      'title': "Stay Hydrated",
      'description': "Drink plenty of water to help ease bloating and prevent dehydration, which can worsen cramps.",
      'imagePath': "assets/firstaid/MenstrualEmergency/ME3.jpeg",
    },
    {
      'title': "Seek Medical Help",
      'description': "If your symptoms worsen or if you're unable to manage the pain, don't hesitate to consult with a healthcare provider.",
      'imagePath': "assets/firstaid/MenstrualEmergency/ME4.jpeg",
    },
    {
      'title': "Rest and Relax",
      'description': "Make sure to rest, avoid overexerting yourself, and practice relaxation techniques like deep breathing.",
      'imagePath': "assets/firstaid/MenstrualEmergency/ME5.jpeg",
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
                    isHindi = !isHindi;
                  });
                },
                child: Text(
                  isHindi ? 'EN' : 'हिंदी',
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
                    tag: 'menstrual_emergencies_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/firstaid/f5.png",
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
                        getTranslatedText('Menstrual Emergency Response '),
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