import 'package:flutter/material.dart';
import 'package:quiz_app/helper/functions.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/views/home.dart';
import 'package:quiz_app/views/signup.dart';
import 'package:quiz_app/widgets/widgets.dart';
import 'package:flutter_svg/svg.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthService authService = new AuthService();
  bool _isLoading = false;

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.signInEmailAndPass(email, password).then((val) {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, //center
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  shrinkWrap: true,
                  reverse: true,
                  children: [
                    SizedBox(height: size.height * 0.03),
                    SvgPicture.asset(
                      "assets/icons/login.svg",
                      height: size.height * 0.35,
                    ),
                    Spacer(),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty ? "Enter Email id" : null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(29),
                              borderSide: BorderSide (color: Colors.transparent),),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(29),
                            borderSide: BorderSide (color: Colors.transparent),),
                          filled: true,
                          fillColor: Color(0xFFF1E6FF),
                          hintText: "Email",
                          prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF6F35A5),)),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val) {
                        return val.isEmpty ? "Enter Password" : null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(29),
                            borderSide: BorderSide (color: Colors.transparent),),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(29),
                            borderSide: BorderSide (color: Colors.transparent),),
                          filled: true,
                          fillColor: Color(0xFFF1E6FF),
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock_outline_rounded,color: Color(0xFF6F35A5),)),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: buttonWidget(context: context, label: "Sign In"),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 15.5),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color:  Color(0xFF6F35A5),
                                  fontSize: 15.5,
                                  decoration: TextDecoration.underline),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ].reversed.toList(),
                ),
              ),
            ),
    );
  }
}
