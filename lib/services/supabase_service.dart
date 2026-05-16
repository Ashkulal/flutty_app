import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/earning_way.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const String tableName = 'earning_ways';

  Future<List<EarningWay>> getAllEarningWays() async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => EarningWay.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch earning ways: $e');
    }
  }

  Future<List<EarningWay>> searchEarningWays(String query) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('is_active', true)
          .or('title.ilike.%$query%,description.ilike.%$query%,category.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => EarningWay.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to search earning ways: $e');
    }
  }

  Future<List<EarningWay>> filterByCategory(String category) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('category', category)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => EarningWay.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to filter by category: $e');
    }
  }

  Future<List<EarningWay>> filterByDifficulty(String difficulty) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('difficulty', difficulty)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => EarningWay.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to filter by difficulty: $e');
    }
  }

  Future<List<EarningWay>> filterByEarningRange(
      double minEarning, double maxEarning) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .gte('estimated_earning', minEarning)
          .lte('estimated_earning', maxEarning)
          .eq('is_active', true)
          .order('estimated_earning', ascending: false);

      return (response as List)
          .map((item) => EarningWay.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to filter by earning range: $e');
    }
  }

  Future<EarningWay?> getEarningWayById(String id) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('id', id)
          .single();

      return EarningWay.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch earning way: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _supabase
          .from(tableName)
          .select('category')
          .eq('is_active', true);

      return (response as List)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
