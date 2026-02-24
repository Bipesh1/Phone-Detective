// Phone Detective - Interrogation Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/interrogation.dart';
import '../models/clue.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class InterrogationScreen extends StatefulWidget {
  final String contactId;

  const InterrogationScreen({super.key, required this.contactId});

  @override
  State<InterrogationScreen> createState() => _InterrogationScreenState();
}

class _InterrogationScreenState extends State<InterrogationScreen>
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  String? _currentResponse;
  bool _isRevealing = false;
  late AnimationController _responseController;

  @override
  void initState() {
    super.initState();
    _responseController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final contact = gameState.currentCase.getContact(widget.contactId);
    final questions = gameState.currentCase.getInterrogationQuestionsForContact(
      widget.contactId,
    );

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            'No questions available.',
            style: GoogleFonts.roboto(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final currentQuestion = questions[_currentQuestionIndex];
    final foundClueSourceIds =
        gameState.currentClues.map((c) => c.sourceId).toSet();

    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A0A18),
              const Color(0xFF080810),
              contact?.avatarColor.withValues(alpha: 0.05) ??
                  const Color(0xFF080810),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'INTERROGATION',
                      style: GoogleFonts.robotoMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.danger,
                        letterSpacing: 3,
                      ),
                    ),
                    const Spacer(),
                    // Question counter
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_currentQuestionIndex + 1}/${questions.length}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Contact avatar — noir style
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: contact?.avatarColor ?? AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: (contact?.avatarColor ?? AppColors.primary)
                          .withValues(alpha: 0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    contact?.initials ?? '?',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                contact?.fullName ?? 'Unknown',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                contact?.relationship ?? '',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
              const Spacer(),
              // Question & Response area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Question
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                              Icon(Icons.record_voice_over,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'YOU ASK:',
                                style: GoogleFonts.robotoMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '"${currentQuestion.question}"',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Response
                    if (_currentResponse != null)
                      FadeTransition(
                        opacity: _responseController,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                (contact?.avatarColor ?? AppColors.surfaceDark)
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (contact?.avatarColor ??
                                      AppColors.surfaceDark)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person,
                                      color: contact?.avatarColor ??
                                          AppColors.textSecondary,
                                      size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${contact?.firstName ?? "THEY"} RESPONDS:',
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: contact?.avatarColor ??
                                          AppColors.textSecondary,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '"$_currentResponse"',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 80),
                  ],
                ),
              ),
              const Spacer(),
              // Action buttons
              Padding(
                padding: EdgeInsets.fromLTRB(
                    24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
                child: Row(
                  children: [
                    if (_currentResponse == null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isRevealing
                              ? null
                              : () => _askQuestion(currentQuestion,
                                  foundClueSourceIds, gameState),
                          icon: const Icon(Icons.chat, size: 18),
                          label: Text(
                            'ASK QUESTION',
                            style: GoogleFonts.robotoMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _nextQuestion(questions.length),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceDark,
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _currentQuestionIndex < questions.length - 1
                                ? 'NEXT QUESTION'
                                : 'DONE',
                            style: GoogleFonts.robotoMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
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
    );
  }

  void _askQuestion(
    InterrogationQuestion question,
    Set<String> foundClueIds,
    GameStateProvider gameState,
  ) async {
    setState(() => _isRevealing = true);
    HapticService.mediumTap();

    await Future.delayed(const Duration(milliseconds: 600));

    final answer = question.getBestAnswer(foundClueIds);

    setState(() {
      _currentResponse = answer.response;
      _isRevealing = false;
    });

    _responseController.forward(from: 0);

    // If this answer reveals a new clue, add it
    if (answer.revealsClueId != null && answer.revealsClueId!.isNotEmpty) {
      final revealClue = Clue(
        id: answer.revealsClueId!,
        type: ClueType.contact,
        sourceId: answer.revealsClueId!,
        preview:
            '${gameState.currentCase.getContact(question.contactId)?.firstName ?? "Contact"} revealed: "${answer.response.length > 60 ? '${answer.response.substring(0, 60)}...' : answer.response}"',
        foundAt: DateTime.now(),
      );
      await gameState.addClue(revealClue);
      HapticService.heavyTap();
    }

    // Mark this interrogation as answered
    gameState.markInterrogationAnswered(question.id);
  }

  void _nextQuestion(int totalQuestions) {
    if (_currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
        _currentResponse = null;
      });
      _responseController.reset();
    } else {
      Navigator.pop(context);
    }
  }
}
