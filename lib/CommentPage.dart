import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'pdf_viewer.dart';

// class CommentPage extends StatelessWidget {
//   final int id;
//
//   CommentPage(this.id);
//
//   @override
//   Widget build(BuildContext context) {
//     // Sử dụng ID ở đây cho mục đích của bạn
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Page'),
//       ),
//       body: Center(
//         child: Text('ID: $id'), // Hiển thị ID hoặc thông tin khác
//       ),
//     );
//   }
// }


class CommentPage extends StatefulWidget {
  final int id;

  CommentPage(this.id);
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentPage> {
  List<dynamic> comments = [];
  TextEditingController contentController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String name_file = "";
  String url_pdf = "";
  @override
  void initState() {
    super.initState();
    fetchData();
    _fetchInfoPdf();
  }

  Future<void> _fetchInfoPdf() async {
    try {
      var response = await http.get(
          Uri.parse('https://haiton26062.pythonanywhere.com/image/${widget.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        name_file = data['name'];
        url_pdf = data['pdf_url'];
        print(url_pdf);
      }
    } catch (e) {
      print('Error fetching PDF: $e');
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://haiton26062.pythonanywhere.com/feedback_data/${widget.id}'));

    if (response.statusCode == 200) {
      setState(() {
        comments = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> postComment() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final response = await http.post(
      Uri.parse('https://haiton26062.pythonanywhere.com/feedback_data/add'),

      body: json.encode({
        'content': contentController.text,
        'username': username,
        'id_pdf': widget.id,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Clear text fields after successful submission
      contentController.clear();
      usernameController.clear();

      // Fetch updated data after adding the comment
      fetchData();
    } else {
      throw Exception('Failed to post comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Text('Abc${name_file}'),
          ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPdfViewer(url_pdf)), // Điều hướng đến màn hình PDF
            );
          },
          child: Text('PDF'),
        ),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(comments[index]['username']),
                  subtitle: Text(comments[index]['content']),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: 'Enter content'),
                ),
                ElevatedButton(
                  onPressed: () {
                    postComment();
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}