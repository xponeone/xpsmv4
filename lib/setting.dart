import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:xpsmv4/system.dart';
import 'alert.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  final TextEditingController _controller = TextEditingController();
  final configFile = File('${runDir}config.json');
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    if (configFile.existsSync()) {
      _controller.text = jsonDecode(configFile.readAsStringSync())['x-plane_path'] as String;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 50, 50, 55),
        child: Stack(
          children: [
            Positioned(
              top: 24,
              left: 24,
              child: Tooltip(
                message: 'Back',
                child: IconButton(
                  hoverColor: const Color.fromARGB(255, 100, 100, 110),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.navigate_before,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: ElevatedButton(
                onPressed: () {
                  configFile.writeAsStringSync(jsonEncode({'x-plane_path': _controller.text}), mode: FileMode.write);
                  Navigator.pop(context);
                  if (loadSetting(context)) {
                    alert(context, 'Settings have been saved. Please restart program.');
                  } else {
                    alert(context, 'Settings have been saved.');
                  }
                },
                child: Text('Save'),
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 32,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'X-Plane Path*',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            if (_changed)
                              Text(
                                ' restart required',
                                style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIconColor: Colors.black87,
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.all(8),
                                ),
                                onChanged: (value) {
                                  if ('$value${Platform.pathSeparator}Custom Scenery' != path) {
                                    setState(() {
                                      _changed = true;
                                    });
                                  } else {
                                    setState(() {
                                      _changed = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            SizedBox(
                              height: 32,
                              width: 32,
                              child: ElevatedButton(
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['exe'], dialogTitle: 'Select "X-Plane.exe"');
                                  if (result != null) {
                                    String mainDir = p.dirname(result.files.single.path ?? '');
                                    if (File('$mainDir\\X-Plane.exe').existsSync() && Directory('$mainDir\\Custom Scenery').existsSync()) {
                                      _controller.text = mainDir;
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                ),
                                child: const Icon(
                                  Icons.folder_open,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          removeCache();
                        },
                        child: const Text('remove cache'))
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

void save() {}
