// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show UserService, PhraseService, User;
import 'package:bokain_admin/components/model_components/user/user_details_component.dart';

@Component(
    selector: 'bo-user-add',
    styleUrls: const ['user_add_component.css'],
    templateUrl: 'user_add_component.html',
    directives: const [FORM_DIRECTIVES, UserDetailsComponent, materialDirectives],
    preserveWhitespace: false
)
class UserAddComponent implements OnDestroy
{
  UserAddComponent(this.phrase, this.userService)
  {
    user = new User();
    user.status = "active";
    user.bookingRank = 0;
  }

  void ngOnDestroy()
  {
    _onPushController.close();
  }

  Future push() async
  {
    String id = await userService.push(user);
    _onPushController.add(id);
  }

  @Output('push')
  Stream<String> get onPush => _onPushController.stream;

  User user;
  final UserService userService;
  final PhraseService phrase;
  final StreamController _onPushController = new StreamController();
}
