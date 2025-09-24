class DriversResponse {
  DriversResponse({required this.success, required this.message, required this.data, required this.timestamp});

  factory DriversResponse.fromJson(Map<String, dynamic> json) {
    return DriversResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)?.map((user) => Driver.fromJson(user as Map<String, dynamic>)).toList() ?? [],
      timestamp: json['timestamp'] ?? 0,
    );
  }

  bool success;
  String message;
  List<Driver> data;
  int timestamp;

  DriversResponse copyWith({bool? success, String? message, List<Driver>? data, int? timestamp}) =>
      DriversResponse(success: success ?? this.success, message: message ?? this.message, data: data ?? this.data, timestamp: timestamp ?? this.timestamp);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['data'] = data.map((v) => v.toJson()).toList();
    map['timestamp'] = timestamp;
    return map;
  }
}

class Driver {
  Driver({this.id, this.fullName, this.licenseNumber, this.phone, this.email, this.active, this.createdAt, this.updatedAt});

  Driver.fromJson(dynamic json) {
    id = json['id'];
    fullName = json['fullName'];
    licenseNumber = json['licenseNumber'];
    phone = json['phone'];
    email = json['email'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  int? id;
  String? fullName;
  String? licenseNumber;
  String? phone;
  String? email;
  bool? active;
  String? createdAt;
  String? updatedAt;

  Driver copyWith({int? id, String? fullName, String? licenseNumber, String? phone, String? email, bool? active, String? createdAt, String? updatedAt}) => Driver(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    licenseNumber: licenseNumber ?? this.licenseNumber,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['fullName'] = fullName;
    map['licenseNumber'] = licenseNumber;
    map['phone'] = phone;
    map['email'] = email;
    map['active'] = active;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}
