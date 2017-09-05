// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_calendar/bokain_calendar.dart';
import 'package:bokain_models/bokain_models.dart' show BookingService, CustomerService, Room, Salon, SalonService, ServiceService, User, UserService;
import 'package:bokain_admin/components/associative_table_component/associative_table_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_details_component.dart';
import 'package:bokain_admin/components/status_select_component/status_select_component.dart';

@Component(
    selector: 'bo-salon-edit',
    styleUrls: const ['salon_edit_component.css'],
    templateUrl: 'salon_edit_component.html',
    directives: const
    [
      AssociativeTableComponent,
      BookingDetailsComponent,
      CORE_DIRECTIVES,
      DataTableComponent,
      materialDirectives,
      SalonDetailsComponent,
      StatusSelectComponent,
      UppercaseDirective
    ],
    pipes: const [PhrasePipe]
)

class SalonEditComponent implements OnDestroy
{
  SalonEditComponent(this.bookingService, this.customerService, this.salonService, this.serviceService, this.userService);

  void ngOnDestroy()
  {
    _onSaveController.close();
  }

  Future save() async
  {
    await salonService.set(salon.id, salon);
    _onSaveController.add(salon.id);
  }

  Future cancel() async
  {
    salon = await salonService.fetch(salon.id, force: true);
    salonService.streamedModels[salon.id] = salon;
  }

  Future createRoom() async
  {
    String id = await salonService.pushRoom(newRoomBuffer);

    salon.roomIds.add(id);
    await salonService.patchRooms(salon);
    newRoomBuffer.name = "";
  }

  void onRoomStatusChange(String room_id, String status)
  {
    salonService.getRoom(room_id).status = status;
    salonService.setRoom(room_id);
  }

  Future addUser(String user_id) async
  {
    if (!salon.userIds.contains(user_id))
    {
      salon.userIds.add(user_id);
      salonService.patchUsers(salon);
    }

    User user = userService.get(user_id);
    if (user != null && !user.salonIds.contains(salon.id))
    {
      user.salonIds.add(salon.id);
      userService.patchSalons(user);
    }
  }

  Future removeUser(String user_id) async
  {
    if (salon.userIds.contains(user_id))
    {
      salon.userIds.remove(user_id);
      await salonService.patchUsers(salon);
    }

    User user = userService.get(user_id);
    if (user != null)
    {
      user.salonIds.remove(salon.id);
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

  final BookingService bookingService;
  final CustomerService customerService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
  String selectedBookingId;
  Room newRoomBuffer = new Room(null)..name = "";
  final StreamController<String> _onSaveController = new StreamController();

  @Input('model')
  Salon salon;

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;
}
