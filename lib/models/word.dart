class Word {
  final String word;
  final String pos;
  final String meaning;
  final String pron;
  final String ipa;
  final bool nsfw;

  Word({
    required this.word,
    required this.pos,
    required this.meaning,
    required this.pron,
    required this.ipa,
    required this.nsfw,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    word: json['word'],
    pos: json['pos'],
    meaning: json['meaning'],
    pron: json['pron'],
    ipa: json['ipa'],
    nsfw: json['nsfw'] ?? false,
  );
}