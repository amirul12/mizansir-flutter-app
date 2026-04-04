# PrivateTutor - Phase Checklist

> **Last Updated:** 2026-04-04
> **Current Phase:** Phase 0 - Analysis & Planning
> **Project Status:** Planning Complete

---

## How to Use This Checklist

### Legend

- `[ ]` - Not started
- `[~]` - In progress
- `[x]` - Completed
- `[!]` - Blocked

### Rules

1. **Complete all items in a phase** before moving to the next phase
2. **Update the checklist** as you complete each task
3. **Mark blockers** immediately with `[!]` and notes
4. **Add tasks** if you discover missing items
5. **Review with senior architect** before proceeding to next phase

---

## Phase 0: Analysis & Planning ✅

**Status:** COMPLETED
**Duration:** Completed
**Goal:** Understand requirements, analyze API, define architecture

### Analysis Tasks

- [x] Inspect reference project structure (time_blocking_app)
- [x] Analyze reference project architecture patterns
- [x] Document reference project conventions (BLoC, DI, routing)
- [x] Analyze Postman API collection
- [x] Document all API endpoints
- [x] Identify all features from API collection
- [x] Create CLAUDE.md with architecture rules
- [x] Create PROJECT_PLAN.md with feature breakdown
- [x] Create PHASE_CHECKLIST.md (this file)
- [x] Create API_MAPPING.md with endpoint mapping

### Documentation Review

- [x] CLAUDE.md reviewed and approved
- [x] PROJECT_PLAN.md reviewed and approved
- [x] PHASE_CHECKLIST.md created
- [x] API_MAPPING.md created

### Sign-off

- [x] Architecture decisions finalized
- [x] Tech stack finalized
- [x] Development phases defined
- [x] Ready to proceed to Phase 1

### Notes

Completed comprehensive analysis of reference project and API collection. All documentation created. Ready to begin implementation.

---

## Phase 1: Foundation

**Status:** NOT STARTED
**Estimated Duration:** 2-3 days
**Goal:** Set up project infrastructure and core services

### 1.1 Project Setup

- [ ] Update pubspec.yaml with all required dependencies
- [ ] Remove default Flutter demo code
- [ ] Create folder structure (core/, features/)
- [ ] Create all feature folders (auth/, course_browsing/, etc.)
- [ ] Set up asset folders (images/, icons/, fonts/)
- [ ] Configure analysis_options.yaml
- [ ] Run `flutter pub get` to verify dependencies

### 1.2 Core Constants

- [ ] Create `lib/core/constants/api_constants.dart`
  - [ ] Base URL
  - [ ] API version
  - [ ] Endpoints
  - [ ] Timeout values
- [ ] Create `lib/core/constants/app_constants.dart`
  - [ ] App name, version
  - [ ] Pagination defaults
  - [ ] App settings
- [ ] Create `lib/core/constants/storage_constants.dart`
  - [ ] Storage keys
  - [ ] Token keys
  - [ ] User data keys

### 1.3 Core Services

#### API Service

- [ ] Create `lib/core/services/api_service.dart`
  - [ ] HTTP client setup
  - [ ] GET method
  - [ ] POST method
  - [ ] PUT method
  - [ ] DELETE method
  - [ ] Error handling
  - [ ] Timeout handling

#### Token Service

- [ ] Create `lib/core/services/token_service.dart`
  - [ ] Save access token
  - [ ] Get access token
  - [ ] Save refresh token
  - [ ] Clear tokens
  - [ ] Check token validity
  - [ ] Secure storage integration

#### Connectivity Service

- [ ] Create `lib/core/services/connectivity_service.dart`
  - [ ] Check connectivity
  - [ ] Connectivity stream
  - [ ] Offline detection

#### Storage Service

- [ ] Create `lib/core/services/storage_service.dart`
  - [ ] Save string
  - [ ] Get string
  - [ ] Remove key
  - [ ] Clear all

### 1.4 Error Handling

- [ ] Create `lib/core/errors/exceptions.dart`
  - [ ] ServerException
  - [ ] NetworkException
  - [ ] UnauthorizedException
  - [ ] NotFoundException
  - [ ] CacheException
