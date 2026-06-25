import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';

class TimeMatrixScreen extends StatefulWidget {
  @override
  _TimeMatrixScreenState createState() => _TimeMatrixScreenState();
}

class _TimeMatrixScreenState extends State<TimeMatrixScreen> {
  DateTime? _birthDate;
  Timer? _timer;

  int _years = 0;
  int _months = 0;
  int _days = 0;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  int _totalDays = 0;

  @override
  void initState() {
    super.initState();
    _startMatrixTimer();
  }

  void _startMatrixTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_birthDate != null) {
        _calculateAge();
      }
    });
    // Calculate immediately on start
    if (_birthDate != null) _calculateAge();
  }

  void _calculateAge() {
    if (_birthDate == null) return;

    final now = DateTime.now();

    // Total days lived
    _totalDays = now.difference(_birthDate!).inDays;

    int years = now.year - _birthDate!.year;
    int months = now.month - _birthDate!.month;
    int days = now.day - _birthDate!.day;

    if (days < 0) {
      months--;
      // Approximation of days in previous month
      final previousMonth = DateTime(now.year, now.month, 0);
      days += previousMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    setState(() {
      _years = years;
      _months = months;
      _days = days;
      _hours = now.hour - _birthDate!.hour;
      _minutes = now.minute - _birthDate!.minute;
      _seconds = now.second - _birthDate!.second;

      // Handle negative time values from simple subtraction
      if (_seconds < 0) {
        _minutes--;
        _seconds += 60;
      }
      if (_minutes < 0) {
        _hours--;
        _minutes += 60;
      }
      if (_hours < 0) {
        _days--;
        _hours += 24;
        if (_days < 0) {
          // rare case handling, simply rollback days if negative hour carries over
          _days = 0; // simplify for display purposes
        }
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _birthDate ?? DateTime.now().subtract(Duration(days: 365 * 20)),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: AppColors.surfaceVariant,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.background,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
      _calculateAge();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Time Matrix",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Glow for Matrix Vibe
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withOpacity(0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.cyanAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_clock,
                            color: Colors.cyanAccent,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "VVIP Time Engine",
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Date Picker Button
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.cyanAccent.withOpacity(0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "TANGGAL LAHIR ANDA",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _birthDate != null
                                ? "${_birthDate!.day.toString().padLeft(2, '0')} / ${_birthDate!.month.toString().padLeft(2, '0')} / ${_birthDate!.year}"
                                : "PILIH TANGGAL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // The Matrix Display
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF101A24).withOpacity(0.9),
                            Color(0xFF0A0F15).withOpacity(0.95),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(
                          color: Colors.cyanAccent.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "WAKTU HIDUP ANDA",
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 14,
                                letterSpacing: 4,
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildTimeBox(_years, "TAHUN"),
                                _buildTimeBox(_months, "BULAN"),
                                _buildTimeBox(_days, "HARI"),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildTimeBox(_hours, "JAM", isHighlight: true),
                                _buildTimeBox(
                                  _minutes,
                                  "MENIT",
                                  isHighlight: true,
                                ),
                                _buildTimeBox(
                                  _seconds,
                                  "DETIK",
                                  isHighlight: true,
                                  isBlinking: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Divider(color: Colors.cyanAccent.withOpacity(0.2)),
                            SizedBox(height: 10),
                            Text(
                              "TOTAL HARI DI BUMI",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "$_totalDays Hari",
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.cyanAccent,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(
    int value,
    String label, {
    bool isHighlight = false,
    bool isBlinking = false,
  }) {
    String valStr = value.toString().padLeft(2, '0');

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isHighlight
                ? Colors.cyanAccent.withOpacity(0.1)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHighlight
                  ? Colors.cyanAccent.withOpacity(0.5)
                  : Colors.white10,
            ),
          ),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              valStr,
              key: ValueKey<int>(value),
              style: TextStyle(
                color: isHighlight ? Colors.cyanAccent : Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
