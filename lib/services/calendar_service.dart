import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:bokain_models/bokain_models.dart' show Day;

@Injectable()
class CalendarService
{
  CalendarService()
  {
    _refDays = firebase.database().ref('days');
    _refDays.onChildAdded.listen(_onChildAdded);
    _refDays.onChildChanged.listen(_onChildChanged);
    _refDays.onChildRemoved.listen(_onChildRemoved);
  }

  Day getDay(String user_id, String salon_id, DateTime date)
  {
    if (user_id == null || salon_id == null || date == null) return null;

    return _dayMap.values.firstWhere((d)
    {
      return d.userId.compareTo(user_id) == 0 && d.salonId.compareTo(salon_id) == 0 && d.isSameDateAs(date);
    }, orElse: () => _getNewOrBufferedDay(user_id, salon_id, date));
  }

  Future<String> save(Day day) async
  {
    _loading = true;
    String id = _dayMap.keys.firstWhere((key)
    {
      return _dayMap[key].isSameDateAs(day.startTime) && _dayMap[key].salonId == day.salonId && _dayMap[key].userId == day.userId;
    }, orElse: () => null);

    if (id == null) await _refDays.push(day.encoded);
    else await _refDays.child(id).update(day.encoded);
    _loading = false;
    return null;
  }

  void _onChildAdded(firebase.QueryEvent e)
  {
    _dayMap[e.snapshot.key] = new Day.decode(e.snapshot.key, e.snapshot.val());
  }

  void _onChildChanged(firebase.QueryEvent e)
  {
    _dayMap[e.snapshot.key] = new Day.decode(e.snapshot.key, e.snapshot.val());
  }

  void _onChildRemoved(firebase.QueryEvent e)
  {
    _dayMap.remove(e.snapshot.key);
  }

  /// If the database has no record of this user_id/date, create a new day and store it in _newDayBuffer
  Day _getNewOrBufferedDay(String user_id, String salon_id, DateTime date)
  {
    Day d = _newDayBuffer.firstWhere((d)
    {
      return d.userId.compareTo(user_id) == 0 && d.salonId.compareTo(salon_id) == 0 && d.isSameDateAs(date);
    }, orElse: () => null);
    if (d == null)
    {
      d = new Day(user_id, salon_id, date);
      _newDayBuffer.add(d);
    }
    return d;
  }

  bool get isLoading => _loading;

  Map<String, Day> _dayMap = new Map();
  List<Day> _newDayBuffer = new List();
  firebase.DatabaseReference _refDays;

  bool _loading = false;
}