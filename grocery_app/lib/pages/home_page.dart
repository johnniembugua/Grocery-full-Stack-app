import 'package:flutter/material.dart';
import 'package:grocery_app/utils/shared_service.dart';
import 'package:grocery_app/widgets/widget_home_categories.dart';
import 'package:grocery_app/widgets/widget_home_products.dart';
import 'package:grocery_app/widgets/widget_home_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String> getUserData() async {
      String userData = await SharedService.loginDetails()
          .then((value) => value!.data.fullName);
      return userData;
    }

    return Scaffold(
      body: Container(
          child: ListView(
        children: [
          const HomeSliderWidget(),
          const HomeCategoriesWidget(),
          const HomeProductWidget(),
          ElevatedButton(
            onPressed: () async {
              await SharedService.logout(context);
            },
            child: const Text("Logout"),
          ),
          FutureBuilder(
            future: getUserData(),
            builder: (BuildContext context, AsyncSnapshot userNameSnapshot) {
              Widget widget;
              if (userNameSnapshot.hasData) {
                widget = Text(userNameSnapshot.data);
              } else if (userNameSnapshot.hasError) {
                widget = Text('Error: ${userNameSnapshot.error}');
              } else {
                widget = Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return widget;
            },
          ),
        ],
      )),
    );
  }
}
