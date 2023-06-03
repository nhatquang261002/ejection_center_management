import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection_center_management/screens/booked_list.dart';
import 'package:injection_center_management/screens/booking_appointment.dart';
import 'package:injection_center_management/screens/vaccine_searching_screen.dart';
import 'package:injection_center_management/vaccine_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!.email;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    BookedList(),
    VaccineSearchScreen(),
    BookingAppointment()
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
              title: Row(
                children: [
                  Icon(Icons.person),
                  Text('  Hồ sơ cá nhân'),
                ],
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/UserInfo');
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
                  Text('  Trang dành cho bác sĩ'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/AdminInfo');
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
            icon: Icon(Icons.assignment),
            label: 'Đặt lịch tiêm',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
