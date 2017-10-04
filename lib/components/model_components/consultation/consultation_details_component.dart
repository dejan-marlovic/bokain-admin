// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of details_component_base;

@Component(
    selector: 'bo-consultation-details',
    templateUrl: '../consultation/consultation_details_component.html',
    styleUrls: const ['../consultation/consultation_details_component.css'],
    directives: const
    [
      CORE_DIRECTIVES,
      formDirectives,
      FoModalComponent,
      FoSelectComponent,
      LowercaseDirective,
      materialDirectives,
      StatusSelectComponent,
      UppercaseDirective
    ],
    pipes: const [PhrasePipe]
)

class ConsultationDetailsComponent extends DetailsComponentBase implements OnInit, OnChanges
{
  ConsultationDetailsComponent(
      ConsultationService consultation_service,
      this.userService)
  : super(consultation_service);

  void ngOnInit()
  {
    userOptions = new StringSelectionOptions(userService.cachedModels.values.toList(growable: false));
  }

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      form = new ControlGroup(
      {
      });
    }
  }

  ConsultationService get consultationService => _service;
  Consultation get consultation => model;

  final UserService userService;
  StringSelectionOptions<User> userOptions;
}
