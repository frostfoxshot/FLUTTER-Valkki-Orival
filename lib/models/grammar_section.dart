class GrammarBlock {
  final String summary;
  final bool open;
  final String content;

  GrammarBlock({required this.summary, required this.open, required this.content});

  factory GrammarBlock.fromJson(Map<String, dynamic> json) => GrammarBlock(
    summary: json['summary'],
    open: json['open'] ?? false,
    content: json['content'],
  );
}

class GrammarSection {
  final String title;
  final List<GrammarBlock> blocks;

  GrammarSection({required this.title, required this.blocks});

  factory GrammarSection.fromJson(Map<String, dynamic> json) => GrammarSection(
    title: json['title'],
    blocks: (json['blocks'] as List)
        .map((b) => GrammarBlock.fromJson(b))
        .toList(),
  );
}