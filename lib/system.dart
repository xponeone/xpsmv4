import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'color.dart';

enum SceneryType { airport, city, library, overlay, photoreal, mesh }

List<Scenery> sceneries = [];

typedef ResolveLnkPath = Pointer<Utf8> Function(Pointer<Utf8> shortcutPath);
final dylib = DynamicLibrary.open('C:\\Users\\kyuye\\Desktop\\XPSMV4\\xpsmv4\\build\\windows\\runner\\Debug\\shortcut_resolver.dll');
final resolveLnkPath = dylib.lookupFunction<ResolveLnkPath, ResolveLnkPath>('ResolveLnkPath');

String getLnkPath(String path) {
  final lnkPath = path.toNativeUtf8();
  final ret = resolveLnkPath(lnkPath).toDartString();
  calloc.free(lnkPath);
  return ret;
}

void init() {
  String path = 'D:\\X-Plane 12\\Custom Scenery';
  for (final f in Directory(path)
      .listSync(followLinks: true)
      .map((e) => e.path)
      .toList()) {
    if (!File(f).existsSync()) {
      sceneries.add(Scenery(name: basename(f), path: f, type: 'f'));
    } else if (f.contains('.lnk')) {
      String link = getLnkPath(f);
      sceneries.add(Scenery(name: basename(link), path: link, type: 'l'));
    }
  }
}

void refresh() {}

void save() {}

void load() {}

class Scenery {
  String name;
  String path;
  String type;
  bool active;
  bool selceted;
  Scenery({
    required this.name,
    required this.path,
    required this.type,
    this.active = true,
    this.selceted = false,
  });
}

class MessageBox extends StatelessWidget {
  final String msg;
  const MessageBox({
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: bgColor,
        child: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: highligtColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

void showMessageBox(dynamic context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return MessageBox(msg: msg);
    },
  );
}
