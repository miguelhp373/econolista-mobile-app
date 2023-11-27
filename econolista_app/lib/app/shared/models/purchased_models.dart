class PurchasedModels {
  String purchasedId;
  String userEmail;
  String description;
  DateTime dateTimeCreated;
  List<Map> productsList;
  String marketName;
  String status;
  bool futurePuchased;

  PurchasedModels({
    this.purchasedId = '',
    this.userEmail = '',
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
      userEmail: json['userEmail'],
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
      'userEmail': userEmail,
      'description': description,
      'dateTimeCreated': dateTimeCreated,
      'productsList': productsList,
      'marketName': marketName,
      'situationFlag': status,
      'futurePuchased': futurePuchased,
    };
  }
}
