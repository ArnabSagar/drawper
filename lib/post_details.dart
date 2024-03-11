import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Generates the desired display of the given date, which must be in YYYY-MM-DD format
String getDateDisplay(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
  return formattedDate;
}

class PostDetails extends StatefulWidget {
  const PostDetails({super.key, required this.post});
  final Map post;

  @override
  PostDetailsState createState() => PostDetailsState();
}

class PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '@${widget.post["author"]["username"]}\'s drawp',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.pink.shade500,
      ),
      //         onTap: () {
      //           Navigator.pushAndRemoveUntil(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) =>
      //                       const MyHomePage(title: "Drawper Login Page")),
      //               (route) => false);
      //         },

      body: Column(
        children: [
          // Date and Caption
          Container(
            child: Column(
              children: [
                Text('Date: ${getDateDisplay(widget.post['post_date'])}'),
                Text('Prompt: ${widget.post['prompt']['title']}')
              ],
            ),
          ),
          // Darp Image
          Container(
            child: Image(image: NetworkImage(widget.post['image_url'])),
          ),
          // Likes, Dislikes, Views
          Container(
            child: const Row(
              children: [],
            ),
          ),
          // Comments
          Container(),
        ],
      ),
    );
  }
}
