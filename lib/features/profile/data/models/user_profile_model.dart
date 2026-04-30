// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  final User? user;
  final ProfileCompletion? profileCompletion;

  UserProfileModel({this.user, this.profileCompletion});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        profileCompletion: json["profile_completion"] == null
            ? null
            : ProfileCompletion.fromJson(json["profile_completion"]),
      );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "profile_completion": profileCompletion?.toJson(),
  };
}

class ProfileCompletion {
  final int? percentage;
  final int? completedFields;
  final int? totalFields;
  final List<String>? missingFields;

  ProfileCompletion({
    this.percentage,
    this.completedFields,
    this.totalFields,
    this.missingFields,
  });

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) =>
      ProfileCompletion(
        percentage: json["percentage"],
        completedFields: json["completed_fields"],
        totalFields: json["total_fields"],
        missingFields: json["missing_fields"] == null
            ? []
            : List<String>.from(json["missing_fields"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "percentage": percentage,
    "completed_fields": completedFields,
    "total_fields": totalFields,
    "missing_fields": missingFields == null
        ? []
        : List<dynamic>.from(missingFields!.map((x) => x)),
  };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? collegeName;
  final String? address;
  final String? userClass;
  final dynamic session;
  final dynamic avatarUrl;
  final Version? version;
  final HscBatch? hscBatch;
  final BatchTime? batchTime;
  final bool? isAdmin;
  final bool? isStudent;
  final Stats? stats;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.collegeName,
    this.address,
    this.userClass,
    this.session,
    this.avatarUrl,
    this.version,
    this.hscBatch,
    this.batchTime,
    this.isAdmin,
    this.isStudent,
    this.stats,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    collegeName: json["college_name"],
    address: json["address"],
    userClass: json["class"],
    session: json["session"],
    avatarUrl: json["avatar_url"],
    version: json["version"] == null ? null : Version.fromJson(json["version"]),
    hscBatch: json["hsc_batch"] == null
        ? null
        : HscBatch.fromJson(json["hsc_batch"]),
    batchTime: json["batch_time"] == null
        ? null
        : BatchTime.fromJson(json["batch_time"]),
    isAdmin: json["is_admin"],
    isStudent: json["is_student"],
    stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "role": role,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "college_name": collegeName,
    "address": address,
    "class": userClass,
    "session": session,
    "avatar_url": avatarUrl,
    "version": version?.toJson(),
    "hsc_batch": hscBatch?.toJson(),
    "batch_time": batchTime?.toJson(),
    "is_admin": isAdmin,
    "is_student": isStudent,
    "stats": stats?.toJson(),
  };
}

class BatchTime {
  final int? id;
  final String? name;
  final dynamic time;

  BatchTime({this.id, this.name, this.time});

  factory BatchTime.fromJson(Map<String, dynamic> json) =>
      BatchTime(id: json["id"], name: json["name"], time: json["time"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "time": time};
}

class HscBatch {
  final int? id;
  final String? name;
  final int? year;

  HscBatch({this.id, this.name, this.year});

  factory HscBatch.fromJson(Map<String, dynamic> json) =>
      HscBatch(id: json["id"], name: json["name"], year: json["year"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "year": year};
}

class Stats {
  final int? totalEnrollments;
  final int? activeEnrollments;
  final int? pendingEnrollments;

  Stats({
    this.totalEnrollments,
    this.activeEnrollments,
    this.pendingEnrollments,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    totalEnrollments: json["total_enrollments"],
    activeEnrollments: json["active_enrollments"],
    pendingEnrollments: json["pending_enrollments"],
  );

  Map<String, dynamic> toJson() => {
    "total_enrollments": totalEnrollments,
    "active_enrollments": activeEnrollments,
    "pending_enrollments": pendingEnrollments,
  };
}

class Version {
  final int? id;
  final String? name;

  Version({this.id, this.name});

  factory Version.fromJson(Map<String, dynamic> json) =>
      Version(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
