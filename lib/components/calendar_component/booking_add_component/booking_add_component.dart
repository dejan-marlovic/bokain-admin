// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, StreamController, Stream;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_admin/components/new_booking_component/new_booking_component.dart';
import 'package:bokain_admin/components/calendar_component/booking_add_day_component/booking_add_day_component.dart';
import 'package:bokain_admin/components/calendar_component/booking_add_week_component/booking_add_week_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/calendar_component/day_stepper_component/day_stepper_component.dart';
import 'package:bokain_admin/components/calendar_component/month_calendar_component/month_calendar_component.dart';
import 'package:bokain_admin/components/calendar_component/week_stepper_component/week_stepper_component.dart';
import 'package:bokain_admin/components/calendar_component/schedule_day_component/schedule_day_component.dart';
import 'package:bokain_admin/components/calendar_component/schedule_week_component/schedule_week_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const
    [
      materialDirectives,
      BookingAddDayComponent,
      BookingAddWeekComponent,
      BookingDetailsComponent,
      ScheduleDayComponent,
      ScheduleWeekComponent,
      DayStepperComponent,
      FoModalComponent,
      MonthCalendarComponent,
      NewBookingComponent,
      WeekStepperComponent
    ],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.Default
)
class BookingAddComponent implements OnDestroy
{
  BookingAddComponent(this.bookingService, this.calendarService, this._customerService, this._mailerService, this._userService, this.phrase);

  void ngOnDestroy()
  {
    _onActiveTabIndexController.close();
    _onSalonChangeController.close();
    _onServiceChangeController.close();
    _onServiceAddonChangeController.close();
    _onUserChangeController.close();
    onBookingDoneController.close();
  }

  void openDayTab(DateTime dt)
  {
    activeTabIndex = 0;
    _date = dt;
  }

  void openWeekTab(DateTime dt)
  {
    activeTabIndex = 1;
    _date = dt;
  }

  Future onTimeSelect(Booking booking) async
  {
    // Select the booking user
    user = _userService.getModel(booking.userId);
    _onUserChangeController.add(user);

    /// New booking, open booking modal
    if (bookingService.rebookBuffer == null)
    {
      if (service == null) return;
      bufferBooking = booking;
      bufferBooking.salonId = salon.id;
      bufferBooking.serviceId = service.id;
      bufferBooking.serviceAddonIds = (serviceAddons == null) ? null : serviceAddons.map((sa) => sa.id).toList(growable: false);
      showBookingModal = true;
    }

    /// Rebook buffer booking, reschedule
    else
    {
      // Remove previous booking from increments, user, salon, employee
      await bookingService.patchRemove(bookingService.rebookBuffer, update_remote: true);

      bookingService.rebookBuffer.roomId = booking.roomId;
      bookingService.rebookBuffer.userId = booking.userId;
      bookingService.rebookBuffer.startTime = booking.startTime;
      bookingService.rebookBuffer.endTime = booking.endTime;
      bookingService.rebookBuffer.duration = booking.duration;
      bookingService.rebookBuffer.salonId = salon.id;
      bookingService.rebookBuffer.serviceId = service.id;
      bookingService.rebookBuffer.serviceAddonIds = (serviceAddons == null) ? null : serviceAddons.map((sa) => sa.id).toList(growable: false);

      await bookingService.set(bookingService.rebookBuffer.id, bookingService.rebookBuffer);

      // Generate reschedule confirmation email
      Customer selectedCustomer = _customerService.getModel(bookingService.rebookBuffer.customerId);
      Map<String, String> stringParams = new Map();
      stringParams["service_name"] = "${service?.name}";
      stringParams["customer_name"] = "${selectedCustomer.firstname} ${selectedCustomer.lastname}";
      stringParams["user_name"] = "${user.firstname} ${user.lastname}";
      stringParams["salon_name"] = "${salon.name}";
      stringParams["salon_address"] = "${salon.street}, ${salon.postalCode}, ${salon.city}";
      stringParams["date"] = _mailerService.formatDatePronounced(bookingService.rebookBuffer.startTime);
      stringParams["start_time"] = _mailerService.formatHM(bookingService.rebookBuffer.startTime);
      stringParams["end_time"] = _mailerService.formatHM(bookingService.rebookBuffer.endTime);
      _mailerService.mail(phrase.get(['_email_reschedule_booking'], params: stringParams), phrase.get(['booking_confirmation']), selectedCustomer.email);

      onBookingDoneController.add(bookingService.rebookBuffer);
      bookingService.rebookBuffer = null;
    }
  }

  DateTime get date => _date;

  Duration get totalDuration
  {
    Duration duration = new Duration(seconds: 0);
    if (service != null)
    {
      duration += service.duration;
      if (serviceAddons != null)
      {
        for (ServiceAddon addon in serviceAddons)
        {
          duration += addon.duration;
        }
      }
    }

    return duration;
  }

  int get activeTabIndex => _activeTabIndex;

  void set activeTabIndex(int value)
  {
    _activeTabIndex = value;
    _onActiveTabIndexController.add(_activeTabIndex);
  }

  void set date(DateTime value)
  {
    _date = value;
    _onDateChangeController.add(_date);

  }

  int _activeTabIndex = 0;
  bool showBookingModal = false;
  Booking bufferBooking;
  DateTime _date;
  final BookingService bookingService;
  final CalendarService calendarService;
  final CustomerService _customerService;
  final MailerService _mailerService;
  final UserService _userService;
  final PhraseService phrase;
  final StreamController<int> _onActiveTabIndexController = new StreamController();
  final StreamController<Booking> onBookingDoneController = new StreamController();
  final StreamController<Salon> _onSalonChangeController = new StreamController();
  final StreamController<Service> _onServiceChangeController = new StreamController();
  final StreamController<List<ServiceAddon>> _onServiceAddonChangeController = new StreamController();
  final StreamController<User> _onUserChangeController = new StreamController();
  final StreamController<DateTime> _onDateChangeController = new StreamController();

  @Input('date')
  void set dateExt(DateTime value)
  {
    _date = value;
  }

  @Input('user')
  User user;

  @Input('salon')
  Salon salon;

  @Input('scheduleMode')
  bool scheduleMode = false;

  @Input('service')
  Service service;

  @Input('serviceAddons')
  List<ServiceAddon> serviceAddons;

  @Input('activeTabIndex')
  void set activeTabIndexExternal(int value) { _activeTabIndex = value; }

  @Input('scheduleState')
  String scheduleState = "open";

  @Output('activeTabIndexChange')
  Stream<int> get onActiveTabIndexOutput => _onActiveTabIndexController.stream;

  @Output('bookingDone')
  Stream<Booking> get onBookingDoneOutput => onBookingDoneController.stream;

  @Output('salonChange')
  Stream<Salon> get onSalonChangeOutput => _onSalonChangeController.stream;

  @Output('serviceChange')
  Stream<Service> get onServiceChangeOutput => _onServiceChangeController.stream;

  @Output('serviceAddonsChange')
  Stream<List<ServiceAddon>> get onServiceAddonChangeOutput => _onServiceAddonChangeController.stream;

  @Output('userChange')
  Stream<User> get onUserChangeOutput => _onUserChangeController.stream;

  @Output('dateChange')
  Stream<DateTime> get onDateChangeOutput => _onDateChangeController.stream;
}