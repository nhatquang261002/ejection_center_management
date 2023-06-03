import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConfirmDocID extends StatefulWidget {
  const ConfirmDocID({super.key});

  @override
  State<ConfirmDocID> createState() => _ConfirmDocIDState();
}

class _ConfirmDocIDState extends State<ConfirmDocID> {
  final _docIdController = TextEditingController();
  final userGmail = FirebaseAuth.instance.currentUser?.email;

  @override
  void dispose() {
    _docIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('users').doc(userGmail).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Column(
                children: [
                  Text(
                    'Vui lòng nhập ID dành cho bác sĩ với tài khoản của bạn',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: 300,
                    child: TextFormField(
                      controller: _docIdController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: 'ID',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[300]),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (snapshot.data['id'].toString() ==
                          _docIdController.text) {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/AdminHome');
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('ID không phù hợp'),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 75,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Xác nhận',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  )
                ],
              )),
            ],
          );
        },
      ),
    );
  }
}
