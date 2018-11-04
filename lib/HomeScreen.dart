import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// SORTCUT: stl stf

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(children: <Widget>[
        Expanded(
          child: Text(document["name"],
          style: Theme.of(context).textTheme.headline,
          ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey
            ),
            padding: EdgeInsets.all(10.0),
            child: Text(
                document["votes"].toString(),
                style: Theme.of(context).textTheme.display1
                ),
          )
    ],),
    onTap: () {
      /* document.reference.updateData({
        "votes" : document["votes"] + 1,
      }); */
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snap = await transaction.get(document.reference);
        await transaction.update(snap.reference, {
          "votes" : document["votes"] + 1,
        });
      });
    },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Baby Names Survey"),),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("babynames").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
          );
        },
      ),
    );
  }
}