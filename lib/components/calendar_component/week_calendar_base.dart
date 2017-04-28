import 'dart:async' show StreamController;
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show SalonService;
import 'package:bokain_models/bokain_models.dart' show Increment, Booking, Salon, User;

abstract class WeekCalendarBase
{
  WeekCalendarBase(this.calendarService, this.salonService, this.phrase);

  List<List<Increment>> get availableWeekIncrements;

  void advanceWeek(int week_count)
  {
    for (int i = 0; i < 7; i++)
    {
      weekdays[i] = weekdays[i].add(new Duration(days: 7 * week_count));
    }
    currentWeek = getWeekOf(weekdays.first);

    onChangeWeek.add(weekdays.first);
  }

  void clearHighlight() { firstHighlighted = lastHighlighted = null; }

  bool isHighlighted(Increment inc)
  {
    if (firstHighlighted == null || lastHighlighted == null) return false;

    if (firstHighlighted.startTime.isBefore(lastHighlighted.startTime))
    {
      return (inc.startTime.isAfter(firstHighlighted.startTime) || inc.startTime.isAtSameMomentAs(firstHighlighted.startTime)) &&
          (inc.endTime.isBefore(lastHighlighted.endTime) || inc.endTime.isAtSameMomentAs(lastHighlighted.endTime));
    }
    else
    {
      return (inc.startTime.isAfter(lastHighlighted.startTime) || inc.startTime.isAtSameMomentAs(lastHighlighted.startTime)) &&
          (inc.endTime.isBefore(firstHighlighted.endTime) || inc.endTime.isAtSameMomentAs(firstHighlighted.endTime));
    }
  }

  int getWeekOf(DateTime date)
  {
    /// Convert any date to the monday of that dates' week
    DateTime mondayDate = date.add(new Duration(days:-(date.weekday-1)));
    DateTime firstMondayOfYear = new DateTime(date.year);
    while (firstMondayOfYear.weekday != 1)
    {
      firstMondayOfYear = firstMondayOfYear.add(const Duration(days:1));
    }
    Duration difference = mondayDate.difference(firstMondayOfYear);
    return (difference.inDays ~/ 7).toInt() + 1;
  }

  String get currentMonth => phrase.get(["month_${weekdays.first.month}"]);

  void set date(DateTime value)
  {
    DateTime iDate = new DateTime(value.year, value.month, value.day, 12);
    // Monday
    iDate = new DateTime(iDate.year, iDate.month, iDate.day - (iDate.weekday - 1), 12);
    currentWeek = getWeekOf(iDate);
    for (int i = 0; i < 7; i++)
    {
      weekdays[i] = iDate;
      iDate = iDate.add(const Duration(days: 1));
    }
  }

  final CalendarService calendarService;
  final SalonService salonService;
  final PhraseService phrase;

  int currentWeek;
  List<DateTime> weekdays = new List(7);
  Increment firstHighlighted, lastHighlighted;
  Booking selectedBooking;
  User selectedUser;
  Salon selectedSalon;

  final List<List<Increment>> weekIncrements = new List(7);

  final StreamController<DateTime> onChangeWeek = new StreamController();
}
