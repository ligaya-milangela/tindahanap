import 'package:flutter/material.dart';
import 'package:front/theme/app_theme.dart';

class UserProfileScreen extends StatelessWidget{
  const UserProfileScreen({super.key});

  @override 
  Widget build(BuildContext context){
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String name = 'Name goes here';
    
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
        ]
      ),
    );
  }
}

Widget buildContent() => Container(
  padding: EdgeInsets.symmetric(horizontal: 48),
  child: Column(
    children: [
      Text(
        'About',
        style: TextStyle(fontSize: 28),
      ),
      const SizedBox(height: 14),
      Text(
        'Credentials',
      ),
    ],
  )
);


Widget buildTop() => Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 35 ),
            child: backgroundImage(),
          ),
          Positioned(
            top: 70,
            child: profilePicture(),
          ),
          
        ],

      );

Widget profilePicture() => CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(
              'https://lh3.googleusercontent.com/a/ACg8ocKkEn4uSpl7y645bVbHFxOR3cpFkgwwYSc1FXbycdjpUU1KyA=s192-c-br100-rg-mo'
            ),
          );

Widget backgroundImage() =>  Container(
            color: colorScheme.tertiary,
            width: double.infinity,
            height: 280.0,
          );