class ListingModel {
  final String id;
  final String title;
  final String? description;
  final double price;
  final String condition;
  final bool isSold;
  final String categoryName;
  final String sellerName;
  final String sellerId;
  final List<ListingImage> images;
  final String createdAt;

  ListingModel({required this.id, required this.title, required this.description, required this.price, required this.condition, required this.isSold, required this.categoryName, required this.sellerName, required this.sellerId,required this.images, required this.createdAt});

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      condition: json["condition"] ?? "",
      isSold: json["isSold"] ?? false,
      categoryName: json["categoryName"] ?? "",
      sellerName: json["sellerName"] ?? "",
      sellerId: json["sellerId"] ?? "",
      images: (json["images"] as List? ?? []).map((img) => ListingImage.fromJson(img)).toList(),
      createdAt: json["createdAt"] ?? "",
    );
  }

  String? get primaryImageUrl{
    try{
    return images.firstWhere((img) => img.isPrimary).signedUrl;
    }catch(e){
      return null;
    }
  }

}

class ListingImage{
  final String id;
  final String signedUrl;
  final bool isPrimary;
  final int displayOrder;

  ListingImage({required this.id,required this.signedUrl,required this.isPrimary,
  required this.displayOrder});

  factory ListingImage.fromJson(Map<String,dynamic> json){
    return ListingImage(
      id: json["id"] ?? "",
      signedUrl: json["signedUrl"] ?? "",
      isPrimary: json["isPrimary"] ?? false,
      displayOrder: json["displayOrder"] ?? 0,);
  }


}