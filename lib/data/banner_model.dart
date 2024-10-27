class BannerModel {
  final String bannerName;
  final String bannerImage;
  final String description;

  BannerModel({
    required this.bannerName,
    required this.bannerImage,
    required this.description,
  });

  // Factory constructor to create a BannerModel from JSON
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      bannerName: json['banner_name'],
      bannerImage: json['banner_image'],
      description: json['description'],
    );
  }

  // Parse a list of banner items from JSON
  static List<BannerModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BannerModel.fromJson(json)).toList();
  }
}