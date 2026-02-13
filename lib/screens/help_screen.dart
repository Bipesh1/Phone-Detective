import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _helpPages = [
    {
      'title': 'Welcome, Detective',
      'content':
          'You have been granted access to a series of recovered phones. Your mission is to uncover the truth hidden within their data.',
      'icon': 'assets/icons/detective.png', // Placeholder, using Icon in build
    },
    {
      'title': 'Investigate',
      'content':
          'Explore apps like Messages, Gallery, and Notes. Look for inconsistencies, motives, and alibis. Every detail matters.',
      'icon': 'assets/icons/search.png',
    },
    {
      'title': 'Collect Clues',
      'content':
          'Tap and hold on messages or images to flag them as potential clues. You can review your findings in the Detective Journal.',
      'icon': 'assets/icons/clue.png',
    },
    {
      'title': 'Solve the Case',
      'content':
          'When you have enough evidence, go to the "Solve" app. correctly identify the culprit, motive, and method to close the case.',
      'icon': 'assets/icons/solve.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background - similar to main menu
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey[900]!, Colors.black],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'FIELD GUIDE',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance close button
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _helpPages.length,
                    itemBuilder: (context, index) {
                      final page = _helpPages[index];
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon/Graphic
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.05),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                _getIconForPage(index),
                                size: 64,
                                color: const Color(0xFF007AFF),
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Title
                            Text(
                              page['title']!.toUpperCase(),
                              style: GoogleFonts.oswald(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Content
                            Text(
                              page['content']!,
                              style: GoogleFonts.robotoMono(
                                color: Colors.white70,
                                fontSize: 16,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Indicators
                Padding(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _helpPages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF007AFF)
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),

                // Next/Finish Button
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32.0,
                    left: 32,
                    right: 32,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage < _helpPages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        _currentPage < _helpPages.length - 1
                            ? 'NEXT'
                            : 'START INVESTIGATING',
                        style: GoogleFonts.oswald(
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForPage(int index) {
    switch (index) {
      case 0:
        return Icons.fingerprint;
      case 1:
        return Icons.search;
      case 2:
        return Icons.bookmark_border;
      case 3:
        return Icons.gavel;
      default:
        return Icons.help_outline;
    }
  }
}
