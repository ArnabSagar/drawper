import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class Draw extends StatefulWidget {
  const Draw({Key? key}) : super(key: key);

  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  List<Line> lines = [];
  Color currentColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draw Something"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Today\'s Prompt is: Cats',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 50,),
          Expanded(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center, // Align children closer together
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                lines.clear();
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.palette),
                            onPressed: () {
                              _showColorPickerDialog(); // Implement eraser tool if needed
                            },
                          ),
                        ],
                      ),
                ),
                Center(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          lines.add(Line(color: currentColor, points: [details.localPosition]));
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          lines.last.points.add(details.localPosition);
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          lines.last.points.add(null); // Indicates the end of a line
                        });
                      },
                      child: CustomPaint(
                        painter: DrawingPainter(lines: lines),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement finish action
        },
        child: const Text('Done!'),
      ),
    );
  }

  void _showColorPickerDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: (color) {
              setState(() {
                currentColor = color;
              });
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

}

class Line {
  Color color;
  List<Offset?> points;

  Line({required this.color, required this.points});
}

class DrawingPainter extends CustomPainter {
  List<Line> lines;

  DrawingPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      Paint paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0;

      for (int i = 0; i < line.points.length - 1; i++) {
        if (line.points[i] != null && line.points[i + 1] != null) {
          canvas.drawLine(line.points[i]!, line.points[i + 1]!, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}