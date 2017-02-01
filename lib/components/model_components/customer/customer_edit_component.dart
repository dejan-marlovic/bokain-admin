// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Customer;
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/model_service.dart' show CustomerService, UserService;
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
    customer = new Customer.from(customerService.modelMap[customerService.selectedModelId]);
  }

  void ngOnDestroy()
  {
    if (details.form.valid && !customer.isEqual(customerService.modelMap[customerService.selectedModelId]))
    {
      _popupService.title = phrase.get(["information"]);
      _popupService.message = phrase.get(["confirm_save"]);
      _popupService.onConfirm = save;
    }
    customerService.selectedModelId = null;
  }

  void save()
  {
    if (details.form.valid)
    {
      customerService.modelMap[customerService.selectedModelId] = customer;
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
    customer = new Customer.from(customerService.modelMap[customerService.selectedModelId]);
  }

  @ViewChild('customerDetails')
  CustomerDetailsComponent details;

  bool formIsValid = false;
  Customer customer;
  final ConfirmPopupService _popupService;
  final UserService userService;
  final CustomerService customerService;
  final PhraseService phrase;
}
