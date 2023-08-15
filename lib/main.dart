import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'sidebar.dart';
import 'system.dart' as system;
import 'listItem.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowMinSize(const Size(600, 400));
  system.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XPSM',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Sidebar(updateState: updateState),
            Positioned(
              top: 0,
              bottom: 0,
              left: 48,
              right: 0,
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = system.sceneries.removeAt(oldIndex);
                      system.sceneries.insert(newIndex, item);
                    });
                  },
                  children: [
                    for (final item in system.sceneries)
                      ListTile(
                        key: Key(item.path),
                        leading: CupertinoCheckbox(
                            value: item.selceted,
                            onChanged: (value) {
                              setState(() {
                                item.selceted = value!;
                              });
                            }),
                        title: CustomListItem(scenery: item),
                        trailing: const SizedBox(width: 0),
                        minVerticalPadding: 5,
                        minLeadingWidth: 0,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
