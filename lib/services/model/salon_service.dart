part of model_service;

@Injectable()
class SalonService extends ModelService
{
  SalonService() : super("salons")
  {
    _db.ref('rooms').onChildAdded.listen(_onRoomAdded);
    _db.ref('rooms').onChildChanged.listen(_onRoomChanged);
    _db.ref('rooms').onChildRemoved.listen(_onRoomRemoved);
  }

  @override
  Salon createModelInstance(Map<String, dynamic> data)
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

  Future patchBookings(String salon_id, List<String> booking_ids) async
  {
    _loading = true;
    await _ref.child(salon_id).child("booking_ids").set(booking_ids);
    _loading = false;
  }

  Future patchUsers(String salon_id, List<String> user_ids) async
  {
    _loading = true;
    await _ref.child(salon_id).child("user_ids").set(user_ids);
    _loading = false;
  }

  List<String> getServiceIds(Salon s)
  {
    Set<String> ids = new Set();
    for (String room_id in s.roomIds)
    {
      ids.addAll(getRoom(room_id)?.serviceIds);
    }
    return ids.toList(growable: false);
  }

  void _onRoomAdded(firebase.QueryEvent e)
  {
    _rooms[e.snapshot.key] = new Room.decode(e.snapshot.val());
    Salon salon = selectedModel as Salon;
    if (salon != null)
    {
      salon.roomIds.add(e.snapshot.key);
      _ref.child(_selectedModelId).child("room_ids").set(salon.roomIds);
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
    _ref.child(_selectedModelId).child("room_ids").set(salon.roomIds);
  }

  Map<String, Room> _rooms = new Map();
}