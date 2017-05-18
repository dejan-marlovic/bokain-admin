// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, StreamController, Stream;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Salon, Service, ServiceAddon, User, BookingService, CalendarService, CustomerService, MailerService, PhraseService, SalonService, ServiceService;
import 'package:bokain_admin/components/calendar_component/day_booking_component/day_booking_component.dart';
import 'package:bokain_admin/components/calendar_component/service_picker_component/service_picker_component.dart';
import 'package:bokain_admin/components/calendar_component/month_calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_booking_component/week_booking_component.dart';
import 'package:bokain_admin/components/calendar_component/week_schedule_component/week_schedule_component.dart';
import 'package:bokain_admin/components/calendar_component/week_stepper_component/week_stepper_component.dart';

@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const [materialDirectives, DayBookingComponent, MonthCalendarComponent, ServicePickerComponent, WeekBookingComponent, WeekScheduleComponent, WeekStepperComponent],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BookingAddComponent implements OnDestroy
{
  BookingAddComponent(this.bookingService, this.calendarService, this._customerService, this._mailerService, this.phrase, this._salonService, this._serviceService);

  void ngOnDestroy()
  {
    _onActiveTabIndexController.close();
    onBookingSaveController.close();
  }

  void openDayTab(DateTime dt)
  {
    activeTabIndex = 0;
    date = dt;
    _onActiveTabIndexController.add(0);
  }

  void openWeekTab(DateTime dt)
  {
    activeTabIndex = 1;
    date = dt;
    _onActiveTabIndexController.add(1);
  }

  void onAdd(String booking_id)
  {
  }

  Future onTimeSelect(Booking booking) async
  {
    if (bookingService.rebookBuffer == null)
    {
      bufferBooking = booking;
      bufferBooking.salonId = _salon.id;
      bufferBooking.serviceId = service.id;
      bufferBooking.serviceAddonIds = (serviceAddons == null) ? null : serviceAddons.map((sa) => sa.id).toList(growable: false);
      showBookingModal = true;
    }
    else
    {
      // Remove previous booking from increments, user, salon, employee
      await bookingService.patchRemove(bookingService.rebookBuffer, update_remote: true);

      bookingService.rebookBuffer.roomId = booking.roomId;
      bookingService.rebookBuffer.userId = booking.userId;
      bookingService.rebookBuffer.startTime = booking.startTime;
      bookingService.rebookBuffer.endTime = booking.endTime;
      bookingService.rebookBuffer.duration = booking.duration;
      bookingService.rebookBuffer.salonId = _salon.id;
      bookingService.rebookBuffer.serviceId = service.id;
      bookingService.rebookBuffer.serviceAddonIds = (serviceAddons == null) ? null : serviceAddons.map((sa) => sa.id).toList(growable: false);

      await bookingService.set(bookingService.rebookBuffer.id, bookingService.rebookBuffer);

      // Generate reschedule confirmation email
      Customer selectedCustomer = _customerService.getModel(bookingService.rebookBuffer.customerId);
      Map<String, String> stringParams = new Map();
      stringParams["service_name"] = "${service?.name}";
      stringParams["customer_name"] = "${selectedCustomer.firstname} ${selectedCustomer.lastname}";
      stringParams["user_name"] = "${_user.firstname} ${_user.lastname}";
      stringParams["salon_name"] = "${_salon.name}";
      stringParams["salon_address"] = "${_salon.street}, ${_salon.postalCode}, ${_salon.city}";
      stringParams["date"] = _mailerService.formatDatePronounced(bookingService.rebookBuffer.startTime);
      stringParams["start_time"] = _mailerService.formatHM(bookingService.rebookBuffer.startTime);
      stringParams["end_time"] = _mailerService.formatHM(bookingService.rebookBuffer.endTime);
      _mailerService.mail(phrase.get(['_email_reschedule_booking'], params: stringParams), phrase.get(['booking_confirmation']), selectedCustomer.email);

      bookingService.rebookBuffer = null;
    }
  }

  Salon get salon => _salon;
  User get user => _user;

  SelectionOptions<Service> get availableServiceOptions
  {
    int sortAlpha(Service a, Service b) => a.name.compareTo(b.name);
    if (_salon == null) return null;
    else if (_user == null)
    {
      // Filter so that only services supported by the salon are listed
      List<String> ids = _salonService.getServiceIds(_salon);
      List<Service> services = _serviceService.getModelsAsList(ids);
      services.sort(sortAlpha);
      return new SelectionOptions([new OptionGroup(services)]);
    }
    else
    {
      // Filter so that only services supported by the user/salon are listed
      List<String> ids = _salonService.getServiceIds(_salon).where(_user.serviceIds.contains).toList();
      List<Service> services = _serviceService.getModelsAsList(ids);
      services.sort(sortAlpha);
      return new SelectionOptions([new OptionGroup(services)]);
    }
  }

  @Input('user')
  void set user(User value)
  {
    _user = value;
  }

  @Input('salon')
  void set salon(Salon value)
  {
    _salon = value;
  }

  @Input('scheduleMode')
  bool scheduleMode = false;

  @Input('activeTabIndex')
  int activeTabIndex = 0;

  @Output('activeTabIndexChange')
  Stream<int> get onActiveTabIndexOutput => _onActiveTabIndexController.stream;

  @Output('save')
  Stream<String> get onBookingSaveOutput => onBookingSaveController.stream;

  Service service;
  List<ServiceAddon> serviceAddons;

  DateTime date = new DateTime.now();

  bool showBookingModal = false;
  Booking bufferBooking;


  final BookingService bookingService;
  final CalendarService calendarService;
  final CustomerService _customerService;
  final MailerService _mailerService;
  final PhraseService phrase;
  final SalonService _salonService;
  final ServiceService _serviceService;
  final StreamController<int> _onActiveTabIndexController = new StreamController();
  final StreamController<String> onBookingSaveController = new StreamController();
  Salon _salon;
  User _user;

}