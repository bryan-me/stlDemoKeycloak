import 'package:hive/hive.dart';

part 'form_data_model.g.dart';

@HiveType(typeId: 0)
class FormDataModel extends HiveObject {
  @HiveField(0)
  Map<String, dynamic> radioGroupValues;

  @HiveField(1)
  Map<String, Map<String, bool>> checkboxGroupValues;

  @HiveField(2)
  String longitude;

  @HiveField(3)
  String latitude;

  @HiveField(4)
  List<String?> imagePaths;

  @HiveField(5)
  List<String?> signaturePaths;

  FormDataModel({
    required this.radioGroupValues,
    required this.checkboxGroupValues,
    required this.longitude,
    required this.latitude,
    required this.imagePaths,
    required this.signaturePaths,
  });
}
