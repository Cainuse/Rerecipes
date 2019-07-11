import 'package:flutter/material.dart';
import 'package:rerecipe_app/main.dart';

class IngredientView extends StatefulWidget {
  final String name;
  final IconData icon;
  Set<String> items;
  MyAppState parent;

  IngredientView(this.name, this.icon, this.items, this.parent);

  @override
  _IngredientViewState createState() => _IngredientViewState();
}

class _IngredientViewState extends State<IngredientView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4.0),
      child: Chip(
          avatar: Icon(widget.icon),
          label: Text(
            widget.name,
            style: TextStyle(fontSize: 18.0),
          ),
          labelPadding: EdgeInsets.all(3.0),
          deleteIcon: Icon(Icons.cancel),
          deleteIconColor: Colors.redAccent,
          backgroundColor: Colors.lightGreenAccent,
          deleteButtonTooltipMessage: "Delete this item",
          onDeleted: () => setState(() {
                widget.items.remove(widget.name);
                widget.parent.onItemsChange();
              })),
    );
  }
}
