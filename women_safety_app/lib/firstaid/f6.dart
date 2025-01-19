import 'package:flutter/material.dart';
import 'dart:async';

class PanicAttacks extends StatefulWidget {
  const PanicAttacks({Key? key}) : super(key: key);

  @override
  State<PanicAttacks> createState() => _PanicAttacksState();
}

class _PanicAttacksState extends State<PanicAttacks> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Managing Panic Attacks': 'Managing Panic Attacks',
      'Recognize the Symptoms': 'Recognize the Symptoms',
      'Recognize signs such as a rapid heartbeat, shortness of breath, or dizziness to acknowledge that you are experiencing a panic attack.':
      'Recognize signs such as a rapid heartbeat, shortness of breath, or dizziness to acknowledge that you are experiencing a panic attack.',
      'Focus on Breathing': 'Focus on Breathing',
      'Slow your breathing by taking deep breaths in through your nose and out through your mouth. This helps calm the body down.':
      'Slow your breathing by taking deep breaths in through your nose and out through your mouth. This helps calm the body down.',
      'Ground Yourself': 'Ground Yourself',
      'Focus on your surroundings. Name five things you can see, four things you can touch, three things you can hear, and so on.':
      'Focus on your surroundings. Name five things you can see, four things you can touch, three things you can hear, and so on.',
      'Use Positive Affirmations': 'Use Positive Affirmations',
      'Repeat calming phrases such as "This will pass" or "I am safe" to remind yourself that you can overcome the panic attack.':
      'Repeat calming phrases such as "This will pass" or "I am safe" to remind yourself that you can overcome the panic attack.',
      'Seek Support': 'Seek Support',
      'Call a trusted friend, family member, or therapist. Talking with someone can provide comfort and reassurance.':
      'Call a trusted friend, family member, or therapist. Talking with someone can provide comfort and reassurance.',
      'Step': 'Step',
    },
    { // Hindi
      'Managing Panic Attacks': 'पैनिक अटैक का प्रबंधन',
      'Recognize the Symptoms': 'लक्षणों को पहचानें',
      'Recognize signs such as a rapid heartbeat, shortness of breath, or dizziness to acknowledge that you are experiencing a panic attack.':
      'तेज दिल की धड़कन, सांस लेने में कठिनाई, या चक्कर आना जैसे लक्षणों को पहचानें ताकि आप यह स्वीकार कर सकें कि आप पैनिक अटैक का अनुभव कर रहे हैं।',
      'Focus on Breathing': 'सांस पर ध्यान केंद्रित करें',
      'Slow your breathing by taking deep breaths in through your nose and out through your mouth. This helps calm the body down.':
      'अपनी सांस को धीमा करें, नाक के माध्यम से गहरी सांस लें और मुँह के माध्यम से छोड़ें। इससे शरीर को शांत करने में मदद मिलती है।',
      'Ground Yourself': 'अपने आप को ग्राउंड करें',
      'Focus on your surroundings. Name five things you can see, four things you can touch, three things you can hear, and so on.':
      'अपने चारों ओर ध्यान केंद्रित करें। पांच चीजें बताएं जो आप देख सकते हैं, चार चीजें जो आप छू सकते हैं, तीन चीजें जो आप सुन सकते हैं, आदि।',
      'Use Positive Affirmations': 'सकारात्मक पुष्टि का उपयोग करें',
      'Repeat calming phrases such as "This will pass" or "I am safe" to remind yourself that you can overcome the panic attack.':
      'शांत करने वाले वाक्यांशों को दोहराएं जैसे "यह गुजर जाएगा" या "मैं सुरक्षित हूं" ताकि आप खुद को याद दिला सकें कि आप पैनिक अटैक पर काबू पा सकते हैं।',
      'Seek Support': 'सहायता प्राप्त करें',
      'Call a trusted friend, family member, or therapist. Talking with someone can provide comfort and reassurance.':
      'एक विश्वसनीय मित्र, परिवार के सदस्य, या चिकित्सक को कॉल करें। किसी से बात करना आराम और आश्वासन प्रदान कर सकता है।',
      'Step': 'चरण',
    },
    { // Marathi
      'Managing Panic Attacks': 'पॅनिक अटॅकचे व्यवस्थापन',
      'Recognize the Symptoms': 'लक्षणे ओळखा',
      'Recognize signs such as a rapid heartbeat, shortness of breath, or dizziness to acknowledge that you are experiencing a panic attack.':
      'जलद हृदयगती, श्वास घेण्यात अडचण किंवा चक्कर येणे यासारखी लक्षणे ओळखा, जेणेकरून तुम्हाला पॅनिक अटॅकचा अनुभव होत आहे हे मान्य करणे.',
      'Focus on Breathing': 'श्वासावर लक्ष केंद्रित करा',
      'Slow your breathing by taking deep breaths in through your nose and out through your mouth. This helps calm the body down.':
      'आपल्या नाकाद्वारे खोल श्वास घेऊन आणि आपल्या तोंडाद्वारे बाहेर सोडून आपल्या श्वासाला मंद करा. यामुळे शरीराला शांत करण्यात मदत होते.',
      'Ground Yourself': 'आपण स्वतःला स्थिर करा',
      'Focus on your surroundings. Name five things you can see, four things you can touch, three things you can hear, and so on.':
      'आपल्या आजुबाजुच्या गोष्टींवर लक्ष केंद्रित करा. तुम्ही पाहू शकता अशा पाच गोष्टी, तुम्ही स्पर्श करू शकता अशा चार गोष्टी, तुम्ही ऐकू शकता अशा तीन गोष्टी आणि इतर गोष्टींची नावे सांगा.',
      'Use Positive Affirmations': 'सकारात्मक पुष्टींचा वापर करा',
      'Repeat calming phrases such as "This will pass" or "I am safe" to remind yourself that you can overcome the panic attack.':
      'शांत करणाऱ्या वाक्यांशांचे पुनरुत्पादन करा जसे "हे जातील" किंवा "मी सुरक्षित आहे" जेणेकरून तुम्हाला आठवण करून द्या की तुम्ही पॅनिक अटॅकवर मात करू शकता.',
      'Seek Support': 'सहाय्य मागा',
      'Call a trusted friend, family member, or therapist. Talking with someone can provide comfort and reassurance.':
      'एक विश्वासार्ह मित्र, कुटुंबाचा सदस्य किंवा थेरपिस्टला कॉल करा. कोणाशीही बोलणे आराम आणि आश्वासन देऊ शकते.',
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
      'title': "Recognize the Symptoms",
      'description': "Recognize signs such as a rapid heartbeat, shortness of breath, or dizziness to acknowledge that you are experiencing a panic attack.",
      'imagePath': "assets/firstaid/PanicAttacks/PA1.jpeg",
    },
    {
      'title': "Focus on Breathing",
      'description': "Slow your breathing by taking deep breaths in through your nose and out through your mouth. This helps calm the body down.",
      'imagePath': "assets/firstaid/PanicAttacks/PA2.jpeg",
    },
    {
      'title': "Ground Yourself",
      'description': "Focus on your surroundings. Name five things you can see, four things you can touch, three things you can hear, and so on.",
      'imagePath': "assets/firstaid/PanicAttacks/PA3.jpeg",
    },
    {
      'title': "Use Positive Affirmations",
      'description': "Repeat calming phrases such as 'This will pass' or 'I am safe' to remind yourself that you can overcome the panic attack.",
      'imagePath': "assets/firstaid/PanicAttacks/PA4.jpeg",
    },
    {
      'title': "Seek Support",
      'description': "Call a trusted friend, family member, or therapist. Talking with someone can provide comfort and reassurance.",
      'imagePath': "assets/firstaid/PanicAttacks/PA5.jpeg",
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
                    tag: 'panic_attack_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/firstaid/f6.jpg",
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
                        getTranslatedText('Managing Panic Attacks'),
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