// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model_service.dart' show UserService;

@Component(
    selector: 'bo-dashboard',
    styleUrls: const ['dashboard_component.css'],
    templateUrl: 'dashboard_component.html',
    directives: const [],
    preserveWhitespace: false
)

class DashboardComponent
{
  DashboardComponent(this.phrase, this.userService)
  {

  }

  final PhraseService phrase;
  final UserService userService;
}
