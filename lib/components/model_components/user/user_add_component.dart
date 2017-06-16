// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart' show UserService, User;
import 'package:bokain_admin/components/model_components/user/user_details_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-user-add',
    styleUrls: const ['user_add_component.css'],
    templateUrl: 'user_add_component.html',
    directives: const [FORM_DIRECTIVES, FoModalComponent, UserDetailsComponent, materialDirectives],
    pipes: const [PhrasePipe]
)
class UserAddComponent implements OnDestroy
{
  UserAddComponent(this.userService)
  {
    _user = new User(null);
  }

  void ngOnDestroy()
  {
    _onAddController.close();
  }

  Future push() async
  {
    try
    {
      _onAddController.add(await userService.push(_user));
      _user = new User();
    }
    catch(e)
    {
      errorMessage = e.toString();
      errorModal = true;
      _onAddController.add(null);
    }
  }
  
  User get user => _user;

  User _user;
  bool errorModal = false;
  String errorMessage;
  final UserService userService;
  final StreamController _onAddController = new StreamController();

  @Output('add')
  Stream<String> get onAddOutput => _onAddController.stream;
}
