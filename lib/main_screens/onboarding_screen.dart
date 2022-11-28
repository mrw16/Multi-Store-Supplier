// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Timer? countDownTimer;
  int seconds = 3;
  List<int> discountList = [];
  String supplierId = '';

  @override
  void initState() {
    startTimer();
    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('supplierid') ?? '';
    }).then((String value) {
      setState(() {
        supplierId = value;
      });
      print(supplierId);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    countDownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          seconds--;
        });
        if (seconds < 0) {
          stopTimer();
          supplierId != ''
              ? Navigator.pushReplacementNamed(context, '/supplier_home')
              : Navigator.pushReplacementNamed(context, '/supplier_login');
        }
        // print(timer.tick);
        // print(seconds);
      },
    );
  }

  void stopTimer() {
    countDownTimer!.cancel();
  }

  Widget buildAsset() {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
        'images/onboard/sale.JPEG',
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildAsset(),
          Positioned(
            top: 60,
            right: 30,
            child: Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade600.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: MaterialButton(
                onPressed: () {
                  stopTimer();
                  supplierId != ''
                      ? Navigator.pushReplacementNamed(
                          context, '/supplier_home')
                      : Navigator.pushReplacementNamed(
                          context, '/supplier_login');
                },
                child: seconds < 1
                    ? const Text(
                        'Skip',
                      )
                    : Text(
                        'Skip | $seconds',
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
