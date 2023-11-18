import 'package:flutter/material.dart';
import 'Subject.dart';
import 'pdf_viewer.dart';
import 'AddPdfViewer.dart';
import 'Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final Sbj = [
    {'code': 'giaitich', 'text': 'Giải tích', 'image': 'assets/giaitich.png'},
    {'code': 'laptrinh', 'text': 'Lập trình', 'image': 'assets/laptrinh.png'},
    {'code': 'dientu', 'text': 'Điện tử', 'image': 'assets/dientu.png'},
    {'code': 'vatly', 'text': 'Vật lý', 'image': 'assets/vatly.png'},
    {'code': 'vienthong', 'text': 'Viễn thông', 'image': 'assets/vienthong.png'},
    {'code': 'nhung', 'text': 'Nhúng', 'image': 'assets/nhung.png'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(Sbj.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Subject(Sbj[index]['code']!,Sbj[index]['text']!,Sbj[index]['image']!)), // Điều hướng đến màn hình PDF
              );
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: AssetImage(Sbj[index]['image']!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  Sbj[index]['text']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

// Phần code khác...
}







// ElevatedButton(
//   onPressed: () {
//     _logout(context);
//   },
//   child: Text('Logout'),
// ),
// ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => MyPdfViewer()), // Điều hướng đến màn hình PDF
//     );
//   },
//   child: Text('PDF'),
// ),
// ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => AddPdfViewer()), // Điều hướng đến màn hình PDF
//     );
//   },
//   child: Text('Add pdf'),
// ),
// ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => Profile()), // Điều hướng đến màn hình PDF
//     );
//   },
//   child: Text('Profile'),
// ),