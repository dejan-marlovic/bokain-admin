// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Day, Increment, Room, Salon, Service, ServiceAddon, User;
import 'package:bokain_admin/components/booking_add_component/booking_add_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, SalonService, ServiceAddonService, ServiceService, UserService;
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
  WeekCalendarComponent(this.phrase, this.bookingService, this.calendarService, this.salonService, this.serviceAddonService, this.serviceService, this.userService)
  {
    date = new DateTime.now();

    availableServiceOptions = new SelectionOptions<Service>([_serviceOptionsGroup]);
    availableServiceAddonOptions = new SelectionOptions([_serviceAddonOptionsGroup]);

    // Update booking whenever the user selects a service
    serviceSelection.selectionChanges.listen(_onServiceSelection);
    serviceAddonSelection.selectionChanges.listen(_onServiceAddonSelection);
  }

  @override
  void ngOnInit()
  {
    userSelection.selectionChanges.listen(_updateAvailableServices);
    salonSelection.selectionChanges.listen(_updateAvailableServices);
    _updateAvailableServices();
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

  void onIncrementMouseDown(Increment increment)
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
    else details.booking = bookingService.getModel(increment.bookingId);
  }

  void onIncrementMouseUp(Increment increment)
  {
    if (_bookingMode)
    {
      if (highlightedIncrements.isNotEmpty && increment.bookingId == null)
      {
        showAddBookingModal = true;
        bookingBuffer.roomId = highlightedIncrements.first.roomId;
        bookingBuffer.startTime = highlightedIncrements.first.startTime;
        bookingBuffer.endTime = highlightedIncrements.last.endTime;
        bookingBuffer.duration = bookingBuffer.endTime.difference(bookingBuffer.startTime);
      }
    }
    else calendarService.save(calendarService.getDay(bookingBuffer.userId, bookingBuffer.salonId, increment.startTime));

    _firstDraggedIncrement = null;
  }

  void onIncrementMouseEnter(Increment increment)
  {
    Day day = calendarService.getDay(bookingBuffer.userId, bookingBuffer.salonId, increment.startTime);
    if (increment.bookingId == null)
    {
      if (_bookingMode) _onIncrementMouseEnterBookingMode(day, increment);
      else _onIncrementMouseEnterCalendarMode(increment);
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
    bookingBuffer.progress = bookingBuffer.secondaryProgress = 0;
    bookingBuffer.roomId = null;
    bookingBuffer.customerId = null;
    bookingBuffer.startTime = null;
    bookingBuffer.endTime = null;
    bookingBuffer.serviceAddonIds?.clear();
    _updateBookableIncrements();
  }

  Service get selectedService => serviceService.getModel(bookingBuffer.serviceId);
  Iterable<ServiceAddon> get selectedServiceAddons => serviceAddonService.getModels(bookingBuffer.serviceAddonIds);

  void _onServiceSelection(List<SelectionChangeRecord<Service>> e)
  {
    _serviceAddonOptionsGroup.clear();
    serviceAddonSelection.clear();

    if (serviceSelection.selectedValues.isNotEmpty)
    {
      Service service = serviceSelection.selectedValues.first;
      bookingBuffer.serviceId = service.id;
      bookingBuffer.duration = service.duration;
      bookingBuffer.price = service.price;
    }

    /// Populate available service addons based on selected service
    Service service = serviceService.getModel(bookingBuffer.serviceId);
    if (service != null)
    {
      service.serviceAddonIds.forEach((id) => _serviceAddonOptionsGroup.add(serviceAddonService.getModel(id)));
    }

    /// Refresh bookable increments
    _updateBookableIncrements();
  }

  void _onServiceAddonSelection(List<SelectionChangeRecord<ServiceAddon>> e)
  {
    bookingBuffer.serviceAddonIds = serviceAddonSelection.selectedValues.map((sa) => sa.id).toList(growable: true);

    // Refresh booking duration and price
    Service service = serviceService.getModel(bookingBuffer.serviceId);
    if (service != null)
    {
      bookingBuffer.duration = service.duration;
      bookingBuffer.price = service.price;
    }
    for (String id in bookingBuffer.serviceAddonIds)
    {
      ServiceAddon addon = serviceAddonService.getModel(id);
      if (addon != null)
      {
        bookingBuffer.duration += addon.duration;
        bookingBuffer.price += addon.price;
      }
    }
  }

  void _onIncrementMouseEnterBookingMode(Day day, Increment increment)
  {
    if (increment.state == "open" && bookingBuffer.userId != null && bookingBuffer.salonId != null && bookingBuffer.serviceId != null)
    {
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

        highlightedIncrements = day.increments.where((i)
        {
          return i.startTime.isAfter(startTime) && i.endTime.isBefore(endTime);
        }).toList(growable: false);
      }
      else
      {
        /// Highlight increments covered by the duration of the booking duration
        DateTime startTime = increment.startTime.add(const Duration(seconds: - 1));
        DateTime endTime = increment.startTime.add(bookingBuffer.duration + const Duration(seconds: 1));

        if (bookableIncrements[increment.startTime.weekday - 1].contains(increment))
        {
          highlightedIncrements = day.increments.where((i)
          {
            return i.startTime.isAfter(startTime) && i.endTime.isBefore(endTime);
          }).toList(growable: false);
        }
        else highlightedIncrements = [];
      }
    }
  }

  void _onIncrementMouseEnterCalendarMode(Increment increment)
  {
    highlightedIncrements = [];
    if (dragging) increment.state = (_dm == DragMode.add) ? selectedState : null;
  }

  void _updateAvailableServices([List e = null])
  {
    if (userSelection.selectedValues.isEmpty || salonSelection.selectedValues.isEmpty || serviceService.modelOptions.optionGroups.isEmpty) return null;

    User selectedUser = userSelection.selectedValues.first;
    Salon selectedSalon = salonSelection.selectedValues.first;

    _serviceOptionsGroup.clear();
    Iterable<String> availableServiceIds = salonService.getServiceIds(selectedSalon).where(selectedUser.serviceIds.contains);
    availableServiceIds.forEach((id) => _serviceOptionsGroup.add(serviceService.getModel(id)));

    if (!availableServiceIds.contains(bookingBuffer.serviceId))
    {
      serviceSelection.clear();
      bookingBuffer.serviceId = null;
    }

    _updateBookableIncrements();
  }

  void _updateBookableIncrements([List e = null])
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
    Day day = calendarService.getDay(bookingBuffer.userId, bookingBuffer.salonId, date);

    List<Increment> output = new List();

    if (bookingBuffer.serviceId == null) return output;

    List<Increment> openIncrements = day.increments.where((increment) => increment.state == "open" && increment.bookingId == null).toList(growable: false);
    // The day has no open increments
    if (openIncrements.isEmpty) return output;

    int bookingStripLength = (bookingBuffer.duration.inMinutes / Increment.duration.inMinutes).ceil();
    // The booking takes up too many increments
    if (openIncrements.length < bookingStripLength) return output;

    Salon salon = salonService.getModel(bookingBuffer.salonId);
    // The salon doesn't have any rooms
    if (salon.roomIds.isEmpty) return output;

    for (int i = 0; i < openIncrements.length - (bookingStripLength - 1); i++)
    {
      bool foundOpenStrip = true;
      for (int j = 0; j < bookingStripLength - 1; j++)
      {
        openIncrements[i+j].roomId = _getFirstAvailableRoomId(salon, bookingBuffer.serviceId, openIncrements[i+j].startTime, bookingBuffer.duration);
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
  Booking bookingBuffer;

  @Input('userSelection')
  SelectionModel<User> userSelection;

  @Input('salonSelection')
  SelectionModel<Salon> salonSelection;

  @Output('changeWeek')
  EventEmitter<DateTime> changeWeekOutput = new EventEmitter();

  final BookingService bookingService;
  final CalendarService calendarService;
  final SalonService salonService;
  final ServiceAddonService serviceAddonService;
  final ServiceService serviceService;
  final UserService userService;
  final PhraseService phrase;
  final SelectionModel<Service> serviceSelection = new SelectionModel.withList(allowMulti: false);
  final SelectionModel<ServiceAddon> serviceAddonSelection = new SelectionModel.withList(allowMulti: true);

  SelectionOptions<Service> availableServiceOptions;
  SelectionOptions<ServiceAddon> availableServiceAddonOptions;
  OptionGroup<Service> _serviceOptionsGroup = new OptionGroup([]);
  OptionGroup<ServiceAddon> _serviceAddonOptionsGroup = new OptionGroup([]);

  bool dragging = false;
  bool showAddBookingModal = false;
  bool _bookingMode = true;
  DragMode _dm = DragMode.remove;
  String selectedState = "open";
  int currentWeek;
  List<Increment> highlightedIncrements = new List();
  List<DateTime> weekdays = new List(7);
  List<List<Increment>> bookableIncrements = new List(7);

  Increment _firstDraggedIncrement;
}