part of model_service;

@Injectable()
class ServiceAddonService extends ModelService
{
  ServiceAddonService() : super("service_addons");

  @override
  ServiceAddon createModelInstance(String id, Map<String, dynamic> data)
  {
    return new ServiceAddon.decode(id, data);
  }
}