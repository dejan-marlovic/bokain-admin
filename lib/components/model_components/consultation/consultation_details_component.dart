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
    imageMapZonesFront =
    [
      new FoZoneModel([new FoShapeEllipse(50, 39, 19, 26)], "all_face", phrase_service.get("all_face")),
      new FoZoneModel(
      [
        new FoShapeRectangle(35, 18, 30, 10),
        new FoShapeRectangle(47, 30, 6, 15)
      ], "t_zone", phrase_service.get("t_zone")),
      new FoZoneModel([new FoShapeRectangle(35, 18, 30, 10)], "forehead", phrase_service.get("forehead")),
      new FoZoneModel([new FoShapeRectangle(47, 30, 6, 15)], "nose", phrase_service.get("nose")),
      new FoZoneModel(
      [
        new FoShapeRectangle(43, 43, 2, 4),
        new FoShapeRectangle(55, 43, 2, 4)
      ], "nostrils", phrase_service.get("nostrils")),
      new FoZoneModel(
      [
        new FoShapeEllipse(40, 45, 4, 5),
        new FoShapeEllipse(60, 45, 4, 5)
      ], "cheeks", phrase_service.get("cheeks")),
      new FoZoneModel([new FoShapeRectangle(42, 52, 16, 5)], "mouth", phrase_service.get("mouth")),
      new FoZoneModel(
      [
        new FoShapePolygon(
        [
          new FoShapePoint(33, 46),
          new FoShapePoint(34, 44),
          new FoShapePoint(38, 53),
          new FoShapePoint(46, 63),
          new FoShapePoint(44, 65),
          new FoShapePoint(36, 55)
        ]),
        new FoShapePolygon(
        [
          new FoShapePoint(67, 46),
          new FoShapePoint(66, 44),
          new FoShapePoint(62, 53),
          new FoShapePoint(54, 63),
          new FoShapePoint(56, 65),
          new FoShapePoint(64, 55),
        ])
      ], "jaws", phrase_service.get("jaws")),
      new FoZoneModel([new FoShapeEllipse(50, 64, 6, 2)], "chin", phrase_service.get("chin")),
      new FoZoneModel([new FoShapeEllipse(40, 34, 5, 2), new FoShapeEllipse(60, 34, 5, 2)], "eyes", phrase_service.get("eyes")),
      new FoZoneModel([
        new FoShapePolygon(
        [
          new FoShapePoint(26, 32),
          new FoShapePoint(29, 31),
          new FoShapePoint(30, 34),
          new FoShapePoint(32, 46),
          new FoShapePoint(30, 44),
          new FoShapePoint(28, 40),
          new FoShapePoint(27, 36),
        ]),
        new FoShapePolygon(
        [
          new FoShapePoint(74, 32),
          new FoShapePoint(71, 31),
          new FoShapePoint(70, 34),
          new FoShapePoint(68, 46),
          new FoShapePoint(70, 44),
          new FoShapePoint(72, 40),
          new FoShapePoint(73, 36),
        ])], "ears", phrase_service.get("ears")),
      new FoZoneModel([
        new FoShapePolygon(
        [
          new FoShapePoint(39, 60),
          new FoShapePoint(42, 65),
          new FoShapePoint(46, 67),
          new FoShapePoint(54, 67),
          new FoShapePoint(58, 65),
          new FoShapePoint(62, 60),
          new FoShapePoint(62, 65),
          new FoShapePoint(63, 68),
          new FoShapePoint(67, 71),
          new FoShapePoint(33, 71),
          new FoShapePoint(38, 68),
          new FoShapePoint(39, 65)
        ]),
      ], "neck", phrase_service.get("neck")),
    ];


    imageMapZonesSide =
    [
      new FoZoneModel([new FoShapeEllipse(29, 39, 12, 22)], "all_face", phrase_service.get("all_face")),
      new FoZoneModel(
          [
            new FoShapeRectangle(28, 10, 1, 10, transform:"rotate(12)"),
            new FoShapeRectangle(32, 14, 1, 15, transform:"rotate(25)")
          ], "t_zone", phrase_service.get("t_zone")),
      new FoZoneModel([new FoShapeRectangle(28, 10, 1, 10, transform:"rotate(12)")], "forehead", phrase_service.get("forehead")),
      new FoZoneModel([new FoShapeRectangle(35, 12, 1, 15, transform:"rotate(30)")], "nose", phrase_service.get("nose")),
      new FoZoneModel(
          [
            new FoShapeRectangle(22, 42, 2, 2),
          ], "nostrils", phrase_service.get("nostrils")),
      new FoZoneModel(
          [
            new FoShapeEllipse(30, 45, 5, 5),
          ], "cheeks", phrase_service.get("cheeks")),
      new FoZoneModel([new FoShapeRectangle(21, 48, 4, 5)], "mouth", phrase_service.get("mouth")),
      new FoZoneModel(
          [
            new FoShapePolygon(
                [
                  new FoShapePoint(42, 44),
                  new FoShapePoint(46, 44),
                  new FoShapePoint(40, 53),
                  new FoShapePoint(30, 58),
                  new FoShapePoint(25, 59),
                  new FoShapePoint(23, 56),
                  new FoShapePoint(32, 54),
                  new FoShapePoint(35, 52)
                ])
          ], "jaws", phrase_service.get("jaws")),
      new FoZoneModel([new FoShapeEllipse(25, 57, 2, 3)], "chin", phrase_service.get("chin")),
      new FoZoneModel([new FoShapeEllipse(25, 32, 2, 3)], "eyes", phrase_service.get("eyes")),
      new FoZoneModel([
        new FoShapePolygon(
            [
              new FoShapePoint(57, 28),
              new FoShapePoint(59, 33),
              new FoShapePoint(56, 40),
              new FoShapePoint(53, 43),
              new FoShapePoint(50, 43),
              new FoShapePoint(48, 41),
              new FoShapePoint(49, 35),
              new FoShapePoint(51, 29),
              new FoShapePoint(52, 28),
              new FoShapePoint(54, 27),
            ])], "ears", phrase_service.get("ears")),
      new FoZoneModel([
        new FoShapePolygon(
            [
              new FoShapePoint(40, 61),
              new FoShapePoint(43, 59),
              new FoShapePoint(47, 54),
              new FoShapePoint(50, 45),
              new FoShapePoint(64, 50),
              new FoShapePoint(63, 55),
              new FoShapePoint(65, 62),
              new FoShapePoint(62, 65),
              new FoShapePoint(55, 69),
              new FoShapePoint(45, 71),
              new FoShapePoint(44, 66)
            ]),
      ], "neck", phrase_service.get("neck")),
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

  List<FoZoneModel> imageMapZonesSide;
  List<FoZoneModel> imageMapZonesFront;
}
