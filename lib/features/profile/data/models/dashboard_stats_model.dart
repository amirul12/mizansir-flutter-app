// To parse this JSON data, do
//
//     final dashboardStatsModel = dashboardStatsModelFromJson(jsonString);

import 'dart:convert';

DashboardStatsModel dashboardStatsModelFromJson(String str) => DashboardStatsModel.fromJson(json.decode(str));

String dashboardStatsModelToJson(DashboardStatsModel data) => json.encode(data.toJson());

class DashboardStatsModel {
    final User? user;
    final EnrollmentStats? enrollmentStats;
    final List<RecentEnrollment>? recentEnrollments;
    final List<dynamic>? expiringSoon;
    final Notifications? notifications;

    DashboardStatsModel({
        this.user,
        this.enrollmentStats,
        this.recentEnrollments,
        this.expiringSoon,
        this.notifications,
    });

    factory DashboardStatsModel.fromJson(Map<String, dynamic> json) => DashboardStatsModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        enrollmentStats: json["enrollment_stats"] == null ? null : EnrollmentStats.fromJson(json["enrollment_stats"]),
        recentEnrollments: json["recent_enrollments"] == null ? [] : List<RecentEnrollment>.from(json["recent_enrollments"]!.map((x) => RecentEnrollment.fromJson(x))),
        expiringSoon: json["expiring_soon"] == null ? [] : List<dynamic>.from(json["expiring_soon"]!.map((x) => x)),
        notifications: json["notifications"] == null ? null : Notifications.fromJson(json["notifications"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "enrollment_stats": enrollmentStats?.toJson(),
        "recent_enrollments": recentEnrollments == null ? [] : List<dynamic>.from(recentEnrollments!.map((x) => x.toJson())),
        "expiring_soon": expiringSoon == null ? [] : List<dynamic>.from(expiringSoon!.map((x) => x)),
        "notifications": notifications?.toJson(),
    };
}

class EnrollmentStats {
    final int? total;
    final int? active;
    final int? pending;
    final int? expired;

    EnrollmentStats({
        this.total,
        this.active,
        this.pending,
        this.expired,
    });

    factory EnrollmentStats.fromJson(Map<String, dynamic> json) => EnrollmentStats(
        total: json["total"],
        active: json["active"],
        pending: json["pending"],
        expired: json["expired"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "active": active,
        "pending": pending,
        "expired": expired,
    };
}

class Notifications {
    final int? pendingApprovals;
    final int? expiringCourses;

    Notifications({
        this.pendingApprovals,
        this.expiringCourses,
    });

    factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        pendingApprovals: json["pending_approvals"],
        expiringCourses: json["expiring_courses"],
    );

    Map<String, dynamic> toJson() => {
        "pending_approvals": pendingApprovals,
        "expiring_courses": expiringCourses,
    };
}

class RecentEnrollment {
    final int? id;
    final String? courseTitle;
    final String? status;
    final DateTime? enrolledAt;
    final DateTime? expiresAt;
    final bool? isActive;

    RecentEnrollment({
        this.id,
        this.courseTitle,
        this.status,
        this.enrolledAt,
        this.expiresAt,
        this.isActive,
    });

    factory RecentEnrollment.fromJson(Map<String, dynamic> json) => RecentEnrollment(
        id: json["id"],
        courseTitle: json["course_title"],
        status: json["status"],
        enrolledAt: json["enrolled_at"] == null ? null : DateTime.parse(json["enrolled_at"]),
        expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "course_title": courseTitle,
        "status": status,
        "enrolled_at": enrolledAt?.toIso8601String(),
        "expires_at": expiresAt?.toIso8601String(),
        "is_active": isActive,
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
    final dynamic address;
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
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        collegeName: json["college_name"],
        address: json["address"],
        userClass: json["class"],
        session: json["session"],
        avatarUrl: json["avatar_url"],
        version: json["version"] == null ? null : Version.fromJson(json["version"]),
        hscBatch: json["hsc_batch"] == null ? null : HscBatch.fromJson(json["hsc_batch"]),
        batchTime: json["batch_time"] == null ? null : BatchTime.fromJson(json["batch_time"]),
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

    BatchTime({
        this.id,
        this.name,
        this.time,
    });

    factory BatchTime.fromJson(Map<String, dynamic> json) => BatchTime(
        id: json["id"],
        name: json["name"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "time": time,
    };
}

class HscBatch {
    final int? id;
    final String? name;
    final int? year;

    HscBatch({
        this.id,
        this.name,
        this.year,
    });

    factory HscBatch.fromJson(Map<String, dynamic> json) => HscBatch(
        id: json["id"],
        name: json["name"],
        year: json["year"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "year": year,
    };
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

    Version({
        this.id,
        this.name,
    });

    factory Version.fromJson(Map<String, dynamic> json) => Version(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
