// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Customer;
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/editable_model_service.dart' show CustomerService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customer-edit',
    styleUrls: const ['customer_edit_component.css'],
    templateUrl: 'customer_edit_component.html',
    directives: const [materialDirectives, CustomerDetailsComponent],
    viewBindings: const [],
    preserveWhitespace: false
)

class CustomerEditComponent implements OnDestroy
{
  CustomerEditComponent(this.phrase, this._popupService, this.userService, this.customerService)
  {
    bufferCustomer = new Customer.from(customerService.selectedModel);
  }

  void ngOnDestroy()
  {
    if (details.form.valid && !bufferCustomer.isEqual(customerService.selectedModel))
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
      bufferCustomer = new Customer.from(customerService.selectedModel);
      customerService.set();
    }
    else
    {
      _popupService.title = phrase.get(["error_occured"]);
      _popupService.message = phrase.get(["_could_not_save_model"], params: {"model":phrase.get(["customer"]).toLowerCase()});
    }
  }

  void cancel()
  {
    customerService.selectedModel = new Customer.from(bufferCustomer);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  @ViewChild('customerDetails')
  CustomerDetailsComponent details;

  Customer bufferCustomer;
  final ConfirmPopupService _popupService;
  final UserService userService;
  final CustomerService customerService;
  final PhraseService phrase;
}
