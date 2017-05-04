// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show Customer;
import 'package:bokain_admin/components/bo_modal_component/bo_modal_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_add_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_edit_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show CustomerService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customer-list',
    styleUrls: const ['customer_list_component.css'],
    templateUrl: 'customer_list_component.html',
    directives: const [materialDirectives, CustomerAddComponent, CustomerEditComponent, DataTableComponent, BoModalComponent],
    preserveWhitespace: false
)

class CustomerListComponent
{
  CustomerListComponent(this.phrase, this.customerService);

  void onRowClick(String event)
  {
    selectedCustomer = customerService.getModel(event);
    editCustomerVisible = true;
  }

  bool addCustomerVisible = false;
  bool editCustomerVisible = false;
  Customer selectedCustomer;

  final CustomerService customerService;
  final PhraseService phrase;
}
