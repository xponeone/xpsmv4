import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpsmv4/dsftool.dart';
import 'sidebar.dart';
import 'system.dart';
import 'listItem.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  windowManager.setMinimumSize(const Size(720, 400));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  final ScrollController _scrollController = ScrollController();
  int idx = -1, idx2 = -1;

  void scroll(int index, {int index2 = -1}) {
    if (index != -1) {
      double pos = 0;
      for (final e in sceneries.take(index)) {
        pos += 50;
        if (e.expand == 1) {
          if (e.items == null) {
            pos += 210;
          } else {
            pos += e.items!.length * 50;
          }
        }
      }
      pos += (index2 + 1) * 50;
      _scrollController.animateTo(pos - 300, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    setState(() {
      idx = index;
      idx2 = index2;
      if (index != -1 && sceneries[index].items != null) sceneries[index].expand = 1;
    });
  }

  Stream? s;
  bool _onLoading = true;
  @override
  void initState() {
    super.initState();
    s = init(setState).asBroadcastStream();
    s!.listen(null, onDone: () {
      s = null;
      setState(() {
        _onLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = sceneries.where((element) => element.selected);
    if (selected.isEmpty) {
      selectType = null;
    } else {
      if (selected.any((element) => element.items != null)) {
        selectType = null;
      } else if (selected.every((element) => element.type == selected.first.type)) {
        selectType = selected.first.type;
      } else {
        selectType = null;
      }
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: const Color.fromARGB(128, 0, 161, 255),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 161, 255),
            foregroundColor: Colors.white,
            animationDuration: const Duration(milliseconds: 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: _onLoading
            ? Loading(s: s)
            : Row(
                children: [
                  Sidebar(
                    scroll: scroll,
                    changeStream: (Stream stream) {
                      s = stream.asBroadcastStream();
                      setState(() {
                        _onLoading = true;
                      });
                      s!.listen(null, onDone: () {
                        s = null;
                        setState(() {
                          _onLoading = false;
                        });
                      });
                    },
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0, blurRadius: 5, offset: const Offset(0, 3)),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Transform.scale(
                                  scale: 1.3,
                                  child: CupertinoCheckbox(
                                    value: sceneries.every((element) => element.selected == true),
                                    onChanged: (value) {
                                      setState(() {
                                        for (var item in sceneries) {
                                          item.selected = value!;
                                          if (item.items != null) {
                                            for (var i in sceneries) {
                                              i.selected = value;
                                            }
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                CupertinoSwitch(
                                  value: sceneries.every((element) => element.active == true),
                                  activeTrackColor: const Color.fromARGB(255, 0, 161, 255),
                                  onChanged: (value) {
                                    setState(() {
                                      for (var item in sceneries) {
                                        item.active = value;
                                        if (item.items != null) {
                                          for (var i in sceneries) {
                                            i.active = value;
                                          }
                                        }
                                      }
                                    });
                                  },
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 100,
                                  child: DropdownButton(
                                    itemHeight: 24,
                                    dropdownColor: Colors.white,
                                    isDense: true,
                                    value: selectType,
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
                                          style: TextStyle(fontSize: 13),
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
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        for (final item in selected) {
                                          item.type = value!;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 9,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: selected.length > 1
                                      ? selected.where((element) => element.items != null).length != 1
                                          ? () async {
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
                                                                      child: const Text('Make Group'),
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
                                              if (name != null) {
                                                setState(() {
                                                  final pos = sceneries.indexWhere((element) => element.selected);
                                                  final List<Scenery> items = [];
                                                  for (final i in selected) {
                                                    if (i.items != null) {
                                                      items.addAll(i.items!);
                                                    } else {
                                                      items.add(i);
                                                    }
                                                  }
                                                  sceneries = sceneries.where((element) => !element.selected).toList();
                                                  sceneries.insert(pos, Scenery(name: name, path: '', type: SceneryTypes.GROUP, items: items));
                                                });
                                              }
                                            }
                                          : () {
                                              setState(() {
                                                final pos = sceneries.indexWhere((element) => element.selected && element.items != null);
                                                sceneries[pos].items!.addAll(sceneries.where((element) => element.selected && element.items == null).toList());
                                                sceneries = sceneries.where((element) => !element.selected || element.items != null).toList();
                                              });
                                            }
                                      : null,
                                  child: const Text('Group'),
                                ),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReorderableListView(
                            proxyDecorator: ((child, index, animation) => AnimatedBuilder(
                                  animation: animation,
                                  builder: (context, child) => Material(
                                    color: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    child: child,
                                  ),
                                  child: child,
                                )),
                            scrollController: _scrollController,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) newIndex--;
                                final item = sceneries.removeAt(oldIndex);
                                sceneries.insert(newIndex, item);
                              });
                            },
                            children: [
                              for (final item in sceneries)
                                if (item.items == null)
                                  ListTile(
                                    key: GlobalKey(),
                                    leading: Transform.scale(
                                      scale: 1.3,
                                      child: CupertinoCheckbox(
                                          value: item.selected,
                                          onChanged: (value) {
                                            setState(() {
                                              item.selected = value!;
                                            });
                                          }),
                                    ),
                                    title: CustomListItem(scenery: item, selected: idx == -1 ? false : sceneries[idx] == item, updateState: updateFunc),
                                    trailing: const SizedBox(width: 0),
                                    minVerticalPadding: 5,
                                    minLeadingWidth: 0,
                                  )
                                else
                                  ListTile(
                                    key: GlobalKey(),
                                    leading: Transform.scale(
                                      scale: 1.3,
                                      child: CupertinoCheckbox(
                                          value: item.selected,
                                          onChanged: (value) {
                                            setState(() {
                                              item.selected = value!;
                                            });
                                          }),
                                    ),
                                    title: GroupItem(scenery: item, selected: idx2, updateState: setState),
                                    trailing: const SizedBox(width: 0),
                                    minVerticalPadding: 5,
                                    minLeadingWidth: 0,
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
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    required this.s,
  });

  final Stream? s;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: s,
        initialData: Progress(progress: 0, msg: ''),
        builder: (context, snapshot) => SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                snapshot.data!.msg,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              LinearProgressIndicator(
                value: snapshot.data!.progress,
                color: const Color.fromARGB(255, 0, 161, 255),
                backgroundColor: Colors.grey[100],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
