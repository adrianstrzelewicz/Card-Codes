
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardCode {
  String id;
  String name;
  Color foreground;
  Color background;
  String code;

  CardCode({this.id, this.name = 'No Name', this.foreground = Colors.black54, this.background = Colors.white, this.code = '0'});

  CardCode copyWith ({String id, String name, Color foreground, Color background, String code}) {
    return CardCode(
      id: id ?? this.id,
      name: name ?? this.name,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      code: code ?? this.code
    );
  }

  CardCode.fromDataSnapshot(DocumentSnapshot dataSnapshot)
      : id = dataSnapshot.id,
        name = dataSnapshot.data()['name'],
        foreground = Color(dataSnapshot.data()['foreground']),
        background = Color(dataSnapshot.data()['background']),
        code = dataSnapshot.data()['code'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'foreground': foreground.value,
        'background': background.value,
        'code': code,
      };
}