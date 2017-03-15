// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show User;
import 'package:bokain_admin/components/model_components/user/user_details_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show CustomerService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-user-edit',
    styleUrls: const ['user_edit_component.css'],
    templateUrl: 'user_edit_component.html',
    directives: const [materialDirectives, DataTableComponent, UserDetailsComponent],
    viewBindings: const [],
    preserveWhitespace: false
)

class UserEditComponent implements OnDestroy
{
  UserEditComponent(this.phrase, this.customerService, this._popupService, this.userService)
  {
    bufferUser = new User.from(userService.selectedModel);
  }

  void ngOnDestroy()
  {
    if (details.form.valid && !bufferUser.isEqual(userService.selectedModel))
    {
      _popupService.title = phrase.get(["information"]);
      _popupService.message = phrase.get(["confirm_save"]);
      _popupService.onConfirm = save;
      _popupService.onCancel = cancel;
    }
  }

  void save()
  {
    if (details.form.valid)
    {
      bufferUser = new User.from(userService.selectedModel);
      userService.set();
    }
    else
    {
      _popupService.title = phrase.get(["error_occured"]);
      _popupService.message = phrase.get(["_could_not_save_model"], params: {"model":phrase.get(["user"]).toLowerCase()});
    }
  }

  void cancel()
  {
    userService.selectedModel = new User.from(bufferUser);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  @ViewChild('details')
  UserDetailsComponent details;

  User bufferUser;
  final CustomerService customerService;
  final ConfirmPopupService _popupService;
  final UserService userService;
  final PhraseService phrase;
}
