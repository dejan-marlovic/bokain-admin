// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';
import 'package:bokain_admin/services/model_service.dart' show CustomerService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customer-edit',
    styleUrls: const ['../model_edit_component/model_edit_component.css', '../customer_edit_component/customer_edit_component.css'],
    templateUrl: '../customer_edit_component/customer_edit_component.html',
    directives: const [materialDirectives, CustomerDetailsComponent],
    viewBindings: const [],
    preserveWhitespace: false
)

class CustomerEditComponent
{
  CustomerEditComponent(this.phrase, this.userService, this.customerService)
  {

  }

  final UserService userService;
  final CustomerService customerService;
  final PhraseService phrase;

}
