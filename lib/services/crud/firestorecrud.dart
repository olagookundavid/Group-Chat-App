import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

late String? loggedInUser;
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class CrudMethods {
  bool isLoggedIn() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user.email;
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(messageData) async {
    await _firestore.collection('messages').add(messageData);
  }

  getMessageStreams() {
    return _firestore
        .collection('messages')
        .orderBy(
          'timestamp',
          descending: false,
        )
        .snapshots();
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  updateData(selectedtext, newtext) {
    _firestore.collection('messages').doc(selectedtext).update(newtext);
  }

  deleteData() {
    _firestore.collection('messages').get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
