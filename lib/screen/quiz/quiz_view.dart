import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screen/quiz/models/balloon_model.dart';
import 'package:myapp/screen/quiz/widgets/balloon_painter.dart';
import 'package:myapp/shared/constants/app_colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  late AnimationController _balloonController;
  late List<Balloon> _balloons;

  @override
  void initState() {
    super.initState();

    // Gradient Animation
    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: AppColors.blue1,
      end: AppColors.blue2,
    ).animate(_gradientController);

    _colorAnimation2 = ColorTween(
      begin: AppColors.blue2,
      end: AppColors.blue1,
    ).animate(_gradientController);

    // Balloon Animation
    _balloons = List.generate(20, (index) {
      final random = Random();
      return Balloon(
        id: index,
        size: random.nextDouble() * 20 + 10,
        speed: random.nextDouble() * 2 + 1,
        color: Colors.blue.withOpacity(random.nextDouble() * 0.5 + 0.2),
      );
    });

    _balloonController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _balloonController.addListener(() {
      setState(() {
        for (var balloon in _balloons) {
          balloon.move();
        }
      });
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _balloonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_colorAnimation1.value!, _colorAnimation2.value!],
                  ),
                ),
              );
            },
          ),
          CustomPaint(
            painter: BalloonPainter(balloons: _balloons),
            size: Size.infinite,
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('lib/assets/images/logo.png', height: 100),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.7),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              'What is the capital of France?',
                              style: GoogleFonts.oswald(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              children: [
                                _buildAnswerButton('Paris'),
                                _buildAnswerButton('London'),
                                _buildAnswerButton('Berlin'),
                                _buildAnswerButton('Madrid'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(String answer) {
    return ElevatedButton(
      onPressed: () {},
      style:
          ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.8),
            foregroundColor: AppColors.blue1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.5),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.pressed)) {
                return AppColors.blue1;
              }
              return null; // Defer to the widget's default.
            }),
          ),
      child: Text(
        answer,
        style: GoogleFonts.robotoMono(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
