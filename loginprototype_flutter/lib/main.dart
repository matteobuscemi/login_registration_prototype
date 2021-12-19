import 'package:flutter/material.dart';
import 'package:loginprototype_flutter/domain/user.dart';
import 'package:loginprototype_flutter/providers/auth_provider.dart';
import 'package:loginprototype_flutter/providers/user_provider.dart';
import 'package:loginprototype_flutter/screens/dashboard.dart';
import 'package:loginprototype_flutter/screens/login.dart';
import 'package:loginprototype_flutter/screens/register.dart';
import 'package:loginprototype_flutter/utility/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Login Prototype Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else if (snapshot.data.token == null)
                    return Login();
                  else
                    Provider.of<UserProvider>(context).setUser(snapshot.data);
                  return DashBoard();
              }
            }),
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/dashboard': (context) => DashBoard(),
        },
      ),
    );
  }
}
