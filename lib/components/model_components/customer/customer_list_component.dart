// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library customer_list_component;

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Customer;
import 'package:bokain_admin/services/model_service.dart' show CustomerService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customer-list',
    styleUrls: const ['../customer_list_component/customer_list_component.css'],
    templateUrl: '../customer_list_component/customer_list_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives],
    preserveWhitespace: false
)

class CustomerListComponent
{
  CustomerListComponent(this.phrase, this._customerService)
  {
  }

  Map<String, Customer> get customerMap => _customerService.modelMap;

  final CustomerService _customerService;
  final PhraseService phrase;


}
