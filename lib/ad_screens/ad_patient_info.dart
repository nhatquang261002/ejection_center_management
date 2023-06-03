import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection_center_management/ad_screens/ad_paybill_screen.dart';
import 'package:injection_center_management/screens/update_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPatientInfo extends StatefulWidget {
  String email = '';
  AdminPatientInfo({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<AdminPatientInfo> createState() => _AdminUserInfoState();
}

class _AdminUserInfoState extends State<AdminPatientInfo> {
  late String userEmail = widget.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'User Information',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userEmail)
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
                                'Ngay sinh: ' +
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
                                'Dia chi: ' + snapshot.data['Dia chi'],
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
                                'So dien thoai: ' +
                                    snapshot.data['So dien thoai'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ]);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Lịch sử tiêm: ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              height: 60,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('phieu dk')
                    .where('email', isEqualTo: userEmail)
                    .where('approve', isEqualTo: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return Container(
                        height: 50,
                        width: 100,
                        child: Column(
                          children: [
                            Text(
                              data['vaccine'],
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              data['ngay dk'],
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              height: 180,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('phieu dk')
                    .where('email', isEqualTo: userEmail)
                    .where('approve', isEqualTo: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.indigo,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Phiếu đăng ký: ' + data['ma dk'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    '\nVaccine: ' + data['vaccine'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    'Ngày đăng ký: ' +
                                        data['ngay dk'] +
                                        ' ' +
                                        data['gio dk'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return PayBill(
                                              email: data['email'],
                                              ma_dk: data['ma dk'],
                                              vaccine: data['vaccine'],
                                              day: data['ngay dk'],
                                            );
                                          }));
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.blue,
                                          ),
                                          child:
                                              Center(child: Text('In Hoá Đơn')),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        height: 25,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          cancelPhieu(data['ma dk']);
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 25,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.red),
                                          child: Center(
                                              child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/UpdateInfo');
              },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'Cập nhật thông tin',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  cancelPhieu(String ma_dk) async {
    await FirebaseFirestore.instance.collection('phieu dk').doc(ma_dk).delete();
  }
}
