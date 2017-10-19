// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of list_component_base;

@Component(
    selector: 'bo-product-list',
    styleUrls: const ['../webshop/product/product_list_component.css'],
    templateUrl: '../webshop/product/product_list_component.html',
    directives: const [CORE_DIRECTIVES, DataTableComponent, FoModalComponent, materialDirectives, ProductAddComponent, ProductEditComponent],
    pipes: const [PhrasePipe]
)
class ProductListComponent extends ListComponentBase<Product>
{
  ProductListComponent(ProductService service) : super(service);
}