- [ ] Create `lib/core/errors/failures.dart`
  - [ ] ServerFailure
  - [ ] NetworkFailure
  - [ ] UnauthorizedFailure
  - [ ] NotFoundFailure
  - [ ] CacheFailure
  - [ ] ValidationFailure

### 1.5 Theme & Styling

- [ ] Create `lib/core/theme/app_colors.dart`
  - [ ] Primary colors
  - [ ] Secondary colors
  - [ ] Error/success colors
  - [ ] Neutral colors
- [ ] Create `lib/core/theme/app_text_styles.dart`
  - [ ] Headings
  - [ ] Body text
  - [ ] Captions
  - [ ] Button text
- [ ] Create `lib/core/theme/app_theme.dart`
  - [ ] Light theme
  - [ ] Dark theme (optional)
  - [ ] Material theme config

### 1.6 Routing

- [ ] Create `lib/core/router/app_router.dart`
  - [ ] Initialize go_router
  - [ ] Define route names
  - [ ] Create basic route structure
  - [ ] Add 404/error route
  - [ ] Add shell route (for bottom nav if needed)
- [ ] Create navigation constants
- [ ] Create route guards (placeholder)

### 1.7 Dependency Injection

- [ ] Create `lib/core/di/injection_container.dart`
  - [ ] Initialize GetIt
  - [ ] Register core services
  - [ ] Create `_initCore()` method
  - [ ] Create feature registration methods (placeholders)
- [ ] Initialize DI in main.dart
- [ ] Test DI registration

### 1.8 Shared Widgets

- [ ] Create `lib/core/widgets/loading_widget.dart`
  - [ ] Centered CircularProgressIndicator
  - [ ] Custom styling
- [ ] Create `lib/core/widgets/error_widget.dart`
  - [ ] Error message display
  - [ ] Retry button
  - [ ] Icon/illustration
- [ ] Create `lib/core/widgets/empty_widget.dart`
  - [ ] Empty state message
  - [ ] Illustration/icon
  - [ ] Action button (optional)
- [ ] Create `lib/core/widgets/custom_app_bar.dart`
  - [ ] Consistent app bar
  - [ ] Back button
  - [ ] Actions

### 1.9 Core Use Cases

- [ ] Create `lib/core/usecases/no_params.dart`
  - [ ] NoParams class for use cases without parameters

### 1.10 App Bootstrap

- [ ] Update `lib/main.dart`
  - [ ] Initialize widgets binding
  - [ ] Initialize dependency injection
  - [ ] Initialize services
  - [ ] Set up error handling
  - [ ] Configure theme
  - [ ] Set up router
- [ ] Test app launch
- [ ] Verify no errors on startup

### 1.11 Testing

- [ ] Test app builds successfully
- [ ] Test on iOS simulator
- [ ] Test on Android emulator
- [ ] Verify folder structure
- [ ] Verify DI registration
- [ ] Verify router navigation

### Definition of Done

- [ ] All core services implemented
- [ ] Router configured with basic routes
- [ ] DI container set up and working
- [ ] Theme system in place
- [ ] Shared widgets created
- [ ] App builds and runs without errors
- [ ] Can navigate between placeholder screens
- [ ] Code reviewed against CLAUDE.md rules

---

## Phase 2: Authentication

**Status:** NOT STARTED
**Estimated Duration:** 3-4 days
**Goal:** Complete authentication flow

### 2.1 Domain Layer

#### Entities

- [ ] Create `lib/features/auth/domain/entities/auth_user.dart`
  - [ ] id, name, email, phone, avatar, etc.
- [ ] Create `lib/features/auth/domain/entities/session.dart`
  - [ ] token, device, lastActive, etc.

#### Repository Interface

- [ ] Create `lib/features/auth/domain/repositories/auth_repository.dart`
  - [ ] login method
  - [ ] register method
  - [ ] getCurrentUser method
  - [ ] logout method
  - [ ] logoutAll method
  - [ ] refreshToken method
  - [ ] changePassword method
  - [ ] getActiveSessions method

#### Use Cases

