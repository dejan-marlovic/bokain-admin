import 'dart:async' show Future;
import 'package:http/http.dart' show Response;
import 'package:http/browser_client.dart';
import 'package:angular2/angular2.dart' show Injectable;

@Injectable()
class MailerService
{
  MailerService()
  {
  }

  Future mail(String body, String subject, String to) async
  {
    Response r = await _client.post(_url, body: {"body":body, "subject":subject, "to":to});
  }



  final BrowserClient _client = new BrowserClient();
  static final String _url = "https://api.bokain.se/mailer.php";
}