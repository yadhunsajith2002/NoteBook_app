import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TermsAndCondition extends StatelessWidget {
  TermsAndCondition({super.key});

  var sizedhght = SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Terms and Conditions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedhght,
            Text("Terms and Conditions for PenPad",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            sizedhght,
            Text("1. Acceptance of Terms ",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
              " By using the PenPad application, you agree to comply with and be bound by the following terms and conditions of use. If you do not agree to these terms, please do not use the App.",
              textAlign: TextAlign.justify,
            ),
            sizedhght,
            Text("2. Use of the App  ",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                " 2.1. The App is designed for the sole purpose of creating, saving, and viewing notes.\n2.2. No user account is required to use the App, and no personal information is collected or stored."),
            sizedhght,
            Text("3. Data Storage",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "3.1. Notes created using the App are stored locally on your device. \n 3.2. PenPad uses Hive database for local storage. Hive is an open-source, lightweight database."),
            sizedhght,
            Text("4. Disclaimer of Warranty",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "4.1. The App is provided  is without any warranty of any kind, either expressed or implied. \n 4.2. Our Company  does not warrant that the App will be error-free or uninterrupted. Use of the App is at your own risk."),
            sizedhght,
            Text("5. Limitation of Liability",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "5.1. In no event shall our company be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in any way connected with the use of the App."),
            sizedhght,
            Text("6. Changes to Terms",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "6.1. Our Company reserves the right to modify or replace these terms at any time without notice. It is your responsibility to review these terms periodically for changes."),
            sizedhght,
            Text("7. Governing Law",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "7.1. These terms are governed by and construed in accordance with the laws of [Your Country/Jurisdiction]."),
            sizedhght,
            Text("8. Contact Information",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "8.1.For any questions or concerns regarding these terms, please contact yadhunsajith2002@gmail.com. \n By using the PenPad application, you agree to these terms and conditions.\nLast updated: 30-11-2023"),
            sizedhght,
          ],
        ),
      ),
    );
  }
}
