// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Student {
  String name;
  String id;
  String attendance;
  String? major;

  Student(
      {required this.name,
      required this.id,
      required this.attendance,
      this.major});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'attendence': attendance,
      'major': major,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'] as String,
      id: map['id'] as String,
      attendance: map['attendence'] as String,
      major: map['major'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);

  Student copyWith({
    String? name,
    String? id,
    String? attendance,
    String? major,
  }) {
    return Student(
      name: name ?? this.name,
      id: id ?? this.id,
      attendance: attendance ?? this.attendance,
      major: major ?? this.major,
    );
  }
}
