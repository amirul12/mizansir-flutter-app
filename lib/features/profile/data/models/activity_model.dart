// To parse this JSON data, do
//
//     final activityModel = activityModelFromJson(jsonString);

import 'dart:convert';

List<ActivityModel> activityModelFromJson(String str) => List<ActivityModel>.from(json.decode(str).map((x) => ActivityModel.fromJson(x)));

String activityModelToJson(List<ActivityModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActivityModel {
    final int? id;
    final String? type;
    final String? action;
    final String? description;
    final String? status;
    final Course? course;
    final DateTime? createdAt;
    final String? humanDate;

    ActivityModel({
        this.id,
        this.type,
        this.action,
        this.description,
        this.status,
        this.course,
        this.createdAt,
        this.humanDate,
    });

    factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: json["id"],
        type: json["type"],
        action: json["action"],
        description: json["description"],
        status: json["status"],
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        humanDate: json["human_date"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "action": action,
        "description": description,
        "status": status,
        "course": course?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "human_date": humanDate,
    };
}

class Course {
    final int? id;
    final String? title;

    Course({
        this.id,
        this.title,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}
