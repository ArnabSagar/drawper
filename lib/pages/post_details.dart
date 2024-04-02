import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Generates the desired display of the given date, which must be in YYYY-MM-DD format
String getDateDisplay(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
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
          '@${widget.post['authorUName']}\'s drawp',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Date: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    TextSpan(
                        text: getDateDisplay(widget.post['timestamp']),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18)),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Prompt: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    TextSpan(
                        text: '${widget.post['prompt']}',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          Image(image: NetworkImage(widget.post['imageURL'])),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.thumb_up_sharp,
                      size: 24,
                    )),
                    TextSpan(
                        text: '${widget.post['likes']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ],
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.thumb_down_sharp,
                      size: 24,
                    )),
                    TextSpan(
                        text: '${widget.post['dislikes']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ],
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.remove_red_eye_outlined,
                      size: 24,
                    )),
                    TextSpan(
                        text: '${widget.post['views']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: widget.post['comments'].length == 0
                  ? const ListTile(
                      title: Text(
                      "No Comments",
                      textAlign: TextAlign.center,
                    ))
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.post['comments'].length,
                      itemBuilder: (BuildContext c, int i) {
                        return ListTile(
                          title: Text(
                              '${widget.post['comments'][i]['userName']}:'),
                          subtitle:
                              Text(' ${widget.post['comments'][i]['commentStr']}'),
                        );
                      })),
        ],
      ),
    );
  }
}
