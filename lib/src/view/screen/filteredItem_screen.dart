import 'package:e_commerce_flutter/src/model/productnew.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/model/category.dart';

class ProductList extends StatelessWidget {
  final Categories category;
  final List<ProNew> allProducts;

  const ProductList(
      {super.key, required this.category, required this.allProducts});

  @override
  Widget build(BuildContext context) {
    List<ProNew> filteredProducts = allProducts
        .where((product) => product.category == category.categoryName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Products in ${category.categoryName}'),
      ),
      body: filteredProducts.isNotEmpty
          ? ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredProducts[index].category.toString()),
                  subtitle: Text(
                      'Price: \$${filteredProducts[index].price.toString()}'),
                  // Add more product details as needed
                );
              },
            )
          : Center(
              child: Text('No products found for ${category.categoryName}'),
            ),
    );
  }
}
