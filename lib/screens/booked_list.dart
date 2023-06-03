import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BookedList extends StatefulWidget {
  const BookedList({super.key});

  @override
  State<BookedList> createState() => _BookedListState();
}

class _BookedListState extends State<BookedList> {
  final userGmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 50,
          color: Colors.amber[200],
          child: Center(
              child: Text(
            'Chào mừng đến với trung tâm tiêm chủng',
            style: Theme.of(context).textTheme.bodyText1,
          )),
        ),
        Container(
          height: 350,
          color: Colors.green[200],
        ),
        Container(
          color: Colors.grey[300],
          height: 180,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('phieu dk')
                .where('email', isEqualTo: userGmail)
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
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                '\nVaccine: ' + data['vaccine'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'Ngày đăng ký: ' +
                                    data['ngay dk'] +
                                    ' ' +
                                    data['gio dk'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  cancelPhieu(data['ma dk']);
                                  setState(() {
                                    BookedList();
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: 175,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child:
                                      Center(child: Text('Huỷ phiếu đăng ký')),
                                ),
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
      ],
    );
  }

  cancelPhieu(String ma_dk) async {
    await FirebaseFirestore.instance.collection('phieu dk').doc(ma_dk).delete();
  }
}