- [ ] Create `lib/features/auth/domain/usecases/login_usecase.dart`
- [ ] Create `lib/features/auth/domain/usecases/register_usecase.dart`
- [ ] Create `lib/features/auth/domain/usecases/get_current_user_usecase.dart`
- [ ] Create `lib/features/auth/domain/usecases/logout_usecase.dart`
- [ ] Create `lib/features/auth/domain/usecases/logout_all_usecase.dart`
- [ ] Create `lib/features/auth/domain/usecases/refresh_token_usecase.dart`
- [ ] Create `lib/features/auth/domain/usecases/change_password_usecase.dart`
- [ ] Create `lib/features/auth/domain/usecases/get_active_sessions_usecase.dart`

### 2.2 Data Layer

#### Models

- [ ] Create `lib/features/auth/data/models/auth_user_model.dart`
- [ ] Create `lib/features/auth/data/models/auth_response_model.dart`
- [ ] Create `lib/features/auth/data/models/session_model.dart`
- [ ] Add JSON serialization (json_serializable)
- [ ] Add toEntity() methods

#### Data Sources

- [ ] Create `lib/features/auth/data/datasources/auth_remote_datasource.dart` (interface)
- [ ] Create `lib/features/auth/data/datasources/auth_remote_datasource_impl.dart`
  - [ ] login API call
  - [ ] register API call
  - [ ] getUser API call
  - [ ] logout API call
  - [ ] logoutAll API call
  - [ ] refreshToken API call
  - [ ] changePassword API call
  - [ ] getActiveSessions API call
- [ ] Create `lib/features/auth/data/datasources/auth_local_datasource.dart` (interface)
- [ ] Create `lib/features/auth/data/datasources/auth_local_datasource_impl.dart`
  - [ ] cacheToken method
  - [ ] getCachedToken method
  - [ ] clearToken method
  - [ ] cacheUser method
  - [ ] getCachedUser method
  - [ ] clearUser method

#### Repository Implementation

- [ ] Create `lib/features/auth/data/repositories/auth_repository_impl.dart`
  - [ ] Implement all interface methods
  - [ ] Handle exceptions and convert to failures
  - [ ] Use remote data source for API calls
  - [ ] Use local data source for caching

### 2.3 Presentation Layer

#### BLoC

- [ ] Create `lib/features/auth/presentation/bloc/auth_event.dart`
  - [ ] LoginRequested event
  - [ ] RegisterRequested event
  - [ ] CheckAuthStatus event
  - [ ] LogoutRequested event
  - [ ] LogoutAllRequested event
  - [ ] RefreshTokenRequested event
  - [ ] ChangePasswordRequested event
  - [ ] GetActiveSessionsRequested event
- [ ] Create `lib/features/auth/presentation/bloc/auth_state.dart`
  - [ ] AuthInitial state
  - [ ] AuthLoading state
  - [ ] AuthAuthenticated state
  - [ ] AuthUnauthenticated state
  - [ ] AuthError state
  - [ ] AuthSessionsLoaded state
- [ ] Create `lib/features/auth/presentation/bloc/auth_bloc.dart`
  - [ ] Implement all event handlers
  - [ ] Use appropriate use cases
  - [ ] Handle errors
  - [ ] Emit appropriate states

#### Pages

- [ ] Create `lib/features/auth/presentation/pages/login_page.dart`
  - [ ] Email field
  - [ ] Password field
  - [ ] Login button
  - [ ] Navigate to register
  - [ ] Form validation
  - [ ] Show loading/error states
- [ ] Create `lib/features/auth/presentation/pages/register_page.dart`
  - [ ] Name field
  - [ ] Email field
  - [ ] Phone field
  - [ ] Password field
  - [ ] Confirm password field
  - [ ] Register button
  - [ ] Navigate to login
  - [ ] Form validation
  - [ ] Show loading/error states

#### Widgets

- [ ] Create `lib/features/auth/presentation/widgets/login_form.dart`
- [ ] Create `lib/features/auth/presentation/widgets/register_form.dart`
- [ ] Create `lib/features/auth/presentation/widgets/password_field.dart` (show/hide)

### 2.4 DI Registration

- [ ] Create `_initAuth()` method in DI container
- [ ] Register AuthBloc as factory
- [ ] Register all use cases as lazySingleton
- [ ] Register AuthRepository as lazySingleton
- [ ] Register data sources as lazySingleton

