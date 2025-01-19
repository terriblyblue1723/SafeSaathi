import 'package:flutter/material.dart';
import 'dart:async';

class PhysicalAssault extends StatefulWidget {
  const PhysicalAssault({Key? key}) : super(key: key);

  @override
  State<PhysicalAssault> createState() => _PhysicalAssaultState();
}

class _PhysicalAssaultState extends State<PhysicalAssault> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  bool isHindi = false; // Language toggle state
  int currentLanguageIndex = 0;

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Physical Assault Defense': 'Physical Assault Defense',
      'Block Attacker\'s Strike': 'Block Attacker\'s Strike',
      'Raise your arms to block an incoming punch or strike. This helps reduce the impact and keeps you safer.':
      'Raise your arms to block an incoming punch or strike. This helps reduce the impact and keeps you safer.',
      'Target Weak Spots': 'Target Weak Spots',
      'Aim for sensitive areas like the eyes, throat, or groin to quickly disable the attacker.':
      'Aim for sensitive areas like the eyes, throat, or groin to quickly disable the attacker.',
      'Escape Holds': 'Escape Holds',
      'Break free by rotating your wrist towards the attacker\'s thumb or using sharp elbow strikes.':
      'Break free by rotating your wrist towards the attacker\'s thumb or using sharp elbow strikes.',
      'Use Nearby Objects': 'Use Nearby Objects',
      'Look for objects around you to defend yourself, such as keys, bags, or even a pen.':
      'Look for objects around you to defend yourself, such as keys, bags, or even a pen.',
      'Run to Safety': 'Run to Safety',
      'The ultimate goal is to escape. Create distance and run towards a safe location or people.':
      'The ultimate goal is to escape. Create distance and run towards a safe location or people.',
      'Step': 'Step',
    },
    { // Hindi
      'Physical Assault Defense': 'शारीरिक हमले की रक्षा',
      'Block Attacker\'s Strike': 'हमलावर के प्रहार को रोकें',
      'Raise your arms to block an incoming punch or strike. This helps reduce the impact and keeps you safer.':
      'अपने हाथ उठाएं ताकि आने वाले मुक्के या प्रहार को रोक सकें। इससे प्रभाव कम होता है और आप सुरक्षित रहते हैं।',
      'Target Weak Spots': 'कमजोर स्थानों को निशाना बनाएं',
      'Aim for sensitive areas like the eyes, throat, or groin to quickly disable the attacker.':
      'हमलावर को जल्दी से निष्क्रिय करने के लिए आंखों, गले या जांघ जैसे संवेदनशील क्षेत्रों को निशाना बनाएं।',
      'Escape Holds': 'पकड़ से बचें',
      'Break free by rotating your wrist towards the attacker\'s thumb or using sharp elbow strikes.':
      'हमलावर के अंगूठे की ओर अपनी कलाई को घुमाकर या तेज कोहनी के प्रहार का उपयोग करके मुक्त हों।',
      'Use Nearby Objects': 'आसपास की वस्तुओं का उपयोग करें',
      'Look for objects around you to defend yourself, such as keys, bags, or even a pen.':
      'अपने बचाव के लिए आसपास की वस्तुओं की तलाश करें, जैसे चाबियाँ, बैग, या यहां तक कि एक पेन।',
      'Run to Safety': 'सुरक्षित स्थान पर भागें',
      'The ultimate goal is to escape. Create distance and run towards a safe location or people.':
      'अंतिम लक्ष्य भागना है। दूरी बनाएं और सुरक्षित स्थान या लोगों की ओर भागें।',
      'Step': 'चरण',
    },
    { // Marathi
      'Physical Assault Defense': 'शारीरिक हल्ला संरक्षण',
      'Block Attacker\'s Strike': 'हल्लेखोराचा प्रहार थांबवा',
      'Raise your arms to block an incoming punch or strike. This helps reduce the impact and keeps you safer.':
      'आगामी मुक्का किंवा प्रहार थांबवण्यासाठी तुमचे हात उंच करा. यामुळे प्रभाव कमी होतो आणि तुम्हाला सुरक्षित ठेवते.',
      'Target Weak Spots': 'कमजोर ठिकाणे लक्ष्य करा',
      'Aim for sensitive areas like the eyes, throat, or groin to quickly disable the attacker.':
      'हल्लेखोराला लवकर निष्क्रिय करण्यासाठी डोळे, गळा किंवा जांघ यांसारख्या संवेदनशील भागांवर लक्ष्य ठेवा.',
      'Escape Holds': 'पकडीतून सुटका करा',
      'Break free by rotating your wrist towards the attacker\'s thumb or using sharp elbow strikes.':
      'हल्लेखोराच्या अंगठ्याकडे तुमची कलाई फिरवून किंवा तीव्र कोपराच्या प्रहारांचा वापर करून सुटका करा.',
      'Use Nearby Objects': 'आसपासच्या वस्तूंचा वापर करा',
      'Look for objects around you to defend yourself, such as keys, bags, or even a pen.':
      'तुमच्या बचावासाठी आसपासच्या वस्तूंचा शोध घ्या, जसे की चाब्या, बॅग किंवा अगदी एक पेन.',
      'Run to Safety': 'सुरक्षिततेकडे धावा',
      'The ultimate goal is to escape. Create distance and run towards a safe location or people.':
      'अंतिम उद्दिष्ट म्हणजे पळून जाणे. अंतर तयार करा आणि सुरक्षित ठिकाण किंवा लोकांकडे धावा.',
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
      setState(() {
        _currentPage = (_currentPage + 1) % _totalSteps;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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
      'title': "Block Attacker's Strike",
      'description': "Raise your arms to block an incoming punch or strike. This helps reduce the impact and keeps you safer.",
      'imagePath': "assets/firstaid/PhysicalAssault/PA1.jpeg",
    },
    {
      'title': "Target Weak Spots",
      'description': "Aim for sensitive areas like the eyes, throat, or groin to quickly disable the attacker.",
      'imagePath': "assets/firstaid/PhysicalAssault/PA2.jpeg",
    },
    {
      'title': "Escape Holds",
      'description': "Break free by rotating your wrist towards the attacker's thumb or using sharp elbow strikes.",
      'imagePath': "assets/firstaid/PhysicalAssault/PA3.jpeg",
    },
    {
      'title': "Use Nearby Objects",
      'description': "Look for objects around you to defend yourself, such as keys, bags, or even a pen.",
      'imagePath': "assets/firstaid/PhysicalAssault/PA4.jpeg",
    },
    {
      'title': "Run to Safety",
      'description': "The ultimate goal is to escape. Create distance and run towards a safe location or people.",
      'imagePath': "assets/firstaid/PhysicalAssault/PA5.jpeg",
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
        ),body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: 'physical_assault_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/firstaid/PhysicalAssault.jpeg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: headerImageHeight,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isLandscape ? screenSize.height * 0.7 : screenSize.height * 0.6,
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
                                            color: Colors.red.shade600,
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