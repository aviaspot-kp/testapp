import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetchingapp/backend/firestore_listener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirestoreCollectionCaching extends StatefulWidget {
  const FirestoreCollectionCaching({Key? key}) : super(key: key);

  @override
  _FirestoreCollectionCachingState createState() =>
      _FirestoreCollectionCachingState();
}

class _FirestoreCollectionCachingState
    extends State<FirestoreCollectionCaching> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Collection'),
      ),
      body: Column(
        children: [
          const Expanded(
            child: DocList(),
          ),
          inputfield(),
        ],
      ),
    );
  }
}

class DocList extends StatefulWidget {
  const DocList({Key? key}) : super(key: key);

  @override
  _DocListState createState() => _DocListState();
}

class _DocListState extends State<DocList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: getFromFirestore(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // return Text(snapshot.data.toString());
            return ListView.builder(
                itemCount: (snapshot.data as dynamic).length,
                itemBuilder: (context, index) {
                  final entry = (snapshot.data as dynamic)[index];
                  final TextEditingController _controller =
                      TextEditingController(text: entry['name'].toString());
                  return ListTile(
                    title: TextField(
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        editDocInFirebase(_controller.text, entry['doc_id']);
                      },
                      controller: _controller,
                    ),
                    subtitle: Text('Doc ID: ${entry['doc_id'].toString()}'),
                    trailing: IconButton(
                        onPressed: () {
                          removeDocFromFirebase(entry['doc_id']);
                        },
                        icon: const Icon(Icons.delete)),
                  );
                });
          }
        },
      ),
    );
  }
}

Widget inputfield() {
  final textController = TextEditingController();

  addDocToFirebase() {
    // if (textController.text == '') {
    //   return;
    // }

    FirebaseFirestore.instance
        .collection('flutter-caching')
        .add({'name': textController.text});
    textController.clear();
  }

  return TextField(
      controller: textController,
      onEditingComplete: () {
        addDocToFirebase();
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.add_circle),
          labelText: "Input new value and click Save:",
          suffixIcon: IconButton(
            icon: const Icon(Icons.save),
            splashColor: Colors.blue,
            tooltip: "Post message",
            onPressed: () {
              addDocToFirebase();
            },
          )));
}

removeDocFromFirebase(String doc) async {
  await FirebaseFirestore.instance
      .collection('flutter-caching')
      .doc(doc)
      .delete();
}

editDocInFirebase(String value, String doc) async {
  await FirebaseFirestore.instance
      .collection('flutter-caching')
      .doc(doc)
      .update({'name': value});
}
