// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SchemeModel {
  String schemeName;
  String schemeDescription;
  String schemeBenefits;
  String schemeLink;
  SchemeModel({
    required this.schemeName,
    required this.schemeDescription,
    required this.schemeBenefits,
    required this.schemeLink,
  });

  SchemeModel copyWith({
    String? schemeName,
    String? schemeDescription,
    String? schemeBenefits,
    String? schemeLink,
  }) {
    return SchemeModel(
      schemeName: schemeName ?? this.schemeName,
      schemeDescription: schemeDescription ?? this.schemeDescription,
      schemeBenefits: schemeBenefits ?? this.schemeBenefits,
      schemeLink: schemeLink ?? this.schemeLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'schemeName': schemeName,
      'schemeDescription': schemeDescription,
      'schemeBenefits': schemeBenefits,
      'schemeLink': schemeLink,
    };
  }

  factory SchemeModel.fromMap(Map<String, dynamic> map) {
    return SchemeModel(
      schemeName: map['schemeName'] as String,
      schemeDescription: map['schemeDescription'] as String,
      schemeBenefits: map['schemeBenefits'] as String,
      schemeLink: map['schemeLink'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeModel.fromJson(String source) =>
      SchemeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SchemeModel(schemeName: $schemeName, schemeDescription: $schemeDescription, schemeBenefits: $schemeBenefits, schemeLink: $schemeLink)';
  }

  @override
  bool operator ==(covariant SchemeModel other) {
    if (identical(this, other)) return true;

    return other.schemeName == schemeName &&
        other.schemeDescription == schemeDescription &&
        other.schemeBenefits == schemeBenefits &&
        other.schemeLink == schemeLink;
  }

  @override
  int get hashCode {
    return schemeName.hashCode ^
        schemeDescription.hashCode ^
        schemeBenefits.hashCode ^
        schemeLink.hashCode;
  }
}
