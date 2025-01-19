import 'package:flutter/material.dart';
import 'dart:async';





class MaternalEmergency extends StatefulWidget {
  const MaternalEmergency({Key? key}) : super(key: key);

  @override
  State<MaternalEmergency> createState() => _MaternalEmergencyState();
}

class _MaternalEmergencyState extends State<MaternalEmergency> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalSteps = 5;
  int currentLanguageIndex = 0; // 0: English, 1: Hindi, 2: Marathi

  // Language translations
  final List<Map<String, String>> translations = [
    { // English
      'Maternal Emergency Protocol': 'Maternal Emergency Protocol',
      'Recognize Signs of Labor': 'Recognize Signs of Labor',
      'Understand the early signs of labor such as regular contractions and water breaking. It\'s important to prepare for delivery.':
      'Understand the early signs of labor such as regular contractions and water breaking. It\'s important to prepare for delivery.',
      'Prepare Delivery Area': 'Prepare Delivery Area',
      'Ensure a clean, safe, and calm environment for delivery. Gather supplies and make sure there is enough space for assistance.':
      'Ensure a clean, safe, and calm environment for delivery. Gather supplies and make sure there is enough space for assistance.',
      'Assist in Delivery': 'Assist in Delivery',
      'Help guide the baby into the world with gentle pressure and assist with breathing. Keep the mother calm and focused.':
      'Help guide the baby into the world with gentle pressure and assist with breathing. Keep the mother calm and focused.',
      'Postpartum Care': 'Postpartum Care',
      'Ensure the mother is stable and monitor for complications. Keep the baby warm and assist with first moments of breastfeeding.':
      'Ensure the mother is stable and monitor for complications. Keep the baby warm and assist with first moments of breastfeeding.',
      'Seek Medical Assistance': 'Seek Medical Assistance',
      'If complications arise, seek immediate medical help. Call emergency services for professional assistance.':
      'If complications arise, seek immediate medical help. Call emergency services for professional assistance.',
      'Step': 'Step',
    },
    { // Hindi
      'Maternal Emergency Protocol': 'मातृ आपातकालीन प्रोटोकॉल',
      'Recognize Signs of Labor': 'प्रसव के संकेतों को पहचानें',
      'Understand the early signs of labor such as regular contractions and water breaking. It\'s important to prepare for delivery.':
      'प्रसव के प्रारंभिक संकेतों को समझें जैसे नियमित संकुचन और पानी का टूटना। डिलीवरी के लिए तैयार रहना महत्वपूर्ण है।',
      'Prepare Delivery Area': 'डिलीवरी क्षेत्र तैयार करें',
      'Ensure a clean, safe, and calm environment for delivery. Gather supplies and make sure there is enough space for assistance.':
      'डिलीवरी के लिए एक साफ, सुरक्षित और शांत वातावरण सुनिश्चित करें। आपूर्ति इकट्ठा करें और सुनिश्चित करें कि सहायता के लिए पर्याप्त स्थान है।',
      'Assist in Delivery': 'डिलीवरी में सहायता करें',
      'Help guide the baby into the world with gentle pressure and assist with breathing. Keep the mother calm and focused.':
      'नरम दबाव के साथ बच्चे को दुनिया में लाने में मदद करें और सांस लेने में सहायता करें। माँ को शांत और केंद्रित रखें।',
      'Postpartum Care': 'प्रसवोत्तर देखभाल',
      'Ensure the mother is stable and monitor for complications. Keep the baby warm and assist with first moments of breastfeeding.':
      'सुनिश्चित करें कि माँ स्थिर है और जटिलताओं की निगरानी करें। बच्चे को गर्म रखें और स्तनपान के पहले क्षणों में सहायता करें।',
      'Seek Medical Assistance': 'चिकित्सा सहायता प्राप्त करें',
      'If complications arise, seek immediate medical help. Call emergency services for professional assistance.':
      'यदि जटिलताएँ उत्पन्न होती हैं, तो तुरंत चिकित्सा सहायता प्राप्त करें। पेशेवर सहायता के लिए आपातकालीन सेवाओं को कॉल करें।',
      'Step': 'चरण',
    },
    { // Marathi
      'Maternal Emergency Protocol': 'मातृ आपातकालीन प्रोटोकॉल',
      'Recognize Signs of Labor': 'प्रसवाचे संकेत ओळखा',
      'Understand the early signs of labor such as regular contractions and water breaking. It\'s important to prepare for delivery.':
      'प्रसवाच्या प्रारंभिक संकेतांना समजून घ्या जसे की नियमित संकुचन आणि पाण्याचा फुटणे. डिलिव्हरीसाठी तयार राहणे महत्त्वाचे आहे.',
      'Prepare Delivery Area': 'डिलिव्हरी क्षेत्र तयार करा',
      'Ensure a clean, safe, and calm environment for delivery. Gather supplies and make sure there is enough space for assistance.':
      'डिलिव्हरीसाठी एक स्वच्छ, सुरक्षित आणि शांत वातावरण सुनिश्चित करा. पुरवठा गोळा करा आणि सहाय्यासाठी पुरेशी जागा आहे याची खात्री करा.',
      'Assist in Delivery': 'डिलिव्हरीमध्ये सहाय्य करा',
      'Help guide the baby into the world with gentle pressure and assist with breathing. Keep the mother calm and focused.':
      'मुलाला सौम्य दबावाने जगात आणण्यात मदत करा आणि श्वास घेण्यात सहाय्य करा. आईला शांत आणि लक्ष केंद्रित ठेवून ठेवा.',
      'Postpartum Care': 'प्रसवोत्तर काळजी',
      'Ensure the mother is stable and monitor for complications. Keep the baby warm and assist with first moments of breastfeeding.':
      'आई स्थिर आहे याची खात्री करा आणि जटिलतांची देखरेख करा. बाळाला उबदार ठेवा आणि स्तनपानाच्या पहिल्या क्षणांमध्ये सहाय्य करा.',
      'Seek Medical Assistance': 'चिकित्सा सहाय्य मिळवा',
      'If complications arise, seek immediate medical help. Call emergency services for professional assistance.':
      'जर जटिलता उद्भवली तर तात्काळ वैद्यकीय मदतीसाठी जा. व्यावसायिक सहाय्य मिळवण्यासाठी आपातकालीन सेवांना कॉल करा.',
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
      'title': "Recognize Signs of Labor",
      'description': "Understand the early signs of labor such as regular contractions and water breaking. It's important to prepare for delivery.",
      'imagePath': "assets/firstaid/MaternalEmergency/MA1.jpeg",
    },
    {
      'title': "Prepare Delivery Area",
      'description': "Ensure a clean, safe, and calm environment for delivery. Gather supplies and make sure there is enough space for assistance.",
      'imagePath': "assets/firstaid/MaternalEmergency/MA2.jpeg",
    },
    {
      'title': "Assist in Delivery",
      'description': "Help guide the baby into the world with gentle pressure and assist with breathing. Keep the mother calm and focused.",
      'imagePath': "assets/firstaid/MaternalEmergency/MA3.jpeg",
    },
    {
      'title': "Postpartum Care",
      'description': "Ensure the mother is stable and monitor for complications. Keep the baby warm and assist with first moments of breastfeeding.",
      'imagePath': "assets/firstaid/MaternalEmergency/MA4.jpeg",
    },
    {
      'title': "Seek Medical Assistance",
      'description': "If complications arise, seek immediate medical help. Call emergency services for professional assistance.",
      'imagePath': "assets/firstaid/MaternalEmergency/MA5.jpeg",
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
                    tag: 'maternal_emergency_image',
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child : Image.asset(
                          "assets/firstaid/f4.jpeg",
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
                        getTranslatedText('Maternal Emergency Protocol'),
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