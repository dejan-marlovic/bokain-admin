// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bokain_models/bokain_models.dart' show Increment, UserState;

@Component(
    selector: 'bo-increment',
    styleUrls: const ['increment_component.css'],
    templateUrl: 'increment_component.html',
    directives: const [],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.Default
)
class IncrementComponent
{
  IncrementComponent();

  UserState get userState => increment.userStates[userId];

  @Input('increment')
  Increment increment;

  @Input('highlight')
  bool highlight = false;

  @Input('userId')
  String userId;

}