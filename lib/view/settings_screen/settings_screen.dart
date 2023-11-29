import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/view/settings_screen/privacy_and_policy/privacy_and_policy.dart';
import 'package:todo_app/view/settings_screen/terms_and_condition/t&c.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // centerTitle: true,
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TermsAndCondition()));
              },
              child: Row(
                children: [
                  Text("Terms and Conditions",
                      style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PrivacyAndPolicy()));
              },
              child: Row(
                children: [
                  Text("Privacy and policy",
                      style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
