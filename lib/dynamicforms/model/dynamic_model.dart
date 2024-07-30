import 'package:oauth2_test/dynamicforms/model/dynamic_form_validator.dart';
import 'package:oauth2_test/dynamicforms/model/item_model.dart';

enum FormType {
  Text,
  Multiline,
  Dropdown,
  AutoComplete,
  RTE,
  DatePicker
}

class DynamicModel {
  String controlName;
  FormType formType;
  String value;
  List<ItemModel> items;
  ItemModel? selectedItem;
  bool isRequired;
  List<DynamicFormValidator> validators;

  DynamicModel(
    this.controlName,
    this.formType, {
    this.value = '',
    this.items = const [],
    this.selectedItem,
    this.isRequired = false,
    this.validators = const [],
  });

  factory DynamicModel.fromJson(Map<String, dynamic> json) {
    return DynamicModel(
      json['controlName'],
      FormType.values[json['formType']],
      value: json['value'] ?? '',
      items: (json['items'] as List)
          .map((item) => ItemModel.fromJson(item))
          .toList(),
      selectedItem: json['selectedItem'] != null
          ? ItemModel.fromJson(json['selectedItem'])
          : null,
      isRequired: json['isRequired'] ?? false,
      validators: (json['validators'] as List)
          .map((validator) => DynamicFormValidator.fromJson(validator))
          .toList(),
    );
  }
}