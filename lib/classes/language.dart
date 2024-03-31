class Language {
  final int id;
  final String name;
  final String code;

  Language({required this.id, required this.name, required this.code});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  static List<Language> languagesList() {
    return <Language>[
      Language(id: 1, name: "English", code: "en"),
      Language(id: 2, name: "हिन्दी", code: "hi"),
      Language(id: 3, name: "मराठी", code: "mr"),
      Language(id: 4, name: "ગુજરાતી", code: "gu"),
      Language(id: 5, name: "தமிழ்", code: "ta"),
      Language(id: 6, name: "తెలుగు", code: "te"),
    ];
  }
}
