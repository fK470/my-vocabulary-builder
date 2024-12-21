/// Retrieves the first available audio URL and its corresponding phonetic text from a list of phonetics.
///
/// Iterates through the provided list of phonetics and returns a map containing the first non-null and non-empty
/// audio URL along with its associated phonetic text. If no valid audio URL is found, returns null.
///
/// The returned map contains the following keys:
/// - 'phonetic': The phonetic text associated with the audio URL.
/// - 'audioUrl': The URL of the audio file.
///
/// Free Dictionary APIにおけるbelowのようなケースに対応するため。
///
/// [phonetics]: A list of phonetic objects, each containing 'text' and 'audio' keys.
///
/// Returns a map with 'phonetic' and 'audioUrl' if a valid audio URL is found, otherwise null.
Map<String, String>? getAudio(List<dynamic> phonetics) {
  for (var item in phonetics) {
    final phonetic = item['text'];
    final audioUrl = item['audio'];

    if (audioUrl != null && audioUrl.isNotEmpty) {
      return {
        'phonetic': phonetic,
        'audioUrl': audioUrl,
      };
    }
  }
  return null;
}
