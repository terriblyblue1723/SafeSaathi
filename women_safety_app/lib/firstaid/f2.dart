import 'package:flutter/material.dart';
import 'dart:async';

class AcidBurn extends StatefulWidget {
  const AcidBurn({Key? key}) : super(key: key);

  @override
  State<AcidBurn> createState() => _AcidBurnState();
}

class _AcidBurnState extends State<AcidBurn> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Acid Burn Emergency': 'Acid Burn Emergency',
      'Rinse with Water': 'Rinse with Water',
      'Immediately rinse the affected area with cool, clean water for at least 20 minutes to dilute and remove the acid.':
      'Immediately rinse the affected area with cool, clean water for at least 20 minutes to dilute and remove the acid.',
      'Remove Contaminated Clothing': 'Remove Contaminated Clothing',
      'Carefully remove any clothing or jewelry that has come into contact with the acid to prevent further damage.':
      'Carefully remove any clothing or jewelry that has come into contact with the acid to prevent further damage.',
      'Do Not Use Neutralizing Agents': 'Do Not Use Neutralizing Agents',
      'Avoid using substances like baking soda to neutralize the acid, as this can worsen the injury.':
      'Avoid using substances like baking soda to neutralize the acid, as this can worsen the injury.',
      'Cover with Sterile Cloth': 'Cover with Sterile Cloth',
      'After rinsing, cover the affected area with a sterile, non-stick cloth or bandage to protect it from infection.':
      'After rinsing, cover the affected area with a sterile, non-stick cloth or bandage to protect it from infection.',
      'Seek Immediate Medical Help': 'Seek Immediate Medical Help',
      'Call emergency services or go to the nearest hospital as soon as possible for professional treatment.':
      'Call emergency services or go to the nearest hospital as soon as possible for professional treatment.',
      'Step': 'Step',
    },
    { // Hindi
      'Acid Burn Emergency': 'एसिड जलने की आपातकालीन स्थिति',
      'Rinse with Water': 'पानी से धोएं',
      'Immediately rinse the affected area with cool, clean water for at least 20 minutes to dilute and remove the acid.':
      'प्रभावित क्षेत्र को कम से कम 20 मिनट तक ठंडे, साफ पानी से धोएं ताकि एसिड को पतला और हटा सकें।',
      'Remove Contaminated Clothing': 'संक्रमित कपड़े हटाएं',
      'Carefully remove any clothing or jewelry that has come into contact with the acid to prevent further damage.':
      'कोई भी कपड़ा या आभूषण जो एसिड के संपर्क में आया है, उसे सावधानी से हटा दें ताकि आगे के नुकसान से बचा जा सके।',
      'Do Not Use Neutralizing Agents': 'न्यूट्रलाइजिंग एजेंट का उपयोग न करें',
      'Avoid using substances like baking soda to neutralize the acid, as this can worsen the injury.':
      'एसिड को न्यूट्रलाइज करने के लिए बेकिंग सोडा जैसे पदार्थों का उपयोग करने से बचें, क्योंकि इससे चोट बढ़ सकती है।',
      'Cover with Sterile Cloth': 'निष्क्रिय कपड़े से ढकें',
      'After rinsing, cover the affected area with a sterile, non-stick cloth or bandage to protect it from infection.':
      'धोने के बाद, प्रभावित क्षेत्र को संक्रमण से बचाने के लिए एक निष्क्रिय, गैर-चिपचिपे कपड़े या पट्टी से ढकें।',
      'Seek Immediate Medical Help': 'तुरंत चिकित्सा सहायता प्राप्त करें',
      'Call emergency services or go to the nearest hospital as soon as possible for professional treatment.':
      'जितनी जल्दी हो सके आपातकालीन सेवाओं को कॉल करें या निकटतम अस्पताल जाएं।',
      'Step': 'चरण',
    },
    { // Marathi
      'Acid Burn Emergency': 'अॅसिड ज लनाची आपातकालीन स्थिती',
      'Rinse with Water': 'पाण्याने धुवा',
      'Immediately rinse the affected area with cool, clean water for at least 20 minutes to dilute and remove the acid.':
      'प्रभावित क्षेत्राला किमान 20 मिनिटे थंड, स्वच्छ पाण्याने धुवा जेणेकरून अॅसिड कमी होईल आणि काढता येईल.',
      'Remove Contaminated Clothing': 'जंतूयुक्त कपडे काढा',
      'Carefully remove any clothing or jewelry that has come into contact with the acid to prevent further damage.':
      'अॅसिडच्या संपर्कात आलेले कोणतेही कपडे किंवा दागिने काळजीपूर्वक काढा जेणेकरून पुढील नुकसान टाळता येईल.',
      'Do Not Use Neutralizing Agents': 'न्यूट्रलायझिंग एजंट वापरू नका',
      'Avoid using substances like baking soda to neutralize the acid, as this can worsen the injury.':
      'अॅसिड न्यूट्रल करण्यासाठी बेकिंग सोडा सारख्या पदार्थांचा वापर टाळा, कारण यामुळे जखम वाढू शकते.',
      'Cover with Sterile Cloth': 'निष्क्रिय कपड्याने झाका',
      'After rinsing, cover the affected area with a sterile, non-stick cloth or bandage to protect it from infection.':
      'धुतल्यानंतर, प्रभावित क्षेत्राला संक्रमणापासून वाचवण्यासाठी एक निष्क्रिय, नॉन-स्टिक कपडा किंवा पट्टीने झाका.',
      'Seek Immediate Medical Help': 'तुरंत वैद्यकीय मदतीसाठी जा',
      'Call emergency services or go to the nearest hospital as soon as possible for professional treatment.':
      'व्यावसायिक उपचारासाठी शक्य तितक्या लवकर आपातकालीन सेवांना कॉल करा किंवा जवळच्या रुग्णालयात जा.',
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
      'title': "Rinse with Water",
      'description': "Immediately rinse the affected area with cool, clean water for at least 20 minutes to dilute and remove the acid.",
      'imagePath': "assets/firstaid/AcidBurn/AB1.jpeg",
    },
    {
      'title': "Remove Contaminated Clothing",
      'description': "Carefully remove any clothing or jewelry that has come into contact with the acid to prevent further damage.",
      'imagePath': "assets/firstaid/AcidBurn/AB2.jpeg",
    },
    {
      'title': "Do Not Use Neutralizing Agents",
      'description': "Avoid using substances like baking soda to neutralize the acid, as this can worsen the injury.",
      'imagePath': "assets/firstaid/AcidBurn/AB3.jpeg",
    },
    {
      'title': "Cover with Sterile Cloth",
      'description': "After rinsing, cover the affected area with a sterile, non-stick cloth or bandage to protect it from infection.",
      'imagePath': "assets/firstaid/AcidBurn/AB4.jpeg",
    },
    {
      'title': "Seek Immediate Medical Help",
      'description': "Call emergency services or go to the nearest hospital as soon as possible for professional treatment.",
      'imagePath': "assets/firstaid/AcidBurn/AB5.jpeg",
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
                    tag: 'acid_burn_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/firstaid/f2.jpg",
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
                        getTranslatedText('Acid Burn Emergency'),
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