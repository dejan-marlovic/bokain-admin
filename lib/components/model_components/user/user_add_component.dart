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
    user = new User(null);
    user.status = "active";
    user.bookingRank = 0;
  }

  void ngOnDestroy()
  {
    _onPushController.close();
  }

  Future push() async
  {
    try
    {
      String id = await userService.push(user);
      _onPushController.add(id);
    } catch(e)
    {
      errorMessage = e.toString();
      errorModal = true;
      _onPushController.add(null);
    }
    user = new User(null);
    user.status = "active";
    user.bookingRank = 0;
  }

  @Output('push')
  Stream<String> get onPush => _onPushController.stream;

  User user;

  bool errorModal = false;
  String errorMessage;
  final UserService userService;
  final StreamController _onPushController = new StreamController();
}
