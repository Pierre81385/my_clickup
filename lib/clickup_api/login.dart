import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_clickup/login_component/response_component.dart';
import 'dart:convert';
import 'constants.dart';
import '../validate.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({super.key});

  @override
  State<LoginComponent> createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailLoginTextController = TextEditingController();
  final _emailLoginFocusNode = FocusNode();
  final _passwordLoginTextController1 = TextEditingController();
  final _passwordLoginFocusNode1 = FocusNode();
  bool _isProcessing = false;
  String _message = "";
  Map<String, dynamic> _response = {};

  Login(String email, String password) async {
    String credentials = '$email:$password';
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded = stringToBase64Url.encode(credentials);
    //String decoded = stringToBase64Url.decode(encoded);
    try {
      await http
          .post(
        Uri.parse(ApiConstants.loginUrl),
        headers: <String, String>{
          'Authorization': 'Basic $encoded',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}),
      )
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
            _message = 'response code: ${response.statusCode.toString()}';
            _response = json.decode(response.body);
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MapResponseComponent(
                    mapResponse: _response,
                    responseMessage: response.statusCode.toString(),
                  )));
        } else {
          setState(() {
            _isProcessing = false;
          });
          throw Exception('Failed to login.');
        }
      });
    } on Exception catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          _emailLoginFocusNode.unfocus();
          _passwordLoginFocusNode1.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '{ ' + ApiConstants.loginUrl + ' }',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    cursorColor: Colors.green,
                    controller: _emailLoginTextController,
                    focusNode: _emailLoginFocusNode,
                    validator: (value) => Validator.validateEmail(
                      email: value,
                    ),
                    style: TextStyle(color: Colors.green),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "> Email Address",
                      labelStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    cursorColor: Colors.green,
                    controller: _passwordLoginTextController1,
                    focusNode: _passwordLoginFocusNode1,
                    validator: (value) => Validator.validatePassword(
                      password: value,
                    ),
                    style: TextStyle(color: Colors.green),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "> Password",
                      labelStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  _isProcessing
                      ? CircularProgressIndicator(
                          color: Colors.green,
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: IconButton(
                              alignment: Alignment.centerRight,
                              onPressed: () async {
                                _emailLoginFocusNode.unfocus();
                                _passwordLoginFocusNode1.unfocus();

                                if (_loginFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  await Login(_emailLoginTextController.text,
                                      _passwordLoginTextController1.text);
                                }
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.green,
                              )),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
