import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/model/notes_model.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class FirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = Uuid();

  Future<bool> createUser(String email) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "id": _auth.currentUser!.uid,
        "email": email,
      });
      return true;
    } catch (e) {
      debugPrint("Error createUser: ${e.toString()}");
      return false;
    }
  }

  Future<bool> addNote(String subtitle, String title, int image) async {
    try {
      String uuid = _uuid.v4();
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('HH:mm').format(now);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'subtitle': subtitle,
        'isDone': false,
        'image': image,
        'time': formattedTime,
        'title': title,
      });
      return true;
    } catch (e) {
      debugPrint("Error addNote: ${e.toString()}");
      return false;
    }
  }

  List<Note> getNotes(AsyncSnapshot snapshot) {
    try {
      return snapshot.data!.docs.map<Note>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          id: data['id'],
          title: data['title'],
          subtitle: data['subtitle'],
          time: data['time'],
          image: data['image'],
          isDone: data['isDone'],
        );
      }).toList();
    } catch (e) {
      debugPrint("Error getNotes: ${e.toString()}");
      return [];
    }
  }

  Stream<QuerySnapshot> streamNotes(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes')
        .where('isDone', isEqualTo: isDone)
        .snapshots();
  }

  Future<bool> updateNoteStatus(String uuid, bool isDone) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({'isDone': isDone});
      return true;
    } catch (e) {
      debugPrint("Error updateNoteStatus: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateNote(String uuid, int image, String title, String subtitle) async {
    try {
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('HH:mm').format(now);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({
        'time': formattedTime,
        'subtitle': subtitle,
        'title': title,
        'image': image,
      });
      return true;
    } catch (e) {
      debugPrint("Error updateNote: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteNote(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      debugPrint("Error deleteNote: ${e.toString()}");
      return false;
    }
  }
}
