import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/model/category.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ListItemSelector extends StatefulWidget {
  const ListItemSelector({
    super.key,
    required this.categories,
    required this.onItemPressed,
  });

  final List<Categories> categories;
  final Function(int) onItemPressed;

  @override
  State<ListItemSelector> createState() => _ListItemSelectorState();
}

class _ListItemSelectorState extends State<ListItemSelector> {
  List<Categories> lstCate = [];
  List<String> name = [];
  void getCate() async {
    List<String> strtemp = [];
    try {
      var temp = await APIRepository().getAllCategories();
      for (var i in temp) {
        strtemp.add(i.categoryName);
      }
      setState(() {
        lstCate = temp;
        name = strtemp;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCate();
  }

  Widget item(Categories item, int index) {
    getCate();
    return Tooltip(
      message: item.categoryName.capitalizeFirst,
      child: AnimatedContainer(
        margin: const EdgeInsets.only(left: 5, top: 10),
        duration: const Duration(milliseconds: 500),
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 21, 95, 156),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          child: Text(item.categoryName),
          onPressed: () {
            widget.onItemPressed(index);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        scrollDirection: Axis.vertical,
        itemCount: widget.categories.length,
        itemBuilder: (_, index) => item(widget.categories[index], index),
      ),
    );
  }
}
