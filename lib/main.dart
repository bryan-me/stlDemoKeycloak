// import 'dart:io';

// import 'package:chopper/chopper.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';
// import 'package:oauth2/oauth2.dart' as oauth2;
// import 'package:oauth2_test/weather_forecast_service.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// ChopperClient? chopperClient;

// class ApplicationHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (_, __, ___) => true;
//   }
// }

// void main() {
//   HttpOverrides.global = ApplicationHttpOverrides();

//   Logger.root.onRecord.listen((record) {
//     if (kReleaseMode) {
//       print('[${record.level.name}] ${record.time}: ${record.message}');
//     }
//   });

//   runApp(WeatherForecastApplication());
// }

// class WeatherForecastApplication extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter with OAuth 2'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final logger = Logger('$_MyHomePageState');

//   late Future<Response<List<Map<dynamic, dynamic>>>> _allWeatherForecasts;

//   @override
//   void initState() {
//     super.initState();

//     // Enable hybrid composition.
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   /// Either load an OAuth2 client from saved credentials or authenticate a new
//   /// one.
//   Future<oauth2.Client> createClient() async {
//     final authorizationEndpoint = Uri.parse(
//         'http://localhost:8080/auth/realms/master/protocol/openid-connect/auth');
//     final tokenEndpoint = Uri.parse(
//         'http://10.0.2.2:8090/auth/realms/master/protocol/openid-connect/token');

//     // The authorization server will issue each client a separate client
//     // identifier and secret, which allows the server to tell which client
//     // is accessing it. Some servers may also have an anonymous
//     // identifier/secret pair that any client may use.
//     //
//     // Note that clients whose source code or binary executable is readily
//     // available may not be able to make sure the client secret is kept a
//     // secret. This is fine; OAuth2 servers generally won't rely on knowing
//     // with certainty that a client is who it claims to be.
//     final identifier = 'push-messenger';
//     final secret = 'Av73kRD2iPeKdnZ3VWbLt1e3rgSmFlkU';

//     // This is a URL on your application's server. The authorization server
//     // will redirect the resource owner here once they've authorized the
//     // client. The redirection will include the authorization code in the
//     // query parameters.
//     final redirectUrl = Uri.parse('http://10.0.2.2:4180/oauth2/callback');

//     var grant = oauth2.AuthorizationCodeGrant(
//       identifier,
//       authorizationEndpoint,
//       tokenEndpoint,
//       secret: secret,
//     );

//     // A URL on the authorization server (authorizationEndpoint with some additional
//     // query parameters). Scopes and state can optionally be passed into this method.
//     var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);

//     Uri? responseUrl;

//     await Navigator.push(
//         context,
//         MaterialPageRoute(
//             fullscreenDialog: true,
//             builder: (_) {
//               // Redirect the resource owner to the authorization URL. Once the resource
//               // owner has authorized, they'll be redirected to `redirectUrl` with an
//               // authorization code. The `redirect` should cause the browser to redirect to
//               // another URL which should also have a listener.
//               return SafeArea(
//                 child: Container(
//                   child: WebView(
//                     javascriptMode: JavascriptMode.unrestricted,
//                     initialUrl: authorizationUrl.toString(),
//                     navigationDelegate: (navigationRequest) {
//                       if (navigationRequest.url
//                           .startsWith(redirectUrl.toString())) {
//                         responseUrl = Uri.parse(navigationRequest.url);
//                         print('Response URL: $responseUrl}');
//                         Navigator.pop(context);
//                         return NavigationDecision.prevent;
//                       }
//                       return NavigationDecision.navigate;
//                     },
//                   ),
//                 ),
//               );
//             }));

//     // Ensure responseUrl is not null before proceeding
//     if (responseUrl != null) {
//       // Once the user is redirected to `redirectUrl`, pass the query parameters to
//       // the AuthorizationCodeGrant. It will validate them and extract the
//       // authorization code to create a new Client.
//       return grant.handleAuthorizationResponse(responseUrl!.queryParameters);
//     } else {
//       throw Exception('Response URL is null');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: FutureBuilder<Response<List<Map>>>(
//         future: _allWeatherForecasts,
//         builder: (_, weatherForecastsSnapshot) {
//           print('Weather forecasts snapshot: $weatherForecastsSnapshot');

