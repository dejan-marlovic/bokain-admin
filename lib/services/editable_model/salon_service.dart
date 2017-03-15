part of editable_model_service;

@Injectable()
class SalonService extends EditableModelService
{
  SalonService() : super("salons")
  {
    _db.ref('rooms').onChildAdded.listen(_onRoomAdded);
    _db.ref('rooms').onChildChanged.listen(_onRoomChanged);
    _db.ref('rooms').onChildRemoved.listen(_onRoomRemoved);

    _salonsRef = _db.ref(_name);
  }

  @override
  Salon createModelInstance(Map<String, String> data)
  {
    return new Salon.decode(data);
  }

  String pushRoom(Room model)
  {
    model.created = new DateTime.now();
    model.addedBy = firebase.auth().currentUser.uid;
    String id = _db.ref('rooms').push(model.encoded).key;
    return id;
  }

  Room getRoom(String id)
  {
    return _rooms.containsKey(id) ? _rooms[id] : null;
  }

  void removeRoom(String id)
  {
    _db.ref('rooms').child(id).remove();
  }

  void setRoom(String id)
  {
    _db.ref('rooms').child(id).set(getRoom(id).data);
  }

  void _onRoomAdded(firebase.QueryEvent e)
  {
    _rooms[e.snapshot.key] = new Room.decode(e.snapshot.val());
    Salon salon = selectedModel as Salon;
    if (salon != null)
    {
      salon.roomIds.add(e.snapshot.key);
      _salonsRef.child(_selectedModelId).child("room_ids").set(salon.roomIds);
    }
  }

  void _onRoomChanged(firebase.QueryEvent e)
  {
    _rooms[e.snapshot.key] = new Room.decode(e.snapshot.val());
  }

  void _onRoomRemoved(firebase.QueryEvent e)
  {
    _rooms.remove(e.snapshot.key);
    Salon salon = selectedModel as Salon;
    salon.roomIds.remove(e.snapshot.key);
    _salonsRef.child(_selectedModelId).child("room_ids").set(salon.roomIds);
  }

  Map<String, Room> _rooms = new Map();
  firebase.DatabaseReference _salonsRef;
}