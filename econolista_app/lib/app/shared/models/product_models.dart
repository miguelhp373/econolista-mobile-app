import 'dart:convert';

class ProductModels {
  String productId;
  String productName;
  String productDescription;
  String productBarcode;
  double productPrice;
  int productQuantity;
  String productPhotoUrl;

  ProductModels({
    this.productId = '',
    this.productName = '',
    this.productDescription = '',
    this.productBarcode = '',
    this.productPrice = 0.0,
    this.productQuantity = 0,
    this.productPhotoUrl = '',
  });

  ProductModels copyWith({
    String? productId,
    String? productName,
    String? productDescription,
    String? productBarcode,
    double? productPrice,
    int? productQuantity,
    String? productPhotoUrl,
  }) {
    return ProductModels(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      productBarcode: productBarcode ?? this.productBarcode,
      productPrice: productPrice ?? this.productPrice,
      productQuantity: productQuantity ?? this.productQuantity,
      productPhotoUrl: productPhotoUrl ?? this.productPhotoUrl,
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

  factory ProductModels.fromMap(Map<String, dynamic> map) {
    return ProductModels(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productDescription: map['productDescription'] ?? '',
      productBarcode: map['productBarcode'] ?? '',
      productPrice: map['productPrice']?.toDouble() ?? 0.0,
      productQuantity: map['productQuantity']?.toInt() ?? 0,
      productPhotoUrl: map['productPhotoUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModels.fromJson(String source) =>
      ProductModels.fromMap(json.decode(source));

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
