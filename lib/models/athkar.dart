// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Athkar {
  String name;
  String description;

  Athkar({required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
    };
  }

  factory Athkar.fromMap(Map<String, dynamic> map) {
    return Athkar(
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Athkar.fromJson(String source) =>
      Athkar.fromMap(json.decode(source) as Map<String, dynamic>);
}
