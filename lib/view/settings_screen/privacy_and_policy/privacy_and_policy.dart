import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrivacyAndPolicy extends StatelessWidget {
  PrivacyAndPolicy({super.key});
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
        title: Text("Privacy and Policy"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            sizedhght,
            Text("Privacy Policy  for PenPad",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            sizedhght,
            Text("1. Information Collection and Use",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
              " 1.1. PenPad does not collect or store any personal information.\n1.2. The App may collect non-personal information such as device information and usage statistics for the purpose of improving user experience and app functionality.",
              textAlign: TextAlign.justify,
            ),
            sizedhght,
            Text("2. Data Storage ",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                " 2.1. Notes created using PenPad are stored locally on the user's device.\n 2.2. PenPad uses Hive database for local storage. Hive is an open-source, lightweight database."),
            sizedhght,
            Text("3. Third-Party Services",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "3.1. PenPad may use third-party services for analytics and crash reporting. These services may collect anonymous usage data to help identify and fix app issues.\n3.2. Users are encouraged to review the privacy policies of third-party services used by PenPad."),
            sizedhght,
            Text("4. Secuirity",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "4.1. PenPad is committed to ensuring the security of user data. However, no method of transmission over the internet or electronic storage is 100% secure.\n4.2. Users are responsible for maintaining the security of their devices and access to the App."),
            sizedhght,
            Text("5. Children’s Privacy",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "5.1. PenPad is not intended for use by individuals under the age of 13.\n5.2. We do not knowingly collect personal information from children under 13. If you believe that a child under 13 has provided personal information, please contact us immediately."),
            sizedhght,
            Text("6. Changes to Privacy Policy",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "6.1. PenPad reserves the right to update this privacy policy at any time. Users will be notified of any changes by updating the  Last updated date at the end of this policy.\n 6.2. Users are advised to review this privacy policy periodically for any changes."),
            sizedhght,
            sizedhght,
            Text("7. Contact Information",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            sizedhght,
            Text(
                "7.1.For any questions or concerns regarding these terms, please contact yadhunsajith2002@gmail.com. \n By using the PenPad application, you agree to these terms and conditions.\nLast updated: 30-11-2023"),
            sizedhght,
          ],
        ),
      ),
    );
  }
}
