import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection_center_management/screens/vaccine_details.dart';
import 'package:injection_center_management/vaccine_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class VaccineSearchScreen extends StatefulWidget {
  const VaccineSearchScreen({super.key});

  @override
  State<VaccineSearchScreen> createState() => _VaccineSearchScreenState();
}

class _VaccineSearchScreenState extends State<VaccineSearchScreen> {
  final _vaccineNameController = TextEditingController();

  @override
  void dispose() {
    _vaccineNameController.dispose();
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
                'Điền tên vaccine cần tìm',
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
                  controller: _vaccineNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'Vaccine',
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
                .collection('vaccine')
                .orderBy('so lo')
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

                  if (_vaccineNameController.text.isEmpty) {
                    return ListTile(
                      leading: Icon(Icons.segment_sharp),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    VaccineDetails(name: data['name']))));
                      },
                      title: Text(
                        data['name'],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    );
                  }
                  if (data['name']
                      .toString()
                      .toLowerCase()
                      .startsWith(_vaccineNameController.text.toLowerCase())) {
                    return ListTile(
                      leading: Icon(Icons.segment_sharp),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    VaccineDetails(name: data['name']))));
                      },
                      title: Text(
                        data['name'],
                        style: Theme.of(context).textTheme.bodyText1,
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
