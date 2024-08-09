import 'package:flutter/material.dart';


class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(title: Text('Profile')),
    );
  }
}
