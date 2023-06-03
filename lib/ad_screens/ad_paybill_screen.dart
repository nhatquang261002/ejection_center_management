// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PayBill extends StatefulWidget {
  String email = '';
  String ma_dk = '';
  String vaccine = '';
  String day = '';
  PayBill({
    Key? key,
    required this.email,
    required this.ma_dk,
    required this.vaccine,
    required this.day,
  }) : super(key: key);

  @override
  State<PayBill> createState() => _PayBillState();
}

class _PayBillState extends State<PayBill> {
  bool cash = true;
  bool atm = false;
  bool card = false;
  late String ma_dk = widget.ma_dk;
  late String vaccine = widget.vaccine;
  late String email = widget.email;
  late String day = widget.day;
  var total = 0;
  TextEditingController _noteController = TextEditingController();

  Future submit() async {
    await FirebaseFirestore.instance
        .collection('vaccine')
        .doc(vaccine.toLowerCase())
        .update({
      'quantity': FieldValue.increment(-1),
    });
    await FirebaseFirestore.instance.collection('hoa don').doc(ma_dk).set({
      'email': email,
      'ma hoa don': ma_dk,
      'vaccine': vaccine,
      'total': total,
      'ngay': day,
      if (cash = true)
        'paymethod': 'Tiền Mặt'
      else if (atm = true)
        'paymethod': 'Online Banking'
      else if (card = true)
        'paymethod': 'Thẻ',
      'ghi chu': _noteController.text
    });
    await FirebaseFirestore.instance.collection('phieu dk').doc(ma_dk).update({
      'approve': true,
      'vaccine': vaccine,
      'ngay dk': day,
      'ma dk': ma_dk,
      'email': email,
    });
    await FirebaseFirestore.instance
        .collection('ho so tiem chung')
        .doc(email)
        .update({
      'email': email,
      'vaccine ' + ma_dk: vaccine,
      'ngay tiem ' + ma_dk: day,
      'ghi chu': _noteController.text,
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Thành công!',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Điền Thông Tin Hoá Đơn',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Hoá Đơn',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              height: 200,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(email)
                      .get(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Họ và Tên: ' +
                                    snapshot.data['First Name'] +
                                    ' ' +
                                    snapshot.data['Last Name'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Ngày sinh: ' +
                                    (snapshot.data['Ngay sinh']).toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'CCCD: ' + snapshot.data['CCCD'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Địa chỉ: ' + snapshot.data['Dia chi'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Số điện thoại: ' +
                                    snapshot.data['So dien thoai'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ]);
                  }),
            ),
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 100,
                    child: Row(
                      children: [
                        Text(
                          'Tiền mặt',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Checkbox(
                            value: cash,
                            onChanged: (value) {
                              setState(() {
                                cash = !cash;
                                atm = false;
                                card = false;
                              });
                            })
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 150,
                    child: Row(
                      children: [
                        Text(
                          'Online Banking',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Checkbox(
                            value: atm,
                            onChanged: (value) {
                              setState(() {
                                cash = false;
                                atm = !atm;
                                card = false;
                              });
                            })
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    child: Row(
                      children: [
                        Text(
                          'Thẻ',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Checkbox(
                            value: card,
                            onChanged: (value) {
                              setState(() {
                                cash = false;
                                atm = false;
                                card = !card;
                              });
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Timeline: ' + day,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 25,
                child: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: 'Ghi Chú',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(32),
                      1: FlexColumnWidth(),
                      2: FixedColumnWidth(70),
                      3: FixedColumnWidth(70),
                      4: FixedColumnWidth(100),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                        children: [
                          Container(
                            height: 25,
                            alignment: Alignment.center,
                            child: Text(
                              'STT',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Container(
                            height: 25,
                            alignment: Alignment.center,
                            child: Text(
                              'Tên Vaccine',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Container(
                            height: 25,
                            alignment: Alignment.center,
                            child: Text(
                              'Đơn Giá',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Container(
                            height: 25,
                            alignment: Alignment.center,
                            child: Text(
                              'Số lượng',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Container(
                            height: 25,
                            alignment: Alignment.center,
                            child: Text(
                              'Thành Tiền',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                      TableRow(children: [
                        Container(
                          height: 25,
                          alignment: Alignment.center,
                          child: Text(
                            '1',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Container(
                            height: 25,
                            alignment: Alignment.center,
                            child: Text(
                              vaccine,
                              style: Theme.of(context).textTheme.bodyText1,
                            )),
                        Container(
                          height: 25,
                          alignment: Alignment.center,
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('vaccine')
                                .doc(vaccine.toLowerCase())
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return Text(
                                snapshot.data!.data()!['price'].toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 25,
                          alignment: Alignment.center,
                          child: Text(
                            '1',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Container(
                          height: 25,
                          alignment: Alignment.center,
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('vaccine')
                                .doc(vaccine.toLowerCase())
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return Text(
                                snapshot.data!.data()!['price'].toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              );
                            },
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Container(
                          height: 25,
                        ),
                        Container(
                          height: 25,
                        ),
                        Container(
                          height: 25,
                        ),
                        Container(
                          height: 25,
                        ),
                        Container(
                          height: 25,
                        ),
                      ]),
                      TableRow(children: [
                        Container(
                          height: 25,
                        ),
                        Container(
                          height: 25,
                        ),
                        Container(
                          height: 25,
                        ),
                        Container(
                          height: 25,
                        ),
                        Container(
                          height: 25,
                        ),
                      ]),
                    ],
                  ),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                      1: FixedColumnWidth(100),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(children: [
                        Container(
                          alignment: Alignment.center,
                          height: 25,
                          child: Text(
                            'Tổng cộng',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 25,
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('vaccine')
                                .doc(vaccine.toLowerCase())
                                .get(),
                            builder: (context, snapshot) {
                              total = snapshot.data!.data()!['price'];
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return Text(
                                snapshot.data!.data()!['price'].toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              );
                            },
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  submit();
                },
                child: Container(
                  height: 25,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blue),
                  child: Text(
                    'Xác Nhận',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
