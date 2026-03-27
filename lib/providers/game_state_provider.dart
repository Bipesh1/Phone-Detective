// Phone Detective - Game State Provider

import 'package:flutter/widgets.dart';

import '../services/save_service.dart';
import '../services/supabase_service.dart';
import '../data/cases/all_cases.dart';
import '../utils/constants.dart';

class GameStateProvider extends ChangeNotifier {
  final SaveService _saveService = SaveService();

  List<CaseData> _allCases = []; // Start empty, load from DB
  int _currentCaseNumber = 1;
  int _tutorialStep = 0; // 0: Inactive, 1+: Active Steps

  Set<int> _solvedCases = {};
  List<Clue> _currentClues = [];
  Set<String> _currentSuspects = {};
  String _playerNotes = '';
  DateTime? _caseStartTime;
  Set<String> _unlockedNotes = {};
  Set<String> _unlockedItemIds = {}; // For password-protected items
  Set<String> _restoredItemIds = {}; // For corrupted items
  Map<String, int> _revealedHints =
      {}; // stepHintId -> number of hints revealed
  bool _isInitialized = false;
  bool _isRemote = false;

  // Suspense & thriller state
  Set<String> _firedSuspenseEvents = {};
  Set<String> _answeredInterrogations = {};
  Set<String> _verifiedDeductions = {};
  bool _timelineCompleted = false;
  SuspenseEvent? _pendingSuspenseEvent;

  // Revelation state
  bool _pendingRevelation = false;
  bool _revelationShown = false;

  // Deduction auto-unlock state
  String? _pendingDeductionUnlock;
  Set<String> _autoUnlockedDeductions = {};

  // Timed suspense guard — prevents re-firing when home screen rebuilds
  bool _timedEventsStarted = false;

  // Getters
  List<CaseData> get cases => _allCases;
  int get currentCaseNumber => _currentCaseNumber;
  Set<int> get solvedCases => _solvedCases;
  List<Clue> get currentClues => _currentClues;
  Set<String> get currentSuspects => _currentSuspects;
  String get playerNotes => _playerNotes;
  DateTime? get caseStartTime => _caseStartTime;
  Set<String> get unlockedNotes => _unlockedNotes;
  Set<String> get unlockedItemIds => _unlockedItemIds;
  Set<String> get restoredItemIds => _restoredItemIds;
  Map<String, int> get revealedHints => _revealedHints;
  bool get isInitialized => _isInitialized;
  bool get isRemote => _isRemote;
  bool get hasSaveData => _saveService.hasSaveData();
  Set<String> get firedSuspenseEvents => _firedSuspenseEvents;
  Set<String> get answeredInterrogations => _answeredInterrogations;
  Set<String> get verifiedDeductions => _verifiedDeductions;
  bool get timelineCompleted => _timelineCompleted;
  SuspenseEvent? get pendingSuspenseEvent => _pendingSuspenseEvent;
  bool get pendingRevelation => _pendingRevelation;
  String? get pendingDeductionUnlock => _pendingDeductionUnlock;
  int get hintsUsed => _revealedHints.values.fold(0, (sum, v) => sum + v);

  CaseData get currentCase {
    // Find case by number
    try {
      return _allCases.firstWhere((c) => c.caseNumber == _currentCaseNumber);
    } catch (_) {
      // Fallback to first case if not found
      return _allCases.isNotEmpty ? _allCases[0] : allCases[0];
    }
  }

  Duration get timePlayed {
    if (_caseStartTime == null) return Duration.zero;
    return DateTime.now().difference(_caseStartTime!);
  }

