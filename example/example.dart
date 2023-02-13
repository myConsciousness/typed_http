import 'package:typed_http/src/http.dart';

Future<void> main() async {
  final http = HttpClient();

  final response = await http.get(
    Uri.parse(
      'https://raw.githubusercontent.com/twitter-dart/twitter-api-v2/main/test/src/service/tweets/data/lookup_by_id.json',
    ),
  );

  print(response.status);
  print(response.body);
}
