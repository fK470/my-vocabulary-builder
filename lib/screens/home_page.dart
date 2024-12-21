import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_vocabulary_builder/models/word.dart';
import 'package:my_vocabulary_builder/services/audio_service.dart';
import 'package:my_vocabulary_builder/services/dictionary_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final DictionaryService _dictionaryService = DictionaryService();
  final AudioService _audioService = AudioService();

  Word? _word;

  Timer? _debounce;

  Future<void> _searchWord(String word) async {
    try {
      final result = await _dictionaryService.searchWord(word);
      setState(() {
        _word = result;
      });
    } catch (e) {
      setState(() {
        _word = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
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
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                )),
            ElevatedButton(
              onPressed: () {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _searchWord(_searchController.text);
                });
              },
              child: const Text('検索'),
            ),
            const SizedBox(height: 20),
            if (_word != null)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _word!.word,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          // FavoriteService().addFavorite(_word!);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_word!.phonetic != null) ...[
                        Text(
                          _word!.phonetic!,
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () {
                            _audioService.playAudio(_word!.audioUrl);
                          },
                        ),
                      ],
                    ],
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
    );
  }
}
