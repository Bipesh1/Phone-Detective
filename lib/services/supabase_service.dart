import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  Future<List<CaseData>> getCases() async {
    try {
      final data = await _client
          .from('cases')
          .select()
          .order(
            'case_number',
            ascending: true,
          ); // returns a List for multiple rows [web:108][web:109]

      final rows = (data as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      final cases = <CaseData>[];
      for (final row in rows) {
        try {
          cases.add(CaseData.fromJson(row));
        } catch (e) {
          debugPrint('Error parsing case ${row['case_number'] ?? 'unknown'}: $e');
        }
      }
      return cases;
    } catch (e) {
      debugPrint('Error fetching cases: $e');
      rethrow;
    }
  }

  Future<bool> checkConnection() async {
    try {
      await _client.from('cases').select('id').limit(1);
      return true;
    } catch (e) {
      debugPrint('Connection check failed: $e');
      return false;
    }
  }
}
