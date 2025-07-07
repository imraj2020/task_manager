import 'package:flutter/material.dart';
class TDAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TDAppBar({
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      backgroundColor: Colors.blue,

      title: Row(

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
    );
  }

  void _onTapLogOutButton() {
  }
}