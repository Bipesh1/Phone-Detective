// Phone Detective - Save Service

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/clue.dart';

class SaveService {
  static const String _keyCurrentCase = 'current_case';
  static const String _keySolvedCases = 'solved_cases';
  static const String _keyClues = 'clues';
  static const String _keySuspects = 'suspects';
  static const String _keyPlayerNotes = 'player_notes';
  static const String _keyCaseStartTime = 'case_start_time';
  static const String _keyUnlockedNotes = 'unlocked_notes';
  static const String _keyRestoredItems = 'restored_items';
  static const String _keyUnlockedItems = 'unlocked_items';
  static const String _keyTutorialCompleted = 'tutorial_completed';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============ CURRENT CASE ============
  Future<void> saveCurrentCase(int caseNumber) async {
    await _prefs?.setInt(_keyCurrentCase, caseNumber);
  }

  int? getCurrentCase() {
    return _prefs?.getInt(_keyCurrentCase);
  }

  // ============ SOLVED CASES ============
  Future<void> saveSolvedCases(Set<int> cases) async {
    await _prefs?.setStringList(
      _keySolvedCases,
      cases.map((c) => c.toString()).toList(),
    );
  }

  Set<int> getSolvedCases() {
    final list = _prefs?.getStringList(_keySolvedCases) ?? [];
    return list.map((s) => int.parse(s)).toSet();
  }

  Future<void> markCaseSolved(int caseNumber) async {
    final solved = getSolvedCases();
    solved.add(caseNumber);
    await saveSolvedCases(solved);
  }

  // ============ CLUES ============
  Future<void> saveClues(int caseNumber, List<Clue> clues) async {
    final json = clues.map((c) => c.toJson()).toList();
    await _prefs?.setString('${_keyClues}_$caseNumber', jsonEncode(json));
  }

  List<Clue> getClues(int caseNumber) {
    final json = _prefs?.getString('${_keyClues}_$caseNumber');
    if (json == null) return [];

    final list = jsonDecode(json) as List;
    return list.map((j) => Clue.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ============ SUSPECTS ============
  Future<void> saveSuspects(int caseNumber, Set<String> suspectIds) async {
    await _prefs?.setStringList(
      '${_keySuspects}_$caseNumber',
      suspectIds.toList(),
    );
  }

  Set<String> getSuspects(int caseNumber) {
    final list = _prefs?.getStringList('${_keySuspects}_$caseNumber') ?? [];
    return list.toSet();
  }

  // ============ PLAYER NOTES ============
  Future<void> savePlayerNotes(int caseNumber, String notes) async {
    await _prefs?.setString('${_keyPlayerNotes}_$caseNumber', notes);
  }

  String getPlayerNotes(int caseNumber) {
    return _prefs?.getString('${_keyPlayerNotes}_$caseNumber') ?? '';
  }

  // ============ CASE START TIME ============
  Future<void> saveCaseStartTime(int caseNumber, DateTime time) async {
    await _prefs?.setString(
      '${_keyCaseStartTime}_$caseNumber',
      time.toIso8601String(),
    );
  }

  DateTime? getCaseStartTime(int caseNumber) {
    final str = _prefs?.getString('${_keyCaseStartTime}_$caseNumber');
    if (str == null) return null;
    return DateTime.parse(str);
  }

  // ============ UNLOCKED NOTES ============
  Future<void> saveUnlockedNotes(int caseNumber, Set<String> noteIds) async {
    await _prefs?.setStringList(
      '${_keyUnlockedNotes}_$caseNumber',
      noteIds.toList(),
    );
  }

  Set<String> getUnlockedNotes(int caseNumber) {
    final list =
        _prefs?.getStringList('${_keyUnlockedNotes}_$caseNumber') ?? [];
    return list.toSet();
  }

  // ============ UNLOCKED & RESTORED ITEMS (New System) ============
  Future<void> saveUnlockedItems(int caseNumber, Set<String> itemIds) async {
    await _prefs?.setStringList(
      '${_keyUnlockedItems}_$caseNumber',
      itemIds.toList(),
    );
  }

  Set<String> getUnlockedItems(int caseNumber) {
    final list =
        _prefs?.getStringList('${_keyUnlockedItems}_$caseNumber') ?? [];
    return list.toSet();
  }

  Future<void> saveRestoredItems(int caseNumber, Set<String> itemIds) async {
    await _prefs?.setStringList(
      '${_keyRestoredItems}_$caseNumber',
      itemIds.toList(),
    );
  }

  Set<String> getRestoredItems(int caseNumber) {
    final list =
        _prefs?.getStringList('${_keyRestoredItems}_$caseNumber') ?? [];
    return list.toSet();
  }

  // ============ RESET ============
  Future<void> resetCase(int caseNumber) async {
    await _prefs?.remove('${_keyClues}_$caseNumber');
    await _prefs?.remove('${_keySuspects}_$caseNumber');
    await _prefs?.remove('${_keyPlayerNotes}_$caseNumber');
    await _prefs?.remove('${_keyCaseStartTime}_$caseNumber');
    await _prefs?.remove('${_keyCaseStartTime}_$caseNumber');
    await _prefs?.remove('${_keyUnlockedNotes}_$caseNumber');
    await _prefs?.remove('${_keyUnlockedItems}_$caseNumber');
    await _prefs?.remove('${_keyRestoredItems}_$caseNumber');
  }

  Future<void> resetAllProgress() async {
    await _prefs?.clear();
  }

  // ============ CHECK SAVE EXISTS ============
  bool hasSaveData() {
    return getCurrentCase() != null;
  }

  // ============ TUTORIAL ============
  Future<void> saveTutorialCompleted(bool completed) async {
    await _prefs?.setBool(_keyTutorialCompleted, completed);
  }

  bool isTutorialCompleted() {
    return _prefs?.getBool(_keyTutorialCompleted) ?? false;
  }
}
