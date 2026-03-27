// Phone Detective - Case Transition Screen
// Shown after correctly solving a case — bridges to the next assignment.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class CaseTransitionScreen extends StatefulWidget {
  final int nextCaseNumber;

  const CaseTransitionScreen({super.key, required this.nextCaseNumber});

  @override
  State<CaseTransitionScreen> createState() => _CaseTransitionScreenState();
}

class _CaseTransitionScreenState extends State<CaseTransitionScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _messageController;
  late AnimationController _caseCardController;
  late AnimationController _buttonsController;

  bool _showMessage = false;
  bool _showCaseCard = false;
  bool _showButtons = false;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _messageController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _caseCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _buttonsController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _headerController.forward();

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _showMessage = true);
    _messageController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _showCaseCard = true);
    _caseCardController.forward();

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _showButtons = true);
    _buttonsController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _messageController.dispose();
    _caseCardController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final nextCase = gameState.cases.firstWhere(
      (c) => c.caseNumber == widget.nextCaseNumber,
      orElse: () => gameState.currentCase,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1628),
              AppColors.background,
              Color(0xFF080810),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                FadeTransition(
                  opacity: _headerController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _headerController,
                      curve: Curves.easeOut,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            'CASE CLOSED',
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'New Assignment\nReceived',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.6),
                                AppColors.primary.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── HQ Incoming Message ──
                if (_showMessage) ...[
                  FadeTransition(
                    opacity: _messageController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _messageController,
                        curve: Curves.easeOut,
                      )),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.shield,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'HQ — Handler',
                                      style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      'Encrypted · Now',
                                      style: GoogleFonts.roboto(
                                        fontSize: 11,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Good work, detective. Your instincts were right on this one.\n\n'
                              'We have another case that needs your attention. '
                              'The details are classified — review the briefing and decide if you\'re ready.',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Next Case Teaser ──
                if (_showCaseCard) ...[
                  FadeTransition(
                    opacity: _caseCardController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _caseCardController,
                        curve: Curves.easeOut,
                      )),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              nextCase.themeColor.withValues(alpha: 0.12),
                              nextCase.themeColor.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: nextCase.themeColor.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.folder_special,
                                  color: nextCase.themeColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'NEXT ASSIGNMENT — CASE ${nextCase.caseNumber.toString().padLeft(2, '0')}',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: nextCase.themeColor,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              nextCase.title,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              nextCase.subtitle,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _TeaserChip(
                                  icon: Icons.signal_cellular_alt,
                                  label:
                                      nextCase.difficulty.name.toUpperCase(),
                                  color: nextCase.themeColor,
                                ),
                                const SizedBox(width: 10),
                                _TeaserChip(
                                  icon: Icons.search,
                                  label: '${nextCase.totalClues} CLUES',
                                  color: AppColors.clue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // ── Action Buttons ──
                if (_showButtons) ...[
                  FadeTransition(
                    opacity: _buttonsController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _buttonsController,
                        curve: Curves.easeOut,
                      )),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                HapticService.heavyTap();
                                gameState.startCase(widget.nextCaseNumber);
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.caseIntro,
                                );
                              },
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                              label: Text(
                                'ACCEPT CASE',
                                style: GoogleFonts.robotoMono(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 4,
                                shadowColor:
                                    AppColors.primary.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                HapticService.lightTap();
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.caseSelect,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                side: const BorderSide(color: Colors.white24),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Skip — View Case Files',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeaserChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TeaserChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.robotoMono(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
