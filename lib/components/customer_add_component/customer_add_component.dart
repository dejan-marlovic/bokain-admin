// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of model_add_component;

@Component(
    selector: 'bo-customer-add',
    styleUrls: const ['../customer_add_component/customer_add_component.css'],
    templateUrl: '../customer_add_component/customer_add_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives],
    preserveWhitespace: false
)

class CustomerAddComponent extends ModelAddComponent
{
  CustomerAddComponent(PhraseService phrase, CustomerService customer_service) : super(phrase, customer_service)
  {
  }

  //List<Customer> get customers => (modelService.models as List<Customer>);
}
