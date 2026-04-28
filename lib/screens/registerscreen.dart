import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chatbot_app/provider/cred_provider.dart';
import 'package:chatbot_app/screens/background/animated_mesh_background.dart';
import 'package:chatbot_app/screens/loginscreen.dart';
import 'package:chatbot_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:provider/provider.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final TextEditingController _mailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? msg;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: AnimatedMeshBackground()),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: LiquidGlassLayer(
                child: LiquidGlass(
                  shape: LiquidRoundedRectangle(borderRadius: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 20,
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Textconstant.txt_getstarted,
                            style: TextStyle(fontSize: 40),
                          ),
                          SizedBox(height: 15),

                          TextFormField(
                            controller: _mailcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }

                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return "Enter valid email";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2),
                              ),
                              hintText: Textconstant.txt_entermail,
                              hintStyle: TextStyle(
                                fontFamily: 'InstrumentSerif',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          TextFormField(
                            controller: _passwordcontroller,

                            keyboardType: TextInputType.visiblePassword,

                            obscureText: !_isPasswordVisible,
                            // obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }

                              if (value.length < 8) {
                                return "Minimum 8 characters required";
                              }

                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return "Must contain at least 1 uppercase letter";
                              }

                              if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return "Must contain at least 1 lowercase letter";
                              }

                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return "Must contain at least 1 number";
                              }

                              if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                                return "Must contain 1 special character";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _isPasswordVisible = !_isPasswordVisible;
                                  setState(() {});
                                },
                                icon: _isPasswordVisible
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2),
                              ),
                              hintText: Textconstant.txt_enterpassword,
                              hintStyle: TextStyle(
                                fontFamily: 'InstrumentSerif',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          TextFormField(
                            // obscureText: true,
                            obscureText: !_isConfirmPasswordVisible,

                            keyboardType: TextInputType.visiblePassword,
                            controller: _confirmpasswordcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "confirm Password is required";
                              }
                              if (value != _passwordcontroller.text) {
                                return "password doesnt match!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {});

                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                },
                                icon: _isConfirmPasswordVisible
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2),
                              ),
                              hintText: Textconstant.txt_enterconfirmpassword,
                              hintStyle: TextStyle(
                                fontFamily: 'InstrumentSerif',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          Container(
                            height: 50,
                            width: MediaQuery.widthOf(context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.color_white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  try {
                                    String? cred = await context
                                        .read<CredProvider>()
                                        .register(
                                          _mailcontroller.text
                                              .trim()
                                              .toLowerCase(),
                                          _passwordcontroller.text,
                                        );
                                    print(cred);
                                    if (!context.mounted) return;

                                    if (cred != null) {
                                      msg = cred;
                                      setState(() {});
                                      return;
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            Textconstant.txt_registersucess,
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                Textconstant.txt_register,
                                style: TextStyle(
                                  color: ColorConstant.color_black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),

                          if (msg != null)
                            Text(
                              msg!,
                              style: TextStyle(
                                color: ColorConstant.color_red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(Textconstant.txt_alreadyhaveanaccount),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Loginscreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),

                                child: Text(Textconstant.txt_login),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
