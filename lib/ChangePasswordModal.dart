import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordModal extends StatefulWidget {
  @override
  _ChangePasswordModalState createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  String newPassword = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                newPassword = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'New Password',
            ),
            obscureText: true,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                confirmPassword = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (newPassword == confirmPassword) {
              // Gửi yêu cầu PUT HTTP để thay đổi mật khẩu
              updatePassword(newPassword); // Gọi hàm updatePassword với mật khẩu mới
              Navigator.pop(context); // Đóng modal sau khi gửi yêu cầu thành công
            } else {
              // Hiển thị thông báo nếu hai mật khẩu không khớp
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Passwords do not match'),
                duration: Duration(seconds: 2),
              ));
            }
          },
          child: Text('Change'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Đóng modal nếu người dùng bấm Cancel
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  // Hàm để gửi yêu cầu PUT HTTP để cập nhật mật khẩu
  void updatePassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final id_get = prefs.getString('id');
    final response = await http.put(
      Uri.https('haiton26062.pythonanywhere.com', '/user/3'),
      body: jsonEncode({'password': newPassword}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Password updated successfully
      // You can add your notification here
      print('Password updated successfully!');
    } else {
      // Handle other status codes if needed
      print('Failed to update password. Status code: ${response.statusCode}');
    }
  }
}