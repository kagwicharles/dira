import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'dart:math';

class GitHubService {
  static const String _clientId = 'Ov23li9dnYpVhfeAAvCL';
  static const String _redirectUri = 'dira://callback';

  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'github_access_token';
  static const String _userKey = 'github_user_data';
  static const String _stateKey = 'github_oauth_state';

  StreamSubscription? _linkSubscription;
  final _appLinks = AppLinks();
  bool _isListenerInitialized = false;

  void _log(String message, {String level = 'INFO'}) {
    final timestamp = DateTime.now().toIso8601String();
    developer.log(
      message,
      time: DateTime.now(),
      name: 'GitHubService',
      level: level == 'ERROR' ? 1000 : 0,
    );
    print('[$timestamp] [GitHubService] [$level] $message');
  }

  String _generateState() {
    _log('Generating OAuth state for CSRF protection');
    try {
      final random = Random.secure();
      final values = List<int>.generate(32, (i) => random.nextInt(256));
      final state = base64Url.encode(values);
      _log('State generated successfully: ${state.substring(0, 10)}...');
      return state;
    } catch (e) {
      _log('Failed to generate state: $e', level: 'ERROR');
      rethrow;
    }
  }

  Future<void> initDeepLinkListener({
    required Function(String token, Map<String, dynamic> user) onSuccess,
    required Function(String error) onError,
  }) async {
    if (_isListenerInitialized) {
      _log('Deep link listener already initialized, skipping');
      return;
    }
    _log('Initializing deep link listener');
    try {
      await _linkSubscription?.cancel();
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          _log('📱 Deep link received: $uri');
          _log('  - Scheme: ${uri.scheme}');
          _log('  - Host: ${uri.host}');
          _log('  - Path: ${uri.path}');
          _log('  - Query parameters: ${uri.queryParameters}');

          final expectedScheme = _redirectUri.split('://')[0];
          if (uri.scheme == expectedScheme) {
            _log('✅ Scheme matches expected: $expectedScheme');
            _handleCallback(uri, onSuccess, onError);
          } else {
            _log(
              '⚠️ Scheme mismatch! Expected: $expectedScheme, Got: ${uri.scheme}',
              level: 'ERROR',
            );
          }
        },
        onError: (err) {
          _log('❌ Link stream error: $err', level: 'ERROR');
          _log('Error type: ${err.runtimeType}');
          onError('Failed to handle deep link: $err');
        },
      );

      _log('Deep link stream listener attached successfully');
      _log('Checking for initial link (app was closed scenario)');
      final initialUri = await _appLinks.getInitialLink();

      if (initialUri != null) {
        _log('🔗 Initial link found: $initialUri');
        if (initialUri.scheme == _redirectUri.split('://')[0]) {
          _log('Processing initial link callback');
          _handleCallback(initialUri, onSuccess, onError);
        }
      } else {
        _log('No initial link found');
      }

