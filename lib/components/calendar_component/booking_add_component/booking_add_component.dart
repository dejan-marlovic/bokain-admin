// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, StreamController, Stream;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_calendar/bokain_calendar.dart';
import '../../new_booking_component/new_booking_component.dart';

@Component(
    selector: 'bo-booking-add',
    styleUrls: const ['booking_add_component.css'],
    templateUrl: 'booking_add_component.html',
    directives: const
    [
      BookingAddDayComponent,
      BookingAddWeekComponent,
      BookingDetailsComponent,
      CORE_DIRECTIVES,
      DayStepperComponent,
      FoModalComponent,
      materialDirectives,
      MonthCalendarComponent,
      NewBookingComponent,
      ScheduleDayComponent,
      ScheduleWeekComponent,
      WeekStepperComponent
    ],
    pipes: const [PhrasePipe]
)
class BookingAddComponent implements OnDestroy
{
  BookingAddComponent(
      this.bookingService,
      this._customerService,
      this._dayService,
      this._mailerService,
      this._outputService,
      this._salonService,
      this._serviceService,
      this._userService,
      this._phraseService
      );

  void ngOnDestroy()
  {
    _onActiveTabIndexController.close();
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
    try
    {
      // Select the booking user
      user = await _userService.fetch(booking.userId);
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
        /**
         * Remove reference to previous booking from increments, user, salon, employee.
         */

        await bookingService.patchRemove(bookingService.rebookBuffer, _customerService, _dayService, _salonService, _userService);

        bookingService.rebookBuffer.dayId = booking.dayId;
        bookingService.rebookBuffer.roomId = booking.roomId;
        bookingService.rebookBuffer.userId = booking.userId;
        bookingService.rebookBuffer.startTime = booking.startTime;
        bookingService.rebookBuffer.endTime = booking.endTime;
        bookingService.rebookBuffer.duration = booking.duration;
        bookingService.rebookBuffer.salonId = salon.id;
        bookingService.rebookBuffer.serviceId = service.id;
        bookingService.rebookBuffer.serviceAddonIds = (serviceAddons == null) ? null : serviceAddons.map((sa) => sa.id).toList(growable: false);

        await bookingService.set(bookingService.rebookBuffer.id, bookingService.rebookBuffer);

        await bookingService.patchAdd(bookingService.rebookBuffer, _customerService, _dayService, _salonService, _serviceService, _userService);

        // Generate reschedule confirmation email
        Customer selectedCustomer = await _customerService.fetch(bookingService.rebookBuffer.customerId);
        Map<String, String> params = new Map();
        params["service_name"] = "${service?.name}";
        params["customer_firstname"] = selectedCustomer.firstname;
        params["user_name"] = "${user.firstname} ${user.lastname}";
        params["salon_name"] = salon.name;
        params["salon_phone"] = salon.phone;
        params["salon_address"] = "${salon.street}, ${salon.postalCode}, ${salon.city}";
        params["date"] = _mailerService.formatDatePronounced(bookingService.rebookBuffer.startTime);
        params["start_time"] = _mailerService.formatHM(bookingService.rebookBuffer.startTime);
        params["end_time"] = _mailerService.formatHM(bookingService.rebookBuffer.endTime);
        params["cancel_code"] = bookingService.rebookBuffer.cancelCode;
        /**
         * TODO: move minimum cancel booking hours variable into a config service
         */
        params["latest_cancel_booking_time"] = ModelBase.timestampFormat(bookingService.rebookBuffer.startTime.add(const Duration(hours: -24)));

        _mailerService.mail(_phraseService.get('email_reschedule_booking', params: params), _phraseService.get('booking_confirmation'), selectedCustomer.email);

        onBookingDoneController.add(bookingService.rebookBuffer);
        bookingService.rebookBuffer = null;
      }
    }
    catch (e)
    {
      _outputService.set(e.toString());
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
  final CustomerService _customerService;
  final DayService _dayService;
  final MailerService _mailerService;
  final OutputService _outputService;
  final PhraseService _phraseService;
  final SalonService _salonService;
  final ServiceService _serviceService;
  final UserService _userService;
  final StreamController<int> _onActiveTabIndexController = new StreamController();
  final StreamController<Booking> onBookingDoneController = new StreamController();
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

  @Output('userChange')
  Stream<User> get onUserChangeOutput => _onUserChangeController.stream;

  @Output('dateChange')
  Stream<DateTime> get onDateChangeOutput => _onDateChangeController.stream;
}