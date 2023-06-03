import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection_center_management/ad_screens/bill_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BillSearch extends StatefulWidget {
  const BillSearch({super.key});

  @override
  State<BillSearch> createState() => _BillSearchState();
}

class _BillSearchState extends State<BillSearch> {
  final _billSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Thống kê chung',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 25,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Có tổng cộng ' +
                                snapshot.data!.docs.length.toString() +
                                ' khách hàng đã đăng ký tài khoản',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 25,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('hoa don')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Row(
                        children: [
                          Icon(
                            Icons.payment,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Đã xuất ' +
                                snapshot.data!.docs.length.toString() +
                                ' hoá đơn',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Tìm kiếm hoá đơn',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 500,
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _billSearchController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: 'Mã Hoá Đơn',
                      fillColor: Colors.grey[300],
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Expanded(
            child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('hoa don').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                if (data['ma hoa don']
                    .toString()
                    .startsWith(_billSearchController.text))
                  return ListTile(
                    leading: Icon(Icons.payment_outlined),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BillDetails(
                                  ma_dk: data['ma hoa don'],
                                  email: data['email'],
                                  vaccine: data['vaccine'],
                                  day: data['ngay'],
                                ))),
                    title: Text(
                      'Hoá đơn ' + data['ma hoa don'],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  );
                else
                  return Container();
              },
            );
          },
        )),
        Center(
          child: Container(
            height: 25,
            width: 247,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('general')
                  .doc('onlineCount')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 10.0,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Hiện có ' +
                          snapshot.data!.data()!['membersOnline'].toString() +
                          ' thành viên đang online',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