//           if (weatherForecastsSnapshot.connectionState !=
//                   ConnectionState.done ||
//               !weatherForecastsSnapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator.adaptive(),
//             );
//           }

//           if (weatherForecastsSnapshot.hasError) {
//             logger.warning(weatherForecastsSnapshot.error);

//             return Center(
//               child: Text(
//                   'Unfortunately, an error has happened and will be needed to try another time.'),
//             );
//           }

//           final weatherForecasts = weatherForecastsSnapshot.data!.body;
//           return ListView.builder(
//             itemCount: weatherForecasts!.length,
//             itemBuilder: (_, int index) {
//               final weatherForecast = weatherForecasts[index];
//               final date = DateTime.tryParse(weatherForecast['date']);

//               return ListTile(
//                 title: Text('${weatherForecast['summary']}'),
//                 subtitle: Text('${date!.day}/${date.month}'),
//                 trailing: Text(
//                   '${weatherForecast['temperatureC']} °C',
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.https),
//         onPressed: () async {
//           final httpClient = await createClient();

//           chopperClient = ChopperClient(
//             client: httpClient,
//             baseUrl: Uri.parse('https://10.0.2.2:5001'),
//             converter: JsonConverter(),
//             services: [
//               WeatherForecastService.create(),
//             ],
//           );

//           final weatherForecastService =
//               chopperClient!.getService<WeatherForecastService>();
//           setState(() {
//             _allWeatherForecasts =
//                 weatherForecastService.getAllWeatherForecasts();
//             print('Weather forecasts: $_allWeatherForecasts');
//           });
//         },
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'dart:convert';
// import 'package:chopper/chopper.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';
// import 'package:http/http.dart' as http;
// import 'package:oauth2/oauth2.dart' as oauth2;
// import 'package:oauth2_test/chatterscreen.dart';
// import 'package:oauth2_test/weather_forecast_service.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

// ChopperClient? chopperClient;

// class ApplicationHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (_, __, ___) => true;
//   }
// }

// void main() {
//   HttpOverrides.global = ApplicationHttpOverrides();

//   Logger.root.onRecord.listen((record) {
//     if (kReleaseMode) {
//       print('[${record.level.name}] ${record.time}: ${record.message}');
//     }
//   });
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(WeatherForecastApplication());
// }

// class WeatherForecastApplication extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'STL Notification Demo'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final logger = Logger('$_MyHomePageState');
//   String _token = '';

//   @override
//   void initState() {
//     super.initState();

//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   Future<oauth2.Client> createClient() async {
//     final redirectUri = Uri.parse('com.example.demo2:/callback');
//     final clientId = 'frontend';
//     final authorizationEndpoint = Uri.parse(
//         'http://192.168.250.209:8070/auth/realms/Push/protocol/openid-connect/auth?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=openid');
//     final tokenEndpoint = Uri.parse(
//         'http://192.168.250.209:8070/auth/realms/Push/protocol/openid-connect/token');

//     var grant = oauth2.AuthorizationCodeGrant(
//       clientId,
//       authorizationEndpoint,
//       tokenEndpoint,
//     );

//     var authorizationUrl = grant.getAuthorizationUrl(redirectUri);

//     Uri? responseUrl;

//     await Navigator.push(
//         context,
//         MaterialPageRoute(
//             fullscreenDialog: true,
//             builder: (_) {
//               return SafeArea(
//                 child: Container(
//                   child: WebView(
//                     javascriptMode: JavascriptMode.unrestricted,
//                     initialUrl: authorizationUrl.toString(),
//                     navigationDelegate: (navigationRequest) {
//                       if (navigationRequest.url.startsWith(redirectUri.toString())) {
//                         responseUrl = Uri.parse(navigationRequest.url);
//                         Navigator.pop(context);
//                         return NavigationDecision.prevent;
//                       }
//                       return NavigationDecision.navigate;
//                     },
//                   ),
//                 ),
//               );
//             }));

//     final code = responseUrl?.queryParameters['code'];

//     if (code != null) {
//       try {
//         final tokenResponse = await http.post(
//           Uri.parse(tokenEndpoint.toString()),
//           headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//           body: {
//             'grant_type': 'authorization_code',
//             'code': code,
//             'redirect_uri': redirectUri.toString(),
//             'client_id': clientId,
//           },
//         );

//         final tokenData = json.decode(tokenResponse.body);
//         final token = tokenData['access_token'];

