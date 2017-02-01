// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-confirm',
    styleUrls: const ['confirm_popup_component.css'],
    templateUrl: 'confirm_popup_component.html',
    directives: const [materialDirectives],
    preserveWhitespace: false
)
class ConfirmPopupComponent
{
  ConfirmPopupComponent(this.confirmPopupService, this.phrase)
  {

  }

  final ConfirmPopupService confirmPopupService;
  final PhraseService phrase;
}
