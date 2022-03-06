import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/components/product_card.dart';
import 'package:grocery_app/models/pagination.dart';
import 'package:grocery_app/models/product_filter.dart';
import 'package:grocery_app/providers.dart';

import '../models/category.dart';
import '../models/product.dart';

class HomeProductWidget extends ConsumerWidget {
  const HomeProductWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // List<Product> list = List<Product>.empty(growable: true);
    // list.add(Product(
    //     productName: "TestProduct",
    //     category: Category(
    //         categoryName: "CategoryName",
    //         categoryImage:
    //             "/uploads/categories/1646437397284-Screenshot_2022-01-08-12-09-05-136_com.example.soko_flow.jpg",
    //         categoryId: "6222a41548078355cbbc5fe5"),
    //     productShortDescription: "short description",
    //     productDescription: "Description",
    //     productPrice: 630,
    //     productSalePrice: 450,
    //     productImage:
    //         "/uploads/products/1646555835724-Screenshot_2022-01-08-12-09-05-136_com.example.soko_flow.jpg",
    //     productSKU: "123",
    //     productType: "single",
    //     stockStatus: "IN",
    //     productId: "622472bb09a6e23d4a488473"));
    // list.add(Product(
    //     productName: "TestProduct",
    //     category: Category(
    //         categoryName: "CategoryName",
    //         categoryImage:
    //             "/uploads/categories/1646437397284-Screenshot_2022-01-08-12-09-05-136_com.example.soko_flow.jpg",
    //         categoryId: "6222a41548078355cbbc5fe5"),
    //     productShortDescription: "short description",
    //     productDescription: "Description",
    //     productPrice: 630,
    //     productSalePrice: 450,
    //     productImage:
    //         "/uploads/products/1646555835724-Screenshot_2022-01-08-12-09-05-136_com.example.soko_flow.jpg",
    //     productSKU: "123",
    //     productType: "single",
    //     stockStatus: "IN",
    //     productId: "622472bb09a6e23d4a488473"));
    return Container(
      color: const Color(0xfff4f7fa),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 15),
                child: Text(
                  "Top 10 Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: _productList(ref),
          ),
        ],
      ),
    );
  }

  Widget _productList(WidgetRef ref) {
    final products = ref.watch(homeProductProvider(ProductFilterModel(
        paginationModel: PaginationModel(page: 1, pageSize: 10))));
    return products.when(
        data: (list) {
          return _buildProductList(list!);
        },
        error: (_, __) {
          return const Center(
            child: Text("Error Occured"),
          );
        },
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  Widget _buildProductList(List<Product> products) {
    return Container(
      height: 200,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, index) {
            var data = products[index];
            return GestureDetector(
              onTap: () {},
              child: ProductCard(
                model: data,
              ),
            );
          }),
    );
  }
}
