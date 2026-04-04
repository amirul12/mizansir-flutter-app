# PrivateTutor - API Mapping

> **Last Updated:** 2026-04-04
> **API Base URL:** http://your-domain.com/api
> **API Version:** v1

---

## Overview

This document maps all API endpoints from the Postman collection to their corresponding features, use cases, and data models.

### API Response Format

All API responses follow this structure:

```json
{
  "success": true|false,
  "data": {},
  "message": "string",
  "errors": {}
}
```

---

## 1. Authentication APIs

### Feature: `auth`

#### 1.1 Register Student

**Endpoint:** `POST /v1/auth/register`

**Feature:** auth
**Use Case:** `RegisterUseCase`
**Repository Method:** `register()`
**Data Source:** `AuthRemoteDataSource.registerStudent()`

**Request:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "password_confirmation": "password123",
  "phone": "01712345678"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "01712345678",
      "avatar": null,
      "created_at": "2026-04-04T10:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "Registration successful"
}
```

**Models:**
- Request: `RegisterParams`
- Response: `AuthResponseModel`
- Entity: `AuthUser`

---

#### 1.2 Login

**Endpoint:** `POST /v1/auth/login`

**Feature:** auth
**Use Case:** `LoginUseCase`
**Repository Method:** `login()`
**Data Source:** `AuthRemoteDataSource.login()`

**Request:**
```json
{
  "email": "john@example.com",
  "password": "password123",
  "device_name": "iPhone 13"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "01712345678",
      "avatar": null
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "Login successful"
}
```

**Models:**
- Request: `LoginParams`
- Response: `AuthResponseModel`
- Entity: `AuthUser`

---

#### 1.3 Get Current User

**Endpoint:** `GET /v1/auth/user`

**Headers:** `Authorization: Bearer {token}`

**Feature:** auth
**Use Case:** `GetCurrentUserUseCase`
**Repository Method:** `getCurrentUser()`
**Data Source:** `AuthRemoteDataSource.getCurrentUser()`

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "01712345678",
    "avatar": "https://example.com/avatar.jpg",
    "college_name": "Dhaka College",
    "address": "Dhaka, Bangladesh",
    "created_at": "2026-04-04T10:00:00Z"
  }
}
```

**Models:**
- Response: `AuthUserModel`
- Entity: `AuthUser`

---

#### 1.4 Logout

**Endpoint:** `POST /v1/auth/logout`

**Headers:** `Authorization: Bearer {token}`

**Feature:** auth
**Use Case:** `LogoutUseCase`
**Repository Method:** `logout()`
**Data Source:** `AuthRemoteDataSource.logout()`

**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

**Models:**
- Response: `SuccessResponse`

---

#### 1.5 Logout All Devices

**Endpoint:** `POST /v1/auth/logout-all`

**Headers:** `Authorization: Bearer {token}`

**Feature:** auth
**Use Case:** `LogoutAllUseCase`
**Repository Method:** `logoutAll()`
**Data Source:** `AuthRemoteDataSource.logoutAll()`

**Response:**
```json
{
  "success": true,
  "message": "Logged out from all devices"
}
```

**Models:**
- Response: `SuccessResponse`

---

#### 1.6 Refresh Token

**Endpoint:** `POST /v1/auth/refresh-token`

**Headers:** `Authorization: Bearer {token}`

