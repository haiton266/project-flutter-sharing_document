import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ChangePasswordModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Khai báo biến để lưu trữ thông tin từ API
  String email = '';
  String phoneNumber = '';
  String username = '';
  String address = '';

  // Hàm để gọi API và lấy thông tin người dùng
  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
      phoneNumber = prefs.getString('phone') ?? '';
      username = prefs.getString('username') ?? '';
      address = prefs.getString('address') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Email: $email'),
            Text('Phone Number: $phoneNumber'),
            Text('Username: $username'),
            Text('Address: $address'),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ChangePasswordModal(); // Hiển thị modal thay đổi mật khẩu
                  },
                );
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
