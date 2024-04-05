import 'dart:typed_data';
import 'dart:io';
import 'package:drawper/services/database.dart';
import 'package:drawper/services/storage.dart';
import 'package:drawper/utils/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class Draw extends StatefulWidget {
  const Draw({Key? key}) : super(key: key);

  @override
  DrawState createState() => DrawState();
}

class DrawState extends State<Draw> {
  final ScreenshotController screenshotController = ScreenshotController();
  
  final StorageService _storage = StorageService();
  // late
  final logger = ToastMessage();
  
  List<Line> lines = [];
  List<Line> redoStack = []; // Stack to store history for undo/redo

  Color currentColor = Colors.blue; // Current stroke color
  double strokeWidth = 5.0; // Initial stroke width
  StrokeCap strokeShape = StrokeCap.round; // Initial stroke shape
  bool isEraserSelected =
      false; // Variable to track whether eraser tool is selected

  @override
  void initState() {
    super.initState();
    //  DatabaseService databaseService = DatabaseService(uid: widget.user.uid);
  }

  Future _uploadDrawper(Uint8List file, String filename, String uid, String? displayname) async {
    try {
      if (context.mounted) {
        // Show loading widget
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent user from dismissing dialog
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        DatabaseService databaseService = DatabaseService();
        

        await _storage.uploadFile(file, filename);
        String imageURL = await _storage.getDownloadURL(filename);
        String timestamp = _getDateString();
        await databaseService.createPostData(displayname ?? "displaynamenotfound", uid, imageURL, timestamp, "Cats");
        // add the post to the user's database somehow and 
        // logger.toast(message: "File successfully created!\nLogging in");

        // Hide loading widget
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Dismiss dialog

        // Navigate after upload
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(newDrawing: file),
          ),
        );
      }
    } catch (e) {
      logger.toast(message: "$e");
      // ignore: avoid_print
      print(e);
    }
  }

  String _getDateString() {
    DateTime now = DateTime.now();
    String date = DateTime(now.year, now.month, now.day)
        .toString()
        .replaceAll("00:00:00.000", "");
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draw something related to..."),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              'Cats', // TODO ADD DAILY PROMPT LOGIC TO GENERATE THIS
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                          size: 35,
                        ),
                        onPressed: () {
                          _showConfirmationDialog();
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.palette,
                              color: currentColor,
                              size: 35,
                            ),
                            onPressed: () {
                              _showColorPickerDialog();
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.brush,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () {
                              _showStrokeWidthDialog();
                            },
                          ),
                          IconButton(
                            icon: (isEraserSelected == true
                                ? SvgPicture.asset(
                                    'assets/icons/ink_eraser.svg',
                                    width: 36,
                                    height: 36)
                                : SvgPicture.asset(
                                    'assets/icons/ink_eraser_off.svg',
                                    width: 36,
                                    height: 36)),
                            onPressed: () {
                              setState(() {
                                isEraserSelected = !isEraserSelected;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.undo,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: _undoStroke,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.redo,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: _redoStroke,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Screenshot(
                    controller: screenshotController,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onPanStart: (details) {
                          Color drawColor = currentColor;
                          if (isEraserSelected) {
                            drawColor = Colors.white;
                          }
                          setState(() {
                            lines.add(Line(
                                color: drawColor,
                                strokeWidth: strokeWidth,
                                strokeShape: strokeShape,
                                points: [details.localPosition]));
                          });
                        },
                        onPanUpdate: (details) {
                          Offset localPosition = details.localPosition;
                          if (localPosition.dx >= 0 &&
                              localPosition.dx <=
                                  MediaQuery.of(context).size.width &&
                              localPosition.dy >= 0 &&
                              localPosition.dy <=
                                  MediaQuery.of(context).size.width) {
                            setState(() {
                              lines.last.points.add(localPosition);
                            });
                          }
                        },
                        onPanEnd: (details) {
                          setState(() {
                            lines.last.points
                                .add(null); // Indicates the end of a line
                          });
                        },
                        child: CustomPaint(
                          painter: DrawingPainter(lines: lines),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all(Colors.purple.shade900)),
            onPressed: () async {
              // Capture the screenshot
              Uint8List? imageUint8List = await screenshotController.capture();
              if (imageUint8List != null) {
                // Save the screenshot as an image file

                Uint8List img = imageUint8List.buffer.asUint8List();

                User? user = FirebaseAuth.instance.currentUser;
                if (user != null){
                  // Format of saving the current day's post
                  // <uid>_<date>
                  String fileName = "${user.uid.toString()}_${_getDateString()}";

                  //_uploadDrawper(context, img, fileName);
                  _uploadDrawper(img, fileName, user.uid, user.displayName);
                } else {
                  // ignore: avoid_print
                  print("ERROR: user is null, could not upload drawp (no one logged in?)");
                }
                
              }
            },
            child: const Text('Drawp It!'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Change color
  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
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
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Change pen thickness / shape
  void _showStrokeWidthDialog() async {
    // this will contain the result from Navigator.pop(context, result)
    final Map<String, dynamic>? result =
        (await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => StrokeWidthShapePickerDialog(
          initialStrokeWidth: strokeWidth, initialStrokeShape: strokeShape),
    ));

    // execution of this code continues when the dialog was closed (popped)

    setState(() {
      strokeWidth = result?['selectedStrokeWidth'];
      strokeShape = result?['selectedStrokeShape'];
    });
  }

  // Confirmation dialog for clearing drawing
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to clear your drawing?'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    lines.clear();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'YES',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 20), // Add some spacing between buttons
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'NO',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _undoStroke() {
    if (lines.isNotEmpty) {
      setState(() {
        redoStack.add(lines.last);
        lines.removeLast();
      });
    }
  }

  void _redoStroke() {
    if (redoStack.isNotEmpty) {
      setState(() {
        lines.add(redoStack.last);
        redoStack.removeLast();
      });
    }
  }

  // This saves the image somewhere in the android emulator file system,
  // I wanted to save it to like the directory here but i cant figure out how, it seems pretty hard,
  // It's prob just easier to upload to AWS bucket or something and into our database eventually
  void saveImage(Uint8List imageUint8List) async {
    // Convert the Uint8List to an Image
    // ui.Image image = await decodeImageFromList(imageUint8List.buffer.asUint8List());

    // Save the Image to the device's storage
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/drawing4.png';
    final File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageUint8List);

    // Display a message
    // ignore: avoid_print
    print('Image saved to $imagePath');
  }
}

class Line {
  Color color;
  double strokeWidth;
  StrokeCap strokeShape;
  List<Offset?> points;

  Line(
      {required this.color,
      required this.strokeWidth,
      required this.strokeShape,
      required this.points});
}

class DrawingPainter extends CustomPainter {
  List<Line> lines;

  DrawingPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      Paint paint = Paint()
        ..color = line.color
        ..strokeCap = line.strokeShape
        ..strokeWidth = line.strokeWidth;

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

// Need to have class for this dialog so that it can update when people move the slider and stuff
class StrokeWidthShapePickerDialog extends StatefulWidget {
  final double initialStrokeWidth;
  final StrokeCap initialStrokeShape;

  const StrokeWidthShapePickerDialog(
      {Key? key,
      required this.initialStrokeWidth,
      required this.initialStrokeShape})
      : super(key: key);

  @override
  StrokeWidthShapePickerDialogState createState() =>
      StrokeWidthShapePickerDialogState();
}

class StrokeWidthShapePickerDialogState
    extends State<StrokeWidthShapePickerDialog> {
  late double _strokeWidth;
  late StrokeCap _strokeShape;

  @override
  void initState() {
    super.initState();
    _strokeWidth = widget.initialStrokeWidth;
    _strokeShape = widget.initialStrokeShape;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Stroke Width',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "${_strokeWidth.toStringAsFixed(2)}  ",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CustomPaint(
                            painter: StrokeWidthIndicatorPainter(
                                strokeWidth: _strokeWidth),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _strokeWidth,
                      min: 0.0,
                      max: 15.0,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          _strokeWidth = value;
                        });
                      },
                    ),
                  ]),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Stroke Shape',
                            style: TextStyle(fontSize: 14)),
                        Text(
                            _strokeShape == StrokeCap.round
                                ? "Round"
                                : "Square",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(_strokeShape == StrokeCap.round
                              ? Icons.circle
                              : Icons.circle_outlined),
                          onPressed: () {
                            setState(() {
                              _strokeShape = StrokeCap.round;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(_strokeShape == StrokeCap.round
                              ? Icons.square_outlined
                              : Icons.square),
                          onPressed: () {
                            setState(() {
                              _strokeShape = StrokeCap.square;
                            });
                          },
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          // style: ButtonStyle(),
          onPressed: () {
            Navigator.of(context).pop({
              'selectedStrokeWidth':
                  _strokeWidth, // Replace with the selected stroke size
              'selectedStrokeShape':
                  _strokeShape, // Replace with the selected stroke shape
            });
          },
          child: const Text(
            'OK',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}

class StrokeWidthIndicatorPainter extends CustomPainter {
  final double strokeWidth;

  StrokeWidthIndicatorPainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(0, size.height / 2), Offset(20, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
