import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AddPdfViewer extends StatefulWidget {
  @override
  _AddPdfViewerState createState() => _AddPdfViewerState();
}

class _AddPdfViewerState extends State<AddPdfViewer> {
  File? _selectedFile;
  String _pdfName = '';
  String _selectedSubject = "Lập trình";

  Future<void> _uploadPdf(File? file) async {
    if (file != null) {
      final url = Uri.parse('https://haiton26062.pythonanywhere.com/image/add');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
      request.fields['school'] = 'BKDN';
      request.fields['name'] = _pdfName;
      request.fields['type'] = _selectedSubject;

      try {
        final streamedResponse = await request.send();
        if (streamedResponse.statusCode == 200) {
          // Xử lý thành công, có thể hiển thị thông báo thành công
          print('PDF uploaded successfully!');
        } else {
          // Xử lý lỗi, có thể hiển thị thông báo lỗi
          print('Failed to upload PDF. Error code: ${streamedResponse.statusCode}');
        }
      } catch (e) {
        // Xử lý lỗi mạng hoặc lỗi khác
        print('Error uploading PDF: $e');
      }
    } else {
      // Xử lý khi không có file được chọn
      print('No PDF selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add PDF Viewer'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Center(
                child: SizedBox(
                  // height: 80,
                  // width: 300,
                  child: TextField(
                    onChanged: (value) {
                      _pdfName = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'PDF Name',
                      hintText: 'Enter the PDF name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Dropdown chọn môn học
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Màu viền
                          width: 1.0, // Độ rộng của viền
                        ),
                        borderRadius: BorderRadius.circular(5.0), // Độ bo cong của viền
                      ),
                      child: SizedBox(
                        width: constraints.maxWidth, // Sử dụng chiều rộng của TextField
                        child: DropdownButton<String>(
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedSubject = newValue;
                              });
                            }
                          },

                          isExpanded: true, // Mở rộng để điền đầy không gian
                          value: _selectedSubject,
                          items: <String>['Lập trình', 'Giải tích', 'Vật lý']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    _pickPDF(context);
                  },
                  child: Text('Select PDF'),
                ),
              ),
              SizedBox(height: 20),
              if (_selectedFile != null)
                Text(
                  'Selected PDF: ${_selectedFile!.path.split('/').last}',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedFile != null) {
                      _uploadPdf(_selectedFile);
                    } else {
                      print('No PDF selected');
                    }
                    print('PDF Name: $_pdfName');
                    print('Selected Subject: $_selectedSubject');
                  },
                  child: Text('Upload PDF'),
                ),
              ),
            ],
          ),
      ),
    );
  }

  Future<void> _pickPDF(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = File(result.files.first.path!);
        });
        // Show SnackBar after selecting a file
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF selected: ${_selectedFile!.path.split('/').last}'),
            duration: Duration(seconds: 2), // Thời gian hiển thị SnackBar
          ),
        );
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error picking PDF: $e');
    }
  }
}