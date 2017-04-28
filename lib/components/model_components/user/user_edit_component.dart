// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Salon, User;
import 'package:bokain_admin/components/associative_table_component/associated_table_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/user/user_details_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, CustomerService, SalonService, ServiceService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-user-edit',
    styleUrls: const ['user_edit_component.css'],
    templateUrl: 'user_edit_component.html',
    directives: const [materialDirectives, AssociativeTableComponent, BookingDetailsComponent, DataTableComponent, UserDetailsComponent],
    preserveWhitespace: false
)

class UserEditComponent implements OnDestroy
{
  UserEditComponent(this.phrase, this.bookingService, this.customerService, this.salonService, this.serviceService, this._popupService, this.userService)
  {
    _bufferUser = new User.from(userService.selectedModel);

    //_bufferUser.bookingIds;
  }

  void ngOnDestroy()
  {
    if (details.form.valid && !_bufferUser.isEqual(userService.selectedModel))
    {
      _popupService.title = phrase.get(["information"]);
      _popupService.message = phrase.get(["confirm_save"]);
      _popupService.onConfirm = save;
      _popupService.onCancel = cancel;
    }
  }

  void save()
  {
    if (details.form.valid)
    {
      _bufferUser = new User.from(selectedUser);
      userService.selectedSet();
    }
    else
    {
      _popupService.title = phrase.get(["error_occured"]);
      _popupService.message = phrase.get(["_could_not_save_model"], params: {"model":phrase.get(["user"]).toLowerCase()});
    }
  }

  void cancel()
  {
    userService.selectedModel = new User.from(_bufferUser);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  void addCustomer(String id)
  {
    selectedUser.customerIds.add(id);
    _bufferUser = new User.from(selectedUser);
    userService.patchCustomers(userService.selectedModelId, selectedUser.customerIds);

    // One-to-many relation (one user per customer)
    Customer customer = customerService.getModel(id);
    customer.belongsTo = userService.selectedModelId;
    customerService.set(id, customer);
  }

  void removeCustomer(String id)
  {
    selectedUser.customerIds.remove(id);
    _bufferUser = new User.from(selectedUser);
    userService.patchCustomers(userService.selectedModelId, selectedUser.customerIds);

    // One-to-many relation (one user per customer)
    Customer customer = customerService.getModel(id);
    customer.belongsTo = null;
    customerService.set(id, customer);
  }

  void addSalon(String id)
  {
    selectedUser.salonIds.add(id);
    _bufferUser = new User.from(selectedUser);
    userService.patchSalons(userService.selectedModelId, selectedUser.salonIds);

    Salon salon = salonService.getModel(id);
    if (!salon.userIds.contains(userService.selectedModelId)) salon.userIds.add(userService.selectedModelId);
    salonService.patchUsers(id, salon.userIds);
  }

  void removeSalon(String id)
  {
    selectedUser.salonIds.remove(id);
    _bufferUser = new User.from(selectedUser);
    userService.patchSalons(userService.selectedModelId, selectedUser.salonIds);

    Salon salon = salonService.getModel(id);
    salon.userIds.remove(userService.selectedModelId);
    salonService.patchUsers(id, salon.userIds);
  }

  void addService(String id)
  {
    selectedUser.serviceIds.add(id);
    _bufferUser = new User.from(selectedUser);
    userService.patchServices(userService.selectedModelId, selectedUser.serviceIds);

    /// TODO patch service users too
  }

  void removeService(String id)
  {
    selectedUser.serviceIds.remove(id);
    _bufferUser = new User.from(selectedUser);
    userService.patchServices(userService.selectedModelId, selectedUser.serviceIds);

    /// TODO patch service users too
  }

  void updateBufferUser()
  {
    _bufferUser = new User.from(selectedUser);
  }

  @ViewChild('details')
  UserDetailsComponent details;

  Map<String, Map<String, String>> get userBookings
  {
    Map<String, Map<String, String>> bookingData = bookingService.getRows(selectedUser.bookingIds, true);
    Map<String, Map<String, String>> output = new Map();
    for (String key in bookingData.keys)
    {
      Booking booking = bookingService.getModel(key);
      Map<String, String> row = new Map();
      row[phrase.get(["start_time"])] = booking.strStartTime;
      row[phrase.get(["duration_minutes"])] = booking.duration.inMinutes.toString();
      row[phrase.get(["customer"])] = (customerService.getModel(booking.customerId) as Customer).email;
      row[phrase.get(["salon"])] = (salonService.getModel(booking.salonId) as Salon).name;
      output[key] = row;
    }
    return output;
  }

  User get selectedUser => userService.selectedModel;

  User _bufferUser;

  String selectedBookingId;

  final BookingService bookingService;
  final CustomerService customerService;
  final SalonService salonService;
  final ServiceService serviceService;
  final ConfirmPopupService _popupService;
  final UserService userService;
  final PhraseService phrase;
}
