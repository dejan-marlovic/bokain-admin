// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Salon, Service, User;
import 'package:bokain_admin/components/associative_table_component/associated_table_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/user/user_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, CustomerService, SalonService, ServiceService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

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
      _bufferUser = new User.from(_user);
      String id = await userService.set(_user.id, _user);
      _onSaveController.add(id);
    }
  }

  void cancel()
  {
    _user = new User.from(_bufferUser);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  void addCustomer(String id)
  {
    _user.customerIds.add(id);
    _bufferUser = new User.from(_user);
    userService.patchCustomers(_user.id, _user.customerIds);

    // One-to-many relation (one user per customer)
    Customer customer = customerService.getModel(id);
    customer.belongsTo = _user.id;
    customerService.set(id, customer);
  }

  void removeCustomer(String id)
  {
    _user.customerIds.remove(id);
    _bufferUser = new User.from(_user);
    userService.patchCustomers(_user.id, _user.customerIds);

    // One-to-many relation (one user per customer)
    Customer customer = customerService.getModel(id);
    customer.belongsTo = null;
    customerService.set(id, customer);
  }

  void addSalon(String id)
  {
    _user.salonIds.add(id);
    _bufferUser = new User.from(_user);
    userService.patchSalons(_user.id, _user.salonIds);

    Salon salon = salonService.getModel(id);
    if (!salon.userIds.contains(_user.id)) salon.userIds.add(_user.id);
    salonService.patchUsers(salon.id, salon.userIds);
  }

  void removeSalon(String id)
  {
    _user.salonIds.remove(id);
    _bufferUser = new User.from(_user);
    userService.patchSalons(_user.id, _user.salonIds);

    Salon salon = salonService.getModel(id);
    salon.userIds.remove(_user.id);
    salonService.patchUsers(salon.id, salon.userIds);
  }

  void addService(String id)
  {
    _user.serviceIds.add(id);
    _bufferUser = new User.from(_user);
    userService.patchServices(_user.id, _user.serviceIds);

    Service service = serviceService.getModel(id);
    if (service != null && !service.userIds.contains(_user.id))
    {
      service.userIds.add(_user.id);
      serviceService.patchUsers(service.id, service.userIds);
    }
  }

  void removeService(String id)
  {
    _user.serviceIds.remove(id);
    _bufferUser = new User.from(_user);
    userService.patchServices(_user.id, _user.serviceIds);
    Service service = serviceService.getModel(id);
    if (service != null)
    {
      service.userIds.remove(_user.id);
      serviceService.patchUsers(service.id, service.userIds);
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
    _user = value;
    _bufferUser = (_user == null) ? null : new User.from(_user);
  }

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;

  @ViewChild('details')
  UserDetailsComponent details;

  User _user, _bufferUser;
  String selectedBookingId;

  final BookingService bookingService;
  final CustomerService customerService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
  final PhraseService phrase;
  final StreamController<String> _onSaveController = new StreamController();
}
