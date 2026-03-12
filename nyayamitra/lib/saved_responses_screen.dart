import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedResponsesScreen extends StatefulWidget {
  @override
  _SavedResponsesScreenState createState() => _SavedResponsesScreenState();
}

class _SavedResponsesScreenState extends State<SavedResponsesScreen> {
  List<Map<String, dynamic>> savedResponses = [];
  List<String> docIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSavedResponses();
  }

  Future<void> _fetchSavedResponses() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('responses')
            .orderBy('timestamp', descending: true)
            .limit(20)
            .get();

        final List<Map<String, dynamic>> responses = [];
        final List<String> ids = [];

        for (var doc in snapshot.docs) {
          responses.add({
            'response': doc['response'],
            'timestamp': doc['timestamp'],
          });
          ids.add(doc.id);
        }

        setState(() {
          savedResponses = responses;
          docIds = ids;
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error fetching responses: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteResponse(int index) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && index < docIds.length) {
        final docId = docIds[index];
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('responses')
            .doc(docId)
            .delete();

        setState(() {
          savedResponses.removeAt(index);
          docIds.removeAt(index);
        });
      }
    } catch (e) {
      print("❌ Error deleting response: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Responses"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : savedResponses.isEmpty
          ? Center(
        child: Text(
          "No saved responses found.",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: savedResponses.length,
        itemBuilder: (context, index) {
          final response = savedResponses[index]['response'];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              title: Text(
                response.length > 100
                    ? "${response.substring(0, 100)}..."
                    : response,
                style: TextStyle(color: Colors.black),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context, response);
              },
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteResponse(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
