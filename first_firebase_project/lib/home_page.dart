import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State {
  TextEditingController nameController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

  final _firestore =
      FirebaseFirestore.instance; // final ile dinamik bir yapı oluşturuyoruz
  // Burada firebase ile bağlantı kuruyoruz tüm metotlar vb kullanımı için

  @override
  Widget build(BuildContext context) {
    CollectionReference moviesRef = _firestore.collection("movies");
    DocumentReference babaRef = moviesRef.doc("Baba");

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text("Firestore CRUD İşlemleri"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            /*  ElevatedButton(onPressed:() async {
             var response = await moviesRef.get();
             var list = response.docs;
             print(list[0]);

              // var response = await babaRef.get();
              //Documentsnapshot gönderecek ve bekleyecek
             // dynamic map = response;
             // print(map["name"]);





            }, child: const Text("Get QuerySnapshot"),),*/
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  //Neyi dinlediğimizin bilgisi hangi stream'i
                  stream: moviesRef.snapshots(),

                  //Streamden her yeni veri aktığında aşağıdaki metodu çalıştır.
                  builder: (BuildContext context, AsyncSnapshot asyncSnaphot) {
                    if (asyncSnaphot.hasError) {
                      return const Center(
                        child: Text("Bir hata oluştu, tekrar deneyiniz."),
                      );
                    } else if (asyncSnaphot.hasData) {
                      List<DocumentSnapshot> ListOfDocumentSnap =
                          asyncSnaphot.data.docs;
                      return Flexible(
                        child: Center(
                          child: ListView.builder(
                              itemCount: ListOfDocumentSnap.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: Colors.white70,
                                  child: ListTile(
                                    title: Text(
                                      "${ListOfDocumentSnap[index]["name"]}",
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    subtitle: Text(
                                      "${ListOfDocumentSnap[index]["rating"]}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          await ListOfDocumentSnap[index]
                                              .reference
                                              .delete();
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ),
                                );
                              }),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: [

                      TextFormField(controller: nameController,
                      decoration: InputDecoration(hintText: "Filmin ismini giriniz."),),
                      TextFormField(controller: ratingController,
                      decoration: InputDecoration(hintText: "Rating giriniz."),),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.black54,),
        onPressed: () async{
          Map<String,dynamic> movieData = {"name": nameController.text,"rating": ratingController.text};
         await moviesRef.doc(nameController.text).set(movieData);

        },
      ),
    );
  }
}
