// class ApiResponse {
//   final int statusCode;
//   final String message;
//   final FormData data;

//   ApiResponse({
//     required this.statusCode,
//     required this.message,
//     required this.data,
//   });

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       statusCode: json['statusCode'],
//       message: json['message'],
//       data: FormData.fromJson(json['data']),
//     );
//   }
// }

// class FormData {
//   final String id;
//   final String name;
//   final int version;
//   final List<FormDetails> formDetails;

//   FormData({
//     required this.id,
//     required this.name,
//     required this.version,
//     required this.formDetails,
//   });

//   factory FormData.fromJson(Map<String, dynamic> json) {
//     var list = json['formDetails'] as List;
//     List<FormDetails> formDetailsList = list.map((i) => FormDetails.fromJson(i)).toList();

//     return FormData(
//       id: json['id'],
//       name: json['name'],
//       version: json['version'],
//       formDetails: formDetailsList,
//     );
//   }
// }

// class FormDetails {
//   final String id;
//   final int index;
//   final String fieldLabel;
//   final Map<String, dynamic> fieldOptions;
//   final bool isRequired;
//   final String defaultValue;
//   final String placeholder;
//   final String fieldType;
//   final String constraints;
//   final String key;
//   final String createdBy;
//   final String createdAt;
//   final String updatedBy;
//   final String updatedAt;

//   FormDetails({
//     required this.id,
//     required this.index,
//     required this.fieldLabel,
//     required this.fieldOptions,
//     required this.isRequired,
//     required this.defaultValue,
//     required this.placeholder,
//     required this.fieldType,
//     required this.constraints,
//     required this.key,
//     required this.createdBy,
//     required this.createdAt,
//     required this.updatedBy,
//     required this.updatedAt,
//   });

//   factory FormDetails.fromJson(Map<String, dynamic> json) {
//     return FormDetails(
//       id: json['id'],
//       index: json['index'],
//       fieldLabel: json['fieldLabel'],
//       fieldOptions: json['fieldOptions'],
//       isRequired: json['isRequired'],
//       defaultValue: json['defaultValue'],
//       placeholder: json['placeholder'],
//       fieldType: json['fieldType'],
//       constraints: json['constraints'],
//       key: json['key'],
//       createdBy: json['createdBy'],
//       createdAt: json['createdAt'],
//       updatedBy: json['updatedBy'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }

// class ApiResponse {
//   final List<FormData> data;

//   ApiResponse({required this.data});

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     List<FormData> formsList = (json['data'] as List).map((i) => FormData.fromJson(i)).toList();
//     return ApiResponse(data: formsList);
//   }
// }
import 'package:oauth2_test/dynamicforms/model/form_model.dart';

// class ApiResponse {
//   List<FormModel> data;

//   ApiResponse({required this.data});

//   factory ApiResponse.fromJson(List<dynamic> json) {
//     return ApiResponse(
//       data: json.map((form) => FormModel.fromJson(form)).toList(),
//     );
//   }

//   List<Map<String, dynamic>> toJson() {
//     return data.map((form) => form.toJson()).toList();
//   }
// }

class ApiResponse {
  final List<FormModel> data;

  ApiResponse({required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: (json['data'] as List)
          .map((form) => FormModel.fromJson(form))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((form) => form.toJson()).toList(),
    };
  }
}

class FormData {
  final String id;
  final String name;
  final int version;
  final List<FormDetails> formDetails;
  final bool? isEnabled;

  FormData({
    required this.id,
    required this.name,
    required this.version,
    required this.formDetails,
    this.isEnabled,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    var list = json['formDetails'] as List;
    List<FormDetails> formDetailsList = list.map((i) => FormDetails.fromJson(i)).toList();

    return FormData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      version: json['version'] ?? 0,
      formDetails: formDetailsList,
      isEnabled: json['isEnabled'],
    );
  }
}

class FormDetails {
  final String id;
  final int index;
  final String fieldLabel;
  final List<Map<String, dynamic>> fieldOptions;
  final bool isRequired;
  final String defaultValue;
  final String placeholder;
  final String fieldType;
  final List<String> constraints;
  final String key;
  final String? createdBy;
  final String? createdAt;
  final String? updatedBy;
  final String? updatedAt;

  FormDetails({
    required this.id,
    required this.index,
    required this.fieldLabel,
    required this.fieldOptions,
    required this.isRequired,
    required this.defaultValue,
    required this.placeholder,
    required this.fieldType,
    required this.constraints,
    required this.key,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  factory FormDetails.fromJson(Map<String, dynamic> json) {
    return FormDetails(
      id: json['id'] ?? '',
      index: json['index'] ?? 0,
      fieldLabel: json['fieldLabel'] ?? '',
      fieldOptions: (json['fieldOptions'] as List).map((e) => e as Map<String, dynamic>).toList(),
      isRequired: json['isRequired'] ?? false,
      defaultValue: json['defaultValue'] ?? '',
      placeholder: json['placeholder'] ?? '',
      fieldType: json['fieldType'] ?? '',
      constraints: List<String>.from(json['constraints'] ?? []),
      key: json['key'] ?? '',
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      updatedBy: json['updatedBy'],
      updatedAt: json['updatedAt'],
    );
  }
}