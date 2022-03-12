import 'package:flutter/material.dart';

class PreparationView extends StatelessWidget {
  final List<String> preparationSteps;

  const PreparationView(this.preparationSteps, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> textElements = [];
    preparationSteps.asMap().forEach((i, item) {
      textElements.add(
        Text('${i + 1}. $item'),
      );
      textElements.add(
        const SizedBox(
          height: 20.0,
          // Tạo khoảng trống giữa các quy trình chế biến
        ),
      );
    });
    return ListView(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: textElements,
    );
  }
}
