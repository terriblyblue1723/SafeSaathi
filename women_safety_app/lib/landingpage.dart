import 'package:flutter/material.dart';
import 'package:women_safety_app/emergencycontacts.dart';
import 'package:women_safety_app/login_page.dart';
import 'package:women_safety_app/DatabaseHelper.dart';
import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:women_safety_app/bottonNavBar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'background_service.dart';
import 'VolumeButtonService.dart';
import 'audio_manager.dart';
import 'recording.dart';
import 'package:women_safety_app/profile_page.dart';
import 'package:women_safety_app/api_service.dart';
import 'announcement.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> with TickerProviderStateMixin {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isDraggable = false;
  Offset buttonPosition = Offset.zero;
  Timer? _holdTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool showDottedCircle = false;
  late AnimationController _rotationController;
  double expansionProgress = 0.0;
  bool hasCompletedHold = false;
  int _selectedIndex = 0;
  bool isVolumeButtonSOS = false;
  final AudioManager _audioManager = AudioManager();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String audioPath = 'audio/alert.mp3';

  @override
  void initState() {
    super.initState();
    _initVolumeButtonDetection();
    _initAudioPlayer();
    _initAudioManager();
    _loadUserData();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0),
        weight: 50.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _initAudioPlayer() async {
    await _audioPlayer.setSource(AssetSource(audioPath));
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void _initAudioManager() async {
    await _audioManager.initialize();
  }

  void _initVolumeButtonDetection() {
    VolumeButtonService.initialize(() {
      if (mounted) {
        setState(() {
          isVolumeButtonSOS = true;
        });
        _activateSOSImmediately();
      }
    });
  }

  void _activateSOSImmediately() async {
    if (!mounted) return;
    
    setState(() {
      isDraggable = false;
      showDottedCircle = true;
      hasCompletedHold = true;
      buttonPosition = Offset.zero;
    });

    _pulseController.stop();
    _pulseController.reset();
    _rotationController.repeat();

    BackgroundService.startSOSTracking();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SOS Activated via Volume Button!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );

    await VolumeButtonService.playManualSOS();
  }

  void _handleSOSReset() {
    if (isVolumeButtonSOS) return;
    
    setState(() {
      isDraggable = false;
      buttonPosition = Offset.zero;
      expansionProgress = 0.0;
      showDottedCircle = false;
    });
    _pulseController.stop();
    _pulseController.reset();
    _rotationController.stop();
    _rotationController.reset();
  }

  @override
  void dispose() {
    _stopFile();
    VolumeButtonService.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _holdTimer?.cancel();
    super.dispose();
  }

  void _stopFile() async {
    await VolumeButtonService.stopAlert();
    setState(() {
      isPlaying = false;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isDraggable) return;

    setState(() {
      buttonPosition += details.delta;
      double distance = buttonPosition.distance;
      expansionProgress = (distance / 100).clamp(0.0, 1.0);

      const double maxRadius = 100.0;
      if (distance > maxRadius) {
        final double angle = atan2(buttonPosition.dy, buttonPosition.dx);
        buttonPosition = Offset(
          maxRadius * cos(angle),
          maxRadius * sin(angle),
        );

        if (hasCompletedHold) {
          debugPrint('SOS Activated!');
          _handleSOSReset();
        } else {
          _handleSOSReset();
        }
      }
    });
  }

  void _startSOS() {
    if (hasCompletedHold) return;

    if (isVolumeButtonSOS) {
      _activateSOSImmediately();
      return;
    }

    setState(() {
      isDraggable = false;
      showDottedCircle = false;
      hasCompletedHold = false;
    });

    BackgroundService.startSOSTracking();
    _pulseController.repeat();

    _holdTimer?.cancel();
    _holdTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        isDraggable = true;
        showDottedCircle = true;
        hasCompletedHold = true;
      });
      _pulseController.stop();
      _pulseController.reset();
      _rotationController.repeat();
    });
  }

  void _resetPosition() {
    if (isVolumeButtonSOS) return;
    
    setState(() {
      isDraggable = false;
      buttonPosition = Offset.zero;
      expansionProgress = 0.0;
      showDottedCircle = false;
    });
    _pulseController.stop();
    _pulseController.reset();
    _rotationController.stop();
    _rotationController.reset();
  }

  void _cancelSOS() {
    if (isVolumeButtonSOS || !hasCompletedHold) return;
    
    _holdTimer?.cancel();
    setState(() {
      isDraggable = false;
      showDottedCircle = false;
      buttonPosition = Offset.zero;
      expansionProgress = 0.0;
      hasCompletedHold = false;
    });
    _pulseController.stop();
    _pulseController.reset();
    _rotationController.stop();
    _rotationController.reset();
  }

  Future<void> _playFile() async {
    try {
      if (isPlaying) {
        await _audioPlayer.stop();
        setState(() {
          isPlaying = false;
        });
      } else {
        await _audioPlayer.resume();
        setState(() {
          isPlaying = true;
        });
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Widget _buildOptionCard(String title, IconData icon, VoidCallback onTap, String subtitle) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: title == 'Distress Alert' && isPlaying
                    ? const Color.fromARGB(255, 249, 68, 70)
                    : Colors.black54,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: title == 'Distress Alert' && isPlaying
                      ? const Color.fromARGB(255, 249, 68, 70)
                      : Colors.black,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadUserData() async {
    try {
      final data = await DatabaseHelper.instance.getLoggedInUser();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await DatabaseHelper.instance.logoutUser();
      
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error logging out. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 242, 249, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Emergency help\nNeeded?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 240,
                child: Center(
                  child: GestureDetector(
                    onTapDown: (details) => _startSOS(),
                    onTapUp: (details) => hasCompletedHold ? null : _cancelSOS(),
                    onTapCancel: () => hasCompletedHold ? null : _cancelSOS(),
                    onPanStart: (_) => _startSOS(),
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: (_) => _resetPosition(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (showDottedCircle)
                          RotationTransition(
                            turns: Tween(begin: 0.0, end: 1.0).animate(_rotationController),
                            child: CustomPaint(
                              size: const Size(200, 200),
                              painter: DottedCirclePainter(),
                            ),
                          ),
                        if (showDottedCircle)
                          Center(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: CustomPaint(
                                painter: ExpansionCirclePainter(
                                  progress: expansionProgress,
                                  color: Colors.lightBlue.shade200,
                                ),
                              ),
                            ),
                          ),
                        Transform.translate(
                          offset: buttonPosition,
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) => Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 249, 68, 70),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 131, 126, 125).withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.wifi_tethering,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'SOS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Press and hold for 3 seconds, then drag the button to the border to send SOS.',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildOptionCard(
                      'Emergency Numbers',
                      Icons.local_police_outlined,
                      () async {
                        final userData = await DatabaseHelper.instance.getLoggedInUser();
                        if (userData != null) {
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmergencyContactsPage(
                                aadhaarNumber: userData['aadhaar_number'],
                              ),
                            ),
                          );
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please log in again'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          _logout();
                        }
                      },
                      '',
                    ),
                    _buildOptionCard(
                      'Distress Alert',
                      Icons.add_alert_sharp,
                      () async {
                        if (isPlaying) {
                          _stopFile();
                        } else {
                          await _playFile();
                        }
                      },
                      '',
                    ),
                    _buildOptionCard(
                      'Recording',
                      Icons.emergency_recording,
                          () async {
                        final userData = await DatabaseHelper.instance.getLoggedInUser();
                        if (userData != null) {
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoRecordingPage(
                                aadhaarNumber: userData['aadhaar_number'],
                                onVideoRecorded: (aadhaarNumber, videoFile) {
                                  final apiService = ApiService();
                                  apiService.uploadVideo(aadhaarNumber, File(videoFile.path));
                                },
                              ),
                            ),
                          );
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please log in again'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          _logout();
                        }
                      },
                      '',
                    ),
                    _buildOptionCard(
                      'Announcements',
                      Icons.announcement,
                      () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostsList()),
                      );
                      },
                      '',
                    ),
                  ],
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

class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double dashLength = 15;
    final double dashSpace = 10;
    double startAngle = 0.2;

    while (startAngle < 2 * pi) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashLength / radius,
        false,
        paint,
      );
      startAngle += (dashLength + dashSpace) / radius;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ExpansionCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  ExpansionCirclePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = 100 * progress;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant ExpansionCirclePainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}