// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show UserService, PhraseService, User;
import 'package:bokain_admin/components/model_components/user/user_add_component.dart';
import 'package:bokain_admin/components/model_components/user/user_edit_component.dart';
import 'package:bokain_admin/components/bo_modal_component/bo_modal_component.dart';

@Component(
    selector: 'bo-user-list',
    styleUrls: const ['user_list_component.css'],
    templateUrl: 'user_list_component.html',
    directives: const [materialDirectives, BoModalComponent, DataTableComponent, UserAddComponent, UserEditComponent],
    preserveWhitespace: false
)

class UserListComponent
{
  UserListComponent(this.phrase, this.userService);

  void onRowClick(String event)
  {
    selectedUser = userService.getModel(event);
    editUserVisible = true;
  }

  User selectedUser;
  bool addUserVisible = false;
  bool editUserVisible = false;

  final UserService userService;
  final PhraseService phrase;
}
