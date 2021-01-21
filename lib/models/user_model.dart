import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel chatModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  UserModel({
    this.email,
    this.password,
    this.name,
    this.birthDate,
    this.address,
    this.contactNumber,
    this.imageUrl,
  });

  final String email;
  final String password;
  final String name;
  final DateTime birthDate;
  final String address;
  final int contactNumber;
  final String imageUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'] == null ? null : json['email'],
        password: json['password'] == null ? null : json['password'],
        name: json['name'] == null ? null : json['name'],
        birthDate: json['birthDate'] == null ? null : json['birthDate'],
        address: json['address'] == null ? null : json['address'],
        contactNumber:
            json['contactNumber'] == null ? null : json['contactNumber'],
        imageUrl: json['imageUrl'] == null ? null : json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'email': email == null ? null : email,
        'password': password == null ? null : password,
        'name': name == null ? null : name,
        'birthDate': birthDate == null ? null : birthDate,
        'address': address == null ? null : address,
        'contactNumber': contactNumber == null ? null : contactNumber,
        'imageUrl': imageUrl == null ? null : imageUrl,
      };
}
