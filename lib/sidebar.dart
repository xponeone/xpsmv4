import 'package:flutter/material.dart';
import 'system.dart' as system;
import 'setting.dart' as setting;
import 'color.dart';

class Sidebar extends StatefulWidget {
  final Function updateState;
  const Sidebar({required this.updateState});

  @override
  State<StatefulWidget> createState() {
    return SidebarState();
  }
}

class SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      child: Container(
        width: 48,
        height: double.infinity,
        color: const Color.fromARGB(255, 50, 50, 55),
        child: Column(
          verticalDirection: VerticalDirection.up,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const setting.Setting(),
                        insetPadding: const EdgeInsets.all(0),
                        backgroundColor: bgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: bgColor,
                            ),
                            onPressed: () {
                              setting.save();
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              tooltip: 'Setting',
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    widget.updateState();
                  },
                  icon: const Icon(
                    Icons.manage_search,
                    color: Colors.white,
                  ),
                  tooltip: 'Search Scenery',
                ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  tooltip: 'Refresh',
                ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {
                    system.save();
                  },
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  tooltip: 'Save',
                ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {
                    system.load();
                  },
                  icon: const Icon(
                    Icons.file_open_outlined,
                    color: Colors.white,
                  ),
                  tooltip: 'Load',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
