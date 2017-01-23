// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of model_add_component;

@Component(
    selector: 'bo-customer-add',
    styleUrls: const ['../model_add_component/model_add_component.css', '../customer_add_component/customer_add_component.css'],
    templateUrl: '../customer_add_component/customer_add_component.html',
    directives: const [FORM_DIRECTIVES, materialDirectives],
    preserveWhitespace: false
)

class CustomerAddComponent extends ModelAddComponent
{
  CustomerAddComponent(PhraseService phrase, CustomerService customer_service, FormBuilder form_builder, Router router)
  : super(phrase, customer_service, form_builder, router)
  {
    form = _formBuilder.group(Customer.controlsConfig);

    _customer.firstname = "bill";
    _customer.lastname = "bauer";
    _customer.email = "patrick.minogue@gmail.com";
    _customer.street = "testgatan 1";
    _customer.postalCode = "12345";
    _customer.city = "stockholm";
    _customer.socialNumber = "201202047491";
    _customer.phone = "0709123456";

    _customer.country = "sv";
    _customer.skinType = "acne";
    _customer.status = "active";
  }

  Future pushIfValid() async
  {
    if (await validateUniqueFields(customer) == true)
    {
      await modelService.push(customer);
      router.navigate(['CustomerList']);
    }
  }

  Customer get customer => _customer;

  final Customer _customer = new Customer();
}
