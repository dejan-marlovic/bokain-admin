// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
  selector: 'bo-product-add',
  styleUrls: const ['../webshop/product/product_add_component.css'],
  templateUrl: '../webshop/product/product_add_component.html',
  directives: const [CORE_DIRECTIVES, ProductDetailsComponent, materialDirectives],
  pipes: const [PhrasePipe],
)
class ProductAddComponent extends AddComponentBase
{
  ProductAddComponent(this._dynamicPhraseService, this._languageService, ProductService service, OutputService output_service) : super(service, output_service);

  @override
  void ngOnInit()
  {
    super.ngOnInit();

    for (Language language in _languageService.cachedModels.values)
    {
      productPhrases[language.iso639_1] = new ProductPhrases();
    }
  }

  Product get product => model;
  ProductService get productService => _service;

  @override
  Future<String> push() async
  {
    String id = await super.push();
    for (String language in productPhrases.keys)
    {
      await _dynamicPhraseService.setPhrases(language, "products", id, productPhrases[language].data);
    }
    return id;
  }


  Map<String, ProductPhrases> productPhrases = new Map();
  final LanguageService _languageService;
  final DynamicPhraseService _dynamicPhraseService;
}
