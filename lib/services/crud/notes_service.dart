import 'package:flutter/cupertino.dart';
import 'package:mynotes/services/crud/notes_exceptions.dart';
import "package:path/path.dart" show join;
import "package:path_provider/path_provider.dart"
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import "package:sqflite/sqflite.dart" show Database, openDatabase;

class NotesService {
  Database? _db;

  Database _getDatabaseOrThrow() {
    final db = _db;

    if (db == null) throw DatabaseIsNotOpenException();
    return db;
  }

  Future<void> open() async {
    if (_db != null) throw DatabaseAlreadyOpenException();

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbFileName);
      // i guess this would create this db if it does not  exist
      // openDatabase supports onCreate, where we could add sql to create tables, instead of doing it separately below
      final db = await openDatabase(dbPath);

      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;

    if (db == null) throw DatabaseIsNotOpenException();
    // if (_db == null) throw DatabaseIsNotOpenException();
    await db.close();
    // await _db.close();
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(userTableName,
        where: "email = ?", whereArgs: [email.toLowerCase()]);

    if (deletedCount != 1) throw CouldNotDeleteUserException();
  }

  Future<DatabaseUser> createUser({required String email}) async {
    // first we want to check if the user exists
    final db = _getDatabaseOrThrow();
    final existingUserResult = await db.query(userTableName,
        limit: 1, where: "email = ?", whereArgs: [email.toLowerCase()]);

    if (existingUserResult.isNotEmpty) throw UserAlreadyExistsException();

    final userId =
        await db.insert(userTableName, {uEmailColumn: email.toLowerCase()});

    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTableName,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) throw CouldNotFindUserException();

    return DatabaseUser.fromRow(results.first);
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    // i mean, we could have found it via id, too. but i guess this is good for learning purposes
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) throw CouldNotFindUserException();

    const text = "";

// again, we can use variables as symbols here
    final noteId = await db.insert(noteTableName, {
      nUserIdColumn: owner.id,
      nTextColumn: text,
      nIsSyncedColumn: 1,
    });

    return DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTableName,
      where: "id = ?",
      whereArgs: [id],
    );

    if (deletedCount == 0) throw CouldNotDeleteNoteException();
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(noteTableName);

    return deletedCount;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();

    final noteResponse = await db.query(
      noteTableName,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );

    if (noteResponse.isEmpty) throw CouldNotFindNoteException();

    return DatabaseNote.fromRow(noteResponse.first);
  }

  Future<List<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();

    final notesResponse = await db.query(noteTableName);

    final databaseNotes = notesResponse.map<DatabaseNote>((note) {
      return DatabaseNote.fromRow(note);
    }).toList();

    return databaseNotes;
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);

    final updatesCount = await db.update(noteTableName, {
      nTextColumn: text,
      nIsSyncedColumn: 0,
    });

    if (updatesCount == 0) throw CouldNotUpdateNoteException();

    return await getNote(id: note.id);
  }
}

const dbFileName = "notes.db";
const noteTableName = "note";
const userTableName = "user";
const createUserTable = '''
CREATE TABLE IF NOT EXISTS "user" (
  "id"	INTEGER NOT NULL,
  "email"	TEXT NOT NULL UNIQUE,
  PRIMARY KEY("id" AUTOINCREMENT)
);
''';
const createNoteTable = '''
CREATE TABLE IF NOT EXISTS "note" (
  "id"	INTEGER NOT NULL,
  "user_id"	INTEGER NOT NULL,
  "text"	TEXT,
  "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY("user_id") REFERENCES "user"("id"),
  PRIMARY KEY("id" AUTOINCREMENT)
);
''';

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

// note that the object is optional?
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[uIdColumn] as int,
        email = map[uEmailColumn] as String;

  @override
  String toString() => "Person, ID = $id, email = $email";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const uIdColumn = "id";
const uEmailColumn = "email";

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[nIdColumn] as int,
        userId = map[nUserIdColumn] as int,
        text = map[nTextColumn] as String,
        // note that this is an integer in the db, right
        isSyncedWithCloud = map[nIsSyncedColumn] as int == 0 ? false : true;

  @override
  String toString() =>
      "Note, ID = $id, userId = $userId, text = ${text.substring(0, 25)}, isSynced = $isSyncedWithCloud";

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const nIdColumn = "id";
const nUserIdColumn = "user_id";
const nTextColumn = "text";
const nIsSyncedColumn = "is_synced_with_cloud";