**Feature:** auth
**Use Case:** `RefreshTokenUseCase`
**Repository Method:** `refreshToken()`
**Data Source:** `AuthRemoteDataSource.refreshToken()`

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "Token refreshed"
}
```

**Models:**
- Response: `RefreshTokenResponse`

---

#### 1.7 Change Password

**Endpoint:** `POST /v1/auth/change-password`

**Headers:** `Authorization: Bearer {token}`

**Feature:** auth
**Use Case:** `ChangePasswordUseCase`
**Repository Method:** `changePassword()`
**Data Source:** `AuthRemoteDataSource.changePassword()`

**Request:**
```json
{
  "current_password": "oldpassword",
  "password": "newpassword123",
  "password_confirmation": "newpassword123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

**Models:**
- Request: `ChangePasswordParams`

---

#### 1.8 Get Active Sessions

**Endpoint:** `GET /v1/auth/active-sessions`

**Headers:** `Authorization: Bearer {token}`

**Feature:** auth
**Use Case:** `GetActiveSessionsUseCase`
**Repository Method:** `getActiveSessions()`
**Data Source:** `AuthRemoteDataSource.getActiveSessions()`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "device_name": "iPhone 13",
      "ip_address": "192.168.1.1",
      "last_active": "2026-04-04T12:00:00Z",
      "is_current": true
    },
    {
      "id": 2,
      "device_name": "Windows PC",
      "ip_address": "192.168.1.2",
      "last_active": "2026-04-04T10:30:00Z",
      "is_current": false
    }
  ]
}
```

**Models:**
- Response: `List<SessionModel>`
- Entity: `Session`

---

## 2. Courses (Public) APIs

### Feature: `course_browsing`

#### 2.1 List All Courses

**Endpoint:** `GET /v1/courses`

**Feature:** course_browsing
**Use Case:** `GetCoursesUseCase`
**Repository Method:** `getCourses()`
**Data Source:** `CourseRemoteDataSource.getCourses()`

**Query Parameters:**
- `page` (int, optional): Page number
- `per_page` (int, optional): Items per page
- `status` (string, optional): Filter by status (active, inactive)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Mathematics for HSC",
      "description": "Complete mathematics course",
      "thumbnail": "https://example.com/course1.jpg",
      "price": 1500.00,
      "status": "active",
      "category": "Mathematics",
      "instructor": "John Doe",
      "duration": 3600,
      "lesson_count": 20,
      "is_featured": true,
      "created_at": "2026-04-01T10:00:00Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total": 100,
    "last_page": 5
  }
}
```

**Models:**
- Response: `List<CourseModel>`
- Entity: `Course`

---

#### 2.2 List Courses with Filters

**Endpoint:** `GET /v1/courses?search=math&status=active&per_page=20&sort_by=price&sort_direction=asc`

**Feature:** course_browsing
**Use Case:** `GetCoursesUseCase`
**Repository Method:** `getCourses()`
**Data Source:** `CourseRemoteDataSource.getCourses()`

**Query Parameters:**
- `search` (string, optional): Search term
- `status` (string, optional): Filter by status
- `per_page` (int, optional): Items per page
- `sort_by` (string, optional): Sort field (price, created_at, title)
- `sort_direction` (string, optional): Sort direction (asc, desc)

**Response:** Same as 2.1

---

#### 2.3 Get Featured Courses

**Endpoint:** `GET /v1/courses/featured`

**Feature:** course_browsing
**Use Case:** `GetFeaturedCoursesUseCase`
**Repository Method:** `getFeaturedCourses()`
**Data Source:** `CourseRemoteDataSource.getFeaturedCourses()`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Featured Course",
      "description": "Description",
      "thumbnail": "https://example.com/course.jpg",
      "price": 1500.00,
      "status": "active",
      "is_featured": true
    }
  ]
}
```

**Models:**
- Response: `List<CourseModel>`

---

#### 2.4 Get Course Categories

**Endpoint:** `GET /v1/courses/categories`

**Feature:** course_browsing
**Use Case:** `GetCategoriesUseCase`
**Repository Method:** `getCategories()`
**Data Source:** `CourseRemoteDataSource.getCategories()`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Mathematics",
      "slug": "mathematics",
      "icon": "https://example.com/math.png",
      "course_count": 25
    },
    {
      "id": 2,
      "name": "Physics",
      "slug": "physics",
      "icon": "https://example.com/physics.png",
      "course_count": 18
    }
  ]
}
```

**Models:**
- Response: `List<CategoryModel>`
- Entity: `Category`

---

#### 2.5 Search Courses

**Endpoint:** `GET /v1/courses/search?q=mathematics`

**Feature:** course_browsing
**Use Case:** `SearchCoursesUseCase`
**Repository Method:** `searchCourses()`
**Data Source:** `CourseRemoteDataSource.searchCourses()`

**Query Parameters:**
- `q` (string, required): Search query
- `page` (int, optional): Page number
- `per_page` (int, optional): Items per page

**Response:** Same as 2.1

---

#### 2.6 Get Course Details

**Endpoint:** `GET /v1/courses/{course_id}`

