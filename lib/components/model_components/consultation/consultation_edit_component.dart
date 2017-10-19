// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of edit_component_base;

@Component(
    selector: 'bo-consultation-edit',
    styleUrls: const ['../consultation/consultation_edit_component.css'],
    templateUrl: '../consultation/consultation_edit_component.html',
    directives: const
    [
      BookingDetailsComponent,
      CORE_DIRECTIVES,
      ConsultationDetailsComponent,
      DataTableComponent,
      JournalComponent,
      materialDirectives
    ],
    pipes: const [AsyncPipe, PhrasePipe],
    providers: const []
)

class ConsultationEditComponent extends EditComponentBase<Consultation>
{
  ConsultationEditComponent(
      this.bookingService,
      ConsultationService consultation_service,
      OutputService output_service)
      : super(consultation_service, output_service);

  @override
  Future save() async
  {
    try
    {
      await consultationService.set(consultation);
      _onSaveController.add(consultation.id);
    }
    catch (e)
    {
      await cancel();
      _outputService.set(e.toString());
      _onSaveController.add(null);
    }
  }

  ConsultationService get consultationService => _service;
  Consultation get consultation => model;

  String selectedBookingId;
  final BookingService bookingService;
}