      _isListenerInitialized = true;
      _log('Deep link listener initialization completed successfully');
    } catch (e, stackTrace) {
      _log('💥 Failed to initialize deep link listener: $e', level: 'ERROR');
      _log('Stack trace: $stackTrace', level: 'ERROR');
      onError('Failed to initialize deep link listener: $e');
    }
  }

  Future<String> startOAuthFlow() async {
    _log('Starting OAuth flow');

    try {
      final state = _generateState();
      _log('Saving state to secure storage');
      await _storage.write(key: _stateKey, value: state);

      final savedState = await _storage.read(key: _stateKey);
      if (savedState == state) {
        _log('State saved successfully to secure storage');
      } else {
        _log('⚠️ State save verification failed!', level: 'ERROR');
      }

      const scope = 'user repo';
      final authUrl =
          'https://github.com/login/oauth/authorize'
          '?client_id=$_clientId'
          '&redirect_uri=$_redirectUri'
          '&scope=$scope'
          '&state=$state';

      _log('OAuth URL generated:');
      _log('  - Client ID: $_clientId');
      _log('  - Redirect URI: $_redirectUri');
      _log('  - Scope: $scope');
      _log('  - State: ${state.substring(0, 10)}...');

      return authUrl;
    } catch (e, stackTrace) {
      _log('Failed to start OAuth flow: $e', level: 'ERROR');
      _log('Stack trace: $stackTrace', level: 'ERROR');
      rethrow;
    }
  }

  Future<void> _handleCallback(
    Uri uri,
    Function(String token, Map<String, dynamic> user) onSuccess,
    Function(String error) onError,
  ) async {
    _log('🔄 Processing OAuth callback');
    _log('Callback URI: $uri');

    try {
      final code = uri.queryParameters['code'];
      final state = uri.queryParameters['state'];
      final error = uri.queryParameters['error'];
      final errorDescription = uri.queryParameters['error_description'];

      _log('Callback parameters:');
      _log(
        '  - code: ${code != null ? "${code.substring(0, 10)}..." : "null"}',
      );
      _log(
        '  - state: ${state != null ? "${state.substring(0, 10)}..." : "null"}',
      );
      _log('  - error: $error');

      if (error != null) {
        final errorMsg =
            'GitHub authorization failed: $error${errorDescription != null ? " - $errorDescription" : ""}';
        _log('❌ $errorMsg', level: 'ERROR');
        onError(errorMsg);
        return;
      }

      if (code == null) {
        _log('❌ No authorization code received', level: 'ERROR');
        onError('No authorization code received');
        return;
      }

      _log('Reading saved state from secure storage');
      final savedState = await _storage.read(key: _stateKey);

      if (savedState == null) {
        _log('❌ No saved state found in storage', level: 'ERROR');
        onError('Invalid state - no saved state found');
        return;
      }

      if (state != savedState) {
        _log('❌ State mismatch - possible CSRF attack!', level: 'ERROR');
        onError('Invalid state parameter - possible CSRF attack');
        return;
      }

      _log('✅ State verification passed');

      _log('Exchanging authorization code for access token');
      final token = await _exchangeCodeForToken(code);
      _log('✅ Access token received');

      _log('Fetching user data from GitHub');
      final userData = await _fetchUserData(token);
      _log('✅ User data fetched: ${userData['login']}');

      _log('Saving credentials to secure storage');
      await _saveCredentials(token, userData);
      _log('✅ Credentials saved successfully');

      _log('Cleaning up state from storage');
      await _storage.delete(key: _stateKey);

      _log('🎉 GitHub authentication completed successfully!');

      onSuccess(token, userData);
    } catch (e, stackTrace) {
      _log('💥 Failed to complete GitHub authentication: $e', level: 'ERROR');
      _log('Stack trace: $stackTrace', level: 'ERROR');
      onError('Failed to complete GitHub authentication: $e');
    }
  }

  Future<String> _exchangeCodeForToken(String code) async {
    _log('Exchanging code for token');
    try {
      final response = await http
          .post(
            Uri.parse('https://github.com/login/oauth/access_token'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'client_id': _clientId,
              'code': code,
              'redirect_uri': _redirectUri,
            }),
          )
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              _log('⏱️ Token exchange request timed out', level: 'ERROR');
              throw TimeoutException('Token exchange request timed out');
            },
          );
      _log('Response status code: ${response.statusCode}');
      if (response.statusCode != 200) {
        _log(
          '❌ Token exchange failed with status ${response.statusCode}',
          level: 'ERROR',
        );
        _log('Response body: ${response.body}');
        throw Exception('Failed to exchange code for token: ${response.body}');
      }
      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        _log('❌ GitHub API error: ${data['error']}', level: 'ERROR');
        throw Exception(
          'GitHub error: ${data['error_description'] ?? data['error']}',
        );
      }
      if (data['access_token'] == null) {
        _log('❌ No access token in response', level: 'ERROR');
        throw Exception('No access token received from GitHub');
      }
      _log('✅ Access token successfully obtained');
      return data['access_token'];
    } catch (e, stackTrace) {
      _log('💥 Token exchange failed: $e', level: 'ERROR');
      _log('Stack trace: $stackTrace', level: 'ERROR');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _fetchUserData(String token) async {
    _log('Fetching user data from GitHub API');

    try {
      final response = await http
          .get(
            Uri.parse('https://api.github.com/user'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/vnd.github.v3+json',
            },
          )
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              _log('⏱️ User data fetch request timed out', level: 'ERROR');
              throw TimeoutException('User data fetch timed out');
            },
          );

      _log('User data response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        _log(
          '❌ Failed to fetch user data: ${response.statusCode}',
          level: 'ERROR',
        );
        throw Exception('Failed to fetch user data: ${response.body}');
      }

      final userData = jsonDecode(response.body);
      _log('✅ User data retrieved successfully');
      _log('User: ${userData['login']}');

      return userData;
    } catch (e, stackTrace) {
      _log('💥 Failed to fetch user data: $e', level: 'ERROR');
      _log('Stack trace: $stackTrace', level: 'ERROR');
      rethrow;
    }
  }

  Future<void> _saveCredentials(
    String token,
    Map<String, dynamic> userData,
  ) async {
    _log('Saving credentials to secure storage');

    try {
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _userKey, value: jsonEncode(userData));
      _log('✅ Credentials saved successfully');
    } catch (e, stackTrace) {
      _log('💥 Failed to save credentials: $e', level: 'ERROR');
      _log('Stack trace: $stackTrace', level: 'ERROR');
      rethrow;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      _log('Failed to retrieve access token: $e', level: 'ERROR');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userData = await _storage.read(key: _userKey);
      if (userData == null) return null;
      return jsonDecode(userData);
    } catch (e) {
      _log('Failed to retrieve user data: $e', level: 'ERROR');
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await getAccessToken();
      if (token == null) return false;

      await _fetchUserData(token);
      return true;
    } catch (e) {
      _log('Token validation failed: $e', level: 'ERROR');
      await logout();
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchRepositories({
    int page = 1,
    int perPage = 30,
    String sort = 'updated',
  }) async {
    final token = await getAccessToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http
        .get(
          Uri.parse(
            'https://api.github.com/user/repos?page=$page&per_page=$perPage&sort=$sort',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/vnd.github.v3+json',
          },
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch repositories: ${response.body}');
    }

    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }

  Future<void> logout() async {
    _log('Logging out - clearing all credentials');

    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
      await _storage.delete(key: _stateKey);
      _log('✅ Logout completed successfully');
    } catch (e, stackTrace) {
      _log('Failed to logout: $e', level: 'ERROR');
      _log('Stack trace: $stackTrace', level: 'ERROR');
      rethrow;
    }
  }

  void dispose() {
    _log('Disposing GitHubService');
    _linkSubscription?.cancel();
    _isListenerInitialized = false;
  }
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);

  @override
  String toString() => message;
}