**Feature:** course_browsing
**Use Case:** `GetCourseDetailsUseCase`
**Repository Method:** `getCourseDetails()`
**Data Source:** `CourseRemoteDataSource.getCourseDetails()`

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Mathematics for HSC",
    "description": "Complete course description",
    "thumbnail": "https://example.com/course1.jpg",
    "price": 1500.00,
    "status": "active",
    "category": "Mathematics",
    "instructor": "John Doe",
    "duration": 3600,
    "lesson_count": 20,
    "is_featured": true,
    "created_at": "2026-04-01T10:00:00Z",
    "curriculum": [
      {
        "id": 1,
        "title": "Chapter 1",
        "order": 1,
        "lessons": [
          {
            "id": 1,
            "title": "Lesson 1",
            "duration": 600,
            "is_preview": true
          }
        ]
      }
    ]
  }
}
```

**Models:**
- Response: `CourseDetailsModel`
- Entity: `Course`

---

## 3. Lessons (Public - Preview) APIs

### Feature: `course_browsing`

#### 3.1 Get Preview Lessons

**Endpoint:** `GET /v1/courses/{course_id}/lessons`

**Feature:** course_browsing
**Use Case:** `GetPreviewLessonsUseCase`
**Repository Method:** `getPreviewLessons()`
**Data Source:** `CourseRemoteDataSource.getPreviewLessons()`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "course_id": 1,
      "title": "Introduction",
      "description": "Course introduction",
      "duration": 600,
      "order": 1,
      "is_preview": true
    }
  ]
}
```

**Models:**
- Response: `List<LessonPreviewModel>`
- Entity: `LessonPreview`

---

#### 3.2 Get Preview Lesson Details

**Endpoint:** `GET /v1/courses/{course_id}/lessons/{lesson_id}`

**Feature:** course_browsing
**Use Case:** `GetPreviewLessonDetailsUseCase`
**Repository Method:** `getPreviewLessonDetails()`
**Data Source:** `CourseRemoteDataSource.getPreviewLessonDetails()`

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "course_id": 1,
    "title": "Introduction",
    "description": "Full description",
    "video_url": "https://example.com/video.mp4",
    "duration": 600,
    "order": 1,
    "is_preview": true,
    "created_at": "2026-04-01T10:00:00Z"
  }
}
```

**Models:**
- Response: `LessonDetailsModel`
- Entity: `Lesson`

---

## 4. My Enrolled Courses APIs

### Feature: `lesson`

#### 4.1 Get My Courses

**Endpoint:** `GET /v1/my-courses`

**Headers:** `Authorization: Bearer {token}`

**Feature:** lesson
**Use Case:** `GetMyCoursesUseCase`
**Repository Method:** `getMyCourses()`
**Data Source:** `LessonRemoteDataSource.getMyCourses()`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Mathematics for HSC",
      "thumbnail": "https://example.com/course1.jpg",
      "instructor": "John Doe",
      "progress": 45.5,
      "enrollment": {
        "id": 1,
        "status": "active",
        "enrolled_at": "2026-04-01T10:00:00Z",
        "expires_at": "2026-05-01T10:00:00Z"
      }
    }
  ]
}
```

**Models:**
- Response: `List<EnrolledCourseModel>`
- Entity: `EnrolledCourse`

---

## 5. Lessons (Protected) APIs

### Feature: `lesson`

#### 5.1 Get Course Lessons

**Endpoint:** `GET /v1/my-courses/{course_id}/lessons`

**Headers:** `Authorization: Bearer {token}`

**Feature:** lesson
**Use Case:** `GetCourseLessonsUseCase`
**Repository Method:** `getCourseLessons()`
**Data Source:** `LessonRemoteDataSource.getCourseLessons()`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Introduction",
      "description": "Lesson description",
      "video_url": "https://example.com/video.mp4",
      "duration": 600,
      "order": 1,
      "progress": {
        "is_completed": true,
        "progress_percentage": 100,
        "watch_time_seconds": 600,
        "completed_at": "2026-04-02T10:00:00Z"
      }
    }
  ]
}
```

**Models:**
- Response: `List<LessonWithProgressModel>`
- Entity: `Lesson`

---

#### 5.2 Get Lesson Details

**Endpoint:** `GET /v1/my-courses/{course_id}/lessons/{lesson_id}`

**Headers:** `Authorization: Bearer {token}`

**Feature:** lesson
**Use Case:** `GetLessonDetailsUseCase`
**Repository Method:** `getLessonDetails()`
**Data Source:** `LessonRemoteDataSource.getLessonDetails()`

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Introduction",
    "description": "Full description",
    "video_url": "https://example.com/video.mp4",
    "duration": 600,
    "order": 1,
    "progress": {
      "is_completed": false,
      "progress_percentage": 50,
      "watch_time_seconds": 300
    }
  }
}
```

**Models:**
- Response: `LessonDetailsModel`

