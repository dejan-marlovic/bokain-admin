// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show Room, Salon;
import 'package:bokain_admin/components/associative_table_component/associated_table_component.dart';
import 'package:bokain_admin/components/booking_details_component/booking_details_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_details_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show BookingService, SalonService, ServiceService, UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-salon-edit',
    styleUrls: const ['salon_edit_component.css'],
    templateUrl: 'salon_edit_component.html',
    directives: const [materialDirectives, AssociativeTableComponent, BookingDetailsComponent, SalonDetailsComponent, DataTableComponent, UppercaseDirective],
    providers: const [],
    viewBindings: const [],
    preserveWhitespace: false
)

class SalonEditComponent implements OnDestroy
{
  SalonEditComponent(this.phrase, this.bookingService, this._popupService, this.salonService, this.serviceService, this.userService)
  {
    _bufferSalon = new Salon.from(selectedSalon);
  }

  void ngOnDestroy()
  {
    if (details.form.valid && !_bufferSalon.isEqual(selectedSalon))
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
      _bufferSalon = new Salon.from(selectedSalon);
      salonService.selectedSet();
    }
    else
    {
      _popupService.title = phrase.get(["error_occured"]);
      _popupService.message = phrase.get(["_could_not_save_model"], params: {"model":phrase.get(["salon"]).toLowerCase()});
    }
  }

  void cancel()
  {
    salonService.selectedModel = new Salon.from(_bufferSalon);
    details.form.controls.values.forEach((control) => control.updateValueAndValidity());
  }

  void createRoom()
  {
    String id = salonService.pushRoom(newRoomBuffer);
    _bufferSalon.roomIds.add(id);
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
      _bufferSalon.roomIds.remove(id);
      _popupService.title = _popupService.message = null;
    };
  }

  void addRoomService(String room_id, String service_id)
  {
    salonService.getRoom(room_id).serviceIds.add(service_id);
    salonService.setRoom(room_id);
  }

  void removeRoomService(String room_id, String service_id)
  {
    salonService.getRoom(room_id).serviceIds.remove(service_id);
    salonService.setRoom(room_id);
  }

  Salon get selectedSalon => salonService.selectedModel;

  Map<String, Map<String, String>> get salonBookings
  {
    return bookingService.getRows(selectedSalon.bookingIds, true);
  }

  void updateBufferSalon()
  {
    _bufferSalon = new Salon.from(selectedSalon);
  }

  @ViewChild('details')
  SalonDetailsComponent details;

  Salon _bufferSalon;

  final BookingService bookingService;
  final ConfirmPopupService _popupService;
  final SalonService salonService;
  final ServiceService serviceService;
  final UserService userService;
  final PhraseService phrase;

  String selectedBookingId;

  Room newRoomBuffer = new Room()..name = "";
}
