import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:bokain_models/bokain_models.dart' show Day, Increment;

@Injectable()
class CalendarService
{
  CalendarService()
  {
    _db = firebase.database();
    _refDays = _db.ref('days');
    _refDays.onChildAdded.listen(_onChildAdded);
    _refDays.onChildChanged.listen(_onChildChanged);
    _refDays.onChildRemoved.listen(_onChildRemoved);
  }

  Day getDay(String user_id, DateTime date)
  {
    return _dayMap.values.firstWhere((d) => d.userId.compareTo(user_id) == 0 && d.isSameDateAs(date), orElse: () => null);
  }

  Future<String> save(Day day) async
  {
    _loading = true;
    if (_dayMap.values.contains(day)) _refDays.update(day.properties);
    else await _refDays.push(day.properties);
    _loading = false;
    /// TODO return string with error if found
    return null;
  }

  void _onChildAdded(firebase.QueryEvent e)
  {
    _dayMap[e.snapshot.key] = new Day.parse(e.snapshot.val());
  }

  void _onChildChanged(firebase.QueryEvent e)
  {
    _dayMap[e.snapshot.key] = new Day.parse(e.snapshot.val());
  }

  void _onChildRemoved(firebase.QueryEvent e)
  {
    _dayMap.remove(e.snapshot.key);
  }

  bool get isLoading => _loading;

  Map<String, Day> _dayMap = new Map();

  firebase.Database _db;
  firebase.DatabaseReference _refDays;

  bool _loading = false;
}