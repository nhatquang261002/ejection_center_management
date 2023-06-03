import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateInfo extends StatefulWidget {
  const UpdateInfo({super.key});

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  final _cancuocController = TextEditingController();
  final _addressController = TextEditingController();
  final _sdtController = TextEditingController();
  final userGmail = FirebaseAuth.instance.currentUser!.email;
  var _birthdate = '';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _cancuocController.dispose();
    _addressController.dispose();
    _sdtController.dispose();
    super.dispose();
  }

  void _showDatePicker() {
    showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        _birthdate = value!.toLocal().year.toString() +
            '/' +
            value.toLocal().month.toString() +
            '/' +
            value.toLocal().day.toString();
      });
    });
  }

  Future UpdateData() async {
    await FirebaseFirestore.instance.collection('users').doc(userGmail).update(
      {
        if (_firstNameController.text != '')
          'First Name': _firstNameController.text,
        if (_lastNameController.text != '')
          'Last Name': _lastNameController.text,
        if (_ageController.text != '') 'Ngay sinh': _ageController.text,
        if (_cancuocController.text != '') 'CCCD': _cancuocController.text,
        if (_addressController.text != '') 'Dia chi': _addressController.text,
        if (_sdtController.text != '') 'So dien thoai': _sdtController.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _ageController = TextEditingController(text: _birthdate);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cập nhật thông tin',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Họ',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Tên',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _ageController,
                readOnly: true,
                onTap: _showDatePicker,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: (_birthdate == '')
                        ? 'Ngay sinh'
                        : _birthdate.toString(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _cancuocController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'CCCD',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Địa chỉ',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _sdtController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Số điện thoại',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            width: 150,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                UpdateData();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/UserInfo');
              },
              child: Text(
                'Cập nhật thông tin',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
