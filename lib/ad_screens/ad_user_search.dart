import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection_center_management/ad_screens/ad_patient_info.dart';
import 'package:injection_center_management/screens/vaccine_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdminUserSearch extends StatefulWidget {
  const AdminUserSearch({super.key});

  @override
  State<AdminUserSearch> createState() => _AdminUserSearchState();
}

class _AdminUserSearchState extends State<AdminUserSearch> {
  final _userSearchController = TextEditingController();

  @override
  void dispose() {
    _userSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Nhập mã số CCCD của khách hàng muốn tìm',
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
                  controller: _userSearchController,
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
                      fillColor: Colors.grey[300]),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('id', isEqualTo: '')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  if (_userSearchController.text.isEmpty) {
                    return ListTile(
                      leading: Icon(Icons.account_box),
                      trailing: IconButton(
                          splashRadius: 20.0,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(data['email'])
                                .delete();
                            setState(() {
                              AdminUserSearch();
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    AdminPatientInfo(email: data['Email']))));
                      },
                      title: Text(
                        data['First Name'] + ' ' + data['Last Name'],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      subtitle: Text(
                        data['CCCD'],
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    );
                  }
                  if (data['CCCD']
                      .toString()
                      .toLowerCase()
                      .startsWith(_userSearchController.text.toLowerCase())) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    AdminPatientInfo(email: data['Email']))));
                      },
                      title: Text(
                        data['First Name'] + ' ' + data['Last Name'],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      leading: Icon(Icons.account_box),
                      trailing: IconButton(
                          splashRadius: 20.0,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(data['email'])
                                .delete();
                            setState(() {
                              AdminUserSearch();
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      subtitle: Text(
                        data['CCCD'],
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    );
                  } else
                    return Container();
                },
              );
            },
          ),
        )
      ],
    );
  }
}
