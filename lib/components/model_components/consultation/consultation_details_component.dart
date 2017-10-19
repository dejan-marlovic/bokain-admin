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
      FoImageFileComponent,
      FoImageMapComponent,
      FoModalComponent,
      FoSelectComponent,
      LowercaseDirective,
      materialDirectives,
      StatusSelectComponent,
      UppercaseDirective
    ],
    pipes: const [DatePipe, PhrasePipe],
    providers: const [CustomerService]
)

class ConsultationDetailsComponent extends DetailsComponentBase<Consultation> implements OnInit, OnChanges
{
  ConsultationDetailsComponent(
      ConsultationService consultation_service,
      this._customerService,
      PhraseService phrase_service,
      this._skinTypeService,
      this.userService)
  : super(consultation_service)
  {
    imageMapZones =
    [
      new FoZoneModel([new FoShapeEllipse(50, 35, 25, 35)], "all_face", phrase_service.get("all_face")),
      new FoZoneModel(
      [
        new FoShapeRectangle(30, 20, 40, 10),
        new FoShapeRectangle(45, 30, 10, 15)
      ], "t_zone", phrase_service.get("t_zone")),
      new FoZoneModel([new FoShapeRectangle(30, 20, 40, 10)], "forehead", phrase_service.get("forehead")),
      new FoZoneModel([new FoShapeRectangle(45, 30, 10, 15)], "nose", phrase_service.get("nose")),
      new FoZoneModel(
      [
        new FoShapeRectangle(43, 43, 2, 4),
        new FoShapeRectangle(55, 43, 2, 4)
      ], "nostrils", phrase_service.get("nostrils")),
      new FoZoneModel(
      [
        new FoShapeEllipse(38, 45, 5, 8),
        new FoShapeEllipse(62, 45, 5, 8)
      ], "cheeks", phrase_service.get("cheeks")),
      new FoZoneModel([new FoShapeRectangle(40, 52, 20, 5)], "mouth", phrase_service.get("mouth")),
      new FoZoneModel(
      [
        new FoShapePolygon(
        [
          new FoShapePoint(30, 45),
          new FoShapePoint(32, 44),
          new FoShapePoint(43, 64),
          new FoShapePoint(41, 65)
        ]),
        new FoShapePolygon(
        [
          new FoShapePoint(68, 44),
          new FoShapePoint(70, 45),
          new FoShapePoint(59, 65),
          new FoShapePoint(57, 64),
        ])
      ], "jaws", phrase_service.get("jaws")),
      new FoZoneModel([new FoShapeEllipse(50, 64, 8, 3)], "chin", phrase_service.get("chin"))
    ];
  }

  void ngOnInit()
  {
    userOptions = new StringSelectionOptions(userService.cachedModels.values.toList(growable: false));
    skinTypeOptions = new StringSelectionOptions(_skinTypeService.cachedModels.values.toList(growable: false));
  }

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      form = new ControlGroup(
      {
      });

      if (_customerService.streaming) _customerService.cancelStreaming();
      _customerService.stream(consultation.customerId);
    }
  }

  ConsultationService get consultationService => _service;
  Consultation get consultation => model;
  Customer get customer => _customerService.get(consultation?.customerId);

  StringSelectionOptions<User> userOptions;
  StringSelectionOptions<SkinType> skinTypeOptions;
  final CustomerService _customerService;
  final SkinTypeService _skinTypeService;
  final UserService userService;

  List<FoZoneModel> imageMapZones;
}
