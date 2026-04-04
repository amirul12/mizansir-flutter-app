# Debug Print Guide - Understanding API Requests & Responses

## User Flow After Login

1. **Login** → User enters credentials
2. **Login Success** → Navigate to `/` (home page)
3. **Home Page** → Checks authentication
4. **If Authenticated** → Auto-redirect to `/courses`
5. **Courses Page** → Loads data from API

---

## What You'll See in Debug Console

### 🔵🟡 API Requests (Blue/Yellow Icons)
All API calls are printed before sending:

```
🟡 LOGIN REQUEST
URL: https://ict.mizansir.com/api/v1/auth/login
Body: {"email":"user@example.com","password":"***","device_name":"iPhone 13"}

🔵 GET COURSES REQUEST
URL: https://ict.mizansir.com/api/v1/courses?page=1&limit=20
Headers: {"Content-Type": "application/json"}
```

### 🟢 API Responses (Green Icons)
All API responses are printed when received:

```
🟢 LOGIN RESPONSE
Status Code: 200
Response Body: {"success":true,"data":{"token":"...","user":{...}}}
✅ Login successful! Token saved.

🟢 GET COURSES RESPONSE
Status Code: 200
Response Body: {"success":true,"data":[{...},{...}]}
✅ Successfully parsed 10 courses
```

### ❌ Errors (Red Icons)
Any errors are clearly marked:

```
❌ Unauthorized: 401
❌ Not Found: 404
❌ Exception: Network error
```

---

## Complete Debug Flow Example

### 1. Login Flow
```dart
// User clicks login button
🟡 LOGIN REQUEST
URL: https://ict.mizansir.com/api/v1/auth/login
Body: {"email":"test@example.com","password":"password123","device_name":"iPhone"}

// Server responds
🟢 LOGIN RESPONSE
Status Code: 200
Response Body: {"success":true,"data":{"token":"eyJ0eXAiOi...","user":{"id":"1","name":"Test User"}}}
✅ Login successful! Token saved.

// Navigate to home, check auth
🟡 GET CURRENT USER REQUEST
URL: https://ict.mizansir.com/api/v1/auth/user
Authorization: Bearer eyJ0eXAiOi...

// User data loaded
🟢 GET CURRENT USER RESPONSE
Status Code: 200
Response Body: {"success":true,"data":{"id":"1","name":"Test User","email":"test@example.com"}}
✅ User data loaded successfully
```

### 2. Load Courses Flow
```dart
// Redirect to courses page
🔵 GET COURSES REQUEST
URL: https://ict.mizansir.com/api/v1/courses?page=1&limit=20
Headers: {"Content-Type": "application/json"}

// Server responds with courses
🟢 GET COURSES RESPONSE
Status Code: 200
Response Body: {"success":true,"data":[
  {"id":"1","title":"Mathematics 101","description":"Learn basic math",...},
  {"id":"2","title":"Physics for Beginners","description":"Introduction to physics",...},
  ...
]}
✅ Successfully parsed 15 courses
```

### 3. Load Categories Flow
```dart
// Categories page loads
🔵 GET CATEGORIES REQUEST
URL: https://ict.mizansir.com/api/v1/courses/categories

// Server responds
🟢 GET CATEGORIES RESPONSE
Status Code: 200
Response Body: {"success":true,"data":[
  {"id":"1","name":"Mathematics","icon":"calculate","color":"#4CAF50"},
  {"id":"2","name":"Science","icon":"science","color":"#2196F3"},
  ...
]}
✅ Successfully parsed 5 categories
```

### 4. Search Flow
```dart
// User searches for "math"
🔵 SEARCH COURSES REQUEST
URL: https://ict.mizansir.com/api/v1/courses/search?q=math&page=1&limit=20

// Results returned
🟢 SEARCH COURSES RESPONSE
Status Code: 200
Response Body: {"success":true,"data":[
  {"id":"1","title":"Mathematics 101",...},
  {"id":"5","title":"Advanced Math",...}
]}
✅ Successfully parsed 2 courses
```

---

## Understanding Response Structure

### Success Response
```json
{
  "success": true,
  "data": {
    // Actual data here
  }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error message here",
  "errors": {
    // Validation errors
  }
}
```

---

## API Endpoints (All with /v1/ prefix)

### Authentication
- `POST /v1/auth/login` - Login
- `POST /v1/auth/register` - Register
- `GET /v1/auth/user` - Get current user

### Public Courses
- `GET /v1/courses` - List all courses
- `GET /v1/courses/featured` - Featured courses
- `GET /v1/courses/search` - Search courses
- `GET /v1/courses/{id}` - Course details
- `GET /v1/courses/{id}/lessons` - Preview lessons
- `GET /v1/courses/categories` - Categories

### Protected (Requires Auth)
- `GET /v1/my-courses` - Enrolled courses
- `GET /v1/my-courses/{id}/lessons` - Full lessons
- `POST /v1/enrollments` - Create enrollment

---

## Common Debug Patterns

### ✅ Working Correctly
```
🔵 REQUEST
🟢 RESPONSE (200)
✅ Success message
```

### ❌ Authentication Error
```
🟡 REQUEST
🟢 RESPONSE (401)
❌ Unauthorized: 401
```

### ❌ Network Error
```
🔵 REQUEST
❌ Exception: NetworkException
```

### ❌ Server Error
```
🔵 REQUEST
🟢 RESPONSE (500)
❌ Error: 500
```

---

## Tips for Debugging

1. **Look for the emoji icons** to quickly identify request/response flow
2. **Check Status Code** - 200 is good, 401 is auth error, 500 is server error
3. **Read Response Body** - Shows actual data or error message from server
4. **Check URL** - Make sure `/v1/` prefix is present
5. **Verify Token** - For protected endpoints, check Authorization header

---

## Example: Troubleshooting No Data

If you see no courses:

1. **Check if login succeeded:**
   ```
   🟢 LOGIN RESPONSE
   Status Code: 200
   ✅ Login successful! Token saved.
   ```

2. **Check if courses request was made:**
   ```
   🔵 GET COURSES REQUEST
   URL: https://ict.mizansir.com/api/v1/courses?page=1&limit=20
   ```

3. **Check what server returned:**
   ```
   🟢 GET COURSES RESPONSE
   Status Code: 200
   Response Body: {"success":true,"data":[]}
   ```
   If `data:[]` - server has no courses (empty database)

4. **Check if parsing worked:**
   ```
   ✅ Successfully parsed 0 courses
   ```
   This confirms no courses in database

---

## Next Steps

1. **Run the app**
2. **Open Debug Console** (Flutter console/logs)
3. **Login with your credentials**
4. **Watch the debug prints** to understand the flow
5. **Check API responses** to see if data is coming from server

All API calls are now fully logged! 🎉