### 2.5 Router Integration

- [ ] Add /login route
- [ ] Add /register route
- [ ] Add auth guard for protected routes
- [ ] Redirect unauthenticated users to login
- [ ] Redirect authenticated users to dashboard

### 2.6 Token Management

- [ ] Save token on successful login
- [ ] Include token in API requests
- [ ] Auto-refresh token on expiry
- [ ] Clear token on logout
- [ ] Handle 401 responses (token expired)

### 2.7 Testing

- [ ] Test registration flow
- [ ] Test login flow
- [ ] Test logout flow
- [ ] Test token refresh
- [ ] Test auth guards
- [ ] Test protected route access
- [ ] Test error scenarios

### Definition of Done

- [ ] User can register successfully
- [ ] User can login successfully
- [ ] Token stored securely
- [ ] Protected routes require authentication
- [ ] Auto-logout on token expiry
- [ ] Auth state persists across app restarts
- [ ] All auth methods working (logout, logout all, refresh, etc.)
- [ ] Form validation working
- [ ] Error handling complete
- [ ] Code reviewed against CLAUDE.md rules

---

## Phase 3: Public Course Browsing

**Status:** NOT STARTED
**Estimated Duration:** 4-5 days
**Goal:** Browse and search courses without authentication

### 3.1 Domain Layer

#### Entities

- [ ] Create `lib/features/course_browsing/domain/entities/course.dart`
- [ ] Create `lib/features/course_browsing/domain/entities/category.dart`
- [ ] Create `lib/features/course_browsing/domain/entities/lesson_preview.dart`
- [ ] Create `lib/features/course_browsing/domain/entities/course_filter.dart`

#### Repository Interface

- [ ] Create `lib/features/course_browsing/domain/repositories/course_repository.dart`
  - [ ] getCourses method
  - [ ] getFeaturedCourses method
  - [ ] getCourseDetails method
  - [ ] searchCourses method
  - [ ] getCategories method
  - [ ] getPreviewLessons method

#### Use Cases

- [ ] Create getCoursesUseCase
- [ ] Create getFeaturedCoursesUseCase
- [ ] Create getCourseDetailsUseCase
- [ ] Create searchCoursesUseCase
- [ ] Create getCategoriesUseCase
- [ ] Create getPreviewLessonsUseCase

### 3.2 Data Layer

#### Models

- [ ] Create CourseModel
- [ ] Create CategoryModel
- [ ] Create LessonPreviewModel
- [ ] Add JSON serialization

#### Data Sources

- [ ] Create CourseRemoteDataSource interface
- [ ] Create CourseRemoteDataSourceImpl
  - [ ] API calls for all course endpoints

#### Repository Implementation

- [ ] Create CourseRepositoryImpl
  - [ ] Implement all methods
  - [ ] Handle errors

### 3.3 Presentation Layer

#### BLoC

- [ ] Create CourseBloc
  - [ ] Events: LoadCourses, LoadFeatured, Search, LoadFilters
  - [ ] States: Loading, Loaded, Error, Empty

#### Pages

- [ ] Create CoursesPage (list with filters)
- [ ] Create CourseDetailsPage
- [ ] Create CourseSearchPage
- [ ] Create CategoriesPage

#### Widgets

- [ ] Create CourseCard widget
- [ ] Create CourseFilterWidget
- [ ] Create CategoryChip
- [ ] Create LessonPreviewItem

### 3.4 Features

- [ ] Pagination for course list
- [ ] Pull-to-refresh
- [ ] Search with debouncing
- [ ] Filter by category, price, status
- [ ] Sort by price, date, popularity
- [ ] Course detail view with preview lessons
- [ ] Featured courses section

### 3.5 Router

- [ ] Add /courses route
- [ ] Add /courses/:id route
- [ ] Add /courses/search route
- [ ] Add /categories route

### Definition of Done

- [ ] User can browse all courses
- [ ] Search and filter working
- [ ] Course details display correctly
- [ ] Preview lessons accessible
- [ ] Pagination works
- [ ] Pull-to-refresh works
- [ ] Featured courses shown
- [ ] Categories displayed
- [ ] Code reviewed

