// Phone Detective - Game State Provider

import 'dart:async';
import 'package:flutter/widgets.dart';

import '../services/save_service.dart';
import '../services/supabase_service.dart';
import '../data/cases/all_cases.dart';
import '../utils/constants.dart';

class GameStateProvider extends ChangeNotifier {
  final SaveService _saveService = SaveService();
  Timer? _batteryTimer;

  List<CaseData> _allCases = [];
  int _currentCaseNumber = 1;

  Set<int> _solvedCases = {};
  List<Clue> _currentClues = [];
  Set<String> _currentSuspects = {};
  String _playerNotes = '';
  DateTime? _caseStartTime;
  Set<String> _unlockedNotes = {};
  Set<String> _unlockedItemIds = {};
  Set<String> _restoredItemIds = {};
  Map<String, int> _revealedHints = {};
  bool _isInitialized = false;
  bool _isRemote = false;

  // Suspense & thriller state
  Set<String> _firedSuspenseEvents = {};
  Set<String> _answeredInterrogations = {};
  bool _timelineCompleted = false;
  SuspenseEvent? _pendingSuspenseEvent;
  bool _timedEventsStarted = false;

  // Battery system — drains in real time to create urgency
  double _batteryPercent = 100.0;

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
  bool get timelineCompleted => _timelineCompleted;
  SuspenseEvent? get pendingSuspenseEvent => _pendingSuspenseEvent;
  int get hintsUsed => _revealedHints.values.fold(0, (sum, v) => sum + v);
  double get batteryPercent => _batteryPercent;
  bool get isBatteryDead => _batteryPercent <= 0;

  // Tutorial stubs — tutorial is disabled; overlays never show
  int get tutorialStep => 0;
  bool get isTutorialActive => false;
  void checkTutorial() {}
  void startTutorial() {}
  void nextTutorialStep() {}
  void advanceTutorialIfOnStep(int step) {}
  Future<void> endTutorial() async {}

  CaseData get currentCase {
    try {
      return _allCases.firstWhere((c) => c.caseNumber == _currentCaseNumber);
    } catch (_) {
      return _allCases.isNotEmpty ? _allCases[0] : allCases[0];
    }
  }

  Duration get timePlayed {
    if (_caseStartTime == null) return Duration.zero;
    return DateTime.now().difference(_caseStartTime!);
  }

  @override
  void dispose() {
    _batteryTimer?.cancel();
    super.dispose();
  }

  // ============ INITIALIZATION ============

  Future<void> init() async {
    await _saveService.init();
    await _loadRemoteCases();
    await _loadSavedState();
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
        debugPrint('Remote DB connected but empty. No cases loaded.');
        _allCases = [];
        _isRemote = true;
      }

      _allCases.sort((a, b) => a.caseNumber.compareTo(b.caseNumber));

      for (final c in _allCases) {
        assert(() {
          c.validate();
          return true;
        }());
      }

