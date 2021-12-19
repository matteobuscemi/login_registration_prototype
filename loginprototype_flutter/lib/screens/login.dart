import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loginprototype_flutter/domain/user.dart';
import 'package:loginprototype_flutter/providers/auth_provider.dart';
import 'package:loginprototype_flutter/providers/user_provider.dart';
import 'package:loginprototype_flutter/utility/validator.dart';
import 'package:loginprototype_flutter/utility/widgets.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  String _username, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    var doLogin = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> response =
            auth.login(_username, _password);

        response.then((response) {
          if (response['status']) {
            User user = response['user'];

            Provider.of<UserProvider>(context, listen: false).setUser(user);

            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        });
      } else {
        Flushbar(
          title: 'Invalid form',
          message: 'Please complete the form properly',
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text('Login... please wait')
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text('Email'),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: validateEmail,
                  onSaved: (value) => _username = value,
                  decoration: buildInputDecoration('Enter Email', Icons.email),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Password'),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter a password!' : null,
                  onSaved: (value) => _password = value,
                  decoration:
                      buildInputDecoration('Enter Password', Icons.lock),
                ),
                SizedBox(
                  height: 20.0,
                ),
                auth.loggedInStatus == Status.Authenticating
                    ?loading
                    : longButtons('Login', doLogin),
                SizedBox(
                  height: 8.0,
                ),
                forgotLabel
              ],
            ),
          ),
        ),
      ),
    );
  }
}
