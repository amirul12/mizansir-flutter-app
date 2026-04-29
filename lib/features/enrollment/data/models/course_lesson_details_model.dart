// To parse this JSON data, do
//
//     final courseLessonDetailsModel = courseLessonDetailsModelFromJson(jsonString);

import 'dart:convert';

CourseLessonDetailsModel courseLessonDetailsModelFromJson(String str) => CourseLessonDetailsModel.fromJson(json.decode(str));

String courseLessonDetailsModelToJson(CourseLessonDetailsModel data) => json.encode(data.toJson());

class CourseLessonDetailsModel {
    final int? id;
    final int? courseId;
    final String? title;
    final String? description;
    final dynamic thumbnail;
    final String? youtubeEmbedUrl;
    final String? youtubeVideoId;
    final int? durationMinutes;
    final String? moduleName;
    final bool? isPreview;
    final bool? isPublished;
    final bool? hasDocuments;
    final String? contentType;
    final dynamic chapter;
    final dynamic tag;
    final Completion? completion;
    final List<dynamic>? documents;
    final Navigation? navigation;

    CourseLessonDetailsModel({
        this.id,
        this.courseId,
        this.title,
        this.description,
        this.thumbnail,
        this.youtubeEmbedUrl,
        this.youtubeVideoId,
        this.durationMinutes,
        this.moduleName,
        this.isPreview,
        this.isPublished,
        this.hasDocuments,
        this.contentType,
        this.chapter,
        this.tag,
        this.completion,
        this.documents,
        this.navigation,
    });

    factory CourseLessonDetailsModel.fromJson(Map<String, dynamic> json) => CourseLessonDetailsModel(
        id: json["id"],
        courseId: json["course_id"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        youtubeEmbedUrl: json["youtube_embed_url"],
        youtubeVideoId: json["youtube_video_id"],
        durationMinutes: json["duration_minutes"],
        moduleName: json["module_name"],
        isPreview: json["is_preview"],
        isPublished: json["is_published"],
        hasDocuments: json["has_documents"],
        contentType: json["content_type"],
        chapter: json["chapter"],
        tag: json["tag"],
        completion: json["completion"] == null ? null : Completion.fromJson(json["completion"]),
        documents: json["documents"] == null ? [] : List<dynamic>.from(json["documents"]!.map((x) => x)),
        navigation: json["navigation"] == null ? null : Navigation.fromJson(json["navigation"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "title": title,
        "description": description,
        "thumbnail": thumbnail,
        "youtube_embed_url": youtubeEmbedUrl,
        "youtube_video_id": youtubeVideoId,
        "duration_minutes": durationMinutes,
        "module_name": moduleName,
        "is_preview": isPreview,
        "is_published": isPublished,
        "has_documents": hasDocuments,
        "content_type": contentType,
        "chapter": chapter,
        "tag": tag,
        "completion": completion?.toJson(),
        "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
        "navigation": navigation?.toJson(),
    };
}

class Completion {
    final bool? isCompleted;
    final int? progressPercentage;
    final int? timeSpentSeconds;
    final DateTime? startedAt;
    final dynamic completedAt;

    Completion({
        this.isCompleted,
        this.progressPercentage,
        this.timeSpentSeconds,
        this.startedAt,
        this.completedAt,
    });

    factory Completion.fromJson(Map<String, dynamic> json) => Completion(
        isCompleted: json["is_completed"],
        progressPercentage: json["progress_percentage"],
        timeSpentSeconds: json["time_spent_seconds"],
        startedAt: json["started_at"] == null ? null : DateTime.parse(json["started_at"]),
        completedAt: json["completed_at"],
    );

    Map<String, dynamic> toJson() => {
        "is_completed": isCompleted,
        "progress_percentage": progressPercentage,
        "time_spent_seconds": timeSpentSeconds,
        "started_at": startedAt?.toIso8601String(),
        "completed_at": completedAt,
    };
}

class Navigation {
    final dynamic previousLesson;
    final NextLesson? nextLesson;

    Navigation({
        this.previousLesson,
        this.nextLesson,
    });

    factory Navigation.fromJson(Map<String, dynamic> json) => Navigation(
        previousLesson: json["previous_lesson"],
        nextLesson: json["next_lesson"] == null ? null : NextLesson.fromJson(json["next_lesson"]),
    );

    Map<String, dynamic> toJson() => {
        "previous_lesson": previousLesson,
        "next_lesson": nextLesson?.toJson(),
    };
}

class NextLesson {
    final int? id;
    final String? title;

    NextLesson({
        this.id,
        this.title,
    });

    factory NextLesson.fromJson(Map<String, dynamic> json) => NextLesson(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}
