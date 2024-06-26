import 'package:flutter/material.dart';

// Generates the desired display of the given date, which must be in YYYY-MM-DD format
// String getDateDisplay(String date) {
//   try {
//     DateTime dateTime = DateTime.parse(date);
//     String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
//     return formattedDate;
//   } catch (e) {
//     print('Error parsing date: $e');
//     return 'Invalid Date';
//   }
// }

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
      body: SingleChildScrollView(
        child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                        text: '${widget.post['prompt']}',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
                    const TextSpan(text: " "),
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
                    const TextSpan(text: " "),
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
                    const TextSpan(text: " "),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 15),
              Text("Comments", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))
            ]
          ),
          widget.post['comments'].length == 0
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
                }),
          ],
        ),
      ),
    );
  }
}
