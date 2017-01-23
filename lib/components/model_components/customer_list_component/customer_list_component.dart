// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of model_list_component;

@Component(
    selector: 'bo-customer-list',
    styleUrls: const ['../model_list_component/model_list_component.css', '../customer_list_component/customer_list_component.css'],
    templateUrl: '../customer_list_component/customer_list_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives],
    pipes: const [],
    preserveWhitespace: false
)

class CustomerListComponent extends ModelListComponent
{
  CustomerListComponent(PhraseService phrase, CustomerService customer_service, this._userService)
  : super(phrase, customer_service)
  {
  }

  Map<String, Customer> get customerMap => (modelService.modelMap as Map<String, Customer>);

  UserService get userService => _userService;

  final UserService _userService;
}
