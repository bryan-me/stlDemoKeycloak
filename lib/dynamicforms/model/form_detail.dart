class FormDetail{
  final String id;
  final String label;
  final String inputType;
  final Map<String, dynamic> option;
  final String key;
  final String constraints;

  FormDetail({
    required this.id,
    required this.label,
    required this.inputType,
    required this.option,
    required this.key,
    required this.constraints,
  });

  factory FormDetail.fromJson(Map<String, dynamic> json)
  {
    return FormDetail(
      id: json['id'], 
      label: json['label'], 
      inputType: json['inputType'], 
      option: json['option'], 
      key: json['key'], 
      constraints: json['constraints'],
      );
  }
}