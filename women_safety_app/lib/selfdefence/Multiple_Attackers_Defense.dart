import 'package:flutter/material.dart';
import 'dart:async';

class MultipleAttackersDefense extends StatefulWidget {
  const MultipleAttackersDefense({Key? key}) : super(key: key);

  @override
  State<MultipleAttackersDefense> createState() => _MultipleAttackersDefenseState();
}

class _MultipleAttackersDefenseState extends State<MultipleAttackersDefense> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Defense Against Multiple Attackers': 'Defense Against Multiple Attackers',
      'Stay Aware': 'Stay Aware',
      'Always be aware of your surroundings and potential threats.': 'Always be aware of your surroundings and potential threats.',
      'Use Your Environment': 'Use Your Environment',
      'Utilize objects around you to create barriers or distractions.': 'Utilize objects around you to create barriers or distractions.',
      'Create Distance': 'Create Distance',
      'Put as much distance as possible between you and the attackers.': 'Put as much distance as possible between you and the attackers.',
      'Target Vulnerable Areas': 'Target Vulnerable Areas',
      'Aim for sensitive areas like eyes, throat, and groin to incapacitate attackers.': 'Aim for sensitive areas like eyes, throat, and groin to incapacitate attackers.',
      'Escape When Possible': 'Escape When Possible',
      'Look for opportunities to escape rather than engage.': 'Look for opportunities to escape rather than engage.',
      'Step': 'Step',
    },
    { // Hindi
      'Defense Against Multiple Attackers': 'कई हमलावरों के खिलाफ रक्षा',
      'Stay Aware': 'जागरूक रहें',
      'Always be aware of your surroundings and potential threats.': 'हमेशा अपने चारों ओर के वातावरण और संभावित खतरों के प्रति जागरूक रहें।',
      'Use Your Environment': 'अपने वातावरण का उपयोग करें',
      'Utilize objects around you to create barriers or distractions.': 'अपने चारों ओर की वस्तुओं का उपयोग करके बाधाएँ या विचलन उत्पन्न करें।',
      'Create Distance': 'दूरी बनाएं',
      'Put as much distance as possible between you and the attackers.': 'हमलावरों और अपने बीच जितनी संभव हो सके दूरी बनाएं।',
      'Target Vulnerable Areas': 'संवेदनशील क्षेत्रों को निशाना बनाएं',
      'Aim for sensitive areas like eyes, throat, and groin to incapacitate attackers.': 'हमलावरों को अक्षम करने के लिए आंखों, गले और जांघ जैसे संवेदनशील क्षेत्रों को निशाना बनाएं।',
      'Escape When Possible': 'जब संभव हो, भागें',
      'Look for opportunities to escape rather than engage.': 'संलग्न होने के बजाय भागने के अवसरों की तलाश करें।',
      'Step': 'चरण',
    },
    { // Marathi
      'Defense Against Multiple Attackers': 'एकाधिक हल्लेखोरांविरुद्ध संरक्षण',
      'Stay Aware': 'जागरूक रहा',
      'Always be aware of your surroundings and potential threats.': 'तुमच्या आजुबाजुच्या गोष्टींचा नेहमी विचार करा आणि संभाव्य धोके ओळखा.',
      'Use Your Environment': 'तुमच्या वातावरणाचा वापर करा',
      'Utilize objects around you to create barriers or distractions.': 'अवरोध किंवा विचलन निर्माण करण्यासाठी तुमच्या आजुबाजुच्या वस्तूंचा वापर करा.',
      'Create Distance': 'अंतर तयार करा',
      'Put as much distance as possible between you and the attackers.': 'तुम्ही आणि हल्लेखोर यांच्यात जितकी शक्य असेल तितकी अंतर ठेवा.',
      'Target Vulnerable Areas': 'संवेदनशील भागांवर लक्ष ठेवा',
      'Aim for sensitive areas like eyes, throat, and groin to incapacitate attackers.': 'हल्लेखोरांना अक्षम करण्यासाठी डोळे, गळा आणि जांघ यांसारख्या संवेदनशील भागांवर लक्ष ठेवा.',
      'Escape When Possible': 'जेव्हा शक्य असेल तेव्हा पळा',
      'Look for opportunities to escape rather than engage.': 'संलग्न होण्याऐवजी पळून जाण्याच्या संधींचा शोध घ्या.',
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
      'description': "Always be aware of your surroundings and potential threats.",
      'imagePath': "assets/images/stay_aware_multiple.jpg",
    },
    {
      'title': "Use Your Environment",
      'description': "Utilize objects around you to create barriers or distractions.",
      'imagePath': "assets/images/use_environment.webp",
    },
    {
      'title': "Create Distance",
      'description': "Put as much distance as possible between you and the attackers.",
      'imagePath': "assets/images/create_distance_multiple.jpg",
    },
    {
      'title': "Target Vulnerable Areas",
      'description': "Aim for sensitive areas like eyes, throat, and groin to incapacitate attackers.",
      'imagePath': "assets/images/target_vulnerable_areas.jpg",
    },
    {
      'title': "Escape When Possible",
      'description': "Look for opportunities to escape rather than engage.",
      'imagePath': "assets/images/escape_multiple.jpg",
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
                    tag: 'multiple_attackers_defense_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/SD7.jpg",
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
                        getTranslatedText('Defense Against Multiple Attackers'),
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