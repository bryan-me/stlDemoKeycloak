class ItemModel {
  String value;
  String display;

  ItemModel(this.value, this.display);

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      json['value'],
      json['display'],
    );
  }
}