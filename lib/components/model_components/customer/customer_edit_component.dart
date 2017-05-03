// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Salon, User;
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, CustomerService, SalonService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customer-edit',
    styleUrls: const ['customer_edit_component.css'],
    templateUrl: 'customer_edit_component.html',
    directives: const [materialDirectives, BookingDetailsComponent, CustomerDetailsComponent, DataTableComponent],
    preserveWhitespace: false
)

class CustomerEditComponent implements OnDestroy
{
  CustomerEditComponent(this.phrase, this.bookingService, this._popupService, this.salonService, this.userService, this.customerService)
  {
    _bufferCustomer = new Customer.from(customerService.selectedModel);
  }

  void ngOnDestroy()
  {
    if (details.form.valid && !_bufferCustomer.isEqual(customerService.selectedModel))
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
      //String previousBelongsTo = _bufferCustomer.belongsTo;
      _bufferCustomer = new Customer.from(customerService.selectedModel);
      customerService.set(selectedCustomer.id, selectedCustomer);

      /*
      // Update user -> customerIds
      if (previousBelongsTo != _bufferCustomer.belongsTo)
      {
        User previousUser = userService.getModel(previousBelongsTo);
        User currentUser = userService.getModel(_bufferCustomer.belongsTo);

        if (previousUser != null)
        {
          previousUser.customerIds.remove(customerService.selectedModel.id);
          userService.set(previousBelongsTo, previousUser);
        }
        if (currentUser != null)
        {
          currentUser.customerIds.add(customerService.selectedModel.id);
          userService.set(_bufferCustomer.belongsTo, currentUser);
        }
      }*/
    }
    else
    {
      _popupService.title = phrase.get(["error_occured"]);
      _popupService.message = phrase.get(["_could_not_save_model"], params: {"model":phrase.get(["customer"]).toLowerCase()});
    }
  }

  void cancel()
  {
    customerService.selectedModel = new Customer.from(_bufferCustomer);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  Map<String, Map<String, String>> get customerBookings
  {
    Map<String, Map<String, String>> bookingData = bookingService.getRows(selectedCustomer.bookingIds, true);
    Map<String, Map<String, String>> output = new Map();
    for (String key in bookingData.keys)
    {
      Booking booking = bookingService.getModel(key);
      Map<String, String> row = new Map();
      row[phrase.get(["start_time"])] = booking.strStartTime;
      row[phrase.get(["duration_minutes"])] = booking.duration.inMinutes.toString();
      row[phrase.get(["user"])] = (userService.getModel(booking.userId) as User).email;
      row[phrase.get(["salon"])] = (salonService.getModel(booking.salonId) as Salon).name;
      output[key] = row;
    }
    return output;
  }

  void updateBufferCustomer()
  {
    _bufferCustomer = new Customer.from(selectedCustomer);
  }

  Customer get selectedCustomer => customerService.selectedModel;

  @ViewChild('details')
  CustomerDetailsComponent details;

  Customer _bufferCustomer;
  String selectedBookingId;
  final BookingService bookingService;
  final ConfirmPopupService _popupService;
  final UserService userService;
  final SalonService salonService;
  final CustomerService customerService;
  final PhraseService phrase;
}
