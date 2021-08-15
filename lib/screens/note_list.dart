import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_details.dart';
import 'dart:async';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}
class NoteListState extends State<NoteList>{
  DatabaseHelper helper = DatabaseHelper();
  List<Note> noteList;
  int count = 0 ;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),),
        body: getNoteList(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
           navigateToDetail(Note('', '', 2), "Add Note");
          },
          tooltip: 'Add a Note!',
          child: Icon(Icons.note_add, color: Colors.white),),
    );
  }

  ListView getNoteList(){
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.grey,
          elevation: 3.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority)
            ),
            title: Text(this.noteList[position].title, style: titleStyle),
            subtitle: Text(this.noteList[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete_outline, color: Colors.redAccent),
              onTap: (){
                
                   _delete(context, noteList[position]);
              },
            ),
            onTap: (){
             navigateToDetail(this.noteList[position], "Edit Note");
            },
          ),
          
        );
      });

  }
  //Returns priority color
  Color getPriorityColor (int priority){
    switch(priority){
      case 1:
      return Colors.red;
      break;
      case 2:
      return Colors.yellowAccent;
      break;
      default:
      return Colors.yellowAccent;
    }
  }
  //returns priority icon
  Icon getPriorityIcon (int priority){
    switch (priority){
      case 1:
      return Icon(Icons.priority_high);
      break;
      case 2:
      return Icon(Icons.low_priority);
      break;
      default:
      return Icon(Icons.low_priority);
    }
  }

  //delete note
  void _delete (BuildContext context, Note note) async {
    int result = await helper.deleteNote(note.id);
    if(result != 0){
      _showSnackBar(context, 'Note Deleted Successfully!');
        updateListView();
    }
  }
  void _showSnackBar(BuildContext context, String message){
    final snackbar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);

  }
void updateListView(){
   final Future<Database> dbFuture = helper.initializeDatabase();
   dbFuture.then((database){
     Future<List<Note>> noteListFuture = helper.getNoteList();
     noteListFuture.then((noteList){
       setState(() {
         this.noteList = noteList;
         this.count = noteList.length;
       });
     });
   });
}
void navigateToDetail(Note note, String title) async{
 bool result = await Navigator.push(context, 
            MaterialPageRoute(builder: (context){
              return NoteDetails(note, title);
            }));
      if (result == true){
        updateListView();
      }
}
}