import 'dart:async' show Future, StreamController;
import 'package:bokain_models/bokain_models.dart' show PhraseService, CalendarService, BookingService, SalonService, UserService, Booking, Day, Increment, Salon, User;

abstract class WeekCalendarBase
{
  WeekCalendarBase(this.bookingService, this.calendarService, this.salonService, this.userService, this.phrase);

  void clearHighlight() { firstHighlighted = lastHighlighted = null; }

  bool isHighlighted(Increment i)
  {
    if (firstHighlighted == null || lastHighlighted == null) return false;

    if (firstHighlighted.startTime.isBefore(lastHighlighted.startTime))
    {
      return (i.startTime.isAfter(firstHighlighted.startTime) || i.startTime.isAtSameMomentAs(firstHighlighted.startTime)) &&
             (i.endTime.isBefore(lastHighlighted.endTime) || i.endTime.isAtSameMomentAs(lastHighlighted.endTime));
    }
    else
    {
      return (i.startTime.isAfter(lastHighlighted.startTime) || i.startTime.isAtSameMomentAs(lastHighlighted.startTime)) &&
             (i.endTime.isBefore(firstHighlighted.endTime) || i.endTime.isAtSameMomentAs(firstHighlighted.endTime));
    }
  }

  // Registers the week in the database and opens it up for scheduling
  void openCurrentWeek()
  {
    for (int i = 0; i < 7; i++)
    {
      calendarService.save(new Day(selectedSalon.id, weekDates[i]));
    }
  }

  String get currentMonth => phrase.get(["month_${weekDates.first.month}"]);

  List<Day> get week
  {
    if (selectedSalon == null || calendarService.getDay(selectedSalon.id, weekDates[0]) == null) return [];
    else return new List.generate(7, (index) => calendarService.getDay(selectedSalon.id, weekDates[index]));
  }

  void set date(DateTime value)
  {
    DateTime iDate = new DateTime(value.year, value.month, value.day, 12);
    // Monday
    iDate = new DateTime(iDate.year, iDate.month, iDate.day - (iDate.weekday - 1), 12);

    for (int i = 0; i < 7; i++)
    {
      weekDates[i] = iDate;
      iDate = iDate.add(const Duration(days: 1));
    }
  }

  final BookingService bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final PhraseService phrase;
  final UserService userService;
  List<DateTime> weekDates = new List(7);
  Increment firstHighlighted, lastHighlighted;
  Booking selectedBooking;
  User selectedUser;
  Salon selectedSalon;
}
