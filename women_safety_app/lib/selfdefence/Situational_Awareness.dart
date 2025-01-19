import 'package:flutter/material.dart';
import 'dart:async';

class SituationalAwareness extends StatefulWidget {
  const SituationalAwareness({Key? key}) : super(key: key);

  @override
  State<SituationalAwareness> createState() => _SituationalAwarenessState();
}

class _SituationalAwarenessState extends State<SituationalAwareness> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Situational Awareness Techniques': 'Situational Awareness Techniques',
      'Stay Aware': 'Stay Aware',
      'Always be aware of your surroundings and the people around you.': 'Always be aware of your surroundings and the people around you.',
      'Trust Your Instincts': 'Trust Your Instincts',
      'If something feels off, trust your gut and take action.': 'If something feels off, trust your gut and take action.',
      'Avoid Distractions': 'Avoid Distractions',
      'Stay off your phone and avoid distractions when in public.': 'Stay off your phone and avoid distractions when in public.',
      'Plan Your Route': 'Plan Your Route',
      'Know your route and avoid isolated areas.': 'Know your route and avoid isolated areas.',
      'Stay in Groups': 'Stay in Groups',
      'Whenever possible, travel with others to enhance safety.': 'Whenever possible, travel with others to enhance safety.',
      'Step': 'Step',
    },
    { // Hindi
      'Situational Awareness Techniques': 'परिस्थितिजन्य जागरूकता तकनीकें',
      'Stay Aware': 'जागरूक रहें',
      'Always be aware of your surroundings and the people around you.': 'हमेशा अपने चारों ओर के वातावरण और लोगों के प्रति जागरूक रहें।',
      'Trust Your Instincts': 'अपने अंतर्ज्ञान पर भरोसा करें',
      'If something feels off, trust your gut and take action.': 'यदि कुछ गलत लगता है, तो अपने अंतर्ज्ञान पर भरोसा करें और कार्रवाई करें।',
      'Avoid Distractions': 'विचलनों से बचें',
      'Stay off your phone and avoid distractions when in public.': 'सार्वजनिक स्थानों पर अपने फोन से दूर रहें और विचलनों से बचें।',
      'Plan Your Route': 'अपने मार्ग की योजना बनाएं',
      'Know your route and avoid isolated areas.': 'अपने मार्ग को जानें और एकाकी क्षेत्रों से बचें।',
      'Stay in Groups': 'समूह में रहें',
      'Whenever possible, travel with others to enhance safety.': 'जब भी संभव हो, दूसरों के साथ यात्रा करें ताकि सुरक्षा बढ़ सके।',
      'Step': 'चरण',
    },
    { // Marathi
      'Situational Awareness Techniques': 'परिस्थितिजन्य जागरूकता तंत्र',
      'Stay Aware': 'जागरूक राहा',
      'Always be aware of your surroundings and the people around you.': 'सर्व वेळ आपल्या आजुबाजुच्या वातावरणाबद्दल आणि लोकांबद्दल जागरूक राहा.',
      'Trust Your Instincts': 'आपल्या अंतर्ज्ञानावर विश्वास ठेवा',
      'If something feels off, trust your gut and take action.': 'जर काही चुकीचे वाटत असेल तर आपल्या अंतर्ज्ञानावर विश्वास ठेवा आणि कारवाई करा.',
      'Avoid Distractions': 'विचलन टाळा',
      'Stay off your phone and avoid distractions when in public.': 'सार्वजनिक ठिकाणी असताना आपल्या फोनपासून दूर राहा आणि विचलन टाळा.',
      'Plan Your Route': 'आपला मार्ग ठरवा',
      'Know your route and avoid isolated areas.': 'आपला मार्ग जाणून घ्या आणि एकाकी क्षेत्रे टाळा.',
      'Stay in Groups': 'गटात राहा',
      'Whenever possible, travel with others to enhance safety.': 'जेव्हा शक्य असेल तेव्हा इतरांसोबत प्रवास करा जेणेकरून सुरक्षा वाढेल.',
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
      'title': "Stay Aware",
      'description': "Always be aware of your surroundings and the people around you.",
      'imagePath': "assets/images/stay_aware.webp",
    },
    {
      'title': "Trust Your Instincts",
      'description': "If something feels off, trust your gut and take action.",
      'imagePath': "assets/images/trust_instincts.jpg",
    },
    {
      'title': "Avoid Distractions",
      'description': "Stay off your phone and avoid distractions when in public.",
      'imagePath': "assets/images/avoid_distractions.png",
    },
    {
      'title': "Plan Your Route",
      'description': "Know your route and avoid isolated areas.",
      'imagePath': "assets/images/plan_route.jpg",
    },
    {
      'title': "Stay in Groups",
      'description': "Whenever possible, travel with others to enhance safety.",
      'imagePath': "assets/images/stay_in_groups.jpg",
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
                    tag: 'situational_awareness_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/SD2.webp",
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
                        getTranslatedText('Situational Awareness Techniques'),
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