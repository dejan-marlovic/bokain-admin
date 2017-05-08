// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show BookingService, CustomerService, SalonService, ServiceService, UserService, PhraseService, Booking, Customer, Salon, Service, User;
import 'package:bokain_admin/components/associative_table_component/associative_table_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/user/user_details_component.dart';

@Component(
    selector: 'bo-user-edit',
    styleUrls: const ['user_edit_component.css'],
    templateUrl: 'user_edit_component.html',
    directives: const [materialDirectives, AssociativeTableComponent, BookingDetailsComponent, DataTableComponent, UserDetailsComponent],
    preserveWhitespace: false
)

class UserEditComponent
{
  UserEditComponent(this.phrase, this.bookingService, this.customerService, this.salonService, this.serviceService, this.userService);

  Future save() async
  {
    if (details.form.valid)
    {
      await userService.set(_user.id, _user);
      _onSaveController.add(_user.id);
    }
  }

  void cancel()
  {
    if (user != null) user = userService.getModel(user.id);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  void addCustomer(String id)
  {
    if (!_user.customerIds.contains(id))
    {
      _user.customerIds.add(id);
      userService.patchCustomers(_user);
    }

    // One-to-many relation (one user / customer)
    Customer customer = customerService.getModel(id);
    customer.belongsTo = _user.id;
    customerService.set(id, customer);
  }

  void removeCustomer(String id)
  {
    _user.customerIds.remove(id);
    userService.patchCustomers(_user);

    // One-to-many relation (one user / customer)
    Customer customer = customerService.getModel(id);
    customer.belongsTo = null;
    customerService.set(id, customer);
  }

  void addSalon(String id)
  {
    if (!_user.salonIds.contains(id))
    {
      _user.salonIds.add(id);
      userService.patchSalons(_user);
    }

    // Many <--> Many
    Salon salon = salonService.getModel(id);
    if (salon != null && !salon.userIds.contains(_user.id))
    {
      salon.userIds.add(_user.id);
      salonService.patchUsers(salon);
    }
  }

  void removeSalon(String id)
  {
    _user.salonIds.remove(id);
    userService.patchSalons(_user);

    Salon salon = salonService.getModel(id);
    if (salon != null)
    {
      salon.userIds.remove(_user.id);
      salonService.patchUsers(salon);
    }
  }

  void addService(String id)
  {
    if (!_user.serviceIds.contains(id))
    {
      _user.serviceIds.add(id);
      userService.patchServices(_user);
    }

    Service service = serviceService.getModel(id);
    if (service != null && !service.userIds.contains(_user.id))
    {
      service.userIds.add(_user.id);
      serviceService.patchUsers(service);
    }
  }

  void removeService(String id)
  {
    _user.serviceIds.remove(id);
    userService.patchServices(_user);

    Service service = serviceService.getModel(id);
    if (service != null)
    {
      service.userIds.remove(_user.id);
      serviceService.patchUsers(service);
    }
  }

  User get user => _user;

  Map<String, Map<String, String>> get userBookings
  {
    List<Booking> bookings = bookingService.getModelObjects(ids: _user.bookingIds);
    Map<String, Map<String, String>> output = new Map();
    for (Booking booking in bookings)
    {
      Map<String, String> row = new Map();
      row[phrase.get(["start_time"])] = booking.strStartTime;
      row[phrase.get(["duration_minutes"])] = booking.duration.inMinutes.toString();
      row[phrase.get(["customer"])] = (customerService.getModel(booking.customerId) as Customer).email;
      row[phrase.get(["salon"])] = (salonService.getModel(booking.salonId) as Salon).name;
      output[booking.id] = row;
    }
    return output;
  }

  @Input('model')
  void set user(User value)
  {
    _user = (value == null) ? null : new User.from(value);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  @ViewChild('details')
  UserDetailsComponent details;

  User _user;
  String selectedBookingId;

  final BookingService bookingService;
  final CustomerService customerService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
  final PhraseService phrase;
  final StreamController<String> _onSaveController = new StreamController();
}
