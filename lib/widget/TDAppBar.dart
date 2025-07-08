import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/Sign_in_screen.dart';
import 'package:task_manager/ui/screens/UpdateProfileScreen.dart';

import '../App/app.dart';


class TDAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TDAppBar({
    super.key,
  });

  @override
  State<TDAppBar> createState() => _TDAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TDAppBarState extends State<TDAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(

      backgroundColor: Colors.blue,

      title: GestureDetector(
        onTap:()=> _onTapProfileBar(context),
        child: Row(
          children: [
            CircleAvatar(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rabbil Hasan',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    'rabbil@gmail.com',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(onPressed: _onTapLogOutButton, icon: Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }



  void _onTapLogOutButton() {
    Navigator.pushNamedAndRemoveUntil(
        context, SignInScreen.name, (predicate) => false);
  }

  void _onTapProfileBar(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == UpdateProfileScreen.name) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are already on the profile page')),
      );
    } else {
      // Navigate to profile page
      Navigator.pushNamed(context, UpdateProfileScreen.name);
    }
  }
}