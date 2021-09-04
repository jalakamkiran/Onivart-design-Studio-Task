// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicantAdapter extends TypeAdapter<Applicant> {
  @override
  final int typeId = 0;

  @override
  Applicant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Applicant(
      firstname: fields[0] as String,
      lastname: fields[1] as String,
      mobile: fields[2] as String,
      Gender: fields[3] as String,
      address: fields[4] as String,
      image_url: fields[5] as String,
      resume_url: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Applicant obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.firstname)
      ..writeByte(1)
      ..write(obj.lastname)
      ..writeByte(2)
      ..write(obj.mobile)
      ..writeByte(3)
      ..write(obj.Gender)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.image_url)
      ..writeByte(6)
      ..write(obj.resume_url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
