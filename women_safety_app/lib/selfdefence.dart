import 'package:flutter/material.dart';
import 'package:women_safety_app/selfdefence/basic.dart';
import 'package:women_safety_app/bottonNavBar.dart';
import 'package:women_safety_app/selfdefence/Verbal_Defense_Techniques.dart';
import 'package:women_safety_app/selfdefence/Escape_Techniques.dart';
import 'package:women_safety_app/selfdefence/Everyday_Object_Defense.dart';
import 'package:women_safety_app/selfdefence/Know_Your_Rights.dart';
import 'package:women_safety_app/selfdefence/Martial_Arts_Basics.dart';
import 'package:women_safety_app/selfdefence/Situational_Awareness.dart';
import 'package:women_safety_app/selfdefence/Multiple_Attackers_Defense.dart';

class SelfDefence extends StatefulWidget {
  const SelfDefence({Key? key}) : super(key: key);

  @override
  _SelfDefence createState() => _SelfDefence();
}

class _SelfDefence extends State<SelfDefence> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double tileHeight = isLandscape ? screenSize.height * 0.3 : screenSize.height * 0.15;

    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 242, 249, 255),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            children: [
              // Header section with responsive text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Self Defence',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.02),

              // Main content section
              // Main content section
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isLandscape ? 2 : 1,
                        childAspectRatio: isLandscape ? 2 : 3,
                        crossAxisSpacing: screenSize.width * 0.04,
                        mainAxisSpacing: screenSize.height * 0.02,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final items = [
                          {
                            'label': "Basic Self-Defense Moves",
                            'imagePath': 'assets/images/SD1.jpg',
                            'heroTag': 'basic_defense_image',
                            'page': const Basic(),
                          },
                          {
                            'label': "Situational Awareness",
                            'imagePath': 'assets/images/SD2.webp',
                            'heroTag': 'situational_awareness_image',
                            'page': const SituationalAwareness(),
                          },
                          {
                            'label': "Everyday Object Defense",
                            'imagePath': 'assets/images/SD3.webp',
                            'heroTag': 'everyday_object_defense_image',
                            'page': const EverydayObjectDefense(),
                          },
                          {
                            'label': "Escape Techniques",
                            'imagePath': 'assets/images/SD4.jpg',
                            'heroTag': 'escape_techniques_image',
                            'page': const EscapeTechniques(),
                          },
                          {
                            'label': "Martial Arts Basics",
                            'imagePath': 'assets/images/SD5.jpg',
                            'heroTag': 'martial_arts_basics_image',
                            'page': const MartialArtsBasics(),
                          },
                          {
                            'label': "Verbal Defense Techniques",
                            'imagePath': 'assets/images/SD6.jpg',
                            'heroTag': 'verbal_defense_techniques_image',
                            'page': const VerbalDefenseTechniques(),
                          },
                          {
                            'label': "Multiple Attackers Defense",
                            'imagePath': 'assets/images/SD7.jpg',
                            'heroTag': 'multiple_attackers_defense_image',
                            'page': const MultipleAttackersDefense(),
                          },
                          {
                            'label': "Know Your Rights",
                            'imagePath': 'assets/images/SD8.jpg',
                            'heroTag': 'know_your_rights_image',
                            'page': const KnowYourRights(),
                          },
                        ];

                        return CustomTile(
                          label: items[index]['label'] as String, // Cast to String
                          imagePath: items[index]['imagePath'] as String, // Cast to String
                          heroTag: items[index]['heroTag'] as String, // Cast to String
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 800),
                              pageBuilder: (context, animation, secondaryAnimation) =>
                              items[index]['page'] as Widget,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedIndex,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback? onTap;
  final String heroTag;

  const CustomTile({
    Key? key,
    required this.label,
    required this.imagePath,
    this.onTap,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double fontSize = isLandscape ? screenSize.width * 0.02 : screenSize.width * 0.045;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        flightShuttleBuilder: (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
            ) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Tween<double>(
                      begin: 16.0,
                      end: flightDirection == HeroFlightDirection.push ? 0.0 : 16.0,
                    ).evaluate(animation),
                  ),
                  border: Border.all(
                    color: Colors.red.withOpacity(
                      Tween<double>(begin: 1.0, end: 0.0).evaluate(animation),
                    ),
                    width: screenSize.width * 0.005,
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                        Tween<double>(begin: 0.3, end: 0.0).evaluate(animation),
                      ),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Opacity(
                  opacity: 1 - animation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.width * 0.04),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(screenSize.width * 0.04),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Colors.red,
              width: screenSize.width * 0.005,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.04),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenSize.width * 0.04),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildImageSection(String heroTag, String imagePath, BuildContext context) {
  final Size screenSize = MediaQuery.of(context).size;
  final bool isLandscape = screenSize.width > screenSize.height;
  final double imageHeight = isLandscape ? screenSize.height * 0.4 : screenSize.height * 0.25;

  return Hero(
    tag: heroTag,
    flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
        ) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final scale = Tween<double>(
            begin: 1.0,
            end: 0.8,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));

          final opacity = Tween<double>(
            begin: 1.0,
            end: 0.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));

          return Transform.scale(
            scale: scale.value,
            child: Opacity(
              opacity: opacity.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Tween<double>(
                      begin: 16.0,
                      end: 0.0,
                    ).evaluate(animation),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                        Tween<double>(begin: 0.3, end: 0.0).evaluate(animation),
                      ),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
    child: Padding(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: imageHeight,
        ),
      ),
    ),
  );
}

// Usage in each page (make sure to pass context)
Widget buildBasicImageSection(BuildContext context) =>
    _buildImageSection('basic_defense_image', "assets/images/SD1.jpg", context);
Widget buildSituationalAwarenessImageSection(BuildContext context) =>
    _buildImageSection('situational_awareness_image', "assets/images/SD2.webp", context);
Widget buildEverydayObjectDefenseImageSection(BuildContext context) =>
    _buildImageSection('everyday_object_defense_image', "assets/images/SD3.webp", context);
Widget buildEscapeTechniquesImageSection(BuildContext context) =>
    _buildImageSection('escape_techniques_image', "assets/images/SD4.jpg", context);
Widget buildMartialArtsBasicsImageSection(BuildContext context) =>
    _buildImageSection('martial_arts_basics_image', "assets/images/SD5.jpg", context);
Widget buildVerbalDefenseTechniquesImageSection(BuildContext context) =>
    _buildImageSection('verbal_defense_techniques_image', "assets/images/SD6.jpg", context);
Widget buildMultipleAttackersDefenseImageSection(BuildContext context) =>
    _buildImageSection('multiple_attackers_defense_image', "assets/images/SD7.jpg", context);
Widget buildKnowYourRightsImageSection(BuildContext context) =>
    _buildImageSection('know_your_rights_image', "assets/images/SD8.jpg", context);