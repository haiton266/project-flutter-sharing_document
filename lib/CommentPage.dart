import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'pdf_viewer.dart';

class CommentPage extends StatefulWidget {
  final int id;

  CommentPage(this.id);
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentPage> {
  List<dynamic> comments = [];
  TextEditingController contentController = TextEditingController();

  String name_file = "";
  String name_type = "";
  String name_school = "";
  String url_pdf = "";
  bool dataLoaded1 = false; // Biến cờ để kiểm tra dữ liệu đã được tải
  bool dataLoaded2 = false; // Biến cờ để kiểm tra dữ liệu đã được tải

  @override
  void initState() {
    super.initState();
    fetchData();
    _fetchInfoPdf();
  }

  Future<void> _fetchInfoPdf() async {
    try {
      var response = await http.get(Uri.parse(
          'https://haiton26062.pythonanywhere.com/image/${widget.id}'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          name_file = data['name'];
          name_type = data['type'];
          name_school = data['school'];
          url_pdf = data['pdf_url'];
          print(url_pdf);
          dataLoaded1 = true; // Đặt cờ thành true sau khi dữ liệu đã được tải
        });
      }
    } catch (e) {
      print('Error fetching PDF: $e');
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://haiton26062.pythonanywhere.com/feedback_data/${widget.id}'));

    if (response.statusCode == 200) {
      setState(() {
        comments = json.decode(response.body);
        dataLoaded2 = true;
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
      // Clear text field after successful submission
      contentController.clear();
      // Fetch updated data after adding the comment
      fetchData();
    } else {
      throw Exception('Failed to post comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!dataLoaded1 || !dataLoaded2) {
      // Nếu dữ liệu chưa được tải, bạn có thể hiển thị một tiêu đề hoặc tiến trình tải
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Nếu dữ liệu đã được tải, hiển thị giao diện bình thường
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$name_type',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Image.asset('assets/pdf.png', height: 120),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' $name_file',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '  $name_type',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '  $name_school',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyPdfViewer(url_pdf),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side:
                              BorderSide(color: Colors.purple, width: 2.0),
                            ),
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 32.0),
                            minimumSize: Size(35.0, 25.0),
                          ),
                          child: Text(
                            'Xem ngay',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Comments',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    comments[index]['username'],
                    style: TextStyle(fontSize: 24),
                  ),
                  subtitle: Text(comments[index]['content']),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Nhập bình luận',
                suffixIcon: IconButton(
                  onPressed: () {
                    postComment();
                  },
                  icon: Icon(Icons.send), // Biểu tượng thay thế 'Send'
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
