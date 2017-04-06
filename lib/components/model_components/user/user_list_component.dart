// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show User;
import 'package:bokain_admin/services/model/model_service.dart' show UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-user-list',
    styleUrls: const ['user_list_component.css'],
    templateUrl: 'user_list_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives, DataTableComponent],
    preserveWhitespace: false
)

class UserListComponent
{
  UserListComponent(this._router, this.phrase, this.userService);

  void onRowClick(String event)
  {
    userService.selectedModelId = event;
    _router.navigate(['UserEdit']);
  }

  final Router _router;
  final UserService userService;
  final PhraseService phrase;
}
