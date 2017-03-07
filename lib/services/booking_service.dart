import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:bokain_models/bokain_models.dart' show Booking;


@Injectable()
class BookingService
{
  BookingService()
  {
    _refBookings = firebase.database().ref('bookings');
    _refBookings.onChildAdded.listen(_onChildAddedOrChanged);
    _refBookings.onChildChanged.listen(_onChildAddedOrChanged);
    _refBookings.onChildRemoved.listen(_onChildRemoved);

    /// TODO temp
    _bookingMap["1231231adfadf"] = new Booking(new DateTime.now(), new DateTime.now(), "-KbtYf_2QvzmSZei-Toa", "serviceId", ["serviceAddonId1"], "-KbFyxn4EVvQPRET--LQ", "cyka");
  }

  void _onChildAddedOrChanged(firebase.QueryEvent e)
  {
    _bookingMap[e.snapshot.key] = new Booking.decode(e.snapshot.val());
  }

  void _onChildRemoved(firebase.QueryEvent e)
  {
    _bookingMap.remove(e.snapshot.key);
  }

  Map<String, Booking> get bookingMap => _bookingMap;

  Map<String, Booking> _bookingMap = new Map();
  firebase.DatabaseReference _refBookings;

  bool get isLoading => _loading;

  bool _loading = false;
}

