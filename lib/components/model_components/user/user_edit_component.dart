// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of edit_component_base;

@Component(
    selector: 'bo-user-edit',
    styleUrls: const ['../user/user_edit_component.css'],
    templateUrl: '../user/user_edit_component.html',
    directives: const [AssociativeTableComponent, BookingDetailsComponent, CORE_DIRECTIVES, DataTableComponent, FoImageFileComponent, materialDirectives, UserDetailsComponent],
    pipes: const [PhrasePipe]
)

class UserEditComponent extends EditComponentBase<User>
{
  UserEditComponent(
      this.bookingService,
      this.customerService,
      this.salonService,
      this.serviceService,
      UserService user_service,
      OutputService output_service) : super(user_service, output_service);

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
    customerService.set(customer);
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

  void removeCustomer(String id)
  {
    user.customerIds.remove(id);
    userService.patchCustomers(user);

    // One-to-many relation (one user / customer)
    Customer customer = customerService.get(id);
    customer.belongsTo = null;
    customerService.set(customer);
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

  UserService get userService => _service;
  User get user => model;

  String selectedBookingId;
  final BookingService bookingService;
  final CustomerService customerService;
  final SalonService salonService;
  final ServiceService serviceService;
}
