import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayerを宣言

  Future<void> playAudio(String? url) async {
    final file = await _getLocalFile(url!);

    if (await file.exists()) {
      // キャッシュが存在する場合、キャッシュから再生
      await _audioPlayer
          .setSourceDeviceFile(file.path); // AudioPlayerにファイルパスを設定
    } else {
      // キャッシュが存在しない場合、ダウンロードして再生
      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
      await _audioPlayer
          .setSourceDeviceFile(file.path); // AudioPlayerにファイルパスを設定
    }

    _audioPlayer.resume(); // 再生開始
  }

  Future<File> _getLocalFile(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = url.split('/').last;
    return File('${directory.path}/$fileName');
  }
}
