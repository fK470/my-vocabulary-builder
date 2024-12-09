import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DictionaryApp());
}

class Word {
  final String word;
  final String definition;

  Word({required this.word, required this.definition});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] ?? '',
      definition: json['meanings'][0]['definitions'][0]['definition'] ?? '',
    );
  }
}

class DictionaryApp extends StatefulWidget {
  const DictionaryApp({super.key});

  @override
  State<DictionaryApp> createState() => _DictionaryAppState();
}

class _DictionaryAppState extends State<DictionaryApp> {
  final _searchController = TextEditingController();
  Word? _word;

  Future<void> _searchWord(String word) async {
    final url =
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _word = Word.fromJson(jsonData[0]);
      });
    } else {
      // エラー処理
      setState(() {
        _word = null;
      });
      throw Exception('Failed to load word');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('辞書アプリ'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '単語を入力',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _searchWord(_searchController.text),
                child: const Text('検索'),
              ),
              const SizedBox(height: 20),
              if (_word != null)
                Column(
                  children: [
                    Text(
                      _word!.word,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _word!.definition,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
