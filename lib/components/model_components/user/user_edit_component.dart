// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/components/model_components/customer/customer_details_component.dart';
import 'package:bokain_admin/services/model_service.dart' show UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-user-edit',
    styleUrls: const ['user_edit_component.css'],
    templateUrl: 'user_edit_component.html',
    directives: const [materialDirectives, CustomerDetailsComponent],
    viewBindings: const [],
    preserveWhitespace: false
)

class UserEditComponent
{
  UserEditComponent(this.phrase, this.userService);

  final UserService userService;
  final PhraseService phrase;

}
