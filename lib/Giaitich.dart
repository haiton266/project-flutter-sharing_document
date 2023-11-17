import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CommentPage.dart';

class Subject extends StatefulWidget {
  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  late List<dynamic> arrData; // List chứa dữ liệu từ API
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://haiton26062.pythonanywhere.com/image/Subject'));

      if (response.statusCode == 200) {
        // Nếu yêu cầu thành công, parse dữ liệu từ JSON
        setState(() {
          arrData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Hiển thị thông báo lỗi ở đây nếu cần
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Gọi hàm lấy dữ liệu khi trang được tạo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Giải Tích'),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : arrData != null
          ? ListView.builder(
        itemCount: arrData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentPage(arrData[index]['id']),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    arrData[index]['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    arrData[index]['school'],
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                  // Các thông tin khác nếu có
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: Text('Failed to load data'),
      ),
    );
  }
}


