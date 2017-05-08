// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show BookingService, CustomerService, PhraseService, SalonService, ServiceService, UserService, Booking, Customer, Room, User, Salon;
import 'package:bokain_admin/components/associative_table_component/associative_table_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_details_component.dart';

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
      await salonService.set(_salon.id, _salon);
      _onSaveController.add(_salon.id);
    }
  }

  void cancel()
  {
    if (salon != null) salon = salonService.getModel(salon.id);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  Future createRoom() async
  {
    String id = await salonService.pushRoom(newRoomBuffer);

    _salon.roomIds.add(id);
    await salonService.patchRooms(_salon);
    newRoomBuffer.name = "";
  }

  Future removeRoom(String id) async
  {
    /// TODO disable instead
    _salon.roomIds.remove(id);
    await salonService.patchRooms(_salon);
    await salonService.removeRoom(id);
  }

  Future addUser(String user_id) async
  {
    if (!_salon.userIds.contains(user_id))
    {
      _salon.userIds.add(user_id);
      salonService.patchUsers(_salon);
    }

    User user = userService.getModel(user_id);
    if (user != null && !user.salonIds.contains(_salon.id))
    {
      user.salonIds.add(_salon.id);
      userService.patchSalons(user);
    }
  }

  Future removeUser(String user_id) async
  {
    if (_salon.userIds.contains(user_id))
    {
      _salon.userIds.remove(user_id);
      await salonService.patchUsers(_salon);
    }

    User user = userService.getModel(user_id);
    if (user != null)
    {
      user.salonIds.remove(_salon.id);
      await userService.patchSalons(user);
    }
  }

  Future addRoomService(String room_id, String service_id) async
  {
    salonService.getRoom(room_id).serviceIds.add(service_id);
    await salonService.setRoom(room_id);
  }

  Future removeRoomService(String room_id, String service_id) async
  {
    salonService.getRoom(room_id).serviceIds.remove(service_id);
    await salonService.setRoom(room_id);
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
    _salon = (value == null) ? null : new Salon.from(value);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  Salon _salon;
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
