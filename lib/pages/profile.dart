import 'package:flutter/material.dart';
import 'package:pts/dialogs/network_config_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialogs/logout_dialog.dart';
import '../widgets/profile_menu_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<SharedPreferences> getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<SharedPreferences>(
        future: getPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for SharedPreferences
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (snapshot.hasData) {
            // Retrieve user details from SharedPreferences
            SharedPreferences preferences = snapshot.data!;
            String name = preferences.getString('name') ?? 'Unknown User';
            String email = preferences.getString('email') ?? 'No email';
            String role = preferences.getString('role') ?? 'No role';

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    /// -- IMAGE
                    Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(
                              image: AssetImage(
                                  "assets/images/user_empty_avatar.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Display user data from SharedPreferences
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      role,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(height: 12),

                    const Divider(),
                    ProfileMenuWidget(
                      title: "Network",
                      icon: Icons.network_check,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () {
                        NetworkConfigurationDialog().show(context, () {
                          setState(() {}); // Reload the profile page after any configuration change
                        });
                      },
                    ),
                    const Divider(),
                    ProfileMenuWidget(
                      title: "Logout",
                      icon: Icons.logout_outlined,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const LogoutDialog();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
