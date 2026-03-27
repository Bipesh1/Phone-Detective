// Phone Detective - Handler Message Widget
// Displays an incoming "secure briefing" from the handler on the hacking screen.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HandlerMessageWidget extends StatefulWidget {
  final String briefing;

  const HandlerMessageWidget({super.key, required this.briefing});

  @override
  State<HandlerMessageWidget> createState() => _HandlerMessageWidgetState();
}

class _HandlerMessageWidgetState extends State<HandlerMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.briefing.isEmpty) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0D2137),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF1A4A6B), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A4A6B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'HANDLER BRIEFING',
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF5BB8FF),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'ENCRYPTED',
                    style: GoogleFonts.robotoMono(
                      color: const Color(0xFF1A4A6B),
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.briefing,
                style: GoogleFonts.robotoMono(
                  color: const Color(0xFF8BBFDF),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
