import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorialOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onContinue;
  final GlobalKey? targetKey;
  final bool isLastStep;

  const TutorialOverlay({
    super.key,
    required this.message,
    required this.onContinue,
    this.targetKey,
    this.isLastStep = false,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  Offset? _targetPosition;
  Size? _targetSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _findTarget());
  }

  @override
  void didUpdateWidget(TutorialOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetKey != oldWidget.targetKey) {
      // Reset first to avoid jumping hole
      setState(() {
        _targetPosition = null;
        _targetSize = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _findTarget());
    }
  }

  void _findTarget() {
    if (widget.targetKey == null) return;

    final RenderBox? renderBox =
        widget.targetKey!.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _targetPosition = renderBox.localToGlobal(Offset.zero);
        _targetSize = renderBox.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we have a key but haven't found it yet, show dimmed but no hole to prevent flashing
    // Or we could show nothing? Let's show dimmed.
    // Actually, if we are waiting for layout, showing the hole at 0,0 is bad.

    return Stack(
      fit: StackFit.expand,
      children: [
        // Dimmed Background with "Hole"
        ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              if (_targetPosition != null && _targetSize != null)
                Positioned(
                  left: _targetPosition!.dx - 8,
                  top: _targetPosition!.dy - 8,
                  child: Container(
                    width: _targetSize!.width + 16,
                    height: _targetSize!.height + 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Message Bubble
        Positioned(
          top: _targetPosition != null
              ? (_targetPosition!.dy > MediaQuery.of(context).size.height / 2
                  ? _targetPosition!.dy - 160 // Above target
                  : _targetPosition!.dy +
                      _targetSize!.height +
                      20) // Below target
              : MediaQuery.of(context).size.height / 2 -
                  50, // Center if no target
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DETECTIVE GUIDE',
                        style: GoogleFonts.oswald(
                          color: const Color(0xFF007AFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.message,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onContinue,
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF007AFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: Text(
                            widget.isLastStep ? 'FINISH' : 'NEXT',
                            style: GoogleFonts.oswald(),
                          ),
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
    );
  }
}
