import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/db_helper.dart';
import 'package:intl/intl.dart';

class NoteDetails extends StatefulWidget{
  final String appBarTitle;
  final Note note;

  NoteDetails(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailsState(this.note, this.appBarTitle);
  }
}
class NoteDetailsState extends State<NoteDetails>{
  var formKey = GlobalKey<FormState>();
    static var priorities = ['High', 'Low'];
    String appBarTitle;
    Note note;
    DatabaseHelper helper = DatabaseHelper();

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    NoteDetailsState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
      onWillPop: (){
       moveBack();
         },
    child: Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
         icon: Icon(Icons.arrow_back),
          onPressed: (){
           moveBack();
          }, )
      ),
      body:Form(
        key:  formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                items: priorities.map((String dropdownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropdownStringItem,
                      child: Text(dropdownStringItem)
                    );
                }).toList(), 
                style: textStyle,
                value: getPriorityAsString(note.priority),
                onChanged:(valueSelectedByUser){
                  setState(() {
                    updatePriorityAsInt(valueSelectedByUser);
                  });
                } 
                ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextFormField(
                validator: (String value) {
                   String result;
                if (value.isEmpty){
                     result = 'Please Enter Title!';}
                    return result;
                },
                controller: titleController,
                style: textStyle,
                onChanged: (value){
                    updateTitle();
                },
                decoration: InputDecoration(
                   errorStyle: TextStyle(
                   fontSize: 15.0
                 ),
                  labelText: 'Title',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                )
              )),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextFormField(
                controller: descriptionController, 
                onChanged: (value) {
                  updateDescription();
                },
                style: textStyle,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              )),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text('Save', 
                        textScaleFactor: 1.5,),
                        onPressed: () {
                         setState(() {
                           if (formKey.currentState.validate()){
                           _save();}
                        }); }, 
                      )),
                      Container(width: 5.0,),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          child: Text('Delete', 
                          textScaleFactor: 1.5,),
                          onPressed:(){
                            setState(() {
                              _delete();
                            });
                          } ,))
                ],))
          ],
        ),)),

    )
    );
  }
void moveBack(){
   Navigator.pop(context, true);
}

 //convert string priority to integer before save it to DB
void updatePriorityAsInt(String value){
  switch(value){
    case 'High':
    note.priority = 1;
    break;
    case 'Low':
    note.priority = 2;
    break;
  }
}
 //Convert int priority  to string and display it to user
 String getPriorityAsString(int value){
   String priority;
   switch (value){
     case 1:
     priority = priorities[0];
     break;
     case 2:
     priority = priorities[1];
     break;
   }
   return priority;
 }
 void updateTitle(){
   note.title = titleController.text;
 }
 void updateDescription(){
   note.description = descriptionController.text;
 }

 void _save() async{
   moveBack();
   note.date = DateFormat.yMMMd().format(DateTime.now());
   int result;
   if (note.id != null){ //update
     result = await helper.updateNote(note);
   } else{ //insert
      result = await helper.insertNote(note);
   }
   if (result != 0){ //Success
      _showDialog('Status', 'Note Saved!');
   }else { //failed
      _showDialog('Status', "Problem Saving Note");
   }
 }

 void _delete() async{
   moveBack();
   if(note.id == null){
     _showDialog('Status', 'No Note Was Deleted');
     return; } 
   int result = await helper.deleteNote(note.id);
   if (result != 0){
     _showDialog('Status', 'Note Deleted Successfully');
   }
   else {
     _showDialog('status', 'Error Occured While Deleting Note');
   }
 }
 void _showDialog (String title, String message){
   AlertDialog alertDialog = AlertDialog(
     title: Text(title),
     content: Text(message)
   );
   showDialog(
     context: context,
     builder: (context) => alertDialog,
   );
 }

  }