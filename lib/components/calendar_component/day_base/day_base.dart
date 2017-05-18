import 'package:bokain_models/bokain_models.dart' show CalendarService, BookingService, PhraseService, SalonService, UserService, Day, Salon, User;

abstract class DayBase
{
  DayBase(this.bookingService, this.calendarService, this.phrase, this.salonService, this.userService);

  Day get day => _day;

  void set date(DateTime value)
  {
    _date = value;
    _day = calendarService.getDay(selectedSalon.id, _date);
  }

  final PhraseService phrase;
  final BookingService bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final UserService userService;
  User selectedUser;
  Salon selectedSalon;
  DateTime _date;
  Day _day;
}