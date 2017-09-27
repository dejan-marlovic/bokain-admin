// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
    selector: 'bo-customer-add',
    styleUrls: const ['../customer/customer_add_component.css'],
    templateUrl: '../customer/customer_add_component.html',
    directives: const [CORE_DIRECTIVES, CustomerDetailsComponent, materialDirectives],
    providers: const [CustomerAuthService],
    pipes: const [PhrasePipe],
)
class CustomerAddComponent extends AddComponentBase implements OnDestroy
{
  CustomerAddComponent(CustomerService customer_service, this._customerAuthService, OutputService output_service) : super(customer_service, output_service);

  Future push() async
  {
    try
    {
      /**
       * This will throw on unique constraint fail
       */
      String id = await customerService.push(customer);

      /*String token = */ await _customerAuthService.register(customer.email);

      model = new Customer();
      _onAddController.add(id);
    }
    catch (e)
    {
      _outputService.set(e.toString());
      _onAddController.add(null);
    }
  }

  Customer get customer => model;
  CustomerService get customerService => _service;

  final CustomerAuthService _customerAuthService;
}
