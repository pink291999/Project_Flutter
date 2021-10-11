import 'package:flutter/material.dart';
import 'package:quiz_app/helper/functions.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/views/home.dart';
import 'package:quiz_app/views/signin.dart';
import 'package:quiz_app/widgets/widgets.dart';
import 'package:flutter_svg/svg.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String name, email, password;
  AuthService authService = new AuthService();
  bool _isLoading = false;

  signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      authService.signUpWithEmailAndPassword(email, password).then((value) {
        if (value != null) {
          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignIn()));
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
                      "assets/icons/signup.svg",
                      height: size.height * 0.35,
                    ),
                    Spacer(),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty ? "Enter Name" : null;
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
                          hintText: "Name",
                          prefixIcon: Icon(Icons.supervised_user_circle,color: Color(0xFF6F35A5),)),
                      onChanged: (val) {
                        name = val;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty ? "Enter Emailid" : null;
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
                          prefixIcon: Icon(Icons.email_outlined,color: Color(0xFF6F35A5),)),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    SizedBox(
                      height: 10,
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
                          prefixIcon: Icon(Icons.lock_outline,color: Color(0xFF6F35A5),)),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        signUp();
                      },
                      /*child: Container(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 48,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),*/
                      child: buttonWidget(context: context, label: "Sign Up"),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 15.5),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
                            },
                            child: Text(
                              "Sign In",
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
