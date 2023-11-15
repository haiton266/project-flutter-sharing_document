import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyPdfViewer extends StatefulWidget {
  const MyPdfViewer({super.key});

  @override
  State<MyPdfViewer> createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchPdf();
  }

  Future<void> _fetchPdf() async {
    try {
      var response = await http.get(
          Uri.parse('https://haiton26061.pythonanywhere.com/image/all'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          var firstObject = data[0];
          setState(() {
            imageUrl = firstObject['image_url'];
            print(imageUrl);
          });
        }
      }
    } catch (e) {
      print('Error fetching PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("PDF View"),
      ),
      body: imageUrl != null
          ? SfPdfViewer.network(
        imageUrl!,
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