  // Initialization
  Future<void> init() async {
    await _saveService.init();
    await _loadRemoteCases(); // Fetch new cases
    await _loadSavedState();
    checkTutorial();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadRemoteCases() async {
    try {
      final remoteCases = await SupabaseService().getCases();
      if (remoteCases.isNotEmpty) {
        _allCases = remoteCases;
        _isRemote = true;
      } else {
        // Remote returned empty list (valid connection, just no cases)
        debugPrint('Remote DB connected but empty. No cases loaded.');
        _allCases = [];
        _isRemote = true;
      }

      // Sort by case number
      _allCases.sort((a, b) => a.caseNumber.compareTo(b.caseNumber));

      // Validate each case in debug mode (throws AssertionError if required fields missing)
      for (final c in _allCases) {
        assert(() {
          c.validate();
          return true;
        }());
      }

      // If we have cases and current case is invalid, reset to first
      if (_allCases.isNotEmpty &&
          _allCases.every((c) => c.caseNumber != _currentCaseNumber)) {
        _currentCaseNumber = _allCases.first.caseNumber;
      } else if (_allCases.isEmpty) {
        _currentCaseNumber = 0; // No cases available
      }
    } catch (e) {
      debugPrint('Failed to load remote cases: $e');
      // Fallback to static cases if remote fails
      if (_allCases.isEmpty) {
        _allCases = [...allCases];
        _isRemote = false;
        for (final c in _allCases) {
          assert(() {
            c.validate();
            return true;
          }());
        }
      }
    }
  }

  Future<void> _loadSavedState() async {
    _solvedCases = _saveService.getSolvedCases();

    final savedCase = _saveService.getCurrentCase();
    if (savedCase != null) {
      _currentCaseNumber = savedCase;
      _currentClues = _saveService.getClues(savedCase);
      _currentSuspects = _saveService.getSuspects(savedCase);
      _playerNotes = _saveService.getPlayerNotes(savedCase);
      _caseStartTime = _saveService.getCaseStartTime(savedCase);
      _unlockedNotes = _saveService.getUnlockedNotes(savedCase);
      _unlockedItemIds = _saveService.getUnlockedItems(savedCase);
      _restoredItemIds = _saveService.getRestoredItems(savedCase);
    }
  }

  // Case Management
  Future<void> startCase(int caseNumber) async {
    _currentCaseNumber = caseNumber;
    _currentClues = _saveService.getClues(caseNumber);
    _currentSuspects = _saveService.getSuspects(caseNumber);
    _playerNotes = _saveService.getPlayerNotes(caseNumber);
    _unlockedNotes = _saveService.getUnlockedNotes(caseNumber);
    _unlockedItemIds = _saveService.getUnlockedItems(caseNumber);
    _restoredItemIds = _saveService.getRestoredItems(caseNumber);

    // Set start time if not already set
    _caseStartTime = _saveService.getCaseStartTime(caseNumber);
    if (_caseStartTime == null) {
      _caseStartTime = DateTime.now();
      await _saveService.saveCaseStartTime(caseNumber, _caseStartTime!);
    }

    _pendingRevelation = false;
    _revelationShown = false;
    _pendingDeductionUnlock = null;
    _autoUnlockedDeductions = {};
    _timedEventsStarted = false;
    await _saveService.saveCurrentCase(caseNumber);
    checkTutorial();
    notifyListeners();
  }

  Future<void> solveCase() async {
    _solvedCases.add(_currentCaseNumber);
    await _saveService.markCaseSolved(_currentCaseNumber);
    // End tutorial when case is correctly solved
    if (_tutorialStep > 0) {
      _tutorialStep = 0;
      await _saveService.saveTutorialCompleted(true);
    }
    notifyListeners();
  }

  bool isCaseSolved(int caseNumber) => _solvedCases.contains(caseNumber);

  bool isCaseUnlocked(int caseNumber) {
    // Find case data for this case number
    CaseData? caseData;
    for (final c in _allCases) {
      if (c.caseNumber == caseNumber) {
        caseData = c;
        break;
      }
    }

    // Use DB unlock_requires if available, else fallback to hardcoded map
    final List<int> required;
    if (caseData != null && caseData.unlockRequires.isNotEmpty) {
      required = caseData.unlockRequires;
    } else {
      required = CaseUnlock.requirements[caseNumber] ?? [];
    }

    if (required.isEmpty) return true;

    return required.every((req) {
      if (_solvedCases.contains(req)) return true;
      // If the required case doesn't exist in loaded cases, treat as met
      final requiredCaseExists = _allCases.any((c) => c.caseNumber == req);
      if (!requiredCaseExists) return true;
      return false;
    });
  }

  void clearPendingRevelation() {
    _pendingRevelation = false;
  }

  void clearPendingDeductionUnlock() {
    _pendingDeductionUnlock = null;
  }

  // Clue Management
  Future<void> addClue(Clue clue) async {
    if (_currentClues.any((c) => c.sourceId == clue.sourceId)) return;

    _currentClues.add(clue);
    await _saveService.saveClues(_currentCaseNumber, _currentClues);

    // Auto-unlock the first newly-completed deduction (shows one insight per clue mark)
    if (_pendingDeductionUnlock == null) {
      for (final deduction in currentCase.solution.deductionChecklist) {
        if (_autoUnlockedDeductions.contains(deduction.id)) continue;
        final allFound = deduction.linkedClueIds.every(
          (cid) => _currentClues.any((c) => c.sourceId == cid),
        );
        if (allFound) {
          _autoUnlockedDeductions.add(deduction.id);
          _pendingDeductionUnlock = deduction.statement;
          break;
        }
      }
    }

    // Check if all key clues are now collected
    if (!_revelationShown) {
      final keyIds = currentCase.solution.keyClueIds;
      if (keyIds.isNotEmpty) {
        final foundKeyCount =
            _currentClues.where((c) => keyIds.contains(c.sourceId)).length;
        if (foundKeyCount >= keyIds.length) {
          _pendingRevelation = true;
          _revelationShown = true;
        }
      }
    }

    notifyListeners();

    // Check for suspense events triggered by this clue
    _checkSuspenseEvents(clue.sourceId);
  }

  Future<void> removeClue(String clueId) async {
    _currentClues.removeWhere((c) => c.id == clueId);
    await _saveService.saveClues(_currentCaseNumber, _currentClues);
    notifyListeners();
  }

  bool isClueMarked(String sourceId) {
    return _currentClues.any((c) => c.sourceId == sourceId);
  }

  /// Returns true if [itemId] is a key clue for the current case.
  /// Falls back to true (allow any) when no key_clue_ids are defined.
  bool isKeyClue(String itemId) {
    final keyClueIds = currentCase.solution.keyClueIds;
    if (keyClueIds.isEmpty) return true;
    return keyClueIds.contains(itemId);
  }

  Future<void> updateClueNote(String clueId, String note) async {
    final index = _currentClues.indexWhere((c) => c.id == clueId);
    if (index != -1) {
      _currentClues[index] = _currentClues[index].copyWith(playerNote: note);
      await _saveService.saveClues(_currentCaseNumber, _currentClues);
      notifyListeners();
    }
  }

  // Suspect Management
  Future<void> toggleSuspect(String contactId) async {
    if (_currentSuspects.contains(contactId)) {
      _currentSuspects.remove(contactId);
    } else {
      _currentSuspects.add(contactId);
    }
    await _saveService.saveSuspects(_currentCaseNumber, _currentSuspects);
    notifyListeners();
  }

  bool isSuspect(String contactId) => _currentSuspects.contains(contactId);

  // Player Notes
  Future<void> updatePlayerNotes(String notes) async {
    _playerNotes = notes;
    await _saveService.savePlayerNotes(_currentCaseNumber, notes);
    notifyListeners();
  }

  // Locked Notes
  Future<void> unlockNote(String noteId) async {
    _unlockedNotes.add(noteId);
    notifyListeners(); // Update UI immediately
    await _saveService.saveUnlockedNotes(_currentCaseNumber, _unlockedNotes);
  }

  bool isNoteUnlocked(String noteId) => _unlockedNotes.contains(noteId);

  // Evidence Locking & Corruption
  Future<void> unlockItem(String itemId) async {
    _unlockedItemIds.add(itemId);
    notifyListeners(); // Update UI immediately
    await _saveService.saveUnlockedItems(_currentCaseNumber, _unlockedItemIds);
  }

  bool isItemUnlocked(String itemId) => _unlockedItemIds.contains(itemId);

  Future<void> restoreItem(String itemId) async {
    _restoredItemIds.add(itemId);
    notifyListeners(); // Update UI immediately
    await _saveService.saveRestoredItems(_currentCaseNumber, _restoredItemIds);
  }

  bool isItemRestored(String itemId) => _restoredItemIds.contains(itemId);

  // Step Hints - Progressive reveal
  int getRevealedHintCount(String stepHintId) {
    return _revealedHints[stepHintId] ?? 0;
  }

  void revealNextHint(String stepHintId, int maxHints) {
    final current = _revealedHints[stepHintId] ?? 0;
    if (current < maxHints) {
      _revealedHints[stepHintId] = current + 1;
      notifyListeners();
    }
  }

  // ============ SUSPENSE SYSTEM ============

  void _checkSuspenseEvents(String clueSourceId) {
    for (final event in currentCase.suspenseEvents) {
      if (_firedSuspenseEvents.contains(event.id)) continue;
      if (event.trigger == SuspenseTrigger.afterClue &&
          event.triggerClueId == clueSourceId) {
        _firedSuspenseEvents.add(event.id);
        Future.delayed(Duration(seconds: event.delaySeconds), () {
          _pendingSuspenseEvent = event;
          notifyListeners();
        });
        break; // Only fire one at a time
      }
    }
  }

  /// Start timed suspense events (afterTime trigger).
  /// Guarded at the provider level so it fires exactly once per case session,
  /// regardless of how many times PhoneHomeScreen rebuilds.
  void startTimedEvents() {
    if (_timedEventsStarted) return;
    _timedEventsStarted = true;

    for (final event in currentCase.suspenseEvents) {
      if (_firedSuspenseEvents.contains(event.id)) continue;
      if (event.trigger == SuspenseTrigger.afterTime) {
        _firedSuspenseEvents.add(event.id);
        Future.delayed(Duration(seconds: event.delaySeconds), () {
          // Only fire if nothing else is showing — don't re-queue, just drop
          if (_pendingSuspenseEvent == null) {
            _pendingSuspenseEvent = event;
            notifyListeners();
          }
        });
      }
    }
  }

  /// Fire onOpen suspense events for the given app name.
  void triggerOnOpenSuspenseEvent(String appName) {
    for (final event in currentCase.suspenseEvents) {
      if (_firedSuspenseEvents.contains(event.id)) continue;
      if (event.trigger == SuspenseTrigger.onOpen &&
          event.appName == appName) {
        _firedSuspenseEvents.add(event.id);
        Future.delayed(Duration(seconds: event.delaySeconds), () {
          if (_pendingSuspenseEvent == null) {
            _pendingSuspenseEvent = event;
            notifyListeners();
          }
        });
        break; // One event per open
      }
    }
  }

  void dismissSuspenseEvent() {
    _pendingSuspenseEvent = null;
    notifyListeners();
  }

  // ============ INTERROGATION SYSTEM ============

  void markInterrogationAnswered(String questionId) {
    _answeredInterrogations.add(questionId);
    notifyListeners();
  }

  bool isInterrogationAnswered(String questionId) =>
      _answeredInterrogations.contains(questionId);

  // ============ DEDUCTION CHECKLIST ============

  void toggleDeduction(String deductionId) {
    if (_verifiedDeductions.contains(deductionId)) {
      _verifiedDeductions.remove(deductionId);
    } else {
      _verifiedDeductions.add(deductionId);
    }
    notifyListeners();
  }

  bool isDeductionVerified(String deductionId) =>
      _verifiedDeductions.contains(deductionId);

  bool get allDeductionsVerified {
    final checklist = currentCase.solution.deductionChecklist;
    if (checklist.isEmpty) return true;
    return checklist.every((d) => _verifiedDeductions.contains(d.id));
  }

  int get verifiedDeductionCount => _verifiedDeductions.length;

  // ============ EVIDENCE TIMELINE ============

  void completeTimeline() {
    _timelineCompleted = true;
    notifyListeners();
  }

  // ============ RED HERRINGS ============

  int get redHerringCount {
    final herringIds = currentCase.solution.redHerringIds;
    if (herringIds.isEmpty) return 0;
    return _currentClues.where((c) => herringIds.contains(c.sourceId)).length;
  }

  // Reset
  Future<void> resetCurrentCase() async {
    await _saveService.resetCase(_currentCaseNumber);
    _currentClues = [];
    _currentSuspects = {};
    _playerNotes = '';
    _caseStartTime = DateTime.now();
    _unlockedNotes = {};
    _unlockedItemIds = {};
    _restoredItemIds = {};
    _revealedHints = {};
    _firedSuspenseEvents = {};
    _answeredInterrogations = {};
    _verifiedDeductions = {};
    _timelineCompleted = false;
    _pendingSuspenseEvent = null;
    _pendingRevelation = false;
    _revelationShown = false;
    _pendingDeductionUnlock = null;
    _autoUnlockedDeductions = {};
    _timedEventsStarted = false;
    await _saveService.saveCaseStartTime(_currentCaseNumber, _caseStartTime!);
    notifyListeners();
  }

  Future<void> resetAllProgress() async {
    await _saveService.resetAllProgress();
    _currentCaseNumber = 1;
    _solvedCases = {};
    _currentClues = [];
    _currentSuspects = {};
    _playerNotes = '';
    _caseStartTime = null;
    _unlockedNotes = {};
    _unlockedItemIds = {};
    _restoredItemIds = {};
    _revealedHints = {};
    _firedSuspenseEvents = {};
    _answeredInterrogations = {};
    _verifiedDeductions = {};
    _timelineCompleted = false;
    _pendingSuspenseEvent = null;
    _tutorialStep = 0; // Ensure tutorial step is reset
    _pendingDeductionUnlock = null;
    _autoUnlockedDeductions = {};
    notifyListeners();
  }

  // Per-case progress helpers (reads from save service for any case)
  int getClueCountForCase(int caseNumber) {
    if (caseNumber == _currentCaseNumber) return _currentClues.length;
    return _saveService.getClues(caseNumber).length;
  }

  bool hasSavedProgressForCase(int caseNumber) {
    return _saveService.getClues(caseNumber).isNotEmpty ||
        _saveService.getSuspects(caseNumber).isNotEmpty;
  }

  // Tutorial Management
  int get tutorialStep => _tutorialStep;
  bool get isTutorialActive => _tutorialStep > 0;

  void checkTutorial() {
    // Start tutorial for tutorial-difficulty cases that haven't been completed
    final isTutorialCase = _allCases.any(
      (c) => c.caseNumber == _currentCaseNumber && c.difficulty == CaseDifficulty.tutorial,
    );
    if (isTutorialCase &&
        !_saveService.isTutorialCompleted() &&
        _tutorialStep == 0) {
      startTutorial();
    }
  }

  void startTutorial() {
    _tutorialStep = 1;
    notifyListeners();
  }

  void nextTutorialStep() {
    if (_tutorialStep < 12) {
      _tutorialStep++;

      // Force a frame to complete before showing next step
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } else {
      endTutorial();
    }
  }

  /// Advance the tutorial only if currently on [step].
  /// Called when the player opens an app during the tutorial.
  void advanceTutorialIfOnStep(int step) {
    if (_tutorialStep == step) nextTutorialStep();
  }

  Future<void> endTutorial() async {
    _tutorialStep = 0;
    await _saveService.saveTutorialCompleted(true);
    notifyListeners();
  }
}
