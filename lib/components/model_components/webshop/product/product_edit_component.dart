// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of edit_component_base;

@Component(
    selector: 'bo-product-edit',
    styleUrls: const ['../webshop/product/product_edit_component.css'],
    templateUrl: '../webshop/product/product_edit_component.html',
    directives: const
    [
      CORE_DIRECTIVES,
      materialDirectives,
      ProductDetailsComponent,
      StatusSelectComponent,
    ],
    pipes: const [PhrasePipe]
)

class ProductEditComponent extends EditComponentBase implements OnChanges
{
  ProductEditComponent(
      this._dynamicPhraseService,
      this._languageService,
      OutputService output_service,
      ProductService service) : super(service, output_service);

  Future ngOnChanges(Map<String, SimpleChange> changes) async
  {
    if (changes.containsKey("model"))
    {
      productPhrases = null;
      Map<String, ProductPhrases> buffer = new Map();
      for (Language language in _languageService.cachedModels.values)
      {
        buffer[language.iso639_1] = new ProductPhrases.decode(await _dynamicPhraseService.fetchPhrases(language.iso639_1, "products", model.id));
      }

      productPhrases = new Map.from(buffer);
    }
  }

  @override
  Future save() async
  {
    await super.save();

    for (String language in productPhrases.keys)
    {
      await _dynamicPhraseService.setPhrases(language, "products", product.id, productPhrases[language].data);
    }
  }

  ProductService get productService => _service;
  Product get product => model;

  Map<String, ProductPhrases> productPhrases;
  final DynamicPhraseService _dynamicPhraseService;
  final LanguageService _languageService;
}
