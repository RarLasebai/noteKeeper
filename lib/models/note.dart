class Note{
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);
  Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get id => _id; //ماتاخدش setter لانها بتتعرف اوتوماتكلي في الداتا بيز
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

  set title(String newTitle){
    this._title = newTitle;
  }
  set date(String newDate){
    this._date = newDate;
  }
  set priority(int newPriority){
    if (newPriority >= 1 && newPriority <= 2){
      this._priority = newPriority;
    }
  }
  set description(String newDescription){
    this._description = newDescription;
  }
  //convert a Note object into a Map object
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if (id != null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }
  //Extract Note object from Map object
  Note.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._priority = map['priority'];
    this._date = map['date'];
    this._description = map['descreption'];
  }
}