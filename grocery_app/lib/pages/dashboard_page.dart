import 'package:flutter/material.dart';
import 'package:grocery_app/pages/home_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Widget> widgetList = const [
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.shifting,
          currentIndex: index,
          onTap: (_index) {
            setState(() {
              index = _index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_outlined),
              label: "Store",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: "Favourite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_outlined),
              label: "My Account",
            ),
          ]),
      body: widgetList[index],
    );
  }
}
