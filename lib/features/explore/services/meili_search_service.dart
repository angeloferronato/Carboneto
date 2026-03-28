import 'dart:convert';
import 'package:http/http.dart' as http;

class MeiliSearchService {
  static const String _host = 'http://140.238.186.227:7700';
  static const String _apiKey =
      '5ced382a622cea321102f9d26f3f5f630d8ef48d2f6e145d98e58619fb264cf4';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_apiKey',
  };

  static Future<List<Map<String, dynamic>>> search({
    required String index,
    required String query,
    int limit = 20,
    List<String>? filterCategories,
  }) async {
    try {
      final body = <String, dynamic>{
        'q': query,
        'limit': limit,
      };

      if (filterCategories != null && filterCategories.isNotEmpty) {
        body['filter'] =
            filterCategories.map((c) => 'Categories = "$c"').join(' OR ');
      }

      final response = await http.post(
        Uri.parse('$_host/indexes/$index/search'),
        headers: _headers,
        body: jsonEncode(body),
      );

      // Log non-200 so filter errors are visible during development
      if (response.statusCode != 200) {
        print('MEILI [$index] HTTP ${response.statusCode}: ${response.body}');
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final rawHits = data['hits'];
      if (rawHits == null) return [];

      final result = <Map<String, dynamic>>[];
      for (final rawHit in rawHits as List) {
        try {
          final hit = Map<String, dynamic>.from(rawHit as Map);
          final normalized = <String, dynamic>{};
          for (final entry in hit.entries) {
            final key = entry.key.toLowerCase();
            final value = entry.value;
            if (value is Map) {
              final nestedNormalized = <String, dynamic>{};
              for (final nestedEntry in value.entries) {
                nestedNormalized[nestedEntry.key.toString().toLowerCase()] =
                    nestedEntry.value;
              }
              normalized[key] = nestedNormalized;
            } else {
              normalized[key] = value;
            }
          }
          result.add(normalized);
        } catch (e) {
          print('NORMALIZATION ERROR: $e');
        }
      }
      return result;
    } catch (e, stack) {
      print('MEILI ERROR: $e');
      print('MEILI STACK: $stack');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> searchTrainings({
    required String query,
    int limit = 20,
    List<String>? categories,
  }) =>
      search(
        index: 'allTrainings',
        query: query,
        limit: limit,
        filterCategories: categories,
      );

  static Future<List<Map<String, dynamic>>> searchUsers({
    required String query,
    int limit = 20,
  }) =>
      search(index: 'users', query: query, limit: limit);

  static Future<List<Map<String, dynamic>>> searchExercises({
    required String query,
    int limit = 20,
    List<String>? categories,
  }) =>
      search(
        index: 'allExercises',
        query: query,
        limit: limit,
        filterCategories: categories,
      );
}