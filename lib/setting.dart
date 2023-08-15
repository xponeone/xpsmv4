import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:xpsmv4/main.dart';
import 'package:xpsmv4/system.dart';
import 'color.dart';

String? path;

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<StatefulWidget> createState() {
    return SettingState();
  }
}

class SettingState extends State<Setting> {
  final TextEditingController _textEditingController = TextEditingController();
  static final GlobalKey<MyAppState> myAppKey = GlobalKey<MyAppState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.7,
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.folder),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIconColor: Color.fromARGB(255, 50, 50, 55),
                    labelText: null,
                    hintText: 'X-Plane Path',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 0, 161, 255),
                      ),
                    ),
                  ),
                  controller: _textEditingController,
                  cursorColor: Colors.white,
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () async {
                  await getDirectoryPath().then(
                    (value) {
                      if (value != null) {
                        setState(() {
                          _textEditingController.text = value;
                        });
                      }
                    },
                  );
                },
                icon: const Icon(
                  Icons.folder_open,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void save() {}
