import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_vocabulary_builder/models/word.dart';

class DictionaryService {
  Future<Word?> searchWord(String word) async {
    final url =
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Word.fromJson(jsonData[0]);
    } else {
      throw Exception('Failed to load word');
    }
  }
}
