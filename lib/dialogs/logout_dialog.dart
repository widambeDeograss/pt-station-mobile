import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/pages/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> clearSharedPreferences() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
    }

    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await clearSharedPreferences();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Signin()),
                (Route<dynamic> route) => false);
            // Navigator.of(context).pop();
            // SystemNavigator.pop();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
