import 'package:flutter/material.dart';
import 'dart:async';

class EverydayObjectDefense extends StatefulWidget {
  const EverydayObjectDefense({Key? key}) : super(key: key);

  @override
  State<EverydayObjectDefense> createState() => _EverydayObjectDefenseState();
}

class _EverydayObjectDefenseState extends State<EverydayObjectDefense> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Everyday Object Defense Techniques': 'Everyday Object Defense Techniques',
      'Use a Bag': 'Use a Bag',
      'Swing your bag to create distance or distract the attacker.': 'Swing your bag to create distance or distract the attacker.',
      'Keys as a Weapon': 'Keys as a Weapon',
      'Hold your keys between your fingers to use as a striking tool.': 'Hold your keys between your fingers to use as a striking tool.',
      'Umbrella Defense': 'Umbrella Defense',
      'Use an umbrella to block or strike an attacker.': 'Use an umbrella to block or strike an attacker.',
      'Belt as a Tool': 'Belt as a Tool',
      'Use your belt to whip or entangle an attacker\'s limbs.': 'Use your belt to whip or entangle an attacker\'s limbs.',
      'Stun Gun': 'Stun Gun',
      'If available, use a stun gun to incapacitate the attacker.': 'If available, use a stun gun to incapacitate the attacker.',
      'Step': 'Step',
    },
    { // Hindi
      'Everyday Object Defense Techniques': 'रोज़मर्रा की वस्तुओं से आत्मरक्षा तकनीकें',
      'Use a Bag': 'बैग का उपयोग करें',
      'Swing your bag to create distance or distract the attacker.': 'दूरी बनाने या हमलावर को विचलित करने के लिए अपने बैग को लहराएं।',
      'Keys as a Weapon': 'चाबी को हथियार के रूप में उपयोग करें',
      'Hold your keys between your fingers to use as a striking tool.': 'प्रहार करने के उपकरण के रूप में अपनी उंगलियों के बीच चाबियाँ पकड़ें।',
      'Umbrella Defense': 'छाता रक्षा',
      'Use an umbrella to block or strike an attacker.': 'हमलावर को रोकने या प्रहार करने के लिए छाता का उपयोग करें।',
      'Belt as a Tool': 'बेल्ट को उपकरण के रूप में उपयोग करें',
      'Use your belt to whip or entangle an attacker\'s limbs.': 'हमलावर के अंगों को लपेटने या मारने के लिए अपनी बेल्ट का उपयोग करें।',
      'Stun Gun': 'स्टन गन',
      'If available, use a stun gun to incapacitate the attacker.': 'यदि उपलब्ध हो, तो हमलावर को अक्षम करने के लिए स्टन गन का उपयोग करें।',
      'Step': 'चरण',
    },
    { // Marathi
      'Everyday Object Defense Techniques': 'दररोजच्या वस्तूंचा बचाव तंत्र',
      'Use a Bag': 'बॅगचा वापर करा',
      'Swing your bag to create distance or distract the attacker.': 'दूरी निर्माण करण्यासाठी किंवा हल्लेखोराला विचलित करण्यासाठी तुमची बॅग हलवा.',
      'Keys as a Weapon': 'चाब्या शस्त्र म्हणून वापरा',
      'Hold your keys between your fingers to use as a striking tool.': 'प्रहार करण्यासाठी तुमच्या बोटांमध्ये चाब्या ठेवा.',
      'Umbrella Defense': 'छत्रीचा बचाव',
      'Use an umbrella to block or strike an attacker.': 'हल्लेखोराला थांबवण्यासाठी किंवा प्रहार करण्यासाठी छत्रीचा वापर करा.',
      'Belt as a Tool': 'बेल्टचा वापर करा',
      'Use your belt to whip or entangle an attacker\'s limbs.': 'हल्लेखोराच्या अंगांना लपेटण्यासाठी किंवा मारण्यासाठी तुमचा बेल्ट वापरा.',
      'Stun Gun': 'स्टन गन',
      'If available, use a stun gun to incapacitate the attacker.': 'जर उपलब्ध असेल तर हल्लेखोराला अक्षम करण्यासाठी स्टन गन वापरा.',
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
      'title': "Use a Bag",
      'description': "Swing your bag to create distance or distract the attacker.",
      'imagePath': "assets/images/use_bag.jpg",
    },
    {
      'title': "Keys as a Weapon",
      'description': "Hold your keys between your fingers to use as a striking tool.",
      'imagePath': "assets/images/keys_weapon.jpg",
    },
    {
      'title': "Umbrella Defense",
      'description': "Use an umbrella to block or strike an attacker.",
      'imagePath': "assets/images/umbrella_defense.jpg",
    },
    {
      'title': "Belt as a Tool",
      'description': "Use your belt to whip or entangle an attacker's limbs.",
      'imagePath': "assets/images/belt_tool.webp",
    },
    {
      'title': "Stun Gun",
      'description': "If available, use a stun gun to incapacitate the attacker.",
      'imagePath': "assets/images/stun_gun.jpg",
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
                    // Toggle language
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
                    tag: 'everyday_object_defense_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/SD3.webp",
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
                        getTranslatedText('Everyday Object Defense Techniques'),
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