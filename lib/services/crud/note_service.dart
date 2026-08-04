import 'package:flutter/material.dart';
import 'package:flutter_app/services/crud/crud_exception.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;


class NoteService {
  Database? _db;

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(
      notesTable,
      {
        textColumn: text,
        isSyncedWithCloudColumn: 0,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
    if (updatesCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(notesTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(notesTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner){
      throw CouldNotFindUserException();
    }
    const text = '';
    final noteId = await db.insert(notesTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    return  note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      usersTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String emial}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      usersTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [emial.toLowerCase()],
    );
    if (results.isEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId = await db.insert(usersTable, {
      emailColumn: emial.toLowerCase(),
    });

    return DatabaseUser(
      id: userId,
      email: emial,
    );
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete( 
      usersTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    } 
    try {
        final docsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(docsPath.path, dbName);
        final db = await openDatabase(dbPath);
        _db = db;



        await db.execute(createUsersTable);
        await db.execute(createNotesTable);
    }on MissingPlatformDirectoryException {
        throw UnableToGetDocumentsDirectoryException();
    }
  }
}

@immutable
class DatabaseUser{
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  }); 
  DatabaseUser.fromRow(Map<String, Object?> map) 
  :  id= map[idColumn] as int,
    email= map[emailColumn] as String;
  
  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

} 

class DatabaseNote{
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
  : id = map[idColumn] as int,
    userId = map[userIdColumn] as int,
    text = map[textColumn] as String,
    isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() => 
  'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';  

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const notesTable = 'notes';
const usersTable = 'users';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';  
const idColumn = 'id';
const emailColumn = 'email';
const createUsersTable = '''
          CREATE TABLE IF NOT EXISTS "User" (
	        "id"	INTEGER NOT NULL,
	        "email"	TEXT NOT NULL UNIQUE,
	        PRIMARY KEY("id" AUTOINCREMENT)
           )
        )''';
const createNotesTable = '''
          CREATE TABLE IF NOT EXISTS "Notes" (
	        "id"	INTEGER NOT NULL,
	        "user_id"	INTEGER NOT NULL,
	        "note"	TEXT NOT NULL,
	        "is_synced_with-cloud"	INTEGER NOT NULL,
	        PRIMARY KEY("id" AUTOINCREMENT),
	        FOREIGN KEY("user_id") REFERENCES "User"("id")
          )
        )''';