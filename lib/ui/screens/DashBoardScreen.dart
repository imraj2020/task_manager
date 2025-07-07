import 'package:flutter/material.dart';

import '../../widget/TDAppBar.dart';
class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  static const String name = '/dashboard';

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: TDAppBar(),
    );
  }
}


