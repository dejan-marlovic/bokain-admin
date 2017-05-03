// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show ServiceAddon;
import 'package:bokain_admin/components/model_components/service_addon/service_addon_details_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show ServiceAddonService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-addon-edit',
    styleUrls: const ['service_addon_edit_component.css'],
    templateUrl: 'service_addon_edit_component.html',
    directives: const [materialDirectives, ServiceAddonDetailsComponent],
    preserveWhitespace: false
)

class ServiceAddonEditComponent implements OnDestroy
{
  ServiceAddonEditComponent(this.phrase, this._popupService, this.service)
  {
    buffer = new ServiceAddon.from(selectedServiceAddon);
  }

  void ngOnDestroy()
  {
    if (details.form.valid && !buffer.isEqual(selectedServiceAddon))
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
      buffer = new ServiceAddon.from(selectedServiceAddon);
      service.set(selectedServiceAddon.id, selectedServiceAddon);
    }
    else
    {
      _popupService.title = phrase.get(["error_occured"]);
      _popupService.message = phrase.get(["_could_not_save_model"], params: {"model":phrase.get(["salon"]).toLowerCase()});
    }
  }

  void cancel()
  {
    service.selectedModel = new ServiceAddon.from(buffer);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  ServiceAddon get selectedServiceAddon => service.selectedModel;

  @ViewChild('details')
  ServiceAddonDetailsComponent details;

  ServiceAddon buffer;

  final ConfirmPopupService _popupService;
  final ServiceAddonService service;
  final PhraseService phrase;
}
