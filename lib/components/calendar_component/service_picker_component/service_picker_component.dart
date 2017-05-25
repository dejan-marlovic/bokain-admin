// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show FoMultiSelectComponent, FoSelectComponent;
import 'package:bokain_models/bokain_models.dart';

@Component(
    selector: 'bo-service-picker',
    styleUrls: const ['service_picker_component.css'],
    templateUrl: 'service_picker_component.html',
    directives: const [materialDirectives, FoMultiSelectComponent, FoSelectComponent],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class ServicePickerComponent implements OnDestroy
{
  ServicePickerComponent(this.phrase, this._salonService, this._serviceService, this.serviceAddonService);

  void ngOnDestroy()
  {
    _onServiceAddonChangeController.close();
    _onServiceChangeController.close();
  }

  Service get service => _service;

  List<ServiceAddon> get serviceAddons => _serviceAddons;

  List<Service> get serviceOptions
  {
    int sortAlpha(Service a, Service b) => a.name.compareTo(b.name);

    if (salon == null) return null;
    else if (user == null)
    {
      List<Service> output = _serviceService.getModelsAsList(_salonService.getServiceIds(salon));
      output.sort(sortAlpha);
      return output;
    }
    else
    {
      List<Service> output = _serviceService.getModelsAsList(_salonService.getServiceIds(salon).where(user.serviceIds.contains).toList());
      output.sort(sortAlpha);
      return output;
    }
  }

  void set service(Service value)
  {
    _service = value;
    _onServiceChangeController.add(_service);
  }

  void set serviceAddons(List<ServiceAddon> value)
  {
    _serviceAddons = value;
    _onServiceAddonChangeController.add(_serviceAddons);
  }

  final SalonService _salonService;
  final ServiceService _serviceService;
  final ServiceAddonService serviceAddonService;
  final PhraseService phrase;
  //final ItemRenderer<ServiceAddon> addonNameRenderer = (ServiceAddon item) => item.name;
  Service _service;
  List<ServiceAddon> _serviceAddons;

  final StreamController<List<ServiceAddon>> _onServiceAddonChangeController = new StreamController();
  final StreamController<Service> _onServiceChangeController = new StreamController();

  @Input('salon')
  Salon salon;

  @Input('service')
  void set serviceExternal(Service value) { _service = value; }

  @Input('serviceAddons')
  void set serviceAddonsExternal(List<ServiceAddon> value) { _serviceAddons = value; }

  @Input('user')
  User user;

  @Output('serviceChange')
  Stream<Service> get onServiceChangeOutput => _onServiceChangeController.stream;

  @Output('serviceAddonsChange')
  Stream<List<ServiceAddon>> get onServiceAddonsChangeOutput => _onServiceAddonChangeController.stream;
}