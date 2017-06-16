//import 'dart:async';
import 'package:bokain_models/bokain_models.dart' show BookingService, CalendarService, SalonService, UserService, Day, Salon, User;

abstract class DayBase
{
  DayBase(this.bookingService, this.calendarService, this.salonService, this.userService);

  Day get day => calendarService.getDay(selectedSalon.id, _date);

  void set date(DateTime value) { _date = value; }

  final BookingService bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final UserService userService;
  User selectedUser;
  Salon selectedSalon;
  DateTime _date;
}