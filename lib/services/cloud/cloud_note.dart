// lib\services\cloud\cloud_note.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.ownerId,
    required this.text,
  });

// instead of dynamic, doucle it be Object?, like with database model note
// we are only using dynamic, because i guess this is what snapshot does
// but this could be a factory construcotr - and we do return data - or we just set it
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerId = snapshot.data()[ownerIdField],
        text = snapshot.data()[textField];
}
