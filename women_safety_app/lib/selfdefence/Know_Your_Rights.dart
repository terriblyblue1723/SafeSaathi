import 'package:flutter/material.dart';
import 'dart:async';

class KnowYourRights extends StatefulWidget {
  const KnowYourRights({Key? key}) : super(key: key);

  @override
  State<KnowYourRights> createState() => _KnowYourRightsState();
}

class _KnowYourRightsState extends State<KnowYourRights> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Know Your Rights': 'Know Your Rights',
      'Right to Defend Yourself': 'Right to Defend Yourself',
      'You have the right to defend yourself if you feel threatened.': 'You have the right to defend yourself if you feel threatened.',
      'Report Incidents': 'Report Incidents',
      'Always report any incidents of harassment or assault to the authorities.': 'Always report any incidents of harassment or assault to the authorities.',
      'Seek Legal Help': 'Seek Legal Help',
      'Know your legal rights and seek help from legal professionals if needed.': 'Know your legal rights and seek help from legal professionals if needed.',
      'Know Local Laws': 'Know Local Laws',
      'Familiarize yourself with local laws regarding self-defense.': 'Familiarize yourself with local laws regarding self-defense.',
      'Emergency Contacts': 'Emergency Contacts',
      'Keep a list of emergency contacts handy for quick access.': 'Keep a list of emergency contacts handy for quick access.',
      'Step': 'Step',
    },
    { // Hindi
      'Know Your Rights': 'अपने अधिकारों को जानें',
      'Right to Defend Yourself': 'अपने बचाव का अधिकार',
      'You have the right to defend yourself if you feel threatened.': 'यदि आप खतरे में महसूस करते हैं तो अपने बचाव का अधिकार है।',
      'Report Incidents': 'घटनाओं की रिपोर्ट करें',
      'Always report any incidents of harassment or assault to the authorities.': 'हमेशा उत्पीड़न या हमले की घटनाओं की रिपोर्ट अधिकारियों को करें।',
      'Seek Legal Help': 'कानूनी मदद लें',
      'Know your legal rights and seek help from legal professionals if needed.': 'अपने कानूनी अधिकारों को जानें और आवश्यकता होने पर कानूनी पेशेवरों से मदद लें।',
      'Know Local Laws': 'स्थानीय कानूनों को जानें',
      'Familiarize yourself with local laws regarding self-defense.': 'आत्म रक्षा के संबंध में स्थानीय कानूनों से परिचित हों।',
      'Emergency Contacts': 'आपातकालीन संपर्क',
      'Keep a list of emergency contacts handy for quick access.': 'त्वरित पहुँच के लिए आपातकालीन संपर्कों की सूची तैयार रखें।',
      'Step': 'चरण',
    },
    { // Marathi
      'Know Your Rights': 'तुमच्या अधिकारांची माहिती घ्या',
      'Right to Defend Yourself': 'तुमच्या बचावाचा अधिकार',
      'You have the right to defend yourself if you feel threatened.': 'जर तुम्हाला धोका वाटत असेल तर तुम्हाला स्वतःचा बचाव करण्याचा अधिकार आहे.',
      'Report Incidents': 'घटनांची नोंद करा',
      'Always report any incidents of harassment or assault to the authorities.': 'कधीही छळ किंवा हल्ल्याच्या घटनांची नोंद अधिकाऱ्यांना द्या.',
      'Seek Legal Help': 'कायदेशीर मदतीसाठी जा',
      'Know your legal rights and seek help from legal professionals if needed.': 'तुमच्या कायदेशीर अधिकारांची माहिती घ्या आणि आवश्यक असल्यास कायदेशीर व्यावसायिकांकडून मदतीसाठी जा.',
      'Know Local Laws': 'स्थानिक कायद्यांची माहिती घ्या',
      'Familiarize yourself with local laws regarding self-defense.': 'आत्मरक्षणाबाबत स्थानिक कायद्यांची माहिती घ्या.',
      'Emergency Contacts': 'आपातकालीन संपर्क',
      'Keep a list of emergency contacts handy for quick access.': 'त्वरित प्रवेशासाठी आपातकालीन संपर्कांची यादी तयार ठेवा.',
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
      'title': "Right to Defend Yourself",
      'description': "You have the right to defend yourself if you feel threatened.",
      'imagePath': "assets/images/right_to_defend.jpg",
    },
    {
      'title': "Report Incidents",
      'description': "Always report any incidents of harassment or assault to the authorities.",
      'imagePath': "assets/images/report_incidents.jpg",
    },
    {
      'title': "Seek Legal Help",
      'description': "Know your legal rights and seek help from legal professionals if needed.",
      'imagePath': "assets/images/legal_help.webp",
    },
    {
      'title': "Know Local Laws",
      'description': "Familiarize yourself with local laws regarding self-defense.",
      'imagePath': "assets/images/local_laws.png",
    },
    {
      'title': "Emergency Contacts",
      'description': "Keep a list of emergency contacts handy for quick access.",
      'imagePath': "assets/images/emergency_contacts.jpg",
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
                    tag: 'know_your_rights_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/SD8.jpg",
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
                        getTranslatedText('Know Your Rights'),
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