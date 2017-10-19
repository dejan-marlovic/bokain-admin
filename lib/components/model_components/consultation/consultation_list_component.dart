// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of list_component_base;

@Component(
    selector: 'bo-consultation-list',
    styleUrls: const ['../consultation/consultation_list_component.css'],
    templateUrl: '../consultation/consultation_list_component.html',
    directives: const [CORE_DIRECTIVES, ConsultationEditComponent, DataTableComponent, FoModalComponent, materialDirectives],
    pipes: const [PhrasePipe],
    providers: const []
)
class ConsultationListComponent extends ListComponentBase<Consultation>
{
  ConsultationListComponent(ConsultationService service) : super(service);
}