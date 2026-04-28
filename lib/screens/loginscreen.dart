import 'dart:developer';

import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chatbot_app/provider/cred_provider.dart';
import 'package:chatbot_app/screens/background/animated_mesh_background.dart';
import 'package:chatbot_app/screens/homescreen.dart';
import 'package:chatbot_app/screens/registerscreen.dart';
import 'package:chatbot_app/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:provider/provider.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? msg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: AnimatedMeshBackground()),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: LiquidGlassLayer(
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 20,
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Textconstant.txt_welcomeback,
                            style: TextStyle(fontSize: 40),
                          ),
                          SizedBox(height: 10),

                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
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
                            controller: _emailcontroller,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              if (value.length < 6) {
                                return "Password too short";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !_isPasswordVisible,
                            controller: _passwordcontroller,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {});
                                  _isPasswordVisible = !_isPasswordVisible;
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
                                if (context.read<CredProvider>().isloading ==
                                    true) {
                                  return;
                                }
                                print(
                                  "--------------------------------------------------------------onpressed",
                                );
                                if (_formkey.currentState!.validate()) {
                                  String? error = await context
                                      .read<CredProvider>()
                                      .login(
                                        _emailcontroller.text
                                            .toLowerCase()
                                            .trim(),
                                        _passwordcontroller.text.toString(),
                                      );

                                  if (error != null) {
                                    msg = error;
                                    setState(() {});
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(content: Text(error)),
                                    // );
                                  }
                                }
                              },
                              child:
                                  context.watch<CredProvider>().isloading ==
                                      true
                                  ? CircularProgressIndicator(
                                      color: ColorConstant.color_black,
                                    )
                                  : Text(
                                      Textconstant.txt_login,
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
                              Text(Textconstant.txt_donthaveaccount),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),

                                child: Text(Textconstant.txt_register),
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
