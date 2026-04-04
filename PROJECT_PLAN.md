# PrivateTutor - Project Plan

> **Last Updated:** 2026-04-04
> **Project:** PrivateTutor - Student Course Management System
> **Status:** Phase 0 - Planning

---

## Executive Summary

**PrivateTutor** is a cross-platform Flutter application for managing student course enrollments, lessons, and progress tracking. The app connects to a RESTful API backend and provides both public course browsing and authenticated student features.

### Project Scope

- **Platform:** iOS, Android, Web, macOS, Windows, Linux
- **Architecture:** Feature-First + Clean Architecture + BLoC
- **State Management:** flutter_bloc
- **Navigation:** go_router
- **Networking:** http package with centralized API service
- **Storage:** secure storage for tokens, shared_preferences for session
- **API:** RESTful with token-based authentication

### Target Users

- Students looking for courses
- Enrolled students managing their learning
- Students tracking lesson progress

---

## Table of Contents

1. [Features Overview](#features-overview)
2. [Technical Stack](#technical-stack)
3. [Architecture Design](#architecture-design)
4. [Feature Breakdown](#feature-breakdown)
5. [Data Models](#data-models)
6. [User Flow](#user-flow)
7. [Security Considerations](#security-considerations)
8. [Offline Strategy](#offline-strategy)
9. [Performance Considerations](#performance-considerations)

---

## Features Overview

### Public Features (No Authentication Required)

1. **Course Discovery**
   - Browse all courses with pagination
   - Search courses by title/description
   - Filter by category, price range, status
   - Sort by price, date, popularity
   - View featured courses on home screen

2. **Course Details**
   - Course overview (title, description, price, instructor)
   - Course curriculum (lesson list)
   - Preview lessons (free lessons without enrollment)
   - Course categories and tags
   - Enrollment requirements

### Authenticated Features (Authentication Required)

3. **Authentication**
   - Student registration
   - Login with email/password
   - Logout (single device)
   - Logout all devices
   - Token refresh
   - Session management
   - Password management (change, reset)

4. **Enrollment Management**
   - Enroll in courses
   - View active enrollments
   - Enrollment details and statistics
   - Renew expired enrollments
   - Cancel enrollments
   - Payment method handling

5. **Learning Management**
   - View enrolled courses
   - Access protected lessons
   - Mark lessons as complete/incomplete
   - Track progress (watch time, percentage)
   - View overall course progress
   - Resume learning from last position

6. **User Profile**
   - View profile information
   - Update profile (name, phone, address)
   - Upload avatar
   - View learning dashboard
   - View activity history
   - Change password
   - Delete account

7. **Dashboard**
   - Active enrollments count
   - Completed lessons count
   - Overall progress
   - Recent activity
   - Upcoming lessons (if any)

---

## Technical Stack

### Core Dependencies

```yaml
# State Management
flutter_bloc: ^8.1.3
equatable: ^2.0.5

# Navigation
go_router: ^14.0.0

# Dependency Injection
get_it: ^7.6.0

# Networking
http: ^1.2.0

# Local Storage
shared_preferences: ^2.2.2
flutter_secure_storage: ^9.0.0

# JSON Serialization
json_annotation: ^4.8.1
json_serializable: ^6.7.1

# Functional Programming
dartz: ^0.10.1

# UI Components
cupertino_icons: ^1.0.6
flutter_svg: ^2.0.7
cached_network_image: ^3.3.0

# Utilities
uuid: ^4.1.0
logger: ^2.0.2
connectivity_plus: ^5.0.2

# Dev Dependencies
flutter_lints: ^3.0.0
build_runner: ^2.4.7
```

### Development Tools

- FVM for Flutter version management
- VS Code / Android Studio
- Postman for API testing
- Firebase Crashlytics (optional for crash reporting)
- Firebase Analytics (optional for analytics)

---

## Architecture Design

### Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── storage_constants.dart
│   ├── data/
│   │   └── models/  # Shared models only
│   ├── di/
│   │   └── injection_container.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── extensions/
│   │   └── context_extensions.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── token_service.dart
│   │   ├── connectivity_service.dart
│   │   └── storage_service.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── app_text_styles.dart
│   ├── usecases/
│   │   └── no_params.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── validation_utils.dart
│   │   └── image_utils.dart
│   └── widgets/
│       ├── loading_widget.dart
│       ├── error_widget.dart
│       ├── empty_widget.dart
│       └── custom_app_bar.dart
├── features/
│   ├── auth/
│   ├── course_browsing/
│   ├── enrollment/
│   ├── lesson/
│   ├── profile/
│   └── dashboard/
└── main.dart
```

### Features Breakdown

#### 1. auth

**Purpose:** User authentication and session management

**Domain Entities:**
- `AuthUser` - Authenticated user data
- `Session` - User session information

**Use Cases:**
- `LoginUseCase` - Authenticate user
- `RegisterUseCase` - Register new user
- `GetCurrentUserUseCase` - Get currently authenticated user
- `LogoutUseCase` - Logout from current device
- `LogoutAllUseCase` - Logout from all devices
- `RefreshTokenUseCase` - Refresh access token
- `ChangePasswordUseCase` - Change user password
- `GetActiveSessionsUseCase` - Get all active sessions

**Pages:**
- `LoginPage` - Login screen
- `RegisterPage` - Registration screen
- `ForgotPasswordPage` - Password recovery

#### 2. course_browsing

**Purpose:** Browse and discover public courses

**Domain Entities:**
- `Course` - Course information
- `Category` - Course category
- `Lesson` - Lesson preview (for non-enrolled)
- `CourseFilter` - Filter parameters

**Use Cases:**
- `GetCoursesUseCase` - List courses with pagination
- `GetFeaturedCoursesUseCase` - Get featured courses
- `GetCourseDetailsUseCase` - Get single course details
- `SearchCoursesUseCase` - Search courses
- `GetCategoriesUseCase` - Get all categories
- `GetPreviewLessonsUseCase` - Get preview lessons for a course

**Pages:**
- `CoursesPage` - Course listing page
- `CourseDetailsPage` - Single course details
- `CourseSearchPage` - Search results
- `CategoriesPage` - Browse by category

#### 3. enrollment

**Purpose:** Manage course enrollments

**Domain Entities:**
- `Enrollment` - Enrollment information
- `EnrollmentStats` - Enrollment statistics
- `PaymentInfo` - Payment information

**Use Cases:**
- `GetEnrollmentsUseCase` - List user enrollments
- `CreateEnrollmentUseCase` - Enroll in a course
- `GetEnrollmentDetailsUseCase` - Get enrollment details
- `GetEnrollmentStatsUseCase` - Get enrollment statistics
- `RenewEnrollmentUseCase` - Renew enrollment
- `CancelEnrollmentUseCase` - Cancel enrollment

**Pages:**
- `MyEnrollmentsPage` - List of enrollments
- `EnrollmentDetailsPage` - Enrollment details
- `EnrollmentPaymentPage` - Payment flow

#### 4. lesson

**Purpose:** Access enrolled course lessons

**Domain Entities:**
- `Lesson` - Full lesson data
- `LessonProgress` - Lesson progress tracking
- `CourseProgress` - Overall course progress

**Use Cases:**
- `GetMyCoursesUseCase` - Get enrolled courses
- `GetCourseLessonsUseCase` - Get lessons for enrolled course
- `GetLessonDetailsUseCase` - Get lesson details
- `MarkLessonCompleteUseCase` - Mark lesson as complete
- `MarkLessonIncompleteUseCase` - Mark lesson as incomplete
- `UpdateProgressUseCase` - Update lesson progress
- `GetCourseProgressUseCase` - Get overall course progress

**Pages:**
- `MyCoursesPage` - List of enrolled courses
- `CourseLessonsPage` - Lessons list for enrolled course
- `LessonPlayerPage` - Lesson viewing page
- `CourseProgressPage` - Overall progress

#### 5. profile

**Purpose:** User profile management

**Domain Entities:**
- `UserProfile` - User profile information
- `Activity` - User activity log

**Use Cases:**
- `GetProfileUseCase` - Get user profile
- `UpdateProfileUseCase` - Update profile information
- `UploadAvatarUseCase` - Upload profile picture
- `ChangePasswordUseCase` - Change password
- `DeleteAccountUseCase` - Delete user account

**Pages:**
- `ProfilePage` - Profile view and edit
- `AvatarUploadPage` - Upload profile picture
- `ChangePasswordPage` - Password change form
- `DeleteAccountPage` - Account deletion confirmation

#### 6. dashboard

**Purpose:** User dashboard and activity

**Domain Entities:**
- `DashboardStats` - Dashboard statistics
- `Activity` - User activity item

**Use Cases:**
- `GetDashboardUseCase` - Get dashboard data
- `GetActivityUseCase` - Get user activity history

**Pages:**
- `DashboardPage` - Main dashboard
- `ActivityPage` - Activity history

---

## Data Models

### User & Auth

```dart
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? collegeName;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class AuthResponse {
  final User user;
  final String token;
  final String? refreshToken;
}
```

### Course

```dart
class Course {
  final int id;
  final String title;
  final String description;
  final String? thumbnail;
  final double price;
  final String status; // active, inactive, draft
  final String? category;
  final String instructor;
  final int duration; // in minutes
  final int lessonCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFeatured;
}

class Category {
  final int id;
  final String name;
  final String? slug;
  final String? icon;
  final int courseCount;
}
```

### Lesson

```dart
class Lesson {
  final int id;
  final int courseId;
  final String title;
  final String description;
  final String? videoUrl;
  final int duration; // in seconds
  final int order;
  final bool isPreview;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class LessonProgress {
  final int lessonId;
  final int userId;
  final bool isCompleted;
  final int progressPercentage;
  final int watchTimeSeconds;
  final DateTime? completedAt;
  final DateTime lastAccessedAt;
}
```

### Enrollment

```dart
class Enrollment {
  final int id;
  final int userId;
  final int courseId;
  final Course course;
  final String status; // active, expired, cancelled
  final DateTime startDate;
  final DateTime endDate;
  final String? paymentMethod;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double progressPercentage;
  final int completedLessons;
}

class EnrollmentStats {
  final int totalEnrollments;
  final int activeEnrollments;
  final int completedEnrollments;
  final int expiredEnrollments;
}
```

### Activity

```dart
class Activity {
  final int id;
  final int userId;
  final String type; // lesson_completed, enrollment_created, etc.
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
}
```

### Dashboard

```dart
class DashboardStats {
  final int totalEnrollments;
  final int activeCourses;
  final int completedLessons;
  final int totalLessons;
  final double overallProgress;
  final List<RecentActivity> recentActivities;
}
```

---

## User Flow

### Unauthenticated User Flow

```
Launch App
    ↓
Show Onboarding (optional)
    ↓
Navigate to Home (Public Courses)
    ↓
Browse Courses / Search / Filter
    ↓
View Course Details
    ↓
View Preview Lessons (free access)
    ↓
Click "Enroll" → Prompt to Login/Register
```

### Authenticated User Flow

```
Login/Register
    ↓
Navigate to Dashboard
    ↓
View Active Enrollments / Browse New Courses
    ↓
For Enrolled Courses:
    - View Course Lessons
    - Watch Lessons
    - Mark Complete/Incomplete
    - Track Progress
    ↓
For New Courses:
    - View Course Details
    - Enroll (with payment)
    - Start Learning
    ↓
View Profile / Update Settings
```

### Enrollment Flow

```
User clicks "Enroll" on Course
    ↓
Check if already enrolled
    ↓
Show Payment Method Selection
    ↓
Enter Payment Details (transaction ID, etc.)
    ↓
Submit Enrollment
    ↓
Show Success Message
    ↓
Redirect to Course Lessons
```

### Lesson Viewing Flow

```
User opens enrolled course
    ↓
Show Lessons List (with progress indicators)
    ↓
User selects lesson
    ↓
Check enrollment validity
    ↓
Show Lesson Player
    ↓
Auto-track progress (watch time)
    ↓
User marks complete or auto-complete
    ↓
Update course progress
    ↓
Show next lesson or return to list
```

---

## Security Considerations

### Authentication

1. **Token Storage**
   - Use `flutter_secure_storage` for token storage
   - Never store tokens in plain text
   - Implement token refresh mechanism

2. **Token Management**
   - Access token with short expiry (e.g., 1 hour)
   - Refresh token with longer expiry (e.g., 30 days)
   - Auto-refresh access token before expiry
   - Clear tokens on logout

3. **Session Management**
   - Track active sessions
   - Allow logout from all devices
   - Detect session conflicts

### API Security

1. **HTTPS Only**
   - All API calls over HTTPS
   - Certificate pinning (optional)

2. **Request Headers**
   - Always include Authorization header
   - Include device info for session tracking
   - Validate responses

3. **Error Handling**
   - Never expose sensitive errors to UI
   - Log errors securely
   - Handle 401/403 gracefully

### Data Protection

1. **Local Storage**
   - Use secure storage for sensitive data
   - Encrypt sensitive data if needed
   - Clear data on logout

2. **User Data**
   - Validate all inputs
   - Sanitize data before storage
   - Implement data deletion on account deletion

---

## Offline Strategy

### Online-First Approach

This is an online-first app with minimal offline support:

1. **Course Browsing**
   - Cache course data for offline viewing
   - Show stale data with "last updated" indicator
   - Refresh when connection restored

2. **Enrolled Courses**
   - Cache enrolled courses and lessons
   - Allow viewing already-loaded content
   - Queue progress updates for sync when online

3. **Authentication**
   - Require connection for login
   - Cache session locally
   - Auto-refresh token when online

### Offline Scenarios

| Scenario | Behavior |
|----------|----------|
| No internet on launch | Show cached data or "no connection" message |
| No internet during enrollment | Disable enrollment, show error |
| No internet during lesson viewing | Show cached lesson, queue progress |
| No internet during profile update | Queue update, sync later |

### Caching Strategy

1. **Course Data**
   - Cache for 24 hours
   - Manual refresh available
   - Background refresh when app opens

2. **User Data**
   - Cache profile data
   - Sync on resume
   - ETag or Last-Modified header support

3. **Progress Data**
   - Queue progress updates locally
   - Sync when connection restored
   - Conflict resolution (server wins)

---

## Performance Considerations

### Image Optimization

1. **Thumbnail Loading**
   - Use lazy loading
   - Cache images with `cached_network_image`
   - Use appropriate image sizes

2. **Avatar Upload**
   - Compress before upload
   - Show progress indicator
   - Handle upload failures

### API Optimization

1. **Pagination**
   - Implement pagination for all list views
   - Load data in pages (e.g., 20 items per page)
   - Infinite scroll or "load more" button

2. **Caching**
   - Cache API responses
   - Use conditional requests (ETag)
   - Respect cache headers

3. **Request Batching**
   - Batch related requests
   - Avoid request chains
   - Use parallel requests when possible

### Memory Management

1. **Widget Lifecycle**
   - Dispose controllers properly
   - Cancel subscriptions
   - Close streams

2. **State Management**
   - Use `close()` on BLoCs when not needed
   - Avoid memory leaks with streams
   - Clean up resources

### Loading States

1. **Skeleton Screens**
   - Show skeleton while loading
   - Smooth transitions
   - Progressive loading

2. **Optimistic Updates**
   - Update UI immediately
   - Revert on failure
   - Show loading indicators for critical actions

---

## Testing Strategy

### Unit Tests

- All use cases
- All repositories
- All BLoCs
- Utility functions
- Entity models

### Widget Tests

- All pages
- All custom widgets
- Navigation flows
- Form validation

### Integration Tests

- Authentication flow
- Enrollment flow
- Lesson progress flow
- Profile update flow

---

## Accessibility

### Accessibility Features

1. **Screen Reader Support**
   - Semantic labels for all buttons
   - Announce state changes
   - Proper focus order

2. **Visual Accessibility**
   - High contrast mode support
   - Scalable text
   - Color blindness friendly

3. **Navigation Accessibility**
   - Keyboard navigation
   - Touch target sizes (min 48x48)
   - Clear focus indicators

---

## Internationalization

### Supported Languages

- English (primary)
- Bengali (optional, based on requirements)

### Localization

- Extract all user-facing strings
- Use `easy_localization` or `flutter_localizations`
- Date/time formatting
- Number formatting (currency, etc.)

---

## Analytics & Monitoring

### Analytics Events

1. **User Actions**
   - Login/register
   - Course views
   - Enrollments
   - Lesson completions
   - Profile updates

2. **App Performance**
   - App launch time
   - API response times
   - Crash reports

### Crash Reporting

- Firebase Crashlytics
- Log errors with context
- Track stack traces

---

## Launch Checklist

### Pre-Launch

- [ ] All features implemented and tested
- [ ] API coverage complete
- [ ] Error handling comprehensive
- [ ] Loading states for all async operations
- [ ] Form validation on all forms
- [ ] Security audit complete
- [ ] Performance testing complete
- [ ] Accessibility testing complete
- [ ] Documentation up to date

### Launch

- [ ] Create production build
- [ ] Test on real devices
- [ ] Deploy to app stores
- [ ] Monitor analytics
- [ ] Fix critical issues

### Post-Launch

- [ ] Monitor crash reports
- [ ] Gather user feedback
- [ ] Plan next iteration
- [ ] Update documentation

---

## Risk Mitigation

### Technical Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| API downtime | High | Implement caching, show error messages |
| Token expiry | Medium | Auto-refresh, handle gracefully |
| Network issues | Medium | Offline support for critical features |
| Security breach | Critical | Secure storage, HTTPS, input validation |

### Business Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Low adoption | Medium | User testing, feedback loops |
| Poor performance | High | Performance monitoring, optimization |
| High churn | Medium | Analytics, user feedback |

---

## Future Enhancements

### Potential Features

1. **Offline Mode**
   - Download lessons for offline viewing
   - Full offline course access

2. **Social Features**
   - Course reviews/ratings
   - Discussion forums
   - Social sharing

3. **Gamification**
   - Achievement badges
   - Learning streaks
   - Leaderboards

4. **Push Notifications**
   - Lesson reminders
   - New course announcements
   - Progress updates

5. **Payment Integration**
   - In-app payments
   - Multiple payment gateways
   - Subscription plans

---

## Conclusion

This project plan provides a comprehensive roadmap for building the PrivateTutor application. Following the architecture patterns, feature breakdown, and implementation guidelines will result in a maintainable, scalable, and user-friendly application.

**Next Steps:**
1. Review and approve this plan
2. Start Phase 1: Foundation
3. Follow PHASE_CHECKLIST.md for progress tracking
4. Update documentation as needed

---

**Document Version:** 1.0
**Last Updated:** 2026-04-04
**Status:** Ready for Development
