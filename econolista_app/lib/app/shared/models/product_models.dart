class ProductModels {
  String productId;
  String productName;
  String productDescription;
  String productBarcode;
  double productPrice;
  int productQuantity;
  String productPhotoUrl;
  String apiStatusCode;

  ProductModels({
    this.productId = '',
    this.productName = '',
    this.productDescription = '',
    this.productBarcode = '',
    this.productPrice = 0.0,
    this.productQuantity = 0,
    this.productPhotoUrl = '',
    this.apiStatusCode = '',
  });

  ProductModels copyWith({
    String? productId,
    String? productName,
    String? productDescription,
    String? productBarcode,
    double? productPrice,
    int? productQuantity,
    String? productPhotoUrl,
    String? apiStatusCode,
  }) {
    return ProductModels(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      productBarcode: productBarcode ?? this.productBarcode,
      productPrice: productPrice ?? this.productPrice,
      productQuantity: productQuantity ?? this.productQuantity,
      productPhotoUrl: productPhotoUrl ?? this.productPhotoUrl,
      apiStatusCode: apiStatusCode ?? this.apiStatusCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'productBarcode': productBarcode,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'productPhotoUrl': productPhotoUrl,
    };
  }

  factory ProductModels.fromJson(Map<String, dynamic> json) {
    return ProductModels(
      productId: '',
      productName: json['description'] ?? '',
      productDescription: json['description'] ?? '',
      productPhotoUrl: json['thumbnail'] ?? '',
      productBarcode: json['gtin'].toString(),
      productPrice: json['avg_price'] ?? 0,
      productQuantity: 1,
      apiStatusCode: '200',
    );
  }

  @override
  String toString() {
    return 'ProductModels(productId: $productId, productName: $productName, productDescription: $productDescription, productBarcode: $productBarcode, productPrice: $productPrice, productQuantity: $productQuantity, productPhotoUrl: $productPhotoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModels &&
        other.productId == productId &&
        other.productName == productName &&
        other.productDescription == productDescription &&
        other.productBarcode == productBarcode &&
        other.productPrice == productPrice &&
        other.productQuantity == productQuantity &&
        other.productPhotoUrl == productPhotoUrl;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        productName.hashCode ^
        productDescription.hashCode ^
        productBarcode.hashCode ^
        productPrice.hashCode ^
        productQuantity.hashCode ^
        productPhotoUrl.hashCode;
  }
}
