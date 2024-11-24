import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class InvigilatorModel {
  final String id;
  final String email;
  final String name;
  String? image;
  InvigilatorModel({
    required this.id,
    required this.email,
    required this.name,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'image': image,
    };
  }

  factory InvigilatorModel.fromMap(Map<String, dynamic> map) {
    return InvigilatorModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvigilatorModel.fromJson(String source) =>
      InvigilatorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
