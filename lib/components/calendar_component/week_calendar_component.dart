// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Day, Increment, Room, Salon, Service, User;
import 'package:bokain_admin/components/booking_add_component/booking_add_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show IdModel, BookingService, SalonService, ServiceService, UserService;
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

enum DragMode
{
  add,
  remove
}

@Component(
    selector: 'bo-week-calendar',
    styleUrls: const ['calendar_component.css','week_calendar_component.css'],
    templateUrl: 'week_calendar_component.html',
    directives: const [materialDirectives, BookingAddComponent, BookingDetailsComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class WeekCalendarComponent implements OnInit
{
  WeekCalendarComponent(this.phrase, this.bookingService, this.calendarService, this.salonService, this.serviceService, this.userService)
  {
    date = new DateTime.now();

    availableServiceOptions = new SelectionOptions<IdModel>([_optionsGroup]);

    // Update booking whenever the user selects a service
    serviceSelection.selectionChanges.listen((e)
    {
      if (e.isNotEmpty && e.first.added.isNotEmpty)
      {
        IdModel idModel = e.first.added.first;
        booking.serviceId = idModel.id;
        Service service = idModel.model;
        booking.duration = new Duration(minutes:service.durationMinutes);
        booking.price = service.price;

        _updateAvailableServicesAndIncrements();
      }
    });
  }

  @override
  void ngOnInit()
  {
    userSelection.selectionChanges.listen(_updateAvailableServicesAndIncrements);
    salonSelection.selectionChanges.listen(_updateAvailableServicesAndIncrements);
    _updateAvailableServicesAndIncrements();
  }

  void advanceWeek(int week_count)
  {
    for (int i = 0; i < 7; i++)
    {
      weekdays[i] = weekdays[i].add(new Duration(days: 7 * week_count));
    }
    _updateBookableIncrements();

    currentWeek = _getWeekOf(weekdays.first);
    changeWeekOutput.emit(weekdays.first);
  }

  void parseIncrementMouseDown(Increment increment)
  {
    if (increment.bookingId == null)
    {
      dragging = true;
      _firstDraggedIncrement = increment;

      if (!_bookingMode && selectedState.isNotEmpty)
      {
        _dm = (increment.state == selectedState) ? DragMode.remove : DragMode.add;
        increment.state = (_dm == DragMode.add) ? selectedState : null;
      }
    }
    else details.bookingId = increment.bookingId;
  }

  void parseIncrementMouseUp(Increment increment)
  {
    if (_bookingMode)
    {
      if (highlightedIncrements.isNotEmpty && increment.bookingId == null)
      {
        showAddBookingModal = true;
        booking.roomId = highlightedIncrements.first.roomId;
        booking.startTime = highlightedIncrements.first.startTime;
        booking.endTime = highlightedIncrements.last.endTime;
        booking.duration = booking.endTime.difference(booking.startTime);
      }
    }
    else calendarService.save(calendarService.getDay(booking.userId, booking.salonId, increment.startTime));

    _firstDraggedIncrement = null;
  }

  void parseIncrementMouseEnter(Increment increment)
  {
    Day day = calendarService.getDay(booking.userId, booking.salonId, increment.startTime);
    if (increment.bookingId == null)
    {
      if (_bookingMode) _parseIncrementMouseEnterBookingMode(day, increment);
      else _parseIncrementMouseEnterCalendarMode(increment);
    }
    else
    {
      /// Highlight currently hovered booking
      highlightedIncrements = day.increments.where((i) => i.bookingId == increment.bookingId).toList(growable: false);
    }
  }

  void dismissAddBookingModal()
  {
    showAddBookingModal = false;
    booking.progress = booking.secondaryProgress = 0;
    booking.roomId = null;
    booking.customerId = null;
    booking.startTime = null;
    booking.endTime = null;
    booking.serviceAddonIds?.clear();
    _updateBookableIncrements();
  }

  Service get selectedService => serviceService.getModel(booking.serviceId);

  void _parseIncrementMouseEnterBookingMode(Day day, Increment increment)
  {
    if (increment.state == "open" && booking.userId != null && booking.salonId != null && booking.serviceId != null)
    {
      Service s = serviceService.getModel(booking.serviceId);

      if (dragging)
      {
        /// TODO drag-select booking duration only if the service allows it

        Increment first;
        Increment last;
        if (increment.startTime.isAfter(_firstDraggedIncrement.startTime))
        {
          first = _firstDraggedIncrement;
          last = increment;
        }
        else
        {
          first = increment;
          last = _firstDraggedIncrement;
        }

        DateTime startTime = first.startTime.add(const Duration(seconds:-1));
        DateTime endTime = last.endTime.add(const Duration(seconds: 1));

        highlightedIncrements =
            day.increments.where((i) => i.startTime.isAfter(startTime) && i.endTime.isBefore(endTime)).toList(growable: false);
      }
      else
      {
        /// Highlight increments covered by the duration of the currently selected services' duration
        DateTime startTime = increment.startTime.add(const Duration(seconds: - 1));
        DateTime endTime = increment.startTime.add(s.duration).add(const Duration(seconds: 1));

        if (bookableIncrements[increment.startTime.weekday - 1].contains(increment))
        {
          highlightedIncrements = day.increments.where((i) => i.startTime.isAfter(startTime) && i.endTime.isBefore(endTime)).toList(growable: false);
        }
        else highlightedIncrements = [];
      }
    }
  }

  void _parseIncrementMouseEnterCalendarMode(Increment increment)
  {
    highlightedIncrements = [];
    if (dragging) increment.state = (_dm == DragMode.add) ? selectedState : null;
  }

  void _updateAvailableServicesAndIncrements([List e = null])
  {
    if (userSelection.selectedValues.isEmpty || salonSelection.selectedValues.isEmpty || serviceService.modelOptions.optionGroups.isEmpty) return null;

    User selectedUser = userSelection.selectedValues.first.model;
    Salon selectedSalon = salonSelection.selectedValues.first.model;
    _optionsGroup.clear();
    Iterable<String> availableServiceIds = salonService.getServiceIds(selectedSalon).where(selectedUser.serviceIds.contains);
    availableServiceIds.forEach((id) => _optionsGroup.add(new IdModel(id, serviceService.getModel(id))));

    if (!availableServiceIds.contains(booking.serviceId))
    {
      serviceSelection.clear();
      booking.serviceId = null;
    }

    _updateBookableIncrements();
  }

  void _updateBookableIncrements()
  {
    // update available increments
    for (int i = 0; i < weekdays.length; i++)
    {
      bookableIncrements[i] = _getBookableIncrements(weekdays[i]);
    }
  }

  // Return increments that has temporal room for the selected service, and where at least one qualified room in the selected
  // salon is available and at least one qualified user is available
  List<Increment> _getBookableIncrements(DateTime date)
  {
    Day day = calendarService.getDay(booking.userId, booking.salonId, date);

    List<Increment> output = new List();

    if (booking.serviceId == null) return output;

    List<Increment> openIncrements = day.increments.where((increment) => increment.state == "open" && increment.bookingId == null).toList(growable: false);
    // The day has no open increments
    if (openIncrements.isEmpty) return output;

    int bookingStripLength = (booking.duration.inMinutes / Increment.duration.inMinutes).ceil();
    // The booking takes up too many increments
    if (openIncrements.length < bookingStripLength) return output;

    Salon salon = salonService.getModel(booking.salonId);
    // The salon doesn't have any rooms
    if (salon.roomIds.isEmpty) return output;

    for (int i = 0; i < openIncrements.length - (bookingStripLength - 1); i++)
    {
      bool foundOpenStrip = true;
      for (int j = 0; j < bookingStripLength - 1; j++)
      {
        openIncrements[i+j].roomId = _getFirstAvailableRoomId(salon, booking.serviceId, openIncrements[i+j].startTime, booking.duration);
        if (openIncrements[i+j].roomId == null || !openIncrements[i+j].endTime.isAtSameMomentAs(openIncrements[i+j+1].startTime))
        {
          foundOpenStrip = false;
          break;
        }
      }
      if (foundOpenStrip == true) output.add(openIncrements[i]);
    }
    return output;
  }

  // Find the first available room in the specified salon, that can host the specified service within the specified time range
  // Returns room_id on success, null if no available room was found
  String _getFirstAvailableRoomId(Salon salon, String service_id, DateTime start_time, Duration duration)
  {
    for (String room_id in salon.roomIds)
    {
      String availableRoomId = room_id;
      Room room = salonService.getRoom(room_id);

      DateTime iTime = start_time;
      DateTime endTime = iTime.add(duration);
      while (iTime.isBefore(endTime))
      {
        availableRoomId =
        (room.serviceIds.contains(service_id) &&
            bookingService.find(iTime, room_id) == null &&
            room_id == availableRoomId) ? room_id : null;

        iTime = iTime.add(Increment.duration);
      }

      // All increments in the specified time range are available for availableRoomId
      if (availableRoomId != null) return availableRoomId;
    }
    return null;
  }

  int _getWeekOf(DateTime date)
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

  @Input('date')
  void set date(DateTime date)
  {
    DateTime iDate = new DateTime(date.year, date.month, date.day, 12);
    // Monday
    iDate = new DateTime(iDate.year, iDate.month, iDate.day - (iDate.weekday - 1), 12);
    currentWeek = _getWeekOf(iDate);
    for (int i = 0; i < 7; i++)
    {
      weekdays[i] = iDate;
      iDate = iDate.add(const Duration(days: 1));
    }
  }

  String get currentMonth => phrase.get(["month_${weekdays.first.month}"]);

  bool get bookingMode => _bookingMode;

  void set bookingMode(bool value)
  {
    _bookingMode = value;
    if (_bookingMode)
    {
      selectedState = "";
      _updateBookableIncrements();
    }
    else
    {
      selectedState = "open";
      highlightedIncrements = [];
    }
  }

  @ViewChild('details')
  BookingDetailsComponent details;

  @Input('booking')
  Booking booking;

  @Input('userSelection')
  SelectionModel<IdModel> userSelection;

  @Input('salonSelection')
  SelectionModel<IdModel> salonSelection;

  @Output('changeWeek')
  EventEmitter<DateTime> changeWeekOutput = new EventEmitter();

  final BookingService bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
  final PhraseService phrase;
  final SelectionModel<IdModel> serviceSelection = new SelectionModel.withList(allowMulti: false);

  SelectionOptions<IdModel> availableServiceOptions;
  OptionGroup<IdModel> _optionsGroup = new OptionGroup<IdModel>([]);

  bool dragging = false;
  bool showAddBookingModal = false;
  bool _bookingMode = false;
  DragMode _dm = DragMode.remove;
  String selectedState = "open";
  int currentWeek;
  List<Increment> highlightedIncrements = new List();
  List<DateTime> weekdays = new List(7);
  List<List<Increment>> bookableIncrements = new List(7);

  Increment _firstDraggedIncrement;
}