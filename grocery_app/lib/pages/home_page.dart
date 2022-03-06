import 'package:flutter/material.dart';
import 'package:grocery_app/components/product_card.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/widgets/widget_home_categories.dart';
import 'package:grocery_app/widgets/widget_home_products.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(
        children: const [
          HomeCategoriesWidget(),
          HomeProductWidget(),
        ],
      )),
    );
  }
}
