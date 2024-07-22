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




import 'dart:io';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:oauth2_test/chatterscreen.dart';
import 'package:oauth2_test/weather_forecast_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

ChopperClient? chopperClient;

class ApplicationHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

void main() {
  HttpOverrides.global = ApplicationHttpOverrides();

  Logger.root.onRecord.listen((record) {
    if (kReleaseMode) {
      print('[${record.level.name}] ${record.time}: ${record.message}');
    }
  });
WidgetsFlutterBinding.ensureInitialized();
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
      home: ChatterScreen(),
      // MyHomePage(title: 'STL Notification Demo'),
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
String _token = '';
  // Future<Response<List<Map<dynamic, dynamic>>>>? _allWeatherForecasts;

  @override
  void initState() {
    super.initState();

    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  /// Either load an OAuth2 client from saved credentials or authenticate a new
  /// one.
  Future<oauth2.Client> createClient() async {
    final redirectUri = Uri.parse('com.example.demo2:/callback');
    final clientId = 'frontend';
    // final secret = 'eca09a20-27db-4141-8976-33886e3eecf8';
    final authorizationEndpoint = Uri.parse(
        'http://192.168.250.209:8070/auth/realms/Push/protocol/openid-connect/auth?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=openid');
    final tokenEndpoint = Uri.parse(
        '$authorizationEndpoint/protocol/openid-connect/token');
    

    var grant = oauth2.AuthorizationCodeGrant(
      clientId,
      authorizationEndpoint,
      tokenEndpoint,
      // secret: secret,
    );

    var authorizationUrl = grant.getAuthorizationUrl(redirectUri);

    Uri? responseUrl;

    await Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) {
              return SafeArea(
                child: Container(
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: authorizationUrl.toString(),
                    navigationDelegate: (navigationRequest) {
                      if (navigationRequest.url
                          .startsWith(redirectUri.toString())) {
                        responseUrl = Uri.parse(navigationRequest.url);
                        print('Response URL: $responseUrl}');
                        Navigator.pop(context);
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                //     navigationDelegate: (navigationRequest) {
                //   if (navigationRequest.url.startsWith(redirectUri.toString())) {
                //     responseUrl = Uri.parse(navigationRequest.url);
                //     print('Response URL: $responseUrl}');
                //     Navigator.of(context).pop(); // Ensure to pop the navigator stack properly
                //     return NavigationDecision.prevent;
                //   }
                //   return NavigationDecision.navigate;
                // },
                  ),
                ),
              );
            }));

    // Extract the authorization code from the redirect URI
      final code = responseUrl!.queryParameters['code'];

       if (code != null) {
      try {
        final tokenResponse = await http.post(
          Uri.parse('$authorizationUrl/protocol/openid-connect/token'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'grant_type': 'authorization_code',
            'code': code,
            'redirect_uri': redirectUri.toString(),
            'client_id': clientId,
            // 'client_secret': clientSecret,
          },
        );

        final tokenData = json.decode(tokenResponse.body);
        final token = tokenData['access_token'];

        setState(() {
          _token = token ?? '';
        });

        if (_token.isNotEmpty) {
          final decodedToken = JwtDecoder.decode(_token);
          print('Token: $_token');
          print('Decoded Token: $decodedToken');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatterScreen()),
          );
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _token = '';
          
        });
      }
    } else {
      throw Exception('Authorization code is null');
      
    }
      throw Exception('Authorization code is null');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
        child: Text('Login with Keycloak'),
        onPressed: () async {
          final httpClient = await createClient();

          // chopperClient = ChopperClient(
          //   client: httpClient,
          //   baseUrl: Uri.parse('https://10.0.2.2:5001'),
          //   converter: JsonConverter(),
          //   services: [
          //     WeatherForecastService.create(),
          //   ],
          // );

          // final weatherForecastService =
          //     chopperClient!.getService<WeatherForecastService>();
          // setState(() {
          //   _allWeatherForecasts =
          //       weatherForecastService.getAllWeatherForecasts();
          //   print('Weather forecasts: $_allWeatherForecasts');
          // });
        },
      ),
      )
    );
  }
}