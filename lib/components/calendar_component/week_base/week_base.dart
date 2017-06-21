import 'package:bokain_models/bokain_models.dart' show CalendarService, SalonService, UserService, Day, Salon, User;

abstract class WeekBase
{
  WeekBase(this.calendarService, this.salonService, this.userService);

  List<Day> get week
  {
    if (selectedSalon == null || calendarService.getDay(selectedSalon.id, weekDates[0]) == null) return [];
    else
    {
      return new List.generate(7, (index) => calendarService.getDay(selectedSalon.id, weekDates[index]));
    }
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

  final CalendarService calendarService;
  final SalonService salonService;
  final UserService userService;
  List<DateTime> weekDates = new List(7);
  User selectedUser;
  Salon selectedSalon;
}
