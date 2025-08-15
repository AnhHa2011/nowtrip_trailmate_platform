import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await requestPermissions();
  runApp(const TrailMateApp());
}

Future<void> requestPermissions() async {
  await [
    Permission.location,
    Permission.camera,
    Permission.storage,
  ].request();
}

class TrailMateApp extends StatelessWidget {
  const TrailMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrailMate - GPS Companion',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
        ),
      ),
      home: const MapPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isTracking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrailMate'),
        backgroundColor: const Color(0xFF2F4F4F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency, color: Colors.red),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency SOS activated!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isTracking ? const Color(0xFF4CAF50) : const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                isTracking ? Icons.gps_fixed : Icons.gps_not_fixed,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              isTracking ? 'GPS Tracking Active' : 'GPS Tracking Ready',
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isTracking ? 'Recording your trail...' : 'Your outdoor safety companion',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: const Color(0xFF4A5568),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            isTracking = !isTracking;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isTracking ? 'GPS tracking started' : 'GPS tracking stopped'),
              backgroundColor: isTracking ? Colors.green : Colors.orange,
            ),
          );
        },
        backgroundColor: isTracking ? Colors.red : const Color(0xFFFF6B35),
        icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
        label: Text(isTracking ? 'STOP' : 'START'),
      ),
    );
  }
}
