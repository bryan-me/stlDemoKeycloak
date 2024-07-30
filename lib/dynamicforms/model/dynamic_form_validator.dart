class DynamicFormValidator {
  String message;
  bool Function(String) validate;

  DynamicFormValidator(this.message, this.validate);

  factory DynamicFormValidator.fromJson(Map<String, dynamic> json) {
    return DynamicFormValidator(
      json['message'],
      (value) => value.isNotEmpty, 
    );
  }
}