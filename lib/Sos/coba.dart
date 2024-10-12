import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:mavis/ConctactScreen/ContactScreen.dart'; // Import ContactScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SOSScreen(),
    );
  }
}

class SOSScreen extends StatefulWidget {
  const SOSScreen({Key? key}) : super(key: key);

  @override
  _SOSScreenState createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> with TickerProviderStateMixin {
  String sosStatus = "Kamu aman sekarang";
  bool isSafe = true;
  bool isCalling = false;
  int countdown = 4; // Mulai hitungan dari 4
  List<Map<String, dynamic>> emergencyContacts = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    loadEmergencyContacts(); // Load contacts from ContactScreen and SharedPreferences

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: (emergencyContacts.length *
              500)), // Duration for staggered animation
    );
    _controller.forward(); // Start the animation
  }

  // Load emergency contacts from SharedPreferences and ContactScreen
  Future<void> loadEmergencyContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsData = prefs.getString('contacts');
    if (contactsData != null) {
      setState(() {
        emergencyContacts =
            List<Map<String, dynamic>>.from(jsonDecode(contactsData));
      });
    }
  }

  // Start countdown function
  void startCountdown() {
    setState(() {
      isCalling = true;
    });
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdown == 1) {
        timer.cancel();
        setState(() {
          sosStatus = "SOS aktif"; // Update status when countdown is done
          isCalling = false;
        });
        callEmergencyContacts();
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  // Function to call all emergency contacts
  void callEmergencyContacts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Menghubungi Kontak Darurat'),
        content: const Text('Kontak darurat sedang dihubungi...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isCalling ? Colors.red.shade700 : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          'SOS',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: isCalling
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Menelpon Darurat...",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Mohon tunggu, kami sedang meminta bantuan. Kontak darurat dan layanan penyelamatan terdekat akan melihat panggilan bantuan Anda.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stack with Countdown Timer and Dashed Circles
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Countdown Circle
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  spreadRadius: 10,
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "$countdown",
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // Dashed Circles and Contacts Positioned Outside the Countdown
                      CustomPaint(
                        painter: DashedCirclePainter(
                          numberOfCircles: 2, // Increase to 2 circles
                          circleRadius:
                              180, // Set radius larger than the countdown
                        ),
                        child: SizedBox(
                          height:
                              450, // Ensure enough space for the circles and contacts
                          width: 450,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Animated Contacts Positioned Outside the Dashed Circles
                              for (int i = 0; i < emergencyContacts.length; i++)
                                Positioned(
                                  // Adjusting to ensure no overlap with countdown
                                  top: i % 2 == 0 ? 50 : 270,
                                  left: (i * 70) +
                                      60, // Space each contact properly
                                  child: AnimatedBuilder(
                                    animation: _controller,
                                    builder: (context, child) {
                                      double scaleFactor =
                                          (i + 1) / emergencyContacts.length;
                                      return Transform.scale(
                                        scale: _controller.value * scaleFactor,
                                        child:
                                            contactWidget(emergencyContacts, i),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactSettingsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      "Pengaturan Kontak",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (isSafe) {
                          startCountdown(); // Start countdown if user is safe
                        } else {
                          setState(() {
                            sosStatus = "Kamu aman sekarang";
                          });
                        }
                        setState(() {
                          isSafe = !isSafe;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 230,
                            width: 230,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: isSafe
                                      ? Colors.green.withOpacity(0.5)
                                      : Colors.red.withOpacity(0.5),
                                  spreadRadius: 20,
                                  blurRadius: 30,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: isSafe
                                  ? Colors.green
                                  : Colors
                                      .red, // Changes color based on SOS status
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white
                                      .withOpacity(0.6), // Soft white glow
                                  spreadRadius: 20, // Radius of the outer glow
                                  blurRadius:
                                      40, // Blur to make it smooth and soft
                                  offset: const Offset(
                                      0, 0), // Centered glow around the button
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  spreadRadius: -10,
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "SOS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(2, 2),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  sosStatus,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Contact Widget Function
  Widget contactWidget(List<Map<String, dynamic>> contacts, int index) {
    if (contacts.isEmpty || index >= contacts.length)
      return Container(); // Handle out-of-bounds

    final contact = contacts[index];

    return Column(
      children: [
        CircleAvatar(
          radius: 50, // Increase size for each contact
          backgroundColor: Colors.white,
          child: Text(
            contact['name']
                [0], // Display the first letter of the contact's name
            style: TextStyle(fontSize: 28, color: Colors.black),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          contact['name'],
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// Painter for dashed circles
class DashedCirclePainter extends CustomPainter {
  final int numberOfCircles;
  final double circleRadius;

  DashedCirclePainter(
      {required this.numberOfCircles, required this.circleRadius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double dashWidth = 5;
    double dashSpace = 5;
    Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < numberOfCircles; i++) {
      double currentRadius = circleRadius + (i * 40);
      double circumference = 2 * 3.141592653589793 * currentRadius;
      int dashCount = (circumference / (dashWidth + dashSpace)).floor();

      for (int j = 0; j < dashCount; j++) {
        double startAngle = (j * (dashWidth + dashSpace)) / currentRadius;
        double endAngle = startAngle + (dashWidth / currentRadius);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: currentRadius),
          startAngle,
          endAngle - startAngle,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