//         setState(() {
//           _token = token ?? '';
//         });

//         if (_token.isNotEmpty) {
//           final decodedToken = JwtDecoder.decode(_token);
//           print('Token: $_token');
//           print('Decoded Token: $decodedToken');

//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ChatterScreen()),
//           );
//         }
//       } catch (e) {
//         print('Error: $e');
//         setState(() {
//           _token = '';
//         });
//       }
//     } else {
//       throw Exception('Authorization code is null');
//     }

//     throw Exception('Authorization code is null');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Login with Keycloak'),
//           onPressed: () async {
//             final httpClient = await createClient();
//           },
//         ),
//       ),
//     );
//   }
// }

// THIS WORKS BUT THERES A PROBLEM WITH THE TOKEN EXCAHNGE
// import 'dart:io';
// import 'dart:convert';
// import 'package:chopper/chopper.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';
// import 'package:http/http.dart' as http;
// import 'package:oauth2/oauth2.dart' as oauth2;
// import 'package:oauth2_test/chatterscreen.dart';
// import 'package:oauth2_test/weather_forecast_service.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

// ChopperClient? chopperClient;

// class ApplicationHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (_, __, ___) => true;
//   }
// }

// void main() {
//   HttpOverrides.global = ApplicationHttpOverrides();

//   Logger.root.onRecord.listen((record) {
//     if (kReleaseMode) {
//       print('[${record.level.name}] ${record.time}: ${record.message}');
//     }
//   });
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(WeatherForecastApplication());
// }

// class WeatherForecastApplication extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'STL Notification Demo'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final logger = Logger('$_MyHomePageState');
//   String _token = '';

//   @override
//   void initState() {
//     super.initState();

//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   Future<oauth2.Client> createClient() async {
//     final redirectUri = Uri.parse('com.example.demo2:/callback');
//     final clientId = 'frontend';
//     final authorizationEndpoint = Uri.parse(
//         'http://192.168.250.209:8070/auth/realms/Push/protocol/openid-connect/auth?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=openid');
//     final tokenEndpoint = Uri.parse(
//         'http://192.168.250.209:8070/auth/realms/Push/protocol/openid-connect/token');

//     var grant = oauth2.AuthorizationCodeGrant(
//       clientId,
//       authorizationEndpoint,
//       tokenEndpoint,
//     );

//     var authorizationUrl = grant.getAuthorizationUrl(redirectUri);

//     Uri? responseUrl;

//     await Navigator.push(
//         context,
//         MaterialPageRoute(
//             fullscreenDialog: true,
//             builder: (_) {
//               return SafeArea(
//                 child: Container(
//                   child: WebView(
//                     javascriptMode: JavascriptMode.unrestricted,
//                     initialUrl: authorizationUrl.toString(),
//                     navigationDelegate: (navigationRequest) {
//                       if (navigationRequest.url.startsWith(redirectUri.toString())) {
//                         responseUrl = Uri.parse(navigationRequest.url);
//                         Navigator.pop(context);
//                         return NavigationDecision.prevent;
//                       }
//                       return NavigationDecision.navigate;
//                     },
//                   ),
//                 ),
//               );
//             }));

//     if (responseUrl != null) {
//       print('Response URL: $responseUrl');
//       final code = responseUrl?.queryParameters['code'];
//       print('Authorization code: $code');

//       if (code != null) {
//         try {
//           final tokenResponse = await http.post(
//             Uri.parse(tokenEndpoint.toString()),
//             headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//             body: {
//               'grant_type': 'authorization_code',
//               'code': code,
//               'redirect_uri': redirectUri.toString(),
//               'client_id': clientId,
//             },
//           );

//           print('Token response: ${tokenResponse.body}');
//           final tokenData = json.decode(tokenResponse.body);
//           final token = tokenData['access_token'];
//           print('Access token: $token');

//           if (token != null && token.isNotEmpty) {
//             setState(() {
//               _token = token;
//             });

//             final decodedToken = JwtDecoder.decode(_token);
//             print('Decoded Token: $decodedToken');

//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ChatterScreen()),
//             );

