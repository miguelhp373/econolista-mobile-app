class PurchasedModels {
  String purchasedID;
  String description;
  DateTime dateTimeCreated;
  List<Map> productsList;
  String marketName;
  String situationFlag;
  bool futurePuchased;

  PurchasedModels({
    required this.purchasedID,
    required this.description,
    required this.dateTimeCreated,
    required this.productsList,
    required this.marketName,
    required this.situationFlag,
    required this.futurePuchased,
  });

  factory PurchasedModels.fromJson(Map<String, dynamic> json) {
    return PurchasedModels(
      purchasedID: json['purchasedID'],
      description: json['description'],
      dateTimeCreated: json['dateTimeCreated'],
      productsList: json['productsList'],
      marketName: json['marketName'],
      situationFlag: json['situationFlag'],
      futurePuchased: json['futurePuchased'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchasedID': purchasedID,
      'description': description,
      'dateTimeCreated': dateTimeCreated,
      'productsList': productsList,
      'marketName': marketName,
      'situationFlag': situationFlag,
      'futurePuchased': futurePuchased,
    };
  }
}
