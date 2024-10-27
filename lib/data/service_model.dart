class ServiceModel {
  final String serviceCode;
  final String serviceName;
  final String serviceIcon;
  final int serviceTariff;

  ServiceModel({
    required this.serviceCode,
    required this.serviceName,
    required this.serviceIcon,
    required this.serviceTariff,
  });

  // Factory constructor to create a ServiceModel from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceCode: json['service_code'],
      serviceName: json['service_name'],
      serviceIcon: json['service_icon'],
      serviceTariff: json['service_tariff'],
    );
  }

  // Parse a list of services from JSON
  static List<ServiceModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ServiceModel.fromJson(json)).toList();
  }
}