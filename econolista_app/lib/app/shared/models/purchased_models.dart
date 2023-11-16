class PurchasedModels {
  String purchasedId;
  String userId;
  String description;
  DateTime dateTimeCreated;
  List<Map> productsList;
  String marketName;
  String status;
  bool futurePuchased;

  PurchasedModels({
    this.purchasedId = '',
    this.userId = '',
    this.description = '',
    required this.dateTimeCreated,
    required this.productsList,
    this.marketName = '',
    this.status = 'Aberta',
    this.futurePuchased = false,
  });

  factory PurchasedModels.fromJson(Map<String, dynamic> json) {
    return PurchasedModels(
      purchasedId: json['purchasedID'],
      userId: json['userId'],
      description: json['description'],
      dateTimeCreated: json['dateTimeCreated'],
      productsList: json['productsList'],
      marketName: json['marketName'],
      status: json['situationFlag'],
      futurePuchased: json['futurePuchased'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchasedID': purchasedId,
      'userId': userId,
      'description': description,
      'dateTimeCreated': dateTimeCreated,
      'productsList': productsList,
      'marketName': marketName,
      'situationFlag': status,
      'futurePuchased': futurePuchased,
    };
  }
}
