// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of edit_component_base;

@Component(
    selector: 'bo-salon-edit',
    styleUrls: const ['../salon/salon_edit_component.css'],
    templateUrl: '../salon/salon_edit_component.html',
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

class SalonEditComponent extends EditComponentBase<Salon>
{
  SalonEditComponent(
      this.bookingService,
      this.customerService,
      OutputService output_service,
      SalonService salon_service,
      this.serviceService,
      this.userService) : super(salon_service, output_service);

  Future createRoom() async
  {
    try
    {
      String id = await salonService.pushRoom(newRoomBuffer);
      salon.roomIds.add(id);
      await salonService.patchRooms(salon);
    }
    catch (e)
    {
      _outputService.set(e.toString());
    }
    finally
    {
      newRoomBuffer.name = "";
    }
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

  SalonService get salonService => _service;
  Salon get salon => model;

  final BookingService bookingService;
  final CustomerService customerService;
  final ServiceService serviceService;
  final UserService userService;
  String selectedBookingId;
  Room newRoomBuffer = new Room(null)..name = "";
}