---

## 6. Lesson Completion & Progress APIs

### Feature: `lesson`

#### 6.1 Mark Lesson Complete

**Endpoint:** `POST /v1/my-courses/{course_id}/lessons/{lesson_id}/complete`

**Headers:** `Authorization: Bearer {token}`

**Feature:** lesson
**Use Case:** `MarkLessonCompleteUseCase`
**Repository Method:** `markComplete()`
**Data Source:** `LessonRemoteDataSource.markComplete()`

**Request:**
```json
{
  "watch_time_seconds": 2700,
  "progress_percentage": 100
}
```

**Response:**
```json
{
  "success": true,
  "message": "Lesson marked as complete"
}
```

---

#### 6.2 Mark Lesson Incomplete

**Endpoint:** `POST /v1/my-courses/{course_id}/lessons/{lesson_id}/incomplete`

**Headers:** `Authorization: Bearer {token}`

**Feature:** lesson
**Use Case:** `MarkLessonIncompleteUseCase`
**Repository Method:** `markIncomplete()`
**Data Source:** `LessonRemoteDataSource.markIncomplete()`

**Response:**
```json
{
  "success": true,
  "message": "Lesson marked as incomplete"
}
```

---

#### 6.3 Update Progress

**Endpoint:** `POST /v1/my-courses/{course_id}/lessons/{lesson_id}/progress`

**Headers:** `Authorization: Bearer {token}`

**Feature:** lesson
**Use Case:** `UpdateProgressUseCase`
**Repository Method:** `updateProgress()`
**Data Source:** `LessonRemoteDataSource.updateProgress()`

**Request:**
```json
{
  "progress_percentage": 50,
  "watch_time_seconds": 1200
}
```

**Response:**
```json
{
  "success": true,
  "message": "Progress updated"
}
```

---

#### 6.4 Get Course Progress

**Endpoint:** `GET /v1/my-courses/{course_id}/progress`

**Headers:** `Authorization: Bearer {token}`

**Feature:** lesson
**Use Case:** `GetCourseProgressUseCase`
**Repository Method:** `getCourseProgress()`
**Data Source:** `LessonRemoteDataSource.getCourseProgress()`

**Response:**
```json
{
  "success": true,
  "data": {
    "course_id": 1,
    "progress_percentage": 45.5,
    "completed_lessons": 9,
    "total_lessons": 20,
    "total_watch_time_seconds": 16200,
    "last_accessed_at": "2026-04-04T12:00:00Z"
  }
}
```

**Models:**
- Response: `CourseProgressModel`
- Entity: `CourseProgress`

---

## 7. Enrollments APIs

### Feature: `enrollment`

#### 7.1 Get My Enrollments

**Endpoint:** `GET /v1/enrollments`

**Headers:** `Authorization: Bearer {token}`

**Feature:** enrollment
**Use Case:** `GetEnrollmentsUseCase`
**Repository Method:** `getEnrollments()`
**Data Source:** `EnrollmentRemoteDataSource.getEnrollments()`

