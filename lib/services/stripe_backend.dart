import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateAccountResponse {
  late String url;
  late bool success;

  CreateAccountResponse({
    required this.url,
    required this.success,
  });
}

class StripeBackendService {
  static const String publishKey =
      "pk_live_51NqD7LHjefWyyt1QtUJqkmJZV3ta5jiSVcVKH7z2VF3DIRPjylVL1zwXsoisIpr2PjHAlxZIpJoLHRAdzHaVVzCv007dIUmc17";

  static const String backendHost =  'http://123.4.345.53:3000';
  static String createAccountUrl = '$backendHost/api/stripe/account?mobile=true';

  static String apiBase = '$backendHost/api/stripe';
  // static String createAccountUrl = '$apiBase/account?mobile=true';

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $publishKey', // Use your Stripe API key here
  };

  static Future<CreateAccountResponse> createSellerAccount() async {
    try {
      final Uri url = Uri.parse(createAccountUrl);
      final http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return CreateAccountResponse(url: body['url'], success: true);
      } else {
        // Handle other status codes or errors
        print('HTTP Error: ${response.statusCode}');
        return CreateAccountResponse(url: '', success: false);
      }
    } catch (e) {
      // Handle network or other exceptions
      print('Exception: $e');
      return CreateAccountResponse(url: '', success: false);
    }
  }
}
