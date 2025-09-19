# 📱 VDM Mobile - API Debug Guide

## 🔧 Debug Features Added

### 1. **Enhanced API Logging**
- ✅ Complete request/response logging in debug mode
- ✅ Error details with full stack traces
- ✅ Token management logging
- ✅ Network connectivity diagnostics

### 2. **Debug Information Widget**
- ✅ Shows API endpoints and configuration
- ✅ Displays connection timeouts
- ✅ Only visible in debug mode
- ✅ Located on login screen

### 3. **Network Diagnostics**
- ✅ Automatic connectivity test on app startup
- ✅ Server reachability check
- ✅ Endpoint validation

## 📋 How to Test APIs on Mobile Device

### **Step 1: Install Debug APK**
```bash
flutter install --debug
# or
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### **Step 2: Enable Developer Options**
1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times
3. Go back to **Settings** → **Developer Options**
4. Enable **USB Debugging**

### **Step 3: View Debug Logs**
```bash
# Connect device via USB and run:
adb logcat | grep -E "(🌐|🚀|✅|❌|🔐|👥|📤|📥|🔍|💡)"

# Or filter by Flutter:
flutter logs
```

## 🔍 Debug Information Available

### **Console Logs to Watch For:**

#### **App Startup**
```
🚀 Starting VDM Mobile App...
🔧 === API ENDPOINTS TEST ===
📍 Base URL: http://185.105.90.34/api
🔑 Login URL: http://185.105.90.34/api/auth/login
👥 Users URL: http://185.105.90.34/api/users
```

#### **Network Connectivity**
```
🌐 === NETWORK DIAGNOSTICS ===
🔍 Testing connection to: 185.105.90.34:80
✅ Successfully connected to 185.105.90.34:80
🌐 Network appears to be working correctly
```

#### **Login Process**
```
🔑 Attempting login with username: admin
🚀 API Request: POST http://185.105.90.34/api/auth/login
📤 Request Data: {username: admin, password: admin123}
✅ API Response: 200 /auth/login
📥 Response Data: {success: true, message: Muvaffaqiyatli kirdingiz, ...}
🔐 Auth State Changed: AuthAuthenticated
✅ Authentication successful, navigating to main
```

#### **Users Loading**
```
👥 UsersPage: Loading users...
🚀 API Request: GET http://185.105.90.34/api/users
📋 Request Headers: {Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...}
✅ API Response: 200 /users
📥 Response Data: {success: true, data: [...]}
👥 UsersBloc State: UsersLoaded
```

#### **Error Cases**
```
❌ API Error: SocketException: Failed host lookup
🔍 Error Details: No address associated with hostname
📍 Request URL: http://185.105.90.34/api/auth/login
💡 Possible issues:
   - Server is down
   - Network connectivity issues
   - Firewall blocking the connection
```

## 🐛 Troubleshooting Common Issues

### **1. Network Connection Issues**
**Symptoms:** App shows network errors, can't reach server
**Solutions:**
- Check if device is connected to internet
- Try accessing `http://185.105.90.34/api/auth/login` in mobile browser
- Check if server is accessible from your network
- Disable VPN if using one

### **2. API Authentication Issues**
**Symptoms:** 401 Unauthorized errors
**Solutions:**
- Check if credentials are correct (admin/admin123)
- Clear app data: Settings → Apps → VDM Mobile → Storage → Clear Data
- Check if server is running and accepting requests

### **3. CORS Issues (if testing on web)**
**Symptoms:** CORS policy errors in browser console
**Solutions:**
- Use mobile device instead of web browser
- Server needs to allow CORS for web testing

### **4. Timeout Issues**
**Symptoms:** Request timeout errors
**Solutions:**
- Check network speed
- Increase timeout in `AppConstants` if needed
- Server might be slow to respond

## 📊 API Endpoints Being Used

| Endpoint | Method | Purpose | Headers Required |
|----------|--------|---------|------------------|
| `/auth/login` | POST | User authentication | Content-Type: application/json |
| `/users` | GET | Fetch users list | Authorization: Bearer {token} |

## 🔧 Debug Controls

### **On Login Screen:**
- **Debug Info Panel:** Shows API configuration
- **Enhanced Error Messages:** More detailed error information
- **Console Logging:** All API calls logged to console

### **On Users Screen:**
- **Pull to Refresh:** Reload users with logging
- **Retry Button:** Retry failed requests with logging
- **State Logging:** All BLoC state changes logged

## 📱 Testing Steps

1. **Install the debug APK** on your mobile device
2. **Open the app** - check console for startup diagnostics
3. **Try to login** with admin/admin123 - watch API logs
4. **Navigate to users** - check if users load correctly
5. **Test error cases** - disconnect internet and retry
6. **Check logs** using `flutter logs` or `adb logcat`

## 🎯 Expected Behavior

### **Successful Flow:**
1. App starts → Network diagnostics run
2. Login screen appears → Debug info visible
3. Enter credentials → Login API called
4. Authentication successful → Navigate to main screen
5. Users screen loads → Users API called with token
6. Users displayed → Success!

### **Error Handling:**
- Network errors show user-friendly messages
- API errors display detailed information
- Token expiration automatically clears auth data
- Retry mechanisms available on all screens

---

**🔍 Need Help?**
- Check console logs first
- Look for emoji indicators in logs (🚀, ✅, ❌, etc.)
- All API requests/responses are logged in detail
- Network diagnostics run automatically on startup
