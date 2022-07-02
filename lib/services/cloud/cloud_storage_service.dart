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

  Future<CloudNote> createNewNote({required String ownerId}) async {
    // we can use collection referen ce to add stuff to it
    final docRef = await notes.add({ownerIdField: ownerId, textField: ""});
    final fetchedNote = await docRef.get();

    return CloudNote(
      documentId: fetchedNote.id,
      ownerId: fetchedNote.data()?[ownerIdField],
      text: fetchedNote.data()?[textField],
    );
  }

  // Future<Iterable<CloudNote>> getAllNotes({required String ownerId}) async {
  //   // Future<List<CloudNote>> getNotes({required String ownerId}) async {
  //   try {
  //     final documentsQuery =
  //         await notes.where(ownerIdField, isEqualTo: ownerId).get();
  //     return documentsQuery.docs.map((doc) => CloudNote.fromSnapshot(doc));
  //     // .toList();
  //   } catch (e) {
  //     throw CouldNotGetAllNotesException();
  //   }
  // }

// TODO test
  Future<CloudNote> getNote({required String id}) async {
    try {
      final fetchedNote = await notes.doc(id).get();

      return CloudNote(
        documentId: fetchedNote.id,
        ownerId: fetchedNote.data()?[ownerIdField],
        text: fetchedNote.data()?[textField],
      );
    } catch (e) {
      throw CouldNotGetNoteException();
    }
  }

  // this is a stream for all ntoes for a user
  Stream<Iterable<CloudNote>> allNotes({required String ownerId}) {
    //
    final notesQuerySnapshotsStream = notes.snapshots();
    // we wil lget an iterable of streams now
    final notesDocsSnapshotsStream = notesQuerySnapshotsStream.map((event) {
      // each event has its own documents
      return event.docs;
    });

    final streamOfIterableCloudNotes = notesDocsSnapshotsStream.map((docs) =>
        docs
            .map((doc) => CloudNote.fromSnapshot(doc))
            .where((note) => note.ownerId == ownerId));

// so this is now a stream of lists
// so lists is an event - so lists is a chunk in the stream
    // return streamOfIterableCloudNotes.map((event) => event.toList());
    return streamOfIterableCloudNotes;
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