      if (_allCases.isNotEmpty &&
          _allCases.every((c) => c.caseNumber != _currentCaseNumber)) {
        _currentCaseNumber = _allCases.first.caseNumber;
      } else if (_allCases.isEmpty) {
        _currentCaseNumber = 0;
      }
    } catch (e) {
      debugPrint('Failed to load remote cases: $e');
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

  // ============ CASE MANAGEMENT ============

  Future<void> startCase(int caseNumber) async {
    _currentCaseNumber = caseNumber;
    _currentClues = _saveService.getClues(caseNumber);
    _currentSuspects = _saveService.getSuspects(caseNumber);
    _playerNotes = _saveService.getPlayerNotes(caseNumber);
    _unlockedNotes = _saveService.getUnlockedNotes(caseNumber);
    _unlockedItemIds = _saveService.getUnlockedItems(caseNumber);
    _restoredItemIds = _saveService.getRestoredItems(caseNumber);

    _caseStartTime = _saveService.getCaseStartTime(caseNumber);
    if (_caseStartTime == null) {
      _caseStartTime = DateTime.now();
      await _saveService.saveCaseStartTime(caseNumber, _caseStartTime!);
    }

    _timedEventsStarted = false;
    _initBattery();
    await _saveService.saveCurrentCase(caseNumber);
    notifyListeners();
  }

  void _initBattery() {
    _batteryTimer?.cancel();
    final caseData = currentCase;
    _batteryPercent = caseData.batteryStartPercent.toDouble();
    final drain = caseData.batteryDrainPerMinute;
    if (drain <= 0) return;

    // Tick every 10 seconds; drain = drainPerMinute / 6
    _batteryTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _batteryPercent -= drain / 6.0;
      _batteryPercent = _batteryPercent.clamp(0.0, 100.0);
      if (_batteryPercent <= 0) timer.cancel();
      notifyListeners();
    });
  }

  Future<void> solveCase() async {
    _solvedCases.add(_currentCaseNumber);
    _batteryTimer?.cancel();
    await _saveService.markCaseSolved(_currentCaseNumber);
    notifyListeners();
  }

  bool isCaseSolved(int caseNumber) => _solvedCases.contains(caseNumber);

  bool isCaseUnlocked(int caseNumber) {
    CaseData? caseData;
    for (final c in _allCases) {
      if (c.caseNumber == caseNumber) {
        caseData = c;
        break;
      }
    }

    final List<int> required;
    if (caseData != null && caseData.unlockRequires.isNotEmpty) {
      required = caseData.unlockRequires;
    } else {
      required = CaseUnlock.requirements[caseNumber] ?? [];
    }

    if (required.isEmpty) return true;

    return required.every((req) {
      if (_solvedCases.contains(req)) return true;
      final requiredCaseExists = _allCases.any((c) => c.caseNumber == req);
      if (!requiredCaseExists) return true;
      return false;
    });
  }

  // ============ CLUE MANAGEMENT ============

  Future<void> addClue(Clue clue) async {
    if (_currentClues.any((c) => c.sourceId == clue.sourceId)) return;

    _currentClues.add(clue);
    await _saveService.saveClues(_currentCaseNumber, _currentClues);
    notifyListeners();

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

  Future<void> updateClueNote(String clueId, String note) async {
    final index = _currentClues.indexWhere((c) => c.id == clueId);
    if (index != -1) {
      _currentClues[index] = _currentClues[index].copyWith(playerNote: note);
      await _saveService.saveClues(_currentCaseNumber, _currentClues);
      notifyListeners();
    }
  }

  // ============ SUSPECT MANAGEMENT ============

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

  // ============ PLAYER NOTES ============

  Future<void> updatePlayerNotes(String notes) async {
    _playerNotes = notes;
    await _saveService.savePlayerNotes(_currentCaseNumber, notes);
    notifyListeners();
  }

  // ============ LOCKED / CORRUPTED ITEMS ============

  Future<void> unlockNote(String noteId) async {
    _unlockedNotes.add(noteId);
    notifyListeners();
    await _saveService.saveUnlockedNotes(_currentCaseNumber, _unlockedNotes);
  }

  bool isNoteUnlocked(String noteId) => _unlockedNotes.contains(noteId);

  Future<void> unlockItem(String itemId) async {
    _unlockedItemIds.add(itemId);
    notifyListeners();
    await _saveService.saveUnlockedItems(_currentCaseNumber, _unlockedItemIds);
  }

  bool isItemUnlocked(String itemId) => _unlockedItemIds.contains(itemId);

  Future<void> restoreItem(String itemId) async {
    _restoredItemIds.add(itemId);
    notifyListeners();
    await _saveService.saveRestoredItems(_currentCaseNumber, _restoredItemIds);
  }

  bool isItemRestored(String itemId) => _restoredItemIds.contains(itemId);

  // ============ STEP HINTS ============

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
        break;
      }
    }
  }

  void startTimedEvents() {
    if (_timedEventsStarted) return;
    _timedEventsStarted = true;

    for (final event in currentCase.suspenseEvents) {
      if (_firedSuspenseEvents.contains(event.id)) continue;
      if (event.trigger == SuspenseTrigger.afterTime) {
        _firedSuspenseEvents.add(event.id);
        Future.delayed(Duration(seconds: event.delaySeconds), () {
          if (_pendingSuspenseEvent == null) {
            _pendingSuspenseEvent = event;
            notifyListeners();
          }
        });
      }
    }
  }

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
        break;
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

  // ============ RESET ============

  Future<void> resetCurrentCase() async {
    _batteryTimer?.cancel();
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
    _timelineCompleted = false;
    _pendingSuspenseEvent = null;
    _timedEventsStarted = false;
    await _saveService.saveCaseStartTime(_currentCaseNumber, _caseStartTime!);
    _initBattery();
    notifyListeners();
  }

  Future<void> resetAllProgress() async {
    _batteryTimer?.cancel();
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
    _timelineCompleted = false;
    _pendingSuspenseEvent = null;
    _batteryPercent = 100.0;
    notifyListeners();
  }

  // ============ PER-CASE PROGRESS HELPERS ============

  int getClueCountForCase(int caseNumber) {
    if (caseNumber == _currentCaseNumber) return _currentClues.length;
    return _saveService.getClues(caseNumber).length;
  }

  bool hasSavedProgressForCase(int caseNumber) {
    return _saveService.getClues(caseNumber).isNotEmpty ||
        _saveService.getSuspects(caseNumber).isNotEmpty;
  }
}