---

## Phase 4: Student Learning Area

**Status:** NOT STARTED
**Estimated Duration:** 4-5 days
**Goal:** Access enrolled courses and track progress

### 4.1 Domain Layer

#### Entities

- [ ] Create Lesson entity
- [ ] Create LessonProgress entity
- [ ] Create CourseProgress entity

#### Repository Interface

- [ ] Create LessonRepository
  - [ ] getMyCourses
  - [ ] getCourseLessons
  - [ ] getLessonDetails
  - [ ] markComplete
  - [ ] markIncomplete
  - [ ] updateProgress
  - [ ] getCourseProgress

#### Use Cases

- [ ] Create all lesson-related use cases

### 4.2 Data Layer

#### Models & Data Sources

- [ ] Create LessonModel
- [ ] Create LessonProgressModel
- [ ] Create LessonRemoteDataSource

#### Repository Implementation

- [ ] Create LessonRepositoryImpl

### 4.3 Presentation Layer

#### BLoC

- [ ] Create LessonBloc
- [ ] Create ProgressBloc

#### Pages

- [ ] Create MyCoursesPage
- [ ] Create CourseLessonsPage
- [ ] Create LessonPlayerPage
- [ ] Create CourseProgressPage

#### Widgets

- [ ] Create LessonCard (with progress)
- [ ] Create ProgressBar widget
- [ ] Create VideoPlayer widget

### 4.4 Features

- [ ] List enrolled courses
- [ ] Show lesson progress
- [ ] Play video lessons
- [ ] Mark complete/incomplete
- [ ] Track watch time
- [ ] Calculate progress percentage
- [ ] Auto-play next lesson

### Definition of Done

- [ ] Enrolled students can access lessons
- [ ] Progress tracking works
- [ ] Completion status updates
- [ ] Progress percentage accurate
- [ ] Video player works
- [ ] Code reviewed

---

## Phase 5: Enrollments

**Status:** NOT STARTED
**Estimated Duration:** 3-4 days
**Goal:** Manage course enrollments

### 5.1 Domain Layer

#### Entities

- [ ] Create Enrollment entity
- [ ] Create EnrollmentStats entity
- [ ] Create PaymentInfo entity

#### Repository & Use Cases

- [ ] Create EnrollmentRepository
- [ ] Create all enrollment use cases

### 5.2 Data Layer

- [ ] Create EnrollmentModel
- [ ] Create EnrollmentRemoteDataSource
- [ ] Create EnrollmentRepositoryImpl

### 5.3 Presentation Layer

#### BLoC

- [ ] Create EnrollmentBloc

#### Pages

- [ ] Create MyEnrollmentsPage
- [ ] Create EnrollmentDetailsPage
- [ ] Create EnrollmentPaymentPage

### 5.4 Features

- [ ] List all enrollments
- [ ] Create enrollment with payment
- [ ] Show enrollment details
- [ ] Show enrollment statistics
- [ ] Renew enrollment
- [ ] Cancel enrollment
- [ ] Payment method selection

### Definition of Done

- [ ] User can enroll in courses
- [ ] Enrollment history visible
- [ ] Renewal flow works
- [ ] Cancellation works
- [ ] Statistics accurate
- [ ] Code reviewed

---

## Phase 6: Profile & Dashboard

**Status:** NOT STARTED
**Estimated Duration:** 3-4 days
**Goal:** User profile and activity tracking

### 6.1 Domain Layer

#### Entities

- [ ] Create UserProfile entity
- [ ] Create Activity entity
- [ ] Create DashboardStats entity

#### Repository & Use Cases

- [ ] Create ProfileRepository
- [ ] Create DashboardRepository
- [ ] Create all use cases

### 6.2 Data Layer

- [ ] Create Models
- [ ] Create DataSources
- [ ] Create RepositoryImpl

### 6.3 Presentation Layer

#### BLoC

- [ ] Create ProfileBloc
- [ ] Create DashboardBloc

#### Pages

- [ ] Create DashboardPage
- [ ] Create ProfilePage
- [ ] Create AvatarUploadPage
- [ ] Create ChangePasswordPage
- [ ] Create ActivityPage
- [ ] Create DeleteAccountPage

