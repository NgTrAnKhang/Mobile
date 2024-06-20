import 'package:e_commerce_flutter/src/data/sharepre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GenderSelectionPage extends StatefulWidget {
  const GenderSelectionPage({super.key});

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<GenderSelectionPage> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio(
                  value: 'Nam',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = 'Nam';
                      savegender(value!);
                    });
                  },
                ),
                const Text('Nam'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'Nữ',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = 'Nữ';
                      savegender(value!);
                    });
                  },
                ),
                const Text('Nữ'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'Khác',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = 'Khác';
                      savegender(value!);
                    });
                  },
                ),
                const Text('Khác'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
