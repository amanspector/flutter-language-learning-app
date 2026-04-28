import 'package:chatbot_app/provider/cred_provider.dart';
import 'package:chatbot_app/screens/homescreen.dart';
import 'package:chatbot_app/screens/loginscreen.dart';
import 'package:chatbot_app/screens/registerscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // final data = snapshot.data;
          print(snapshot.data);

          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (!context.mounted) return;
          //   // Provider.of<CredProvider>(
          //   //   context,
          //   //   listen: false,
          //   // ).getGmail(snapshot.data);
          //   final provider = context.read<CredProvider>();

          //   if (provider.gmail != data!.email) {
          //     provider.getGmail(data);
          //   }
          // });

          print("Stored in provider");
          return Homescreen();
        }
        return Loginscreen();
      },
    );
  }
}
