// Stub for decorated_flutter
import 'package:flutter/material.dart';

const Widget kDividerTiny = Divider(height: 1);

class DecoratedColumn extends StatelessWidget {
  final List<Widget> children;
  final bool scrollable;
  final Widget? divider;

  const DecoratedColumn({
    Key? key,
    this.children = const [],
    this.scrollable = false,
    this.divider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (divider != null && i < children.length - 1) {
        items.add(divider!);
      }
    }
    Widget column = Column(
      children: items,
    );
    if (scrollable) {
      return SingleChildScrollView(child: column);
    }
    return column;
  }
}
