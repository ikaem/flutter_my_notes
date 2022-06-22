import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import "package:mynotes/services/cloud/cloud_storage_exceptions.dart";

class CloudStorageService {
  // make it a singleton
  static final CloudStorageService _shared =
      CloudStorageService._sharedInstance();
  CloudStorageService._sharedInstance();
  factory CloudStorageService() => _shared;

  // service functionality
  // ntoes is a reference to notes collection
  final notes = FirebaseFirestore.instance.collection("notes");

  Future<void> createNewNote({required String ownerId}) async {
    // we can use collection referen ce to add stuff to it
    await notes.add({ownerIdField: ownerId, textField: ""});
  }

  // Future<Iterable<CloudNote>> getAllNotes({required String ownerId}) async {
  Future<List<CloudNote>> getAllNotes({required String ownerId}) async {
    try {
      final documentsQuery =
          await notes.where(ownerIdField, isEqualTo: ownerId).get();
      return documentsQuery.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  // this is a stream for all ntoes for a user
  Stream<List<CloudNote>> allNotes({required String ownerId}) {
    //
    final notesQuerySnapshotsStream = notes.snapshots();
    // we wil lget an iterable of streams now
    final notesDocsSnapshotsStream = notesQuerySnapshotsStream.map((event) {
      return event.docs;
    });

    final streamOfIterableCloudNotes = notesDocsSnapshotsStream.map((docs) =>
        docs
            .map((doc) => CloudNote.fromSnapshot(doc))
            .where((note) => note.ownerId == ownerId));

    return streamOfIterableCloudNotes.map((event) => event.toList());
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textField: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}