//             return grant.handleAuthorizationResponse(responseUrl!.queryParameters); // Return the client here
//           } else {
//             throw Exception('Access token is empty');
//           }
//         } catch (e) {
//           print('Error during token exchange: $e');
//           setState(() {
//             _token = '';
//           });
//           throw Exception('Failed to obtain access token');
//         }
//       } else {
//         throw Exception('Authorization code is null');
//       }
//     } else {
//       throw Exception('Response URL is null');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Login with Keycloak'),
//           onPressed: () async {
//             try {
//               final httpClient = await createClient();
//               // Proceed with your authenticated client
//             } catch (e) {
//               print('Error during login: $e');
//               // Handle login error appropriately
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// // import 'dart:math';
// // import 'package:crypto/crypto.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';
// import 'package:oauth2_test/chatterscreen.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

// class ApplicationHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (_, __, ___) => true;
//   }
// }

// void main() {
//   HttpOverrides.global = ApplicationHttpOverrides();

//   Logger.root.onRecord.listen((record) {
//     if (kReleaseMode) {
//       print('[${record.level.name}] ${record.time}: ${record.message}');
//     }
//   });
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(WeatherForecastApplication());
// }

// class WeatherForecastApplication extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'STL Notification Demo'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final logger = Logger('$_MyHomePageState');
//   String _token = '';
//   // late String _codeVerifier;
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   Future<void> createClient() async {
//     final tokenEndpoint = Uri.parse(
//         'http://192.168.250.209:8070/auth/realms/Push/protocol/openid-connect/token');
//     final clientId = 'frontend';
//     final username = _usernameController.text;
//     final password = _passwordController.text;

//     try {
//       final tokenResponse = await http.post(
//         tokenEndpoint,
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: {
//           'grant_type': 'password',
//           'client_id': clientId,
//           'username': username,
//           'password': password,
//         },
//       );

//       print('Token response: ${tokenResponse.body}');
//       final tokenData = json.decode(tokenResponse.body);
//       final token = tokenData['access_token'];
//       print('Access token: $token');

//       if (token != null && token.isNotEmpty) {
//         setState(() {
//           _token = token;
//         });

//         final decodedToken = JwtDecoder.decode(_token);
//         print('Decoded Token: $decodedToken');

//         // Log a successful login message
//         logger.info('Login successful for user $username');

//        Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatterScreen(
//             token: _token,
//             username: decodedToken['preferred_username'],
//             email: decodedToken['email'],
//           ),
//         ),
//       );
//       } else {
//         throw Exception('Access token is empty');
//       }
//     } catch (e) {
//       print('Error during token exchange: $e');
//       setState(() {
//         _token = '';
//       });
//       throw Exception('Failed to obtain access token');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               child: Text('Login with Keycloak'),
//               onPressed: () async {
//                 try {
//                   await createClient();
//                   // Proceed with your authenticated client
//                 } catch (e) {
//                   print('Error during login: $e');
//                   // Handle login error appropriately
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:oauth2_test/chatterscreen.dart';
import 'package:oauth2_test/screens/form_screen.dart';
import 'package:oauth2_test/widgets/dynamic_form.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Global Token Manager
class TokenManager {
  static String? accessToken;
  static String? refreshToken;
  static String? sub;

  static void setTokens(String access, String refresh, String sub) {
    accessToken = access;
    refreshToken = refresh;
    sub = sub;
  }

  static void clearTokens() {
    accessToken = null;
    refreshToken = null;
    sub = null;
  }
}

class ApplicationHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

void main() async {
  HttpOverrides.global = ApplicationHttpOverrides();

  Logger.root.onRecord.listen((record) {
    if (kReleaseMode) {
      print('[${record.level.name}] ${record.time}: ${record.message}');
    }
  });
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(WeatherForecastApplication());
}

class WeatherForecastApplication extends StatelessWidget {
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
            builder: (context) => ChatterScreen(
              token: accessToken,
              username: decodedToken['preferred_username'],
              email: decodedToken['email'],
              sub: sub,
            ),
          ),
        );
      } else {
        throw Exception('Access token is empty');
      }
    } catch (e) {
      print('Error during token exchange: $e');
      setState(() {
        TokenManager.clearTokens();
      });
      throw Exception('Failed to obtain access token');
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
                      onPressed: () async {
                        try {
                          await createClient();
                        } catch (e) {
                          print('Error during login: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue.shade800,
                      ),
                    ),
                    // ElevatedButton(
                    //   child: Text('Login with Keycloak'),
                    //   onPressed: () async {
                    //     try {
                    //       await createClient();
                    //     } catch (e) {
                    //       print('Error during login: $e');
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
