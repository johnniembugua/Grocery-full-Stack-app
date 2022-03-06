import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/widget_home_categories.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(
        children: [
          HomeCategoriesWidget(),
        ],
      )),
    );
  }
}
