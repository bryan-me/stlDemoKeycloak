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

class ApiResponse {
  final int statusCode;
  final String message;
  final FormData data;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: FormData.fromJson(json['data']),
    );
  }
}

class FormData {
  final String id;
  final String name;
  final int version;
  final List<FormDetails> formDetails;

  FormData({
    required this.id,
    required this.name,
    required this.version,
    required this.formDetails,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    var list = json['formDetails'] as List;
    List<FormDetails> formDetailsList = list.map((i) => FormDetails.fromJson(i)).toList();

    return FormData(
      id: json['id'],
      name: json['name'],
      version: json['version'],
      formDetails: formDetailsList,
    );
  }
}

class FormDetails {
  final String id;
  final int index;
  final String fieldLabel;
  final Map<String, dynamic> fieldOptions;
  final bool isRequired;
  final String defaultValue;
  final String placeholder;
  final String fieldType;
  final String constraints;
  final String key;
  final String createdBy;
  final String createdAt;
  final String updatedBy;
  final String updatedAt;

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
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  factory FormDetails.fromJson(Map<String, dynamic> json) {
    return FormDetails(
      id: json['id'],
      index: json['index'],
      fieldLabel: json['fieldLabel'],
      fieldOptions: json['fieldOptions'],
      isRequired: json['isRequired'],
      defaultValue: json['defaultValue'],
      placeholder: json['placeholder'],
      fieldType: json['fieldType'],
      constraints: json['constraints'],
      key: json['key'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      updatedBy: json['updatedBy'],
      updatedAt: json['updatedAt'],
    );
  }
}