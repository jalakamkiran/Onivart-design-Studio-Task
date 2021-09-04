import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'applicant_g.dart';

@HiveType(typeId: 0)
class Applicant {
  @HiveField(0)
  String firstname;

  @HiveField(1)
  String lastname;

  @HiveField(2)
  String mobile;

  @HiveField(3)
  String Gender;

  @HiveField(4)
  String address;

  @HiveField(5)
  String image_url;

  @HiveField(6)
  String resume_url;

  Applicant(
      {this.firstname,
      this.lastname,
      this.mobile,
      this.Gender,
      this.address,
      this.image_url,
      this.resume_url});
}
