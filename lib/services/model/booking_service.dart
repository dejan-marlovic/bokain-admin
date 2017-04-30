part of model_service;

@Injectable()
class BookingService extends ModelService
{
  BookingService(this._calendarService) : super("bookings")
  {
    _ref.onChildAdded.listen(_onChildAddedOrChanged);
    _ref.onChildChanged.listen(_onChildAddedOrChanged);
    _ref.onChildRemoved.listen(_onChildRemoved);
  }

  @override
  Booking createModelInstance(String id, Map<String, dynamic> data)
  {
    return new Booking.decode(id, data);
  }

  Booking find(DateTime time, String room_id)
  {
    return _bookingMap.values.firstWhere((b) =>
      b.roomId == room_id &&
      (b.startTime.isAtSameMomentAs(time) || (b.startTime.isBefore(time) && b.endTime.isAfter(time))), orElse: () => null);
  }

  void _onChildAddedOrChanged(firebase.QueryEvent e)
  {
    Booking b = _bookingMap[e.snapshot.key] = new Booking.decode(e.snapshot.key, e.snapshot.val());
    Day day = _calendarService.getDay(b.salonId, b.startTime);

    DateTime iTime = new DateTime.fromMillisecondsSinceEpoch(b.startTime.millisecondsSinceEpoch);
    while (iTime.isBefore(b.endTime))
    {
      Increment increment = day.increments.firstWhere((i) => i.startTime.isAtSameMomentAs(iTime));
      increment.userStates[b.userId]?.bookingId = b.id;
      iTime = iTime.add(Increment.duration);
    }

    _calendarService.save(day);
  }

  void _onChildRemoved(firebase.QueryEvent e)
  {
    Booking b = new Booking.decode(e.snapshot.key, e.snapshot.val());
    Day day = _calendarService.getDay(b.salonId, b.startTime);

    DateTime iTime = new DateTime.fromMillisecondsSinceEpoch(b.startTime.millisecondsSinceEpoch);
    while (iTime.isBefore(b.endTime))
    {
      Increment increment = day.increments.firstWhere((i) => i.startTime.isAtSameMomentAs(iTime));
      increment.userStates[b.userId].bookingId = null;
      iTime = iTime.add(Increment.duration);
    }

    _calendarService.save(day);
    _bookingMap.remove(e.snapshot.key);
  }

  Map<String, Booking> get bookingMap => _bookingMap;
  Map<String, Booking> _bookingMap = new Map();
  final CalendarService _calendarService;
}

