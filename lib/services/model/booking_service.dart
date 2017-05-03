part of model_service;

@Injectable()
class BookingService extends ModelService
{
  BookingService(this._calendarService, this._customerService, this._salonService, this._userService) : super("bookings")
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

  Future _onChildAddedOrChanged(firebase.QueryEvent e) async
  {
    Booking booking = new Booking.decode(e.snapshot.key, e.snapshot.val());

    if (_bookingMap.containsKey(e.snapshot.key)) await _patchRemove(_bookingMap[e.snapshot.key]);
    await _patchAdd(booking);

    _bookingMap[e.snapshot.key] = booking;
  }

  Future _onChildRemoved(firebase.QueryEvent e) async
  {
    Booking booking = bookingMap[e.snapshot.key]; //new Booking.decode(e.snapshot.key, e.snapshot.val());
    if (booking != null)
    {
      await _patchRemove(booking);
      _bookingMap.remove(booking.id);
    }
  }

  Future _patchAdd(Booking booking) async
  {
    if (booking == null) return;

    Day day = _calendarService.getDay(booking.salonId, booking.startTime);
    User user = _userService.getModel(booking.userId);
    Salon salon = _salonService.getModel(booking.salonId);
    Customer customer = _customerService.getModel(booking.customerId);

    /// Increments
    if (day != null)
    {
      DateTime iTime = new DateTime.fromMillisecondsSinceEpoch(booking.startTime.millisecondsSinceEpoch);
      while (iTime.isBefore(booking.endTime))
      {
        Increment increment = day.increments.firstWhere((i) => i.startTime.isAtSameMomentAs(iTime));
        increment.userStates[booking.userId]?.bookingId = booking.id;
        iTime = iTime.add(Increment.duration);
      }
      await _calendarService.save(day);
    }

    /// User->bookings
    if (user != null && !user.bookingIds.contains(booking.id))
    {
      user.bookingIds.add(booking.id);
      await _userService.patchBookings(user.id, user.bookingIds);
    }

    /// Salon->bookings
    if (salon != null && !salon.bookingIds.contains(booking.id))
    {
      salon.bookingIds.add(booking.id);
      await _salonService.patchBookings(salon.id, salon.bookingIds);
    }

    /// Customer->bookings
    if (customer != null && !customer.bookingIds.contains(booking.id))
    {
      customer.bookingIds.add(booking.id);
      await _customerService.patchBookings(customer.id, customer.bookingIds);
    }
  }

  Future _patchRemove(Booking booking) async
  {
    if (booking == null) return;

    /// Increments
    Day day = _calendarService.getDay(booking.salonId, booking.startTime);
    User user = _userService.getModel(booking.userId);
    Salon salon = _salonService.getModel(booking.salonId);
    Customer customer = _customerService.getModel(booking.customerId);

    if (day != null)
    {
      DateTime iTime = new DateTime.fromMillisecondsSinceEpoch(booking.startTime.millisecondsSinceEpoch);
      while (iTime.isBefore(booking.endTime))
      {
        Increment increment = day.increments.firstWhere((i) => i.startTime.isAtSameMomentAs(iTime));
        increment.userStates[booking.userId].bookingId = null;
        iTime = iTime.add(Increment.duration);
      }
      await _calendarService.save(day);
    }

    /// User->bookings
    if (user != null)
    {
      user.bookingIds.removeWhere((id) => id == booking.id);
      await _userService.patchBookings(user.id, user.bookingIds);
    }

    /// Salon->bookings
    if (salon != null)
    {
      salon.bookingIds.removeWhere((id) => id == booking.id);
      await _salonService.patchBookings(salon.id, salon.bookingIds);
    }

    /// Customer->bookings
    if (customer != null)
    {
      customer.bookingIds.remove(booking.id);
      await _customerService.patchBookings(customer.id, customer.bookingIds);
    }
  }

  Booking rebookBuffer;
  Map<String, Booking> get bookingMap => _bookingMap;
  Map<String, Booking> _bookingMap = new Map();
  final CalendarService _calendarService;
  final CustomerService _customerService;
  final SalonService _salonService;
  final UserService _userService;
}

