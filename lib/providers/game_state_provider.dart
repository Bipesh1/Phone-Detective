// Phone Detective - Game State Provider

import 'package:flutter/foundation.dart';

import '../services/save_service.dart';
import '../services/supabase_service.dart';
import '../data/cases/all_cases.dart';

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
  bool _isInitialized = false;
  bool _isRemote = false;

  // Getters
  List<CaseData> get cases => _allCases;
  int get currentCaseNumber => _currentCaseNumber;
  Set<int> get solvedCases => _solvedCases;
  List<Clue> get currentClues => _currentClues;
  Set<String> get currentSuspects => _currentSuspects;
  String get playerNotes => _playerNotes;
  DateTime? get caseStartTime => _caseStartTime;
  Set<String> get unlockedNotes => _unlockedNotes;
  bool get isInitialized => _isInitialized;
  bool get isRemote => _isRemote;
  bool get hasSaveData => _saveService.hasSaveData();

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
        _allCases = remoteCases;
        _isRemote = true;
      } else {
        // Remote returned empty list (valid connection, just no cases)
        print('Remote DB connected but empty. No cases loaded.');
        _allCases = [];
        _isRemote = true;
      }

      // Sort by case number
      _allCases.sort((a, b) => a.caseNumber.compareTo(b.caseNumber));

      // If we have cases and current case is invalid, reset to first
      if (_allCases.isNotEmpty &&
          _allCases.every((c) => c.caseNumber != _currentCaseNumber)) {
        _currentCaseNumber = _allCases.first.caseNumber;
      } else if (_allCases.isEmpty) {
        _currentCaseNumber = 0; // No cases available
      }
    } catch (e) {
      print('Failed to load remote cases: $e');
      // Fallback to static cases if remote fails
      if (_allCases.isEmpty) {
        _allCases = [...allCases];
        _isRemote = false;
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
    }
  }

  // Case Management
  Future<void> startCase(int caseNumber) async {
    _currentCaseNumber = caseNumber;
    _currentClues = _saveService.getClues(caseNumber);
    _currentSuspects = _saveService.getSuspects(caseNumber);
    _playerNotes = _saveService.getPlayerNotes(caseNumber);
    _unlockedNotes = _saveService.getUnlockedNotes(caseNumber);

    // Set start time if not already set
    _caseStartTime = _saveService.getCaseStartTime(caseNumber);
    if (_caseStartTime == null) {
      _caseStartTime = DateTime.now();
      await _saveService.saveCaseStartTime(caseNumber, _caseStartTime!);
    }

    await _saveService.saveCurrentCase(caseNumber);
    checkTutorial();
    notifyListeners();
  }

  Future<void> solveCase() async {
    _solvedCases.add(_currentCaseNumber);
    await _saveService.markCaseSolved(_currentCaseNumber);
    notifyListeners();
  }

  bool isCaseSolved(int caseNumber) => _solvedCases.contains(caseNumber);

  bool isCaseUnlocked(int caseNumber) {
    if (caseNumber == 1) return true;

    // Case unlock logic from constants
    final requirements = {
      2: [1],
      3: [1],
      4: [3],
      5: [3],
      6: [3],
      7: [6],
      8: [6],
      9: [6],
      10: [1, 2, 3, 4, 5, 6, 7, 8, 9],
    };

    final required = requirements[caseNumber] ?? [];
    return required.every((req) {
      // If the case is already solved, requirement met
      if (_solvedCases.contains(req)) return true;

      // If the required case does NOT exist in our loaded cases,
      // treat it as "skipped" (unlocking this requirement) because we can't play it.
      final requiredCaseExists = _allCases.any((c) => c.caseNumber == req);
      if (!requiredCaseExists) return true;

      // Otherwise, the case exists but isn't solved yet -> locked
      return false;
    });
  }

  // Clue Management
  Future<void> addClue(Clue clue) async {
    if (_currentClues.any((c) => c.sourceId == clue.sourceId)) return;

    _currentClues.add(clue);
    await _saveService.saveClues(_currentCaseNumber, _currentClues);
    notifyListeners();
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
    await _saveService.saveUnlockedNotes(_currentCaseNumber, _unlockedNotes);
    notifyListeners();
  }

  bool isNoteUnlocked(String noteId) => _unlockedNotes.contains(noteId);

  // Reset
  Future<void> resetCurrentCase() async {
    await _saveService.resetCase(_currentCaseNumber);
    _currentClues = [];
    _currentSuspects = {};
    _playerNotes = '';
    _caseStartTime = DateTime.now();
    _unlockedNotes = {};
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
    _tutorialStep = 0; // Ensure tutorial step is reset
    notifyListeners();
  }

  // Tutorial Management
  int get tutorialStep => _tutorialStep;
  bool get isTutorialActive => _tutorialStep > 0;

  void checkTutorial() {
    // Start tutorial if Case 1 and not completed
    if (_currentCaseNumber == 1 &&
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
    _tutorialStep++;
    notifyListeners();
  }

  Future<void> endTutorial() async {
    _tutorialStep = 0;
    await _saveService.saveTutorialCompleted(true);
    notifyListeners();
  }
}