**Query Parameters:**
- `status` (string, optional): Filter by status (active, expired, cancelled)
- `page` (int, optional): Page number
- `per_page` (int, optional): Items per page

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "course_id": 1,
      "course": {
        "id": 1,
        "title": "Mathematics for HSC",
        "thumbnail": "https://example.com/course1.jpg"
      },
      "status": "active",
      "start_date": "2026-04-01T10:00:00Z",
      "end_date": "2026-05-01T10:00:00Z",
      "payment_method": "bkash",
      "transaction_id": "TXN123456",
      "progress_percentage": 45.5,
      "completed_lessons": 9,
      "created_at": "2026-04-01T10:00:00Z"
    }
  ]
}
```

**Models:**
- Response: `List<EnrollmentModel>`
- Entity: `Enrollment`

---

#### 7.2 Create Enrollment

**Endpoint:** `POST /v1/enrollments`

**Headers:** `Authorization: Bearer {token}`

**Feature:** enrollment
**Use Case:** `CreateEnrollmentUseCase`
**Repository Method:** `create()`
**Data Source:** `EnrollmentRemoteDataSource.create()`

**Request:**
```json
{
  "course_id": 1,
  "payment_method": "bkash",
  "payment_notes": "Sent from 01712345678",
  "transaction_id": "TXN123456"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "course_id": 1,
    "status": "active",
    "start_date": "2026-04-04T10:00:00Z",
    "end_date": "2026-05-04T10:00:00Z"
  },
  "message": "Enrollment created successfully"
}
```

**Models:**
- Request: `CreateEnrollmentParams`

---

#### 7.3 Get Enrollment Details

**Endpoint:** `GET /v1/enrollments/{enrollment_id}`

**Headers:** `Authorization: Bearer {token}`

**Feature:** enrollment
**Use Case:** `GetEnrollmentDetailsUseCase`
**Repository Method:** `getDetails()`
**Data Source:** `EnrollmentRemoteDataSource.getDetails()`

**Response:** Same as 7.1 (single enrollment object)

---

#### 7.4 Get Enrollment Statistics

**Endpoint:** `GET /v1/enrollments/stats`

**Headers:** `Authorization: Bearer {token}`

**Feature:** enrollment
**Use Case:** `GetEnrollmentStatsUseCase`
**Repository Method:** `getStats()`
**Data Source:** `EnrollmentRemoteDataSource.getStats()`

**Response:**
```json
{
  "success": true,
  "data": {
    "total_enrollments": 10,
    "active_enrollments": 7,
    "completed_enrollments": 2,
    "expired_enrollments": 1
  }
}
```

**Models:**
- Response: `EnrollmentStatsModel`
- Entity: `EnrollmentStats`

---

#### 7.5 Renew Enrollment

**Endpoint:** `POST /v1/enrollments/{enrollment_id}/renew`

**Headers:** `Authorization: Bearer {token}`

**Feature:** enrollment
**Use Case:** `RenewEnrollmentUseCase`
**Repository Method:** `renew()`
**Data Source:** `EnrollmentRemoteDataSource.renew()`

**Request:**
```json
{
  "payment_method": "bkash",
  "payment_notes": "Renewal payment",
  "transaction_id": "TXN789012"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "end_date": "2026-06-01T10:00:00Z"
  },
  "message": "Enrollment renewed successfully"
}
```

---

#### 7.6 Cancel Enrollment

**Endpoint:** `DELETE /v1/enrollments/{enrollment_id}/cancel`

**Headers:** `Authorization: Bearer {token}`

**Feature:** enrollment
**Use Case:** `CancelEnrollmentUseCase`
**Repository Method:** `cancel()`
**Data Source:** `EnrollmentRemoteDataSource.cancel()`

**Response:**
```json
{
  "success": true,
  "message": "Enrollment cancelled successfully"
}
```

---

## 8. User Profile APIs

### Feature: `profile`

#### 8.1 Get Profile

**Endpoint:** `GET /v1/user/profile`

**Headers:** `Authorization: Bearer {token}`

**Feature:** profile
**Use Case:** `GetProfileUseCase`
**Repository Method:** `getProfile()`
**Data Source:** `ProfileRemoteDataSource.getProfile()`

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "01712345678",
    "avatar": "https://example.com/avatar.jpg",
    "address": "Dhaka, Bangladesh",
    "college_name": "Dhaka College",
    "created_at": "2026-04-01T10:00:00Z"
  }
}
```

**Models:**
- Response: `UserProfileModel`
- Entity: `UserProfile`

---

#### 8.2 Update Profile

**Endpoint:** `PUT /v1/user/profile`

**Headers:** `Authorization: Bearer {token}`

**Feature:** profile
**Use Case:** `UpdateProfileUseCase`
**Repository Method:** `updateProfile()`
**Data Source:** `ProfileRemoteDataSource.updateProfile()`

**Request:**
```json
{
  "name": "John Doe",
  "phone": "01712345678",
  "address": "Dhaka, Bangladesh",
  "college_name": "Dhaka College"
}
```

**Response:** Same as 8.1

---

#### 8.3 Upload Avatar

**Endpoint:** `POST /v1/user/upload-avatar`

**Headers:** `Authorization: Bearer {token}`

**Feature:** profile
**Use Case:** `UploadAvatarUseCase`
**Repository Method:** `uploadAvatar()`
**Data Source:** `ProfileRemoteDataSource.uploadAvatar()`

**Request:** Multipart form data
- `avatar` (file): Image file

**Response:**
```json
{
  "success": true,
  "data": {
    "avatar_url": "https://example.com/avatars/new-avatar.jpg"
  },
  "message": "Avatar uploaded successfully"
}
```

---

#### 8.4 Get Dashboard

**Endpoint:** `GET /v1/user/dashboard`

**Headers:** `Authorization: Bearer {token}`

