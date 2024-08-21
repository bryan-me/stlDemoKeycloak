import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:oauth2_test/dynamicforms/model/form_model.dart';
import 'package:oauth2_test/screens/bottomnav.dart';
import 'package:oauth2_test/tokenmanager.dart';
import 'package:oauth2_test/widgets/internet_status.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();


class ApplicationHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

// void main() async {
//   HttpOverrides.global = ApplicationHttpOverrides();
//   await Hive.initFlutter();

//   Hive.registerAdapter(FormModelAdapter());
//   Hive.registerAdapter(FormDetailAdapter());
//   Hive.registerAdapter(FieldOptionAdapter());


//   Logger.root.onRecord.listen((record) {
//     if (kReleaseMode) {
//       print('[${record.level.name}] ${record.time}: ${record.message}');
//     }
//   });
//   WidgetsFlutterBinding.ensureInitialized();
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   runApp(DemoApp());
// }

void main() async {
  HttpOverrides.global = ApplicationHttpOverrides();
  await Hive.initFlutter();

    HttpOverrides.global = ApplicationHttpOverrides();


  Hive.registerAdapter(FormModelAdapter());
  Hive.registerAdapter(FormDetailAdapter());
  Hive.registerAdapter(FieldOptionAdapter());

  Logger.root.onRecord.listen((record) {
    if (kReleaseMode) {
      print('[${record.level.name}] ${record.time}: ${record.message}');
    }
  });

  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'STL Notification Demo'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final logger = Logger('$_MyHomePageState');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    _loadSavedCredentials();
  }

    Future<void> _loadSavedCredentials() async {
    final credentials = await retrieveCredentials();
    if (credentials['username'] != null && credentials['password'] != null) {
      _usernameController.text = credentials['username']!;
      _passwordController.text = credentials['password']!;
    }
  }

  Future<void> storeCredentials(String username, String password) async {
    await secureStorage.write(key: 'username', value: username);
    await secureStorage.write(key: 'password', value: password);
  }

  Future<Map<String, String?>> retrieveCredentials() async {
    String? username = await secureStorage.read(key: 'username');
    String? password = await secureStorage.read(key: 'password');
    print("");
    return {'username': username, 'password': password};
  }

Future<bool> isConnectedToNetwork() async {
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.mobile || 
      connectivityResult == ConnectivityResult.wifi) {
    // Connected to a mobile network or Wi-Fi
    return true;
  } else {
    // Not connected to any network
    return false;
  }
}

  Future<void> createClient() async {
    final tokenEndpoint = Uri.parse(
        'http://192.168.250.209:8070/auth/realms/Push/protocol/openid-connect/token');
    final clientId = 'frontend';
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final tokenResponse = await http.post(
        tokenEndpoint,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'client_id': clientId,
          'username': username,
          'password': password,
        },
      );
      

      print('Token response: ${tokenResponse.body}');
      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'];
      final refreshToken = tokenData['refresh_token'];
      final decodedToken = JwtDecoder.decode(accessToken);
      final sub = decodedToken['sub'];

      if (accessToken != null && accessToken.isNotEmpty) {
        setState(() {
          TokenManager.setTokens(accessToken, refreshToken, sub);
        });

        print('Access token: $accessToken');
        print('Session State: $sub');
        print('Decoded Token: $decodedToken');

        logger.info('Login successful for user $username');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation()
            // ChatterScreen(
            //   token: accessToken,
            //   username: decodedToken['preferred_username'],
            //   email: decodedToken['email'],
            //   sub: sub,
            // ),
          ),
        );
      } else {
        throw Exception('Access token is empty');
      }
    } catch (e) {
      print('Error during token exchange: $e');
      setState(() {
        // TokenManager.clearTokens();
      });
      throw Exception('Failed to obtain access token');
    }
  }

  Future<void> login() async {
    if (await isConnectedToNetwork()) {
      // Online login
      try {
        await createClient();
      } catch (e) {
        print('Error during login: $e');
      }
    } else {
      // Offline login
      final credentials = await retrieveCredentials();
      if (credentials['username'] == _usernameController.text &&
          credentials['password'] == _passwordController.text) {
        // Allow offline access
        final lastAccessToken = await secureStorage.read(key: 'access_token');
        final lastRefreshToken = await secureStorage.read(key: 'refresh_token');
        final lastSub = await secureStorage.read(key: 'sub');

        if (lastAccessToken != null && lastRefreshToken != null && lastSub != null) {
          setState(() {
            TokenManager.setTokens(lastAccessToken, lastRefreshToken, lastSub);
          });

          logger.info('Offline login successful for user ${credentials['username']}');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
          );
        } else {
          print('No valid tokens available for offline use');
        }
      } else {
        print('No stored credentials or invalid credentials');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.blue,
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 20,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Check internet status
                    InternetStatusWidget(),
                      Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.blue.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.blue.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: login,
                      // () async {
                      //   print('Login button pressed');
                      //   try {
                          
                      //     // await createClient();
                      //   } catch (e) {
                      //     print('Error during login: $e');
                      //   }
                      // },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue.shade800,
                      ),
                    ),],
                ),
              ),
            ),
          ),
        ));
  }
}
