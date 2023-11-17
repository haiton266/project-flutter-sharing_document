import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CommentsPage(),
    );
  }
}

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<dynamic> comments = [];
  TextEditingController contentController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://haiton26062.pythonanywhere.com/feedback_data/1'));

    if (response.statusCode == 200) {
      setState(() {
        comments = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> postComment() async {
    final response = await http.post(
      Uri.parse('https://haiton26062.pythonanywhere.com/feedback_data/add'),
      body: json.encode({
        'content': contentController.text,
        'username': 'hai',
        'id_pdf': 1,
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
