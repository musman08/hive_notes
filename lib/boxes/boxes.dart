import 'package:localhive_storage_flutter/models/notes_models.dart';
import 'package:hive/hive.dart';
class Boxes{
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}