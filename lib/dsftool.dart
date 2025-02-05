import 'dart:collection';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:xpsmv4/system.dart';
import 'package:path/path.dart' as p;

enum SceneryTypes {
  AIRPORT,
  HELIPAD,
  GLOBAL,
  CITY,
  OVERLAY,
  PHOTOREAL,
  MESH,
  LIBRARY,
  GROUP,
  UNKNOWN;

  factory SceneryTypes.fromString(String code) {
    switch (code) {
      case 'SceneryTypes.AIRPORT':
        return SceneryTypes.AIRPORT;
      case 'SceneryTypes.HELIPAD':
        return SceneryTypes.HELIPAD;
      case 'SceneryTypes.GLOBAL':
        return SceneryTypes.GLOBAL;
      case 'SceneryTypes.CITY':
        return SceneryTypes.CITY;
      case 'SceneryTypes.OVERLAY':
        return SceneryTypes.OVERLAY;
      case 'SceneryTypes.PHOTOREAL':
        return SceneryTypes.PHOTOREAL;
      case 'SceneryTypes.MESH':
        return SceneryTypes.MESH;
      case 'SceneryTypes.LIBRARY':
        return SceneryTypes.LIBRARY;
      case 'SceneryTypes.GROUP':
        return SceneryTypes.GROUP;
      default:
        return SceneryTypes.UNKNOWN;
    }
  }
}

extension SceneryTypesExtension on SceneryTypes {
  String get string {
    switch (this) {
      case SceneryTypes.AIRPORT:
        return 'SceneryTypes.AIRPORT';
      case SceneryTypes.HELIPAD:
        return 'SceneryTypes.HELIPAD';
      case SceneryTypes.GLOBAL:
        return 'SceneryTypes.GLOBAL';
      case SceneryTypes.CITY:
        return 'SceneryTypes.CITY';
      case SceneryTypes.OVERLAY:
        return 'SceneryTypes.OVERLAY';
      case SceneryTypes.PHOTOREAL:
        return 'SceneryTypes.PHOTOREAL';
      case SceneryTypes.MESH:
        return 'SceneryTypes.MESH';
      case SceneryTypes.LIBRARY:
        return 'SceneryTypes.LIBRARY';
      case SceneryTypes.GROUP:
        return 'SceneryTypes.GROUP';
      case SceneryTypes.UNKNOWN:
        return 'SceneryTypes.UNKNOWN';
    }
  }
}

final class Str extends Struct {
  external Pointer<Utf8> p;
  @Uint32()
  external int len;
}

final class Result extends Struct {
  external Str TERT;
  external Str OBJT;
  external Str POLY;
  external Str NETW;
  external Str DEMN;
}

final Result Function(Pointer<Utf8>) getDEFN = DynamicLibrary.open('dsftool.dll').lookup<NativeFunction<Result Function(Pointer<Utf8>)>>('getDEFN').asFunction();
final void Function(Result) freeMem = DynamicLibrary.open('dsftool.dll').lookup<NativeFunction<Void Function(Result)>>('freeMem').asFunction();

final db = sqlite3.open('${runDir}library.db', mode: OpenMode.readOnly);
final stmt = db.prepare('SELECT lib FROM lib WHERE path=? LIMIT 1');
final stmtdef = db.prepare('SELECT * FROM def$version WHERE path=? LIMIT 1');

List<String> split2list(Str s) {
  List<String> data = [];
  int pos = 0;
  while (pos < s.len) {
    data.add(Pointer<Utf8>.fromAddress(s.p.address + pos).toDartString());
    pos += data.last.length + 1;
  }
  return data;
}

class DSF {
  final String path;
  List<String> data = [];
  int TERT = 0;
  int OBJT = 0;
  int POLY = 0;
  int NETW = 0;
  int DEMN = 0;
  DSF({required this.path}) {
    final res = getDEFN(path.toNativeUtf8());
    TERT = res.TERT.len;
    OBJT = res.OBJT.len;
    POLY = res.POLY.len;
    NETW = res.NETW.len;
    DEMN = res.DEMN.len;
    data.addAll(split2list(res.TERT));
    data.addAll(split2list(res.OBJT));
    data.addAll(split2list(res.POLY));
    data.addAll(split2list(res.NETW));
    data.addAll(split2list(res.DEMN));
    freeMem(res);
  }

  Set<String> getLibrarySync() {
    final scenery = p.dirname(p.dirname(p.dirname(path)));
    print(scenery);
    Set<String> res = {};
    for (final vp in data) {
      if (stmtdef.select([vp]).isEmpty) {
        final result = stmt.select([vp]);
        if (result.isNotEmpty) {
          res.add(result.first['lib']);
        }
      }
    }
    return SplayTreeSet.from(res);
  }

  Future<Set<String>> getLibrary() async {
    Set<String> res = {};
    for (final vp in data) {
      if (stmtdef.select([vp]).isEmpty) {
        final result = stmt.select([vp]);
        if (result.isNotEmpty) {
          res.add(result.first['lib']);
        }
      }
    }
    return res;
  }
}
