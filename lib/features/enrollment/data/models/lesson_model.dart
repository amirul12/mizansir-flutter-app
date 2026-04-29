// // To parse this JSON data, do
// //
// //     final lessonModel = lessonModelFromJson(jsonString);

// import 'dart:convert';

// LessonModel lessonModelFromJson(String str) => LessonModel.fromJson(json.decode(str));

// String lessonModelToJson(LessonModel data) => json.encode(data.toJson());

// class LessonModel {
//     final Course? course;
//     final Enrollment? enrollment;
//     final List<Module>? modules;
//     final Progress? progress;
//     final Navigation? navigation;

//     LessonModel({
//         this.course,
//         this.enrollment,
//         this.modules,
//         this.progress,
//         this.navigation,
//     });

//     factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
//         course: json["course"] == null ? null : Course.fromJson(json["course"]),
//         enrollment: json["enrollment"] == null ? null : Enrollment.fromJson(json["enrollment"]),
//         modules: json["modules"] == null ? [] : List<Module>.from(json["modules"]!.map((x) => Module.fromJson(x))),
//         progress: json["progress"] == null ? null : Progress.fromJson(json["progress"]),
//         navigation: json["navigation"] == null ? null : Navigation.fromJson(json["navigation"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "course": course?.toJson(),
//         "enrollment": enrollment?.toJson(),
//         "modules": modules == null ? [] : List<dynamic>.from(modules!.map((x) => x.toJson())),
//         "progress": progress?.toJson(),
//         "navigation": navigation?.toJson(),
//     };
// }

// class Course {
//     final int? id;
//     final String? title;
//     final dynamic thumbnail;

//     Course({
//         this.id,
//         this.title,
//         this.thumbnail,
//     });

//     factory Course.fromJson(Map<String, dynamic> json) => Course(
//         id: json["id"],
//         title: json["title"],
//         thumbnail: json["thumbnail"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "thumbnail": thumbnail,
//     };
// }

// class Enrollment {
//     final int? id;
//     final String? status;
//     final DateTime? enrolledAt;
//     final DateTime? expiresAt;
//     final bool? isActive;

//     Enrollment({
//         this.id,
//         this.status,
//         this.enrolledAt,
//         this.expiresAt,
//         this.isActive,
//     });

//     factory Enrollment.fromJson(Map<String, dynamic> json) => Enrollment(
//         id: json["id"],
//         status: json["status"],
//         enrolledAt: json["enrolled_at"] == null ? null : DateTime.parse(json["enrolled_at"]),
//         expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
//         isActive: json["is_active"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "status": status,
//         "enrolled_at": enrolledAt?.toIso8601String(),
//         "expires_at": expiresAt?.toIso8601String(),
//         "is_active": isActive,
//     };
// }

// class Module {
//     final String? moduleName;
//     final List<Lesson>? lessons;

//     Module({
//         this.moduleName,
//         this.lessons,
//     });

//     factory Module.fromJson(Map<String, dynamic> json) => Module(
//         moduleName: json["module_name"],
//         lessons: json["lessons"] == null ? [] : List<Lesson>.from(json["lessons"]!.map((x) => Lesson.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "module_name": moduleName,
//         "lessons": lessons == null ? [] : List<dynamic>.from(lessons!.map((x) => x.toJson())),
//     };
// }

// class Lesson {
//     final int? id;
//     final String? title;
//     final String? description;
//     final dynamic thumbnail;
//     final String? youtubeEmbedUrl;
//     final String? youtubeVideoId;
//     final int? durationMinutes;
//     final String? moduleName;
//     final bool? isPreview;
//     final bool? isCompleted;
//     final DateTime? completedAt;

//     Lesson({
//         this.id,
//         this.title,
//         this.description,
//         this.thumbnail,
//         this.youtubeEmbedUrl,
//         this.youtubeVideoId,
//         this.durationMinutes,
//         this.moduleName,
//         this.isPreview,
//         this.isCompleted,
//         this.completedAt,
//     });

//     factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
//         id: json["id"],
//         title: json["title"],
//         description: json["description"],
//         thumbnail: json["thumbnail"],
//         youtubeEmbedUrl: json["youtube_embed_url"],
//         youtubeVideoId: json["youtube_video_id"],
//         durationMinutes: json["duration_minutes"],
//         moduleName: json["module_name"],
//         isPreview: json["is_preview"],
//         isCompleted: json["is_completed"],
//         completedAt: json["completed_at"] == null ? null : DateTime.parse(json["completed_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "description": description,
//         "thumbnail": thumbnail,
//         "youtube_embed_url": youtubeEmbedUrl,
//         "youtube_video_id": youtubeVideoId,
//         "duration_minutes": durationMinutes,
//         "module_name": moduleName,
//         "is_preview": isPreview,
//         "is_completed": isCompleted,
//         "completed_at": completedAt?.toIso8601String(),
//     };
// }

// class Navigation {
//     final NextLessonClass? previousLesson;
//     final NextLessonClass? nextLesson;

//     Navigation({
//         this.previousLesson,
//         this.nextLesson,
//     });

//     factory Navigation.fromJson(Map<String, dynamic> json) => Navigation(
//         previousLesson: json["previous_lesson"] == null ? null : NextLessonClass.fromJson(json["previous_lesson"]),
//         nextLesson: json["next_lesson"] == null ? null : NextLessonClass.fromJson(json["next_lesson"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "previous_lesson": previousLesson?.toJson(),
//         "next_lesson": nextLesson?.toJson(),
//     };
// }

// class NextLessonClass {
//     final int? id;
//     final String? title;

//     NextLessonClass({
//         this.id,
//         this.title,
//     });

//     factory NextLessonClass.fromJson(Map<String, dynamic> json) => NextLessonClass(
//         id: json["id"],
//         title: json["title"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//     };
// }

// class Progress {
//     final int? totalLessons;
//     final int? completedLessons;
//     final double? progressPercentage;
//     final int? nextLessonId;

//     Progress({
//         this.totalLessons,
//         this.completedLessons,
//         this.progressPercentage,
//         this.nextLessonId,
//     });

//     factory Progress.fromJson(Map<String, dynamic> json) => Progress(
//         totalLessons: json["total_lessons"],
//         completedLessons: json["completed_lessons"],
//         progressPercentage: json["progress_percentage"]?.toDouble(),
//         nextLessonId: json["next_lesson_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "total_lessons": totalLessons,
//         "completed_lessons": completedLessons,
//         "progress_percentage": progressPercentage,
//         "next_lesson_id": nextLessonId,
//     };
// }
