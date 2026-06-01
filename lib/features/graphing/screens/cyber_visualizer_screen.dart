import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../logic/js_interop.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CyberVisualizerScreen extends StatefulWidget {
  @override
  _CyberVisualizerScreenState createState() => _CyberVisualizerScreenState();
}

class _CyberVisualizerScreenState extends State<CyberVisualizerScreen> {
  @override
  void initState() {
    super.initState();
    // Start the JS particle effect if on Web
    if (kIsWeb) {
      CyberBgInterop.start();
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      CyberBgInterop.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent to show JS canvas behind
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('VVIP Visualizer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(24),
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.accentCyan.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentCyan.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentPurple],
                  ).createShader(bounds),
                  child: Icon(Icons.hub_rounded, size: 80, color: Colors.white),
                ),
                SizedBox(height: 24),
                Text(
                  'Sistem Visualisasi Aktif',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Merender efek partikel VVIP secara real-time menggunakan JavaScript Interop pada Web Canvas.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Trigger a sudden surge in the particle effect by stopping and starting quickly
                    if (kIsWeb) {
                      CyberBgInterop.stop();
                      Future.delayed(Duration(milliseconds: 100), () => CyberBgInterop.start());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: Text(
                        'RESET PARTICLES',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
