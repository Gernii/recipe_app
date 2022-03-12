import 'package:flutter/material.dart';

String _measurements(type) {
  switch (type) {
    case 0:
      return 'Gr';
    case 1:
      return 'Kg';
    case 2:
      return 'ml';
    case 3:
      return 'Quả';
    case 4:
      return 'Hộp';
    case 5:
      return 'Chai';
    case 6:
      return 'Gói';
    case 7:
      return 'Muỗng canh';
    case 8:
      return 'Trái';
    case 9:
      return 'Lon';
    default:
      return '';
  }
}

class IngredientsView extends StatelessWidget {
  final List<Map<String, dynamic>> ingredients;

  const IngredientsView(this.ingredients, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (var item in ingredients) {
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.done),
                const SizedBox(width: 5.0),
                Text(item['name']),
              ],
            ),
            Row(
              children: [
                Text(item['weight'].toString()),
                const SizedBox(width: 5.0),
                Text(_measurements(item['measurement'])),
              ],
            )
          ],
        ),
      );
      // Add spacing between the lines:
      children.add(
        const SizedBox(
          height: 15.0,
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: children,
    );
  }
}
