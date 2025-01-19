import 'package:flutter/material.dart';
import 'package:women_safety_app/firstaid/f1.dart';
import 'package:women_safety_app/firstaid/f2.dart';
import 'package:women_safety_app/firstaid/f3.dart';
import 'package:women_safety_app/firstaid/f4.dart';
import 'package:women_safety_app/firstaid/f5.dart';
import 'package:women_safety_app/firstaid/f6.dart';
import 'package:women_safety_app/bottonNavBar.dart';

class FirstAid extends StatefulWidget {
  const FirstAid({Key? key}) : super(key: key);

  @override
  _FirstAid createState() => _FirstAid();
}

class _FirstAid extends State<FirstAid> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 242, 249, 255),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            children: [
              // Header section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'First Aid',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.02),

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
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final items = [
                          {
                            'label': "Physical Assault",
                            'imagePath': 'assets/firstaid/PhysicalAssault.jpeg',
                            'heroTag': 'physical_assault_image',
                            'page': const PhysicalAssault(),
                          },
                          {
                            'label': "Acid Burn",
                            'imagePath': 'assets/firstaid/f2.jpg',
                            'heroTag': 'acid_burn_image',
                            'page': const AcidBurn(),
                          },
                          {
                            'label': "Sexual Violence",
                            'imagePath': 'assets/firstaid/f3.jpg',
                            'heroTag': 'sexual_violence_image',
                            'page': const SexualViolence(),
                          },
                          {
                            'label': "Maternal Emergencies",
                            'imagePath': 'assets/firstaid/f4.jpeg',
                            'heroTag': 'maternal_emergencies_image',
                            'page': const MaternalEmergency(),
                          },
                          {
                            'label': "Menstrual Emergencies",
                            'imagePath': 'assets/firstaid/f5.png',
                            'heroTag': 'menstrual_emergencies_image',
                            'page': const MenstrualEmergency(),
                          },
                          {
                            'label': "Panic / Anxiety Attack",
                            'imagePath': 'assets/firstaid/f6.jpg',
                            'heroTag': 'panic_anxiety_attack_image',
                            'page': const PanicAttacks(),
                          },
                        ];

                        return CustomTile(
                          label: items[index]['label'] as String,
                          imagePath: items[index]['imagePath'] as String,
                          heroTag: items[index]['heroTag'] as String,
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
    _buildImageSection('physical_assault_image', "assets/firstaid/PhysicalAssault.jpeg", context);
Widget buildSituationalAwarenessImageSection(BuildContext context) =>
    _buildImageSection('acid_burn_image', "assets/firstaid/f2.jpg", context);
Widget buildEverydayObjectDefenseImageSection(BuildContext context) =>
    _buildImageSection('sexual_violence_image', "assets/firstaid/f3.jpg", context);
Widget buildEscapeTechniquesImageSection(BuildContext context) =>
    _buildImageSection('maternal_emergencies_image', "assets/firstaid/f4.jpeg", context);
Widget buildMartialArtsBasicsImageSection(BuildContext context) =>
    _buildImageSection('menstrual_emergencies_image', "assets/firstaid/f5.png", context);
Widget buildVerbalDefenseTechniquesImageSection(BuildContext context) =>
    _buildImageSection('panic_anxiety_attack_image', "assets/firstaid/f6.jpg", context);
