// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/user/user_add_component.dart';
import 'package:bokain_admin/components/model_components/user/user_edit_component.dart';

@Component(
    selector: 'bo-user-list',
    styleUrls: const ['user_list_component.css'],
    templateUrl: 'user_list_component.html',
    directives: const [CORE_DIRECTIVES, DataTableComponent, FoModalComponent, materialDirectives, UserAddComponent, UserEditComponent],
    pipes: const [PhrasePipe]
)

class UserListComponent
{
  UserListComponent(this.userService);

  void openUser(String event)
  {
    selectedUser = userService.getModel(event);
    editUserVisible = true;
  }

  User selectedUser;
  bool addUserVisible = false;
  bool editUserVisible = false;

  final UserService userService;
}
