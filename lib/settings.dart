import 'package:dhe/resources/auth_methods.dart';
import 'package:dhe/signinpatient.dart';
import 'package:flutter/material.dart';

import 'PatientsPages/profile.dart';
import 'feedback.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 0,
        //automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /*InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileDetails(),
                    ),
                  );
                },
                child:ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text('Profile'),
                ),
            ),*/

            //const Divider(),
           /* InkWell(
                onTap: (){

                },
                child: ListTile(
                  leading: const Icon(Icons.notifications_none_rounded),
                  title: Text('Notification Settings'),
                ),
            ),

            const Divider(),
            InkWell(
                onTap: (){

                },
                child:ListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: Text('Terms and Conditions'),
                ),
            ),

            const Divider(),
            InkWell(
                onTap: (){

                },
                child:ListTile(
                  leading: const Icon(Icons.lock_outline_rounded),
                  title: Text('Privacy'),
                ),
            ),*/

            //const Divider(),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackScreen(),
                  ),
                );
              },
              child:const ListTile(
                leading: Icon(Icons.support_agent_rounded),
                title: Text('Feedback'),
              ),
            ),
            const Divider(),
            InkWell(
              onTap:() {
                AuthMethods().signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Psignin(),
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: Text('Logout'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
