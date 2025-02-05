import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:xpsmv4/dsftool.dart';
import 'package:xpsmv4/system.dart';
import 'setting.dart' as setting;

class Sidebar extends StatefulWidget {
  final Function scroll;
  final Function changeStream;
  const Sidebar({required this.scroll, required this.changeStream, super.key});

  @override
  State<StatefulWidget> createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  final _textController = TextEditingController();
  bool onSearching = false;
  List<Widget> finded = [];

  void updateFunc(fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: onSearching ? 300 : 48,
      height: double.infinity,
      color: const Color.fromARGB(255, 50, 50, 55),
      child: Row(
        children: [
          Column(
            verticalDirection: VerticalDirection.up,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Tooltip(
                      message: 'Setting',
                      child: IconButton(
                          hoverColor: const Color.fromARGB(255, 100, 100, 110),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const setting.Setting()));
                          },
                          icon: const Icon(Icons.settings, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Tooltip(
                      message: 'Search',
                      child: IconButton(
                          hoverColor: const Color.fromARGB(255, 100, 100, 110),
                          onPressed: () {
                            setState(() {
                              onSearching = !onSearching;
                              widget.scroll(-1);
                            });
                          },
                          icon: Icon(Icons.manage_search, color: onSearching ? const Color.fromARGB(255, 0, 161, 255) : Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Tooltip(
                      message: 'Refresh',
                      child: IconButton(
                          hoverColor: const Color.fromARGB(255, 100, 100, 110),
                          onPressed: () {
                            widget.changeStream(refresh());
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Tooltip(
                      message: 'Sort',
                      child: IconButton(
                          hoverColor: const Color.fromARGB(255, 100, 100, 110),
                          onPressed: () {
                            sort();
                          },
                          icon: const Icon(Icons.sort, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Tooltip(
                      message: 'Save',
                      child: IconButton(
                          hoverColor: const Color.fromARGB(255, 100, 100, 110),
                          onPressed: () {
                            save(context);
                          },
                          icon: const Icon(Icons.save, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Tooltip(
                      message: 'Load',
                      child: IconButton(
                          hoverColor: const Color.fromARGB(255, 100, 100, 110),
                          onPressed: () {
                            widget.changeStream(load());
                          },
                          icon: const Icon(Icons.file_open_outlined, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (onSearching)
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 235, 235, 235),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 32,
                              width: 200,
                              child: CupertinoTextField(
                                controller: _textController,
                                style: const TextStyle(fontSize: 16, height: 1),
                                suffix: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(Icons.close, color: Colors.grey[300], size: 14),
                                  ),
                                  onTap: () {
                                    _textController.clear();
                                  },
                                ),
                                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color.fromARGB(255, 0, 161, 255))),
                                placeholder: 'Search',
                                onChanged: (value) {
                                  setState(() {
                                    finded = [];
                                    if (value != '') {
                                      for (Scenery e in sceneries) {
                                        int match = 0;
                                        if (e.name.toLowerCase().contains(value.toLowerCase())) match += 1;
                                        if (e.items == null) {
                                          for (final ap in e.ap) {
                                            if (ap.name.toLowerCase().contains(value.toLowerCase())) match += 2;
                                            break;
                                          }
                                          for (final ap in e.ap) {
                                            if (ap.icao.toUpperCase().contains(value.toUpperCase())) match += 4;
                                            break;
                                          }
                                          if (match > 0) {
                                            finded.add(SearchItem(
                                              scenery: e,
                                              match: match,
                                              onTap: () {
                                                widget.scroll(sceneries.indexOf(e));
                                              },
                                            ));
                                          }
                                        } else {
                                          for (final i in e.items!) {
                                            int m = 0;
                                            if (i.name.contains(value)) m += 1;
                                            if (i.name.toLowerCase().contains(value.toLowerCase())) m += 2;
                                            if (i.path.contains(value)) m += 4;
                                            // for (final icao in i.getAirportICAOList()) {
                                            //   if (icao.toUpperCase().contains(value.toUpperCase())) m += 8;
                                            //   if (name.toLowerCase().contains(value.toLowerCase())) m += 16;
                                            //   break;
                                            // }
                                            if (m > 0) {
                                              finded.add(
                                                SearchItem(
                                                  scenery: i,
                                                  match: m,
                                                  onTap: () {
                                                    widget.scroll(sceneries.indexOf(e), index2: e.items!.indexOf(i));
                                                  },
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      }
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              height: 32,
                              width: 32,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final findTiles = await showDialog<List<String>>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        List<Polygon> tiles = [];
                                        List<String> tilenames = [];
                                        final MapController _mapController = MapController();
                                        return StatefulBuilder(builder: (context, setState) {
                                          return Dialog(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.7,
                                              height: MediaQuery.of(context).size.height * 0.7,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.white,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16),
                                                child: Row(
                                                  spacing: 16,
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(4),
                                                        child: FlutterMap(
                                                          mapController: _mapController,
                                                          options: MapOptions(
                                                            initialZoom: 2,
                                                            onTap: (tapPosition, point) {
                                                              final lat = point.latitude.floor(), long = point.longitude.floor();
                                                              final tilename = '${lat >= 0 ? '+' : '-'}${lat.abs().toString().padLeft(2, '0')}${long >= 0 ? '+' : '-'}${long.abs().toString().padLeft(3, '0')}';
                                                              final find = tilenames.indexOf(tilename);
                                                              if (find == -1) {
                                                                setState(() {
                                                                  final tile = Polygon(points: [
                                                                    LatLng(lat.toDouble(), long.toDouble()),
                                                                    LatLng(lat.toDouble() + 1, long.toDouble()),
                                                                    LatLng(lat.toDouble() + 1, long.toDouble() + 1),
                                                                    LatLng(lat.toDouble(), long.toDouble() + 1),
                                                                  ], color: Colors.red.withOpacity(0.4), borderColor: Colors.red, borderStrokeWidth: 1.0);
                                                                  tiles.add(tile);
                                                                  tilenames.add(tilename);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  tiles.removeAt(find);
                                                                  tilenames.removeAt(find);
                                                                });
                                                              }
                                                            },
                                                          ),
                                                          children: [
                                                            TileLayer(
                                                              urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                            ),
                                                            PolygonLayer(
                                                              polygons: tiles,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors.grey,
                                                                ),
                                                                borderRadius: BorderRadius.circular(4),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(4),
                                                                child: ListView(
                                                                  children: [
                                                                    for (var i = 0; i < tiles.length; i++)
                                                                      TileItem(
                                                                        tile: tilenames[i],
                                                                        onTap: () {
                                                                          _mapController.move(LatLng(tiles[i].points.first.latitude + 0.5, tiles[i].points.first.longitude + 0.5), 7);
                                                                        },
                                                                        onX: () {
                                                                          setState(() {
                                                                            tiles.removeAt(i);
                                                                            tilenames.removeAt(i);
                                                                          });
                                                                        },
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 8),
                                                          SizedBox(
                                                            width: 150,
                                                            child: ElevatedButton(
                                                              child: const Text('Done'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop(tilenames);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      });
                                  updateFunc(() {
                                    finded = [];
                                    for (final e in sceneries) {
                                      if (e.items == null) {
                                        if (e.getTiles().any((element) => findTiles!.contains(element))) {
                                          finded.add(SearchItem(
                                            scenery: e,
                                            match: 8,
                                            onTap: () {
                                              widget.scroll(sceneries.indexOf(e));
                                            },
                                          ));
                                        }
                                      } else {
                                        for (final i in e.items!) {
                                          if (i.getTiles().any((element) => findTiles!.contains(element))) {
                                            finded.add(
                                              SearchItem(
                                                scenery: i,
                                                match: 8,
                                                onTap: () {
                                                  widget.scroll(sceneries.indexOf(e), index2: e.items!.indexOf(i));
                                                },
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                ),
                                child: const Icon(
                                  Icons.travel_explore,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 11),
                          child: ListView(
                            children: finded,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TileItem extends StatefulWidget {
  final String tile;
  final Function onX;
  final Function onTap;
  const TileItem({required this.tile, required this.onTap, required this.onX, super.key});

  @override
  State<StatefulWidget> createState() => TileItemState();
}

class TileItemState extends State<TileItem> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          onHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          onHover = false;
        });
      },
      child: GestureDetector(
        onTap: () => widget.onTap(),
        child: Container(
          color: onHover ? Colors.grey[100] : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.tile,
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                  iconSize: 12,
                  onPressed: () => widget.onX(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchItem extends StatefulWidget {
  final Scenery scenery;
  final int match;
  // final String keyword;
  final Function onTap;
  // match
  // 16 그룹 속 일치
  // 8 좌표일치(lat, long)
  // 4  ICAO코드 일치
  // 2 공항 일치
  // 1  이름일치
  const SearchItem({required this.scenery, required this.match, required this.onTap, super.key});

  @override
  State<StatefulWidget> createState() => SearchItemState();
}

class SearchItemState extends State<SearchItem> {
  bool onHover = false;

  List<TextSpan> highlight(String text, String keyword) {
    List<TextSpan> spans = [];
    int start = 0, idx = 0;
    while (text != '') {
      idx = text.toLowerCase().indexOf(keyword.toLowerCase(), start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(text: text.substring(idx, idx + keyword.length), style: const TextStyle(backgroundColor: Colors.amber)));
      start = idx + keyword.length;
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          onHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          onHover = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Container(
          color: onHover ? const Color.fromARGB(255, 225, 225, 225) : const Color.fromARGB(255, 235, 235, 235),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 11, right: 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.scenery.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                )
                // RichText(
                //   text: TextSpan(
                //     children: highlight(widget.scenery.name, widget.keyword),
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.black54,
                //     ),
                //   ),
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 1,
                // ),
                // if (widget.match & 4 > 0)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 8, top: 2),
                //     child: RichText(
                //       text: TextSpan(
                //         children: highlight(widget.scenery.path, widget.keyword),
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.w500,
                //           color: Colors.black54,
                //         ),
                //       ),
                //       overflow: TextOverflow.ellipsis,
                //       maxLines: 1,
                //     ),
                //   ),
                // if (widget.match & 8 > 0)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 8, top: 2),
                //     child: RichText(
                //       text: TextSpan(
                //         children: highlight(widget.scenery.getAirportICAO(), widget.keyword),
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.w500,
                //           color: Colors.black54,
                //         ),
                //       ),
                //       overflow: TextOverflow.ellipsis,
                //       maxLines: 1,
                //     ),
                //   ),
                // if (widget.match & 16 > 0)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 8, top: 2),
                //     child: RichText(
                //       text: TextSpan(
                //         children: highlight(widget.scenery.getAirportName(), widget.keyword),
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.w500,
                //           color: Colors.black54,
                //         ),
                //       ),
                //       overflow: TextOverflow.ellipsis,
                //       maxLines: 1,
                //     ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
