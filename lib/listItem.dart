import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'system.dart' as system;
import 'color.dart';

class CustomListItem extends StatefulWidget {
  final system.Scenery scenery;
  const CustomListItem({required this.scenery});

  @override
  State<StatefulWidget> createState() {
    return CustomListItemState();
  }
}

class CustomListItemState extends State<CustomListItem> {
  int expand = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {},
            child: CupertinoSwitch(
              value: widget.scenery.active,
              activeColor: highligtColor,
              onChanged: (value) {
                setState(() {
                  widget.scenery.active = !widget.scenery.active;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              widget.scenery.name,
              textAlign: TextAlign.left,
              style: const TextStyle(
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 60,
            child: Text(
              widget.scenery.type,
              textAlign: TextAlign.right,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(left: 10, right: 10),
            onPressed: () {
              setState(() {
                expand = expand == 1 ? 0 : 1;
              });
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
    );
  }
}

class CustomListItemGroup extends StatefulWidget {
  final system.Scenery scenery;
  const CustomListItemGroup({required this.scenery});

  @override
  State<StatefulWidget> createState() {
    return CustomListItemGroupState();
  }
}

class CustomListItemGroupState extends State<CustomListItem> {
  int expand = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 3)),
        ],
      ),
      
      );
  }
}
