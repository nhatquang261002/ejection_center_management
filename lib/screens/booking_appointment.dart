import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection_center_management/screens/booked_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

class BookingAppointment extends StatefulWidget {
  const BookingAppointment({super.key});

  @override
  State<BookingAppointment> createState() => _BookingAppointmentScreenState();
}

class _BookingAppointmentScreenState extends State<BookingAppointment> {
  final _formfield = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _vaccineNameController = TextEditingController();
  final userGmail = FirebaseAuth.instance.currentUser!.email;
  var _date = '';
  var _time = '';

  void _showDatePicker() {
    showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((value) {
      setState(() {
        _date = value!.toLocal().year.toString() +
            '/' +
            value.toLocal().month.toString() +
            '/' +
            value.toLocal().day.toString();
      });
    });
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _time = value!.format(context);
      });
    });
  }

  Future Submit() async {
    DocumentReference phieudk =
        FirebaseFirestore.instance.collection('phieu dk').doc();
    await phieudk.set({
      'email': userGmail,
      'ngay dk': _dateController.text,
      'gio dk': _timeController.text,
      'vaccine': _vaccineNameController.text,
      'ma dk': phieudk.id,
      'approve': false,
    });
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Đăng ký thành Công.\nMã phiếu đăng ký của bạn là: ' +
                    phieudk.id,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    _dateController = TextEditingController(text: _date);
    _timeController = TextEditingController(text: _time);
    return Container(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Phiếu đăng ký',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userGmail)
                  .get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            'Số điện thoại: ' + snapshot.data['So dien thoai'],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ]);
              },
            ),
            Form(
              key: _formfield,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Ngày đặt lịch: ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Container(
                        height: 30,
                        width: 150,
                        color: Colors.grey[100],
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng chọn ngày đặt lịch';
                            }
                          },
                          onTap: _showDatePicker,
                          decoration: InputDecoration(
                              hintText: '  Date',
                              suffixIcon: Icon(Icons.ads_click)),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 150,
                        color: Colors.grey[100],
                        child: TextFormField(
                          controller: _timeController,
                          readOnly: true,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng chọn khung giờ đặt lịch';
                            }
                          },
                          onTap: _showTimePicker,
                          decoration: InputDecoration(
                              hintText: '  Time',
                              suffixIcon: Icon(Icons.ads_click)),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Vaccine: ',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            color: Colors.grey[100],
                            width: 150,
                            height: 30,
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Vui lòng chọn vaccine cần đặt lịch";
                                }
                              },
                              controller: _vaccineNameController,
                              decoration: InputDecoration(
                                hintText: 'Vaccine',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: 100,
                              width: 225,
                              color: Colors.grey[100],
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('vaccine')
                                    .orderBy('so lo')
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final data = snapshot.data!.docs[index]
                                          .data() as Map<String, dynamic>;

                                      if (data['name']
                                          .toString()
                                          .toLowerCase()
                                          .startsWith(_vaccineNameController
                                              .text
                                              .toLowerCase())) {
                                        return ListTile(
                                          onTap: () {
                                            _vaccineNameController.text =
                                                data['name'];
                                          },
                                          title: Text(
                                            data['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        );
                                      } else
                                        return Container();
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _formfield.currentState!.validate() == true
                              ? Submit()
                              : null;
                          setState(() {
                            BookedList();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.blue),
                          child: Text(
                            'Xác nhận',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
