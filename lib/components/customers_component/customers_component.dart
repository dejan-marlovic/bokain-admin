// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of model_list_component;

@Component(
    selector: 'bo-customers',
    styleUrls: const ['../customers_component/customers_component.css'],
    templateUrl: '../customers_component/customers_component.html',
    directives: const [materialDirectives],
    preserveWhitespace: false
)

class CustomersComponent extends ModelListComponent
{
  CustomersComponent(PhraseService phrase, CustomerService customer_service) : super(phrase, customer_service)
  {
    new Timer(const Duration(seconds:2), ()
    {
      modelService.remove("abc123");
    });
  }

  List<Customer> get customers => (modelService.models as List<Customer>);
}
