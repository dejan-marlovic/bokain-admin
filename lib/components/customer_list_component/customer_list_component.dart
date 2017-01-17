// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of model_list_component;

@Component(
    selector: 'bo-customer-list',
    styleUrls: const ['../customer_list_component/customer_list_component.css'],
    templateUrl: '../customer_list_component/customer_list_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives],
    preserveWhitespace: false
)

class CustomerListComponent extends ModelListComponent
{
  CustomerListComponent(PhraseService phrase, CustomerService customer_service) : super(phrase, customer_service)
  {
  }

  List<Customer> get customers => (modelService.models as List<Customer>);
}
