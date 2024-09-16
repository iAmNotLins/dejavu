import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  bool _showFinalLogo = false;

  @override
  void initState() {
    super.initState();

    // Inicializando o AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duração da rotação e crescimento
      vsync: this,
    );

    // Tween para a rotação (0 a 360 graus)
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Tween para o crescimento (escala)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Inicializando a animação de fade para transição
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Iniciando a animação de rotação e crescimento
    _controller.forward();

    // Após 2 segundos, troca para DejavuLogo.png com fade suave
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _showFinalLogo = true;
      });

      // Nova animação de "pulso" para DejavuLogo.png
      _pulseAnimation = Tween<double>(begin: 0.6, end: 1.5).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.repeat(reverse: true);
    });

    // Timer para navegar para a próxima tela após o "pulso"
    Timer(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacementNamed('/auth');
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Descartando o controller ao finalizar
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Alterna entre as animações
            if (_showFinalLogo) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Image.asset(
                    'lib/images/DejavuLogo.png', // Imagem final sem rotação
                    width: 350,
                    height: 350,
                  ),
                ),
              );
            } else {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 2.0 * 3.1416, // Rotação completa
                  child: Transform.scale(
                    scale: _scaleAnimation.value, // Crescimento do Logo.png
                    child: Image.asset(
                      'lib/images/Logo.png', // Primeira imagem com rotação
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
