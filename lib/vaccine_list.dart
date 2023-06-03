import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injection_center_management/screens/vaccine_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class VaccineList extends StatefulWidget {
  const VaccineList({Key? key}) : super(key: key);

  @override
  _VaccineListState createState() => _VaccineListState();
}

class _VaccineListState extends State<VaccineList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('vaccine')
              .orderBy('so lo')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data();
                return ListTile(
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
                  subtitle: Text(
                    data['so lo'],
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
