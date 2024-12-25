import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String backendUrl = dotenv.env['LOCAL_API_URL']!;
}
