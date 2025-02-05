import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  final String message;
  final OverlayEntry overlayEntry;
  final Color color;

  const Alert({required this.message, required this.overlayEntry, required this.color, super.key});

  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(_controller);
    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (_controller.isCompleted) {
        _controller.reverse().then((_) => widget.overlayEntry.remove());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.all(10),
          width: 360,
          height: 36,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 250, 250, 250),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                    child: Text(
                      widget.message,
                      style: TextStyle(color: widget.color, fontSize: 16),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _controller.reverse().then((_) => widget.overlayEntry.remove());
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon( Icons.close, color: Colors.black87, size: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void alert(BuildContext context, String message, {Color color=Colors.black87}) {
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(builder: (context) => Alert(message: message, overlayEntry: overlayEntry, color: color));
  Overlay.of(context).insert(overlayEntry);
}
