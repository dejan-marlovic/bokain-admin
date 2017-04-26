// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream;
import 'dart:html' as dom show MouseEvent;
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Day, Increment, Room, Salon, Service, ServiceAddon, User;
import 'package:bokain_admin/components/calendar_component/service_picker_component.dart';
import 'package:bokain_admin/components/calendar_component/increment_component.dart';
import 'package:bokain_admin/components/calendar_component/week_calendar_base.dart';
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, SalonService, ServiceService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-week-booking',
    styleUrls: const ['calendar_component.css', 'week_calendar_base.css', 'week_booking_component.css'],
    templateUrl: 'week_booking_component.html',
    directives: const [materialDirectives, IncrementComponent, ServicePickerComponent],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class WeekBookingComponent extends WeekCalendarBase
{
  WeekBookingComponent(PhraseService phrase, CalendarService calendar, BookingService booking, SalonService salon, this._serviceService)
      : super(calendar, booking, salon, phrase);

  SelectionOptions<Service> get availableServiceOptions
  {
    if (selectedUser == null || selectedSalon == null) return null;
    else
    {
      return new SelectionOptions([new OptionGroup(
          _serviceService.getModels(
            salonService.getServiceIds(selectedSalon).where(
              selectedUser.serviceIds.contains).toList(growable: false)))]);
    }
  }

  void onIncrementMouseEnter(dom.MouseEvent e, Increment increment)
  {
    /// The increment is open (the selected user is registered to work)
    if (increment.state == "open")
    {
      /// The increment is not occupied by another booking, and a service has been selected
      if (increment.bookingId == null && selectedService != null)
      {
        /// Drag-select booking duration only if the selected service allows it
        if (e.buttons == 1 /* && selectedService.dynamicTime*/)
        {
          /// TODO check if service has dynamic time
          lastHighlighted = increment;
        }
        else
        {
          clearHighlight();
          /// Highlight available increments covered by the duration of the booking duration
          DateTime startTime = increment.startTime.add(const Duration(seconds: -1));
          DateTime endTime = startTime.add(selectedService.duration).add(const Duration(seconds: -1));
          if (selectedServiceAddons != null) for (ServiceAddon addon in selectedServiceAddons) endTime = endTime.add(addon.duration);

          Day day = calendarService.getDay(selectedUser.id, selectedSalon.id, increment.startTime);
          Iterable<Increment> coveredIncrements = day.increments.where((i) => i.startTime.isAfter(startTime) && i.endTime.isBefore(endTime));

          bool allAvailable(Iterable<Increment> increments)
          {
            if (selectedService == null || selectedSalon == null || selectedSalon.roomIds.isEmpty) return false;
            bool unavailable(Increment increment) => (increment.state != "open" || increment.bookingId != null);
            if (increments.where(unavailable).isNotEmpty) return false;
            return true;
          }

          if (allAvailable(coveredIncrements))
          {
            firstHighlighted = coveredIncrements.first;
            lastHighlighted = coveredIncrements.last;
          }
        }
      }
      /// The increment is occupied by another booking, highlight the booking
      else if (increment.bookingId != null)
      {

      }
    }
  }

  void onIncrementMouseDown(Increment increment)
  {
    if (increment.bookingId == null && increment.state == "open") firstHighlighted = lastHighlighted = increment;
  }

  void onIncrementMouseUp(Increment increment)
  {
    if (increment.bookingId != null)
    {
      // TODO existing open booking
    }

    clearHighlight();
  }

  @Output('changeWeek')
  Stream<DateTime> get changeWeek => onChangeWeek.stream;

  @Input('user')
  void set user(User value) { selectedUser = value; }

  @Input('salon')
  void set salon(Salon value) { selectedSalon = value; }

  @Input('date')
  @override
  void set date(DateTime value) { super.date = value; }

  Service selectedService;
  List<ServiceAddon> selectedServiceAddons;

  final ServiceService _serviceService;
 // final SalonService _salonService;
}