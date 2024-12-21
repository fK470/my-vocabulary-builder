import 'package:my_vocabulary_builder/utils/audio_utils.dart';

class Word {
  final String word;
  final String definition;
  final String? phonetic;
  final String? audioUrl;

  Word(
      {required this.word,
      required this.definition,
      this.phonetic,
      this.audioUrl});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] ?? '',
      definition: json['meanings'][0]['definitions'][0]['definition'] ?? '',
      phonetic: getAudio(json['phonetics'])?['phonetic'],
      audioUrl: getAudio(json['phonetics'])?['audioUrl'],
    );
  }
}
