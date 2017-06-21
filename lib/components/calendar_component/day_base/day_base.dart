import 'package:bokain_models/bokain_models.dart' show BookingService, CalendarService, SalonService, UserService, Day, Salon, User;

abstract class DayBase
{
  DayBase(this.bookingService, this.calendarService, this.salonService, this.userService);

  Day get day => calendarService.getDay(selectedSalon.id, _date);

  void set date(DateTime value)
  {
    _date = new DateTime(value.year, value.month, value.day, Day.startHour, Day.startMinute, 0);
    calendarService.setRange(value, value, selectedSalon?.id);
  }

  DateTime get date => _date;

  final BookingService bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final UserService userService;
  User selectedUser;
  Salon selectedSalon;
  DateTime _date;
}