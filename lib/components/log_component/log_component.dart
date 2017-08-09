// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:bokain_models/bokain_models.dart' show PhrasePipe;

@Component(
    selector: 'bo-log',
    styleUrls: const ['log_component.css'],
    templateUrl: 'log_component.html',
    pipes: const [PhrasePipe]
)

class LogComponent
{
  LogComponent()
  {
  }
}
