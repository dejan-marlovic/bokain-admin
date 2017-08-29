// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/customer/customer_add_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_edit_component.dart';

@Component(
    selector: 'bo-customer-list',
    styleUrls: const ['customer_list_component.css'],
    templateUrl: 'customer_list_component.html',
    directives: const [CORE_DIRECTIVES, CustomerAddComponent, CustomerEditComponent, DataTableComponent, FoModalComponent, materialDirectives],
    pipes: const [PhrasePipe]
)

class CustomerListComponent
{
  CustomerListComponent(this.customerService);

  void openCustomer(String event)
  {
    selectedCustomer = customerService.getModel(event);
    editCustomerVisible = true;
  }

  bool addCustomerVisible = false;
  bool editCustomerVisible = false;
  Customer selectedCustomer;

  final CustomerService customerService;
}
