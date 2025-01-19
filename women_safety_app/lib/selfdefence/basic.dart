import 'package:flutter/material.dart';
import 'dart:async';

class Basic extends StatefulWidget {
  const Basic({Key? key}) : super(key: key);

  @override
  State<Basic> createState() => _BasicState();
}

class _BasicState extends State<Basic> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Basic Self-Defense Moves': 'Basic Self-Defense Moves',
      'Palm Strike': 'Palm Strike',
      'Use the base of your palm to target an attacker\'s nose or jaw. This can disorient the attacker and provide you with a chance to escape.':
      'Use the base of your palm to target an attacker\'s nose or jaw. This can disorient the attacker and provide you with a chance to escape.',
      'Elbow Strike': 'Elbow Strike',
      'If the attacker is close, use your elbow to hit sensitive areas such as the chin or stomach.':
      'If the attacker is close, use your elbow to hit sensitive areas such as the chin or stomach.',
      'Knee Strike': 'Knee Strike',
      'Target the attacker\'s groin with your knee for maximum impact, especially if they are directly in front of you.':
      'Target the attacker\'s groin with your knee for maximum impact, especially if they are directly in front of you.',
      'Escape from Wrist Hold': 'Escape from Wrist Hold',
      'Rotate your wrist towards the attacker\'s thumb to break free. Follow up with a strike or create distance immediately.':
      'Rotate your wrist towards the attacker\'s thumb to break free. Follow up with a strike or create distance immediately.',
      'Shout for Help': 'Shout for Help',
      'Always yell loudly for help to alert others nearby and to intimidate the attacker.':
      'Always yell loudly for help to alert others nearby and to intimidate the attacker.',
      'Step': 'Step',
    },
    { // Hindi
      'Basic Self-Defense Moves': 'मूल आत्मरक्षा युक्तियाँ',
      'Palm Strike': 'हथेली का प्रहार',
      'Use the base of your palm to target an attacker\'s nose or jaw. This can disorient the attacker and provide you with a chance to escape.':
      'हमलावर की नाक या जबड़े को निशाना बनाने के लिए अपनी हथेली का आधार उपयोग करें। यह हमलावर को भ्रमित कर सकता है और आपको बचने का मौका प्रदान कर सकता है।',
      'Elbow Strike': 'कोहनी का प्रहार',
      'If the attacker is close, use your elbow to hit sensitive areas such as the chin or stomach.':
      'यदि हमलावर नज़दीक है, तो ठोड़ी या पेट जैसे संवेदनशील क्षेत्रों पर प्रहार करने के लिए अपनी कोहनी का उपयोग करें।',
      'Knee Strike': 'घुटने का प्रहार',
      'Target the attacker\'s groin with your knee for maximum impact, especially if they are directly in front of you.':
      'अधिकतम प्रभाव के लिए अपने घुटने से हमलावर की जांघ को निशाना बनाएं, विशेष रूप से यदि वे सीधे आपके सामने हैं।',
      'Escape from Wrist Hold': 'कलाई की पकड़ से बचना',
      'Rotate your wrist towards the attacker\'s thumb to break free. Follow up with a strike or create distance immediately.':
      'मुक्त होने के लिए अपनी कलाई को हमलावर के अंगूठे की ओर घुमाएं। तुरंत प्रहार करें या दूरी बनाएं।',
      'Shout for Help': 'मदद के लिए चिल्लाएं',
      'Always yell loudly for help to alert others nearby and to intimidate the attacker.':
      'आस-पास के लोगों को सतर्क करने और हमलावर को डराने के लिए हमेशा जोर से मदद के लिए चिल्लाएं।',
      'Step': 'चरण',
    },
    { // Marathi
      'Basic Self-Defense Moves': 'मूल आत्मसंरक्षण चाली',
      'Palm Strike': 'हथेलीचा प्रहार',
      'Use the base of your palm to target an attacker\'s nose or jaw. This can disorient the attacker and provide you with a chance to escape .':
      'आपल्या हाताच्या तळाशीचा भाग वापरून हल्लेखोराच्या नाक किंवा जबड्यावर लक्ष्य ठेवा. हे हल्लेखोराला गोंधळात टाकू शकते आणि तुम्हाला पळून जाण्याची संधी देऊ शकते.',
      'Elbow Strike': 'कोहनीचा प्रहार',
      'If the attacker is close, use your elbow to hit sensitive areas such as the chin or stomach.':
      'जर हल्लेखोर जवळ असेल, तर ठोड़ी किंवा पोटासारख्या संवेदनशील भागांवर प्रहार करण्यासाठी तुमची कोहनी वापरा.',
      'Knee Strike': 'घुटनेचा प्रहार',
      'Target the attacker\'s groin with your knee for maximum impact, especially if they are directly in front of you.':
      'अधिकतम प्रभावासाठी तुमच्या घुटनेने हल्लेखोराच्या जांघेला लक्ष्य ठेवा, विशेषतः जर ते तुमच्या समोर थेट असतील.',
      'Escape from Wrist Hold': 'कलाईच्या पकडीतून पळा',
      'Rotate your wrist towards the attacker\'s thumb to break free. Follow up with a strike or create distance immediately.':
      'मुक्त होण्यासाठी तुमची कलाई हल्लेखोराच्या अंगठ्याकडे फिरवा. तात्काळ प्रहार करा किंवा अंतर तयार करा.',
      'Shout for Help': 'मदतीसाठी चिल्ला',
      'Always yell loudly for help to alert others nearby and to intimidate the attacker.':
      'आस-पासच्या लोकांना सतर्क करण्यासाठी आणि हल्लेखोराला भिती दाखवण्यासाठी नेहमी जोरात मदतीसाठी चिल्ला.',
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
      'title': "Palm Strike",
      'description': "Use the base of your palm to target an attacker's nose or jaw. This can disorient the attacker and provide you with a chance to escape.",
      'imagePath': "assets/images/palm_strike.png",
    },
    {
      'title': "Elbow Strike",
      'description': "If the attacker is close, use your elbow to hit sensitive areas such as the chin or stomach.",
      'imagePath': "assets/images/elbow_strike.jpg",
    },
    {
      'title': "Knee Strike",
      'description': "Target the attacker's groin with your knee for maximum impact, especially if they are directly in front of you.",
      'imagePath': "assets/images/Knee_strike.jpg",
    },
    {
      'title': "Escape from Wrist Hold",
      'description': "Rotate your wrist towards the attacker's thumb to break free. Follow up with a strike or create distance immediately.",
      'imagePath': "assets/images/wrist_escape.jpg",
    },
    {
      'title': "Shout for Help",
      'description': "Always yell loudly for help to alert others nearby and to intimidate the attacker.",
      'imagePath': "assets/images/shout_for_help.jpg",
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
                    tag: 'basic_defense_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/SD1.jpg",
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
                        getTranslatedText('Basic Self-Defense Moves'),
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
                            return AnimatedSlide(
                              duration: const Duration(milliseconds: 500),
                              offset: _currentPage == index ? Offset.zero : Offset(1.0, 0.0),
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
                                        AnimatedScale(
                                          duration: const Duration(milliseconds: 500),
                                          scale: _currentPage == index ? 1.0 : 0.8,
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.asset(
                                                steps[index]['imagePath']!,
                                                fit: BoxFit.contain,
                                              ),
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

class AnimatedSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Offset offset;

  const AnimatedSlide({
    Key? key,
    required this.child,
    required this.duration,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(offset.dx * MediaQuery.of(context).size.width, 0, 0),
      child: child,
    );
  }
}

class AnimatedScale extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double scale;

  const AnimatedScale({
    Key? key,
    required this.child,
    required this.duration,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      transform: Matrix4.diagonal3Values(scale, scale, 1),
      child: child,
    );
  }
}