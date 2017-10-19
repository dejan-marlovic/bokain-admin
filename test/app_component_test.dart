import 'package:test/test.dart';
import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:bokain_admin/components/app_component.dart';

@Tags(const ['aot'])
@TestOn('browser')

@AngularEntrypoint()
void main()
{
  final NgTestBed<AppComponent> testBed = new NgTestBed();
  NgTestFixture<AppComponent> fixture;

  setUp(() async => fixture = await testBed.create());
  tearDown(disposeAnyRunningTest);



  test('Default greeting', ()
  {
    expect(fixture.text, 'Hello Angular');
  });
}

