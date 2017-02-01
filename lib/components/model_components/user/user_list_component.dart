// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show User;
import 'package:bokain_admin/services/model_service.dart' show UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-user-list',
    styleUrls: const ['user_list_component.css'],
    templateUrl: 'user_list_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives],
    preserveWhitespace: false
)

class UserListComponent
{
  UserListComponent(this.phrase, this.userService)
  {
  }

  final UserService userService;
  final PhraseService phrase;
}
