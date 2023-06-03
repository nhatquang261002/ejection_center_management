import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection_center_management/ad_screens/ad_bill_search.dart';
import 'package:injection_center_management/ad_screens/ad_paybill_screen.dart';
import 'package:injection_center_management/ad_screens/ad_user_info.dart';
import 'package:injection_center_management/ad_screens/ad_user_search.dart';
import 'package:injection_center_management/ad_screens/ad_vaccine_manage.dart';

import 'package:injection_center_management/screens/vaccine_searching_screen.dart';
import 'package:injection_center_management/vaccine_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  int i = 0;
  AdminHomeScreen({
    Key? key,
    required this.i,
  }) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final user = FirebaseAuth.instance.currentUser!.email;
  late int _selectedIndex = widget.i;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    BillSearch(),
    AdminVaccineScreen(),
    AdminUserSearch(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Row(
                    children: [
                      Text(
                        'Xin chào, ' + snapshot.data!.data()!['Last Name'],
                        style: Theme.of(context).textTheme.headline1,
                      )
                    ],
                  );
                },
              ),
            ),
            ListTile(
              title: Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person),
                    Text('  Hồ sơ cá nhân'),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminUserInfo()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout),
                  Text('  Đăng xuất'),
                ],
              ),
              onTap: () async {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/Login'));
                Navigator.pushNamed(context, '/Login');
                await FirebaseFirestore.instance
                    .collection('general')
                    .doc('onlineCount')
                    .update({'membersOnline': FieldValue.increment(-1)});
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.local_hospital_rounded),
                  Text('  Trang dành cho bệnh nhân'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Home');
              },
            ),
            ListTile(
              title: GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.info_rounded),
                    Text('  Thông tin ứng dụng'),
                  ],
                ),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationIcon: FlutterLogo(),
                  applicationName: 'Ứng dụng quản lý trung tâm tiêm chủng',
                  applicationVersion: '0.0.1',
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'Cảm ơn đã sử dụng dịch vụ của  chúng tôi',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey[500],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Vaccine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search),
            label: 'Tìm kiếm khách hàng',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
