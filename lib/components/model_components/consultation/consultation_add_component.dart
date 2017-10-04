// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
    selector: 'bo-consultation-add',
    styleUrls: const ['../consultation/consultation_add_component.css'],
    templateUrl: '../consultation/consultation_add_component.html',
    directives: const [CORE_DIRECTIVES, ConsultationDetailsComponent, materialDirectives],
    providers: const [],
    pipes: const [PhrasePipe],
)
class ConsultationAddComponent extends AddComponentBase implements OnDestroy
{
  ConsultationAddComponent(ConsultationService consultation_service, OutputService output_service) : super(consultation_service, output_service);

  Future push() async
  {
    try
    {
      String id = await consultationService.push(consultation);
      model = new Consultation();
      _onAddController.add(id);
    }
    catch (e)
    {
      _outputService.set(e.toString());
      _onAddController.add(null);
    }
  }

  Consultation get consultation => model;
  ConsultationService get consultationService => _service;
}
