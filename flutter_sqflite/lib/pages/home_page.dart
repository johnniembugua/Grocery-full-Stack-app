import 'package:flutter/material.dart';
import 'package:flutter_sqflite/pages/add_edit_product.dart';
import 'package:flutter_sqflite/services/db_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/list_helper.dart';

import '../models/products_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBService dbService = DBService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Flutter SQFlite Crud"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FormHelper.submitButton(
                "Add Product",
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AddEditProductPage()));
                },
                borderRadius: 10,
                btnColor: Colors.lightBlue,
                borderColor: Colors.lightBlue,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _fetchData()
          ],
        ),
      ),
    );
  }

  _fetchData() {
    return FutureBuilder<List<ProductModel>>(
        future: dbService.getProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> products) {
          if (products.hasData) {
            _buildDataTable(products.data!);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  _buildDataTable(List<ProductModel> model) {
    return ListUtils.buildDataTable(
      context,
      ["Product Name", "Price", ""],
      ["productName", "price", ""],
      false,
      0,
      model,
      (ProductModel data) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddEditProductPage(
                      isEditMode: true,
                      model: data,
                    )));
      },
      (ProductModel data) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("SQFLITE CRUD"),
                content: const Text("Do you want to delete"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FormHelper.submitButton(
                        "Yes",
                        () {
                          dbService.deleteProduct(data).then((value) {
                            setState(() {
                              Navigator.pop(context);
                            });
                          });
                        },
                        width: 100,
                        borderRadius: 5,
                        btnColor: Colors.green,
                        borderColor: Colors.green,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      FormHelper.submitButton("No", () {
                        Navigator.pop(context);
                      },
                          width: 100,
                          borderRadius: 5,
                          btnColor: Colors.green,
                          borderColor: Colors.green),
                    ],
                  )
                ],
              );
            });
      },
      headingRowColor: Colors.orangeAccent,
      isScrollable: true,
      columnTextBold: false,
      columnTextFontSize: 15,
      columnSpacing: 50,
      onSort: (columnIndex, columnName, asc) {},
    );
  }
}
