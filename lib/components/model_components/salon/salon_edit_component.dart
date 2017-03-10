// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show Room, Salon;
import 'package:bokain_admin/components/associative_table_component/associated_table_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_details_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show SalonService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-salon-edit',
    styleUrls: const ['salon_edit_component.css'],
    templateUrl: 'salon_edit_component.html',
    directives: const [materialDirectives, AssociativeTableComponent, SalonDetailsComponent, DataTableComponent, UppercaseDirective],
    viewBindings: const [],
    preserveWhitespace: false
)

class SalonEditComponent implements OnDestroy
{
  SalonEditComponent(this.phrase, this._popupService, this.salonService)
  {
    bufferSalon = new Salon.from(selectedSalon);
  }

  void ngOnDestroy()
  {
    if (details.form.valid && !bufferSalon.isEqual(selectedSalon))
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
      bufferSalon = new Salon.from(selectedSalon);
      salonService.set();
    }
    else
    {
      _popupService.title = phrase.get(["error_occured"]);
      _popupService.message = phrase.get(["_could_not_save_model"], params: {"model":phrase.get(["salon"]).toLowerCase()});
    }
  }

  void cancel()
  {
    salonService.selectedModel = new Salon.from(bufferSalon);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  void addRoom()
  {
    String id = salonService.pushRoom(newRoomBuffer);
    bufferSalon.roomIds.add(id);
    newRoomBuffer.name = "";
  }

  void removeRoom(String id)
  {
    _popupService.title = phrase.get(["confirm_remove"]);
    _popupService.message = phrase.get(["_delete_are_you_sure"], params: {"model": phrase.get(['room_pronounced'], capitalize_first: false)});

    _popupService.onCancel = () { _popupService.title = _popupService.message = null; };
    _popupService.onConfirm = ()
    {
      salonService.removeRoom(id);
      bufferSalon.roomIds.remove(id);
      _popupService.title = _popupService.message = null;
    };
  }

  Salon get selectedSalon => salonService.selectedModel;

  @ViewChild('details')
  SalonDetailsComponent details;

  Salon bufferSalon;
  final ConfirmPopupService _popupService;
  final SalonService salonService;
  final PhraseService phrase;

  Room newRoomBuffer = new Room()..name = "";
}
