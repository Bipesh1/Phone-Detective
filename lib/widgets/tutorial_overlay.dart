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
    _scheduleFindTarget();
  }

  @override
  void didUpdateWidget(covariant TutorialOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the target changed (or step changes), reset immediately then refind
    if (widget.targetKey != oldWidget.targetKey) {
      setState(() {
        _targetPosition = null;
        _targetSize = null;
      });
      _scheduleFindTarget();
    }
  }

  void _scheduleFindTarget() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // One small delay helps after animations / layout
      Future.delayed(const Duration(milliseconds: 80), () {
        if (!mounted) return;
        _findTarget(retries: 6);
      });
    });
  }

  void _findTarget({required int retries}) {
    if (widget.targetKey == null) {
      if (!mounted) return;
      setState(() {
        _targetPosition = null;
        _targetSize = null;
      });
      return;
    }

    final RenderBox? targetBox =
        widget.targetKey!.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? overlayBox = context.findRenderObject() as RenderBox?;

    if (targetBox != null &&
        overlayBox != null &&
        targetBox.attached &&
        overlayBox.attached &&
        targetBox.hasSize) {
      // IMPORTANT: position relative to overlay stack (NOT global screen)
      final Offset pos =
          targetBox.localToGlobal(Offset.zero, ancestor: overlayBox);
      final Size size = targetBox.size;

      if (!mounted) return;
      setState(() {
        _targetPosition = pos;
        _targetSize = size;
      });
      return;
    }

    if (retries <= 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 80), () {
        if (!mounted) return;
        _findTarget(retries: retries - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasTarget = _targetPosition != null && _targetSize != null;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Dim background + "hole"
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
              if (hasTarget)
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

        // Message bubble
        Positioned(
          left: 20,
          right: 20,
          top: hasTarget
              ? (_targetPosition!.dy <= MediaQuery.of(context).size.height / 2
                  ? _targetPosition!.dy + _targetSize!.height + 20
                  : null)
              : MediaQuery.of(context).size.height / 2 - 100,
          bottom: hasTarget
              ? (_targetPosition!.dy > MediaQuery.of(context).size.height / 2
                  ? MediaQuery.of(context).size.height -
                      _targetPosition!.dy +
                      20
                  : null)
              : null,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
          ),
        ),
      ],
    );
  }
}