### 6.4 Features

- [ ] Display dashboard stats
- [ ] Show recent activity
- [ ] View/edit profile
- [ ] Upload avatar
- [ ] Change password
- [ ] Delete account with confirmation

### Definition of Done

- [ ] Profile data displays correctly
- [ ] Updates work
- [ ] Avatar upload works
- [ ] Dashboard shows relevant data
- [ ] Activity log works
- [ ] Code reviewed

---

## Phase 7: Polish

**Status:** NOT STARTED
**Estimated Duration:** 2-3 days
**Goal:** Improve UX/UI and handle edge cases

### 7.1 Loading States

- [ ] Add loading indicators everywhere needed
- [ ] Add skeleton screens
- [ ] Smooth transitions

### 7.2 Empty States

- [ ] Empty course list
- [ ] Empty enrollment list
- [ ] Empty lesson list
- [ ] Empty activity

### 7.3 Error States

- [ ] Network error
- [ ] Server error
- [ ] Not found error
- [ ] Unauthorized error
- [ ] Retry mechanism

### 7.4 Form Validation

- [ ] All forms validated
- [ ] Clear error messages
- [ ] Real-time validation
- [ ] Input masks (phone, etc.)

### 7.5 Session Management

- [ ] Auto-logout on token expiry
- [ ] Show session expiry dialog
- [ ] Auto-refresh token
- [ ] Handle multiple sessions

### 7.6 Consistency

- [ ] Consistent styling
- [ ] Consistent navigation
- [ ] Consistent error handling
- [ ] Consistent loading patterns

### Definition of Done

- [ ] No missing states
- [ ] Consistent UI/UX
- [ ] Good error messages
- [ ] Smooth loading
- [ ] Form validation works
- [ ] Session management solid
- [ ] Code reviewed

---

## Phase 8: QA & Final Documentation

**Status:** NOT STARTED
**Estimated Duration:** 2-3 days
**Goal:** Final review and documentation

### 8.1 Architecture Review

- [ ] Check layer separation
- [ ] Check dependency direction
- [ ] Check BLoC usage
- [ ] Check naming conventions
- [ ] Check file organization

### 8.2 API Coverage

- [ ] All endpoints implemented
- [ ] All use cases tested
- [ ] Error handling complete
- [ ] Token management working

### 8.3 Code Cleanup

- [ ] Remove commented code
- [ ] Remove unused imports
- [ ] Remove debug prints
- [ ] Format code
- [ ] Run lints

### 8.4 Documentation

- [ ] Update CLAUDE.md if needed
- [ ] Update PROJECT_PLAN.md if needed
- [ ] Update API_MAPPING.md if needed
- [ ] Finalize CHANGELOG.md
- [ ] Add inline code comments

### 8.5 Testing

- [ ] Manual testing on all flows
- [ ] Test on iOS
- [ ] Test on Android
- [ ] Test error scenarios
- [ ] Test offline scenarios

### 8.6 Performance

- [ ] Check app launch time
- [ ] Check list scroll performance
- [ ] Check image loading
- [ ] Check memory usage

### Definition of Done

- [ ] All documented features work
- [ ] No dead code
- [ ] Documentation up to date
- [ ] No critical bugs
- [ ] Performance acceptable
- [ ] Ready for production

---

## Summary

### Total Phases: 9
### Completed Phases: 1 (Phase 0)
### Remaining Phases: 8

### Progress

- [x] Phase 0: Analysis & Planning
- [ ] Phase 1: Foundation
- [ ] Phase 2: Authentication
- [ ] Phase 3: Public Course Browsing
- [ ] Phase 4: Student Learning Area
- [ ] Phase 5: Enrollments
- [ ] Phase 6: Profile & Dashboard
- [ ] Phase 7: Polish
- [ ] Phase 8: QA & Final Documentation

---

## Notes

Use this checklist to track progress. Update items as you complete them. Mark blockers with `[!]` and add notes. Do not skip phases or move ahead without completing current phase.

**Remember:** Quality over speed. Build it right the first time.

---

**Last Updated:** 2026-04-04
**Current Status:** Ready to start Phase 1
