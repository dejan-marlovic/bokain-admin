// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_calendar/bokain_calendar.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/associative_table_component/associative_table_component.dart';
import 'package:bokain_admin/components/model_components/user/user_details_component.dart';

@Component(
    selector: 'bo-user-edit',
    styleUrls: const ['user_edit_component.css'],
    templateUrl: 'user_edit_component.html',
    directives: const [AssociativeTableComponent, BookingDetailsComponent, CORE_DIRECTIVES, DataTableComponent, FoImageFileComponent, materialDirectives, UserDetailsComponent],
    pipes: const [PhrasePipe]
)

class UserEditComponent implements OnDestroy
{
  UserEditComponent(this.bookingService, this.customerService, this.salonService, this.serviceService, this.userService);

  void ngOnDestroy()
  {
    _onSaveController.close();
  }

  Future save() async
  {
      await userService.set(user.id, user);
      _onSaveController.add(user.id);
  }

  Future cancel() async
  {
    user = await userService.fetch(user.id, force: true);
    userService.streamedModels[user.id] = user;
  }

  void addCustomer(String id)
  {
    if (!user.customerIds.contains(id))
    {
      user.customerIds.add(id);
      userService.patchCustomers(user);
    }

    // One-to-many relation (one user / customer)
    Customer customer = customerService.get(id);
    customer.belongsTo = user.id;
    customerService.set(id, customer);
  }

  void removeCustomer(String id)
  {
    user.customerIds.remove(id);
    userService.patchCustomers(user);

    // One-to-many relation (one user / customer)
    Customer customer = customerService.get(id);
    customer.belongsTo = null;
    customerService.set(id, customer);
  }

  void addSalon(String id)
  {
    if (!user.salonIds.contains(id))
    {
      user.salonIds.add(id);
      userService.patchSalons(user);
    }

    // Many <--> Many
    Salon salon = salonService.get(id);
    if (salon != null && !salon.userIds.contains(user.id))
    {
      salon.userIds.add(user.id);
      salonService.patchUsers(salon);
    }
  }

  void removeSalon(String id)
  {
    user.salonIds.remove(id);
    userService.patchSalons(user);

    Salon salon = salonService.get(id);
    if (salon != null)
    {
      salon.userIds.remove(user.id);
      salonService.patchUsers(salon);
    }
  }

  void addService(String id)
  {
    if (!user.serviceIds.contains(id))
    {
      user.serviceIds.add(id);
      userService.patchServices(user);
    }

    Service service = serviceService.get(id);
    if (service != null && !service.userIds.contains(user.id))
    {
      service.userIds.add(user.id);
      serviceService.patchUsers(service);
    }
  }

  void removeService(String id)
  {
    user.serviceIds.remove(id);
    userService.patchServices(user);

    Service service = serviceService.get(id);
    if (service != null)
    {
      service.userIds.remove(user.id);
      serviceService.patchUsers(service);
    }
  }

  String selectedBookingId;
  final BookingService bookingService;
  final CustomerService customerService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
  final StreamController<String> _onSaveController = new StreamController();

  @Input('user')
  User user;

  @Output('save')
  Stream<String> get onSaveOutput => _onSaveController.stream;
}
