class LanguageInfo {
  final String version;
  final String lastUpdated;
  final String author;
  final List<String> months;
  final bool maintenance;
  final String maintenanceMessage;

  LanguageInfo({
    required this.version,
    required this.lastUpdated,
    required this.author,
    required this.months,
    required this.maintenance,
    required this.maintenanceMessage,
  });

  factory LanguageInfo.fromJson(Map<String, dynamic> json) => LanguageInfo(
    version: json['version'],
    lastUpdated: json['lastUpdated'],
    author: json['author'],
    months: List<String>.from(json['months']),
    maintenance: json['maintenance'] ?? false,
    maintenanceMessage: json['maintenanceMessage'] ?? '',
  );
}