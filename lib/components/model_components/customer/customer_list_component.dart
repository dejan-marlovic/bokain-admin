// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of list_component_base;

@Component(
    selector: 'bo-customer-list',
    styleUrls: const ['../customer/customer_list_component.css'],
    templateUrl: '../customer/customer_list_component.html',
    directives: const [CORE_DIRECTIVES, CustomerAddComponent, CustomerEditComponent, DataTableComponent, FoModalComponent, materialDirectives],
    pipes: const [PhrasePipe],
    providers: const []
)
class CustomerListComponent extends ListComponentBase
{
  CustomerListComponent(CustomerService service) : super(service);
}