import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/model/category.dart';
import 'package:get/get.dart';

class MenuLeft extends StatefulWidget {
  const MenuLeft({super.key});

  @override
  State<MenuLeft> createState() => _MenuLeftState();
}

class _MenuLeftState extends State<MenuLeft> {
  final ProductController controller = Get.put(ProductController());
  late List<Categories> lstCate;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      List<Categories> categories = await APIRepository().getAllCategories();
      setState(() {
        lstCate = categories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      // Handle error gracefully (e.g., show error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topCategoriesHeader(context),
              _buildCategoryGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topCategoriesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Danh mục",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextButton(
            onPressed: () {
              // Handle "XEM THÊM" button tap
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: Text(
              "XEM THÊM",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 21, 95, 156),
                  ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: lstCate.map((category) {
        return GestureDetector(
          onTap: () {
            // Handle category selection (e.g., navigate to category screen)
            print('Selected category: ${category.categoryName}');
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                category.categoryName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
