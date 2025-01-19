import 'package:flutter/material.dart';
import 'dart:async';

class SexualViolence extends StatefulWidget {
  const SexualViolence({Key? key}) : super(key: key);

  @override
  State<SexualViolence> createState() => _SexualViolenceState();
}

class _SexualViolenceState extends State<SexualViolence> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Sexual Violence Support': 'Sexual Violence Support',
      'Ensure Immediate Safety': 'Ensure Immediate Safety',
      'Move to a secure location, away from potential harm, and call for help if needed.':
      'Move to a secure location, away from potential harm, and call for help if needed.',
      'Preserve Evidence': 'Preserve Evidence',
      'Avoid bathing, changing clothes, or cleaning up to help preserve vital evidence.':
      'Avoid bathing, changing clothes, or cleaning up to help preserve vital evidence.',
      'Seek Medical Attention': 'Seek Medical Attention',
      'Visit a healthcare facility for a checkup and receive necessary treatment and support.':
      'Visit a healthcare facility for a checkup and receive necessary treatment and support.',
      'Contact Support Services': 'Contact Support Services',
      'Reach out to trusted organizations or helplines that specialize in supporting survivors.':
      'Reach out to trusted organizations or helplines that specialize in supporting survivors.',
      'Consider Reporting': 'Consider Reporting',
      'File a report with law enforcement when ready, and consider legal or counseling options.':
      'File a report with law enforcement when ready, and consider legal or counseling options.',
      'Step': 'Step',
    },
    { // Hindi
      'Sexual Violence Support': 'यौन हिंसा सहायता',
      'Ensure Immediate Safety': 'तुरंत सुरक्षा सुनिश्चित करें',
      'Move to a secure location, away from potential harm, and call for help if needed.':
      'एक सुरक्षित स्थान पर जाएं, संभावित नुकसान से दूर, और यदि आवश्यक हो तो मदद के लिए कॉल करें।',
      'Preserve Evidence': 'साक्ष्य को संरक्षित करें',
      'Avoid bathing, changing clothes, or cleaning up to help preserve vital evidence.':
      'साक्ष्य को संरक्षित करने में मदद करने के लिए स्नान करने, कपड़े बदलने या सफाई करने से बचें।',
      'Seek Medical Attention': 'चिकित्सा सहायता प्राप्त करें',
      'Visit a healthcare facility for a checkup and receive necessary treatment and support.':
      'चिकित्सा जांच के लिए एक स्वास्थ्य सेवा सुविधा पर जाएं और आवश्यक उपचार और समर्थन प्राप्त करें।',
      'Contact Support Services': 'समर्थन सेवाओं से संपर्क करें',
      'Reach out to trusted organizations or helplines that specialize in supporting survivors.':
      'विश्वसनीय संगठनों या हेल्पलाइनों से संपर्क करें जो उत्तरजीवियों का समर्थन करने में विशेषज्ञता रखते हैं।',
      'Consider Reporting': 'रिपोर्ट करने पर विचार करें',
      'File a report with law enforcement when ready, and consider legal or counseling options.':
      'जब तैयार हों, तो कानून प्रवर्तन के साथ एक रिपोर्ट दर्ज करें, और कानूनी या परामर्श विकल्पों पर विचार करें।',
      'Step': 'चरण',
    },
    { // Marathi
      'Sexual Violence Support': 'यौन हिंसा समर्थन',
      'Ensure Immediate Safety': 'तत्काळ सुरक्षा सुनिश्चित करा',
      'Move to a secure location, away from potential harm, and call for help if needed.':
      'संभाव्य हानिकारक ठिकाणांपासून दूर, सुरक्षित ठिकाणी जा आणि आवश्यक असल्यास मदतीसाठी कॉल करा.',
      'Preserve Evidence': 'साक्ष्य जतन करा',
      'Avoid bathing, changing clothes, or cleaning up to help preserve vital evidence.':
      'महत्त्वाचे साक्ष्य जतन करण्यासाठी स्नान, कपडे बदलणे किंवा स्वच्छता टाळा.',
      'Seek Medical Attention': 'वैद्यकीय मदतीसाठी जा',
      'Visit a healthcare facility for a checkup and receive necessary treatment and support.':
      'चिकित्सा तपासणीसाठी आरोग्य सेवा केंद्र पर भेट द्या आणि आवश्यक उपचार आणि समर्थन मिळवा.',
      'Contact Support Services': 'समर्थन सेवांशी संपर्क साधा',
      'Reach out to trusted organizations or helplines that specialize in supporting survivors.':
      'उत्तरजीवींच्या समर्थनात विशेषीकृत विश्वसनीय संस्थांशी किंवा हेल्पलाइनशी संपर्क साधा.',
      'Consider Reporting': 'रिपोर्ट करण्याचा विचार करा',
      'File a report with law enforcement when ready, and consider legal or counseling options.':
      'तयार झाल्यावर कायदा अंमलबजावणीसह रिपोर्ट दाखल करा आणि कायदेशीर किंवा सल्लागार पर्यायांचा विचार करा.',
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
      'title': "Ensure Immediate Safety",
      'description': "Move to a secure location, away from potential harm, and call for help if needed.",
      'imagePath': "assets/firstaid/SexualViolence/SV1.jpeg",
    },
    {
      'title': "Preserve Evidence",
      'description': "Avoid bathing, changing clothes, or cleaning up to help preserve vital evidence.",
      'imagePath': "assets/firstaid/SexualViolence/SV2.jpeg",
    },
    {
      'title': "Seek Medical Attention",
      'description': "Visit a healthcare facility for a checkup and receive necessary treatment and support.",
      'imagePath': "assets/firstaid/SexualViolence/SV3.jpeg",
    },
    {
      'title': "Contact Support Services",
      'description': "Reach out to trusted organizations or helplines that specialize in supporting survivors.",
      'imagePath': "assets/firstaid/SexualViolence/SV4.jpeg",
    },
    {
      'title': "Consider Reporting",
      'description': "File a report with law enforcement when ready, and consider legal or counseling options.",
      'imagePath': "assets/firstaid/SexualViolence/SV5.jpeg",
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
                    tag: 'sexual_violence_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child : Image.asset(
                          "assets/firstaid/f3.jpg",
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
                        getTranslatedText('Sexual Violence Support'),
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
                                        curve: Curves.easeInOut );
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