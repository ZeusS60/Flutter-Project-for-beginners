import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Survey extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SurveyList();
  }

}

class SurveyList extends State{

  final _firestore = FirebaseFirestore.instance;
  


  @override
  Widget build(BuildContext context) {
    CollectionReference suffrageRef = _firestore.collection("Suffrage");
    return Scaffold(
      appBar: AppBar(title: const Text("Anket",style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,
      backgroundColor: Colors.blueGrey,
      ),

      body: Container(
        child: Column(
          children: [
            Expanded(child: StreamBuilder<QuerySnapshot>(
              stream: suffrageRef.snapshots(),
              builder: (context, AsyncSnapshot snapshot){
                if(snapshot.hasError){
                  return LinearProgressIndicator();
                }else if(snapshot.hasData){
                  List<DocumentSnapshot> documentSnapshot = snapshot.data.docs;
                  return Flexible(child: Center(
                    child: ListView.builder(
                        itemCount: documentSnapshot.length,
                        itemBuilder: (context,index){
                         final name = documentSnapshot[index]["name"];
                         final vote = documentSnapshot[index]["vote"];

                        return Card(
                          child: ListTile(
                            title: Text("$name",
                            style: const TextStyle(fontSize: 24),),
                            subtitle: Text("$vote",
                            style: const TextStyle(fontSize: 15),),
                             onTap: () => _firestore.runTransaction((transaction) async{

                               await transaction.update(documentSnapshot[index].reference, {"vote": vote+1});

                             }),
                          ),

                        );
                        }),
                  ),
                  );
                }
                else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },

            ),

            )
          ],
        ),
      ),
    );
  }
}