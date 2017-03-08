// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Service;
import 'package:bokain_admin/components/model_components/service/service_details_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show ServiceService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-edit',
    styleUrls: const ['service_edit_component.css'],
    templateUrl: 'service_edit_component.html',
    directives: const [materialDirectives, ServiceDetailsComponent],
    viewBindings: const [],
    preserveWhitespace: false
)

class ServiceEditComponent implements OnDestroy
{
  ServiceEditComponent(this.phrase, this._popupService, this.service)
  {
    model = new Service.from(service.selectedModel);
  }

  void ngOnDestroy()
  {
    if (details.form.valid && !model.isEqual(service.selectedModel))
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
      model = new Service.from(service.selectedModel);
      service.set();
    }
    else
    {
      _popupService.title = phrase.get(["error_occured"]);
      _popupService.message = phrase.get(["_could_not_save_model"], params: {"model":phrase.get(["salon"]).toLowerCase()});
    }
  }

  void cancel()
  {
    service.selectedModel = new Service.from(model);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  @ViewChild('details')
  ServiceDetailsComponent details;

  Service model;
  final ConfirmPopupService _popupService;
  final ServiceService service;
  final PhraseService phrase;
}
