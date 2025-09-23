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
