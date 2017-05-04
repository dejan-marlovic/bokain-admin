// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Room, User, Salon;
import 'package:bokain_admin/components/associative_table_component/associated_table_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, CustomerService, SalonService, ServiceService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-salon-edit',
    styleUrls: const ['salon_edit_component.css'],
    templateUrl: 'salon_edit_component.html',
    directives: const [materialDirectives, AssociativeTableComponent, BookingDetailsComponent, SalonDetailsComponent, DataTableComponent, UppercaseDirective],
    providers: const [],
    preserveWhitespace: false
)

class SalonEditComponent
{
  SalonEditComponent(this.phrase, this.bookingService, this.customerService, this.salonService, this.serviceService, this.userService);

  Future save() async
  {
    if (details.form.valid)
    {
      _bufferSalon = new Salon.from(_salon);
      await salonService.set(_salon.id, _salon);
      _onSaveController.add(salon.id);
    }
  }

  void cancel()
  {
    _salon = new Salon.from(_bufferSalon);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  void createRoom()
  {
    String id = salonService.pushRoom(newRoomBuffer);
    _bufferSalon.roomIds.add(id);
    newRoomBuffer.name = "";
  }

  void removeRoom(String id)
  {
    salonService.removeRoom(id);
    _bufferSalon.roomIds.remove(id);
  }

  Future addUser(String user_id) async
  {
    if (!_salon.userIds.contains(user_id))
    {
      _salon.userIds.add(user_id);
      _bufferSalon.userIds.add(user_id);
      salonService.patchUsers(_salon.id, _salon.userIds);
    }
  }

  Future removeUser(String user_id) async
  {
    if (_salon.userIds.contains(user_id))
    {
      _salon.userIds.remove(user_id);
      _bufferSalon.userIds.remove(user_id);
      salonService.patchUsers(_salon.id, _salon.userIds);
    }
  }

  void addRoomService(String room_id, String service_id)
  {
    salonService.getRoom(room_id).serviceIds.add(service_id);
    salonService.setRoom(room_id);
  }

  void removeRoomService(String room_id, String service_id)
  {
    salonService.getRoom(room_id).serviceIds.remove(service_id);
    salonService.setRoom(room_id);
  }

  Salon get salon => _salon;

  Map<String, Map<String, String>> get salonBookings
  {
    Map<String, Map<String, String>> bookingData = bookingService.getRows(_salon.bookingIds, true);
    Map<String, Map<String, String>> output = new Map();
    for (String key in bookingData.keys)
    {
      Booking booking = bookingService.getModel(key);
      Map<String, String> row = new Map();
      row[phrase.get(["start_time"])] = booking.strStartTime;
      row[phrase.get(["duration_minutes"])] = booking.duration.inMinutes.toString();
      row[phrase.get(["customer"])] = (customerService.getModel(booking.customerId) as Customer).email;
      row[phrase.get(["user"])] = (userService.getModel(booking.userId) as User).email;
      output[key] = row;
    }
    return output;
  }

  @ViewChild('details')
  SalonDetailsComponent details;

  @Input('model')
  void set salon(Salon value)
  {
    _salon = value;
    _bufferSalon = (_salon == null) ? null : new Salon.from(_salon);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  Salon _salon, _bufferSalon;
  final BookingService bookingService;
  final CustomerService customerService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
  final PhraseService phrase;
  String selectedBookingId;
  Room newRoomBuffer = new Room()..name = "";

  final StreamController<String> _onSaveController = new StreamController();
}
