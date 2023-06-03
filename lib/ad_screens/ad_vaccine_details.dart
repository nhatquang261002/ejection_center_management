// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection_center_management/ad_screens/ad_home_screen.dart';
import 'package:injection_center_management/screens/update_info_screen.dart';
import 'package:injection_center_management/screens/vaccine_searching_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminVaccineDetails extends StatefulWidget {
  final String name;
  const AdminVaccineDetails({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<AdminVaccineDetails> createState() => _AdminVaccineDetailsState();
}

class _AdminVaccineDetailsState extends State<AdminVaccineDetails> {
  late final _nameController = TextEditingController(text: widget.name);
  final _soloController = TextEditingController();
  TextEditingController _productDateController = TextEditingController();
  TextEditingController _expireDateController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _nhaSXController = TextEditingController();
  var _productDate = '';
  var _expireDate = '';

  void _showDatePicker1() {
    showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        _productDate = value!.toLocal().year.toString() +
            '/' +
            value.toLocal().month.toString() +
            '/' +
            value.toLocal().day.toString();
      });
    });
  }

  void _showDatePicker2() {
    showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    ).then((value) {
      setState(() {
        _expireDate = value!.toLocal().year.toString() +
            '/' +
            value.toLocal().month.toString() +
            '/' +
            value.toLocal().day.toString();
      });
    });
  }

  Future UpdateVaccineDetails() async {
    await FirebaseFirestore.instance
        .collection('vaccine')
        .doc(_nameController.text.toLowerCase())
        .update(
      {
        if (_nameController.text != '') 'name': _nameController.text,
        if (_soloController.text != '') 'id': _soloController.text,
        if (_productDateController.text != '')
          'product date': _productDateController.text,
        if (_expireDateController.text != '')
          'expire date': _expireDateController.text,
        if (_quantityController.text != '')
          'quantity': _quantityController.text,
        if (_priceController.text != '') 'price': _priceController.text,
        if (_nhaSXController.text != '') 'price': _nhaSXController.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _expireDateController = TextEditingController(text: _expireDate);
    _productDateController = TextEditingController(text: _productDate);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Thông tin vaccine',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('vaccine')
                .doc(widget.name.toLowerCase())
                .get(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: snapshot.data!.data()['name'],
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
                          controller: _soloController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText:
                                  snapshot.data!.data()['so lo'].toString(),
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
                          controller: _nhaSXController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: snapshot.data!.data()['nha sx'],
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
                          readOnly: true,
                          onTap: _showDatePicker1,
                          controller: _productDateController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: snapshot.data!.data()['product date'],
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
                          readOnly: true,
                          onTap: _showDatePicker2,
                          controller: _expireDateController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: snapshot.data!.data()['expire date'],
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
                          controller: _quantityController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText:
                                  snapshot.data!.data()['quantity'].toString(),
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
                          controller: _priceController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText:
                                  snapshot.data!.data()['price'].toString(),
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
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            UpdateVaccineDetails();
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminHomeScreen(
                                  i: 1,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Xác nhận',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ]);
            }));
  }
}
