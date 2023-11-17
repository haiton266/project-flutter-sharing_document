import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyPdfViewer extends StatefulWidget {
  // const MyPdfViewer({super.key});
  final String url_pdf;

  MyPdfViewer(this.url_pdf);

  @override
  State<MyPdfViewer> createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.url_pdf;
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
