# Refresh Token Implementation

This document explains the refresh token implementation in the VDM Mobile application.

## Overview

The application now includes a comprehensive refresh token system that automatically handles token expiration and renewal. This ensures users don't get logged out unexpectedly when their access tokens expire.

## Key Components

### 1. Data Models

#### `RefreshTokenRequest`
- Used to send refresh token requests to the server
- Contains the stored refresh token

#### `RefreshTokenResponse`
- Response from the server containing new access and refresh tokens
- Handles both `refresh_token` and `refreshToken` field names for compatibility

#### `LoginResponse` (Updated)
- Now includes `refreshToken` field alongside the existing `token` field
- Stores refresh token during login for future use

### 2. Data Sources

#### `AuthRemoteDataSource`
- Added `refreshToken(RefreshTokenRequest request)` method
- Sends refresh token requests to `/auth/refresh` endpoint

#### `AuthLocalDataSource`
- Added `cacheRefreshToken(String refreshToken)` method
- Added `getRefreshToken()` method
- Updated `clearAuthData()` to also clear refresh token

### 3. Repository Layer

#### `AuthRepository`
- Added `refreshToken()` method for manual token refresh
- Added `getRefreshToken()` method to retrieve stored refresh token

#### `AuthRepositoryImpl`
- Implements refresh token logic with proper error handling
- Caches both new access and refresh tokens after successful refresh
- Handles network connectivity checks

### 4. Use Cases

#### `RefreshAuthToken`
- Use case for manual token refresh operations
- Returns `Either<Failure, void>` indicating success or failure

#### `GetRefreshToken`
- Use case to retrieve stored refresh token
- Useful for debugging or manual operations

### 5. BLoC Layer

#### `AuthBloc`
- Added `RefreshTokenRequested` event
- Added `AuthTokenRefreshed` state
- Handles refresh token operations with proper state management

#### Events
- `RefreshTokenRequested`: Triggers manual token refresh

#### States
- `AuthTokenRefreshed`: Indicates successful token refresh
- `AuthError`: Indicates refresh failure with error message

### 6. API Client Integration

#### Automatic Token Refresh
The `ApiClient` automatically handles token refresh when:
- A request receives a 401 (Unauthorized) response
- The request is not already a refresh token request
- A valid refresh token is available

#### Features
- **Request Queuing**: Multiple requests are queued during token refresh
- **Automatic Retry**: Failed requests are automatically retried with new tokens
- **Error Handling**: Proper cleanup when refresh fails
- **Thread Safety**: Prevents multiple simultaneous refresh operations

### 7. Configuration

#### App Constants
- `refreshTokenKey`: Storage key for refresh tokens
- `refreshTokenEndpoint`: API endpoint for token refresh (`/auth/refresh`)

## Usage Examples

### Manual Token Refresh

```dart
// Using BLoC
context.read<AuthBloc>().add(RefreshTokenRequested());

// Using Use Case directly
final refreshAuthToken = sl<RefreshAuthToken>();
final result = await refreshAuthToken(NoParams());
result.fold(
  (failure) => print('Refresh failed: ${failure.message}'),
  (_) => print('Token refreshed successfully'),
);
```

### Using the Token Refresh Helper

```dart
final helper = TokenRefreshHelper(dio, sharedPreferences);

// Check if tokens are valid
final hasTokens = await helper.hasValidTokens();

// Manually refresh tokens
final success = await helper.refreshToken();

// Clear all tokens
await helper.clearAllTokens();
```

### Using the Token Refresh Button Widget

```dart
// Add to any screen for testing
TokenRefreshButton(text: 'Refresh My Token')
```

## API Endpoint Requirements

The server must implement the following endpoint:

### POST /auth/refresh

**Request Body:**
```json
{
  "refresh_token": "your_refresh_token_here"
}
```

**Success Response (200):**
```json
{
  "data": {
    "token": "new_access_token",
    "refresh_token": "new_refresh_token",
    "type": "Bearer"
  }
}
```

**Error Response (401):**
```json
{
  "error": "Invalid refresh token"
}
```

## Storage

Tokens are stored securely using SharedPreferences:
- Access Token: `auth_token`
- Refresh Token: `refresh_token`
- User Data: `current_user`

## Error Handling

The system handles various error scenarios:

1. **Network Errors**: Proper error messages for connectivity issues
2. **Invalid Refresh Token**: Automatic logout and token cleanup
3. **Server Errors**: Graceful degradation with error messages
4. **Concurrent Requests**: Queuing system prevents race conditions

## Security Considerations

1. **Token Storage**: Tokens are stored in SharedPreferences (consider encryption for production)
2. **Automatic Cleanup**: All tokens are cleared on refresh failure
3. **Request Queuing**: Prevents token refresh race conditions
4. **Error Handling**: No sensitive information leaked in error messages

## Testing

To test the refresh token functionality:

1. **Login**: Login with valid credentials
2. **Wait for Expiration**: Wait for access token to expire (or manually invalidate it)
3. **Make API Call**: Any API call should automatically trigger token refresh
4. **Manual Refresh**: Use the `TokenRefreshButton` widget for manual testing

## Troubleshooting

### Common Issues

1. **Refresh Token Not Working**: Check if the server endpoint `/auth/refresh` is implemented correctly
2. **Tokens Not Stored**: Verify SharedPreferences permissions and storage keys
3. **Automatic Refresh Failing**: Check network connectivity and server response format
4. **Multiple Refresh Attempts**: The system prevents this automatically with the `_isRefreshing` flag

### Debug Information

Enable debug logging in `ApiClient` to see:
- Token refresh attempts
- Request queuing
- Error handling
- Successful token updates

## Future Enhancements

Potential improvements for the future:

1. **Token Encryption**: Encrypt tokens before storing in SharedPreferences
2. **Refresh Token Rotation**: Implement refresh token rotation for enhanced security
3. **Background Refresh**: Proactively refresh tokens before expiration
4. **Analytics**: Track token refresh success/failure rates
5. **Biometric Authentication**: Integrate with biometric auth for sensitive operations

