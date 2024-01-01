import 'package:http/http.dart' as http;
import 'dart:convert';

class SuggestionService {
  final String _baseUrl =
      'https://europe-central2-bastirchef-3aeef.cloudfunctions.net/makeSuggestion';

  Future<List<dynamic>> makeSuggestion(String userId) async {
    final uri = Uri.parse('$_baseUrl?userId=$userId');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        List<dynamic> recipeSuggestions = jsonResponse['suggestedRecipes'];
        return recipeSuggestions;
      } else {
        print('Failed to load suggestions: ${response.body}');
      }
    } catch (e) {
      print('Caught error: $e');
    }
    return [];
  }
}
