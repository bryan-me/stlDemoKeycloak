// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormDataModelAdapter extends TypeAdapter<FormDataModel> {
  @override
  final int typeId = 0;

  @override
  FormDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormDataModel(
      radioGroupValues: (fields[0] as Map).cast<String, dynamic>(),
      checkboxGroupValues: (fields[1] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<String, bool>())),
      longitude: fields[2] as String,
      latitude: fields[3] as String,
      imagePaths: (fields[4] as List).cast<String?>(),
      signaturePaths: (fields[5] as List).cast<String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, FormDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.radioGroupValues)
      ..writeByte(1)
      ..write(obj.checkboxGroupValues)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.imagePaths)
      ..writeByte(5)
      ..write(obj.signaturePaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
