import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CommentPage.dart';

class Subject extends StatefulWidget {
  final String subject;
  final String nameSubject;
  final String urlImageSubject;
  Subject(this.subject, this.nameSubject, this.urlImageSubject);

  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  late List<dynamic> arrData; // List chứa dữ liệu từ API
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://haiton26062.pythonanywhere.com/image/${widget.subject}'));

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
        title: Text(
          '${widget.nameSubject}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25, // Đặt kích thước chữ là 20
            fontWeight: FontWeight.bold, // Có thể thêm kiểu chữ in đậm nếu muốn
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true, // Đặt tiêu đề căn giữa
        elevation: 0, // Đặt độ nâng của AppBar là 0 để xóa gạch ngang phân cách
        iconTheme: IconThemeData(color: Colors.black), // Đặt màu của icon là đen
      ),
        body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : arrData != null
          ? Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Image.asset(
              widget.urlImageSubject, // Replace with your image path
              // width: 500, // Adjust width as needed
              height: 180, // Adjust height as needed
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: arrData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CommentPage(arrData[index]['id']),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/pdf.png', // Replace with your icon image path
                            width: 52,
                            height: 52,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      )
          : Center(
        child: Text('Failed to load data'),
      ),
    );
  }
}