**Feature:** dashboard
**Use Case:** `GetDashboardUseCase`
**Repository Method:** `getDashboard()`
**Data Source:** `DashboardRemoteDataSource.getDashboard()`

**Response:**
```json
{
  "success": true,
  "data": {
    "total_enrollments": 10,
    "active_courses": 7,
    "completed_lessons": 45,
    "total_lessons": 200,
    "overall_progress": 22.5,
    "recent_activities": [
      {
        "id": 1,
        "type": "lesson_completed",
        "description": "Completed Lesson 5",
        "created_at": "2026-04-04T12:00:00Z"
      }
    ]
  }
}
```

**Models:**
- Response: `DashboardStatsModel`
- Entity: `DashboardStats`

---

#### 8.5 Get Activity

**Endpoint:** `GET /v1/user/activity`

**Headers:** `Authorization: Bearer {token}`

**Feature:** dashboard
**Use Case:** `GetActivityUseCase`
**Repository Method:** `getActivity()`
**Data Source:** `DashboardRemoteDataSource.getActivity()`

**Query Parameters:**
- `page` (int, optional): Page number
- `per_page` (int, optional): Items per page

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "type": "lesson_completed",
      "description": "Completed Lesson 5",
      "metadata": {
        "course_id": 1,
        "lesson_id": 5
      },
      "created_at": "2026-04-04T12:00:00Z"
    }
  ]
}
```

**Models:**
- Response: `List<ActivityModel>`
- Entity: `Activity`

---

#### 8.6 Change Password (Profile)

**Endpoint:** `POST /v1/user/change-password`

**Headers:** `Authorization: Bearer {token}`

**Feature:** profile
**Use Case:** `ChangePasswordUseCase` (same as auth)
**Repository Method:** `changePassword()`
**Data Source:** `ProfileRemoteDataSource.changePassword()`

**Request:** Same as 1.7

---

#### 8.7 Delete Account

**Endpoint:** `DELETE /v1/user/account`

**Headers:** `Authorization: Bearer {token}`

**Feature:** profile
**Use Case:** `DeleteAccountUseCase`
**Repository Method:** `deleteAccount()`
**Data Source:** `ProfileRemoteDataSource.deleteAccount()`

**Response:**
```json
{
  "success": true,
  "message": "Account deleted successfully"
}
```

---

## 9. System APIs

### Feature: `core`

#### 9.1 Health Check

**Endpoint:** `GET /health`

**Feature:** core
**Use Case:** N/A (system check)
**Repository Method:** N/A
**Data Source:** `ApiService.healthCheck()`

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2026-04-04T12:00:00Z"
}
```

---

#### 9.2 API Documentation

**Endpoint:** `GET /docs`

**Feature:** core
**Use Case:** N/A (documentation)

**Response:** HTML/Swagger documentation page

---

## Summary Table

| Section | Feature | Endpoints | Auth Required |
|---------|---------|-----------|---------------|
| 1. Authentication | auth | 8 endpoints | No (for register/login) |
| 2. Courses (Public) | course_browsing | 6 endpoints | No |
| 3. Lessons (Preview) | course_browsing | 2 endpoints | No |
| 4. My Courses | lesson | 1 endpoint | Yes |
| 5. Lessons (Protected) | lesson | 2 endpoints | Yes |
| 6. Progress | lesson | 4 endpoints | Yes |
| 7. Enrollments | enrollment | 6 endpoints | Yes |
| 8. Profile | profile | 7 endpoints | Yes |
| 9. System | core | 2 endpoints | No |
| **Total** | **8 features** | **38 endpoints** | **Mixed** |

---

## Implementation Priority

### Phase 2: Authentication
- All 8 authentication endpoints

### Phase 3: Public Course Browsing
- All 6 course browsing endpoints
- 2 preview lesson endpoints

### Phase 4: Student Learning Area
- 1 "my courses" endpoint
- 2 protected lesson endpoints
- 4 progress endpoints

### Phase 5: Enrollments
- All 6 enrollment endpoints

### Phase 6: Profile & Dashboard
- 7 profile/user endpoints
- 2 dashboard endpoints

---

## Notes

- All authenticated endpoints require `Authorization: Bearer {token}` header
- All dates are in ISO 8601 format
- Pagination uses 1-based indexing
- Error responses contain `success: false` with error details
- File uploads use multipart/form-data

---

**Last Updated:** 2026-04-04
**API Version:** v1.0.0
**Total Endpoints:** 38
