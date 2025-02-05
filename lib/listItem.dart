import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:xpsmv4/dsftool.dart';
import 'system.dart';

class CustomListItem extends StatefulWidget {
  final Scenery scenery;
  final bool selected;
  final Function updateState;
  const CustomListItem({required this.scenery, required this.selected, required this.updateState, super.key});
  @override
  State<StatefulWidget> createState() => CustomListItemState();
}

class CustomListItemState extends State<CustomListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: widget.selected
            ? Border.all(
                color: const Color.fromARGB(255, 0, 161, 255),
              )
            : null,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0, blurRadius: 5, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: CupertinoSwitch(
                  value: widget.scenery.active,
                  activeTrackColor: const Color.fromARGB(255, 0, 161, 255),
                  onChanged: (value) {
                    widget.updateState(() {
                      widget.scenery.active = !widget.scenery.active;
                    });
                  },
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Text(
                    widget.scenery.name,
                    textAlign: TextAlign.left,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: DropdownButton(
                  itemHeight: 24,
                  dropdownColor: Colors.white,
                  isDense: true,
                  value: widget.scenery.type,
                  items: const [
                    DropdownMenuItem(
                      value: SceneryTypes.AIRPORT,
                      child: Text(
                        'AIRPORT',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SceneryTypes.HELIPAD,
                      child: Text(
                        'HELIPAD',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SceneryTypes.GLOBAL,
                      child: Text(
                        'GLOBAL',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SceneryTypes.CITY,
                      child: Text(
                        'CITY',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SceneryTypes.LIBRARY,
                      child: Text(
                        'LIBRARY',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SceneryTypes.OVERLAY,
                      child: Text(
                        'OVERLAY',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SceneryTypes.PHOTOREAL,
                      child: Text(
                        'PHOTOREAL',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SceneryTypes.MESH,
                      child: Text(
                        'MESH',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SceneryTypes.UNKNOWN,
                      child: Text(
                        'UKNOWN',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      widget.scenery.type = value ?? widget.scenery.type;
                    });
                  },
                ),
              ),
              IconButton(
                style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                ),
                padding: const EdgeInsets.only(left: 10, right: 10),
                onPressed: () {
                  widget.updateState(() {
                    widget.scenery.expand = widget.scenery.expand == 1 ? 0 : 1;
                  });
                },
                icon: widget.scenery.expand == 0 ? const Icon(Icons.expand_more) : const Icon(Icons.expand_less),
              ),
            ],
          ),
          if (widget.scenery.expand == 1)
            SizedBox(
              width: double.infinity,
              height: 210,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 250,
                        height: 200,
                        child: widget.scenery.getMap(),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Text(
                              widget.scenery.path,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blueAccent,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () {
                              OpenFile.open(widget.scenery.path);
                            },
                          ),
                          Flexible(
                            child: Row(
                              spacing: 10,
                              children: [
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey, width: 1)),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(4, 1, 8, 1),
                                            child: Row(
                                              spacing: 8,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'AIRPORT',
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text('ICAO'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView(
                                            children: [
                                              for (final airport in widget.scenery.ap)
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(4, 1, 8, 1),
                                                  child: Row(
                                                    spacing: 8,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          airport.name,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Text(airport.icao),
                                                    ],
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey, width: 1)),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(4, 1, 8, 1),
                                            child: Text(
                                              'Require Library',
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView(
                                            children: [
                                              for (final lib in widget.scenery.library!)
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(4, 1, 8, 1),
                                                  child: Text(lib),
                                                )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class GroupItem extends StatefulWidget {
  final Scenery scenery;
  final int selected;
  final Function updateState;
  const GroupItem({required this.scenery, required this.selected, required this.updateState, super.key});
  @override
  State<StatefulWidget> createState() => GroupItemState();
}

class GroupItemState extends State<GroupItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0, blurRadius: 5, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: CupertinoSwitch(
                  value: widget.scenery.active,
                  activeTrackColor: const Color.fromARGB(255, 0, 161, 255),
                  onChanged: (value) {
                    widget.updateState(() {
                      widget.scenery.active = !widget.scenery.active;
                    });
                  },
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Text(
                    widget.scenery.name,
                    textAlign: TextAlign.left,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  'GROUP',
                  textAlign: TextAlign.right,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(left: 10, right: 10),
                onPressed: () {
                  setState(() {
                    widget.scenery.expand = widget.scenery.expand == 1 ? 0 : 1;
                  });
                },
                icon: widget.scenery.expand == 0 ? const Icon(Icons.expand_more) : const Icon(Icons.expand_less),
              ),
            ],
          ),
          if (widget.scenery.expand == 1)
            SizedBox(
              height: 50.0 * widget.scenery.items!.length + 5.0 + 210.0 * widget.scenery.items!.where((element) => element.expand == 1).length,
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = sceneries.removeAt(oldIndex);
                    sceneries.insert(newIndex, item);
                  });
                },
                children: [
                  for (final item in widget.scenery.items!)
                    ListTile(
                      key: GlobalKey(),
                      leading: IconButton(
                        icon: const Icon(
                          Icons.do_not_disturb_on,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                      title: CustomListItem(scenery: item, selected: widget.selected == widget.scenery.items!.indexOf(item), updateState: setState),
                      trailing: const SizedBox(width: 0),
                      minVerticalPadding: 5,
                      minLeadingWidth: 0,
                    )
                ],
              ),
            ),
          if (widget.scenery.expand == 1)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: const Color.fromARGB(255, 0, 161, 255),
                      foregroundColor: Colors.white,
                      animationDuration: const Duration(milliseconds: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Rename'),
                    onPressed: () async {
                      String? name = await showDialog<String?>(
                          context: context,
                          builder: (BuildContext context) {
                            String name = '';
                            return StatefulBuilder(builder: (context, setState) {
                              return Dialog(
                                child: Container(
                                  width: 360,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Group Name',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                        CupertinoTextField(
                                          onChanged: (value) {
                                            setState(() {
                                              name = value;
                                            });
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                splashFactory: NoSplash.splashFactory,
                                                backgroundColor: Colors.grey,
                                                foregroundColor: Colors.white,
                                                animationDuration: const Duration(milliseconds: 100),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                splashFactory: NoSplash.splashFactory,
                                                backgroundColor: const Color.fromARGB(255, 0, 161, 255),
                                                foregroundColor: Colors.white,
                                                animationDuration: const Duration(milliseconds: 100),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: name.isEmpty || sceneries.any((e) => e.name == name && e.type == 99)
                                                  ? null
                                                  : () {
                                                      Navigator.of(context).pop(name);
                                                    },
                                              child: const Text('Rename'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          });
                      setState(() {
                        widget.scenery.name = name ?? widget.scenery.name;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      animationDuration: const Duration(milliseconds: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Ungroup'),
                    onPressed: () {
                      final idx = sceneries.indexOf(widget.scenery);
                      widget.updateState(() {
                        sceneries.insertAll(idx + 1, widget.scenery.items!);
                        sceneries.removeAt(idx);
                      });
                    },
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
