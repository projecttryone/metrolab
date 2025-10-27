import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_int2/models/customerformat.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Always default to production unless explicitly overridden
  static const String _kProdBase = 'https://metrolabs.com.np';

  final String baseUrl = _kProdBase;
  String? _token;       // set after login() or setToken()

  // ApiService({String? baseUrl}) : baseUrl = baseUrl ?? _kProdBase;

 ApiService({String? baseUrl}) {
    // even if someone tries to pass something, ignore it.
    print('ApiService initialized with: $_kProdBase');
  }
  // ----------------------------------------------------------------------------
  // Public: set token manually (e.g., after restoring a saved session)
  void setToken(String token) {
    _token = token;
  }

  // ----------------------------------------------------------------------------
  // Internal: build a full URL from baseUrl + path
  Uri _url(String path) {
    String cleanBase = baseUrl;
    if (cleanBase.endsWith('/')) {
      cleanBase = cleanBase.substring(0, cleanBase.length - 1);
    }

    String cleanPath = path;
    if (!cleanPath.startsWith('/')) {
      cleanPath = '/$cleanPath';
    }

    return Uri.parse('$cleanBase$cleanPath');
  }

  // Internal: common headers, optionally including Authorization
  Map<String, String> _headers({bool auth = true}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final hasToken = _token != null && _token!.isNotEmpty;
    if (auth && hasToken) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Internal: POST returning JSON (Map)
  Future<Map<String, dynamic>> _postJson(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final uri = _url(path);
    final reqHeaders = _headers(auth: auth);
    final reqBody = jsonEncode(body);

    final res = await http
        .post(uri, headers: reqHeaders, body: reqBody)
        .timeout(const Duration(seconds: 15));

    final ok = res.statusCode >= 200 && res.statusCode < 300;
    if (ok) {
      if (res.body.isEmpty) {
        return <String, dynamic>{};
      }
      return jsonDecode(res.body) as Map<String, dynamic>;
    }

    throw HttpException('POST $path failed (${res.statusCode}): ${res.body}');
  }

  // Internal: GET returning JSON (Map)
  Future<Map<String, dynamic>> _getJson(
    String path, {
    bool auth = true,
  }) async {
    final uri = _url(path);
    final reqHeaders = _headers(auth: auth);

    final res = await http
        .get(uri, headers: reqHeaders)
        .timeout(const Duration(seconds: 15));

    final ok = res.statusCode >= 200 && res.statusCode < 300;
    if (ok) {
      if (res.body.isEmpty) {
        return <String, dynamic>{};
      }
      return jsonDecode(res.body) as Map<String, dynamic>;
    }

    throw HttpException('GET $path failed (${res.statusCode}): ${res.body}');
  }

  // ----------------------------------------------------------------------------
  // 1) Login once → receive and store Sanctum token
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final json = await _postJson(
      '/api/login',
      {
        'email': email,
        'password': password,
      },
      auth: false,
    );

    final tokenValue = (json['token'] ?? '').toString();
    if (tokenValue.isEmpty) {
      throw const FormatException('Token missing in response');
    }

    _token = tokenValue;
    return tokenValue;
  }

  // 2) Ensure customer by phone → returns {id, existed}
  Future<EnsureByPhoneResult> ensureCustomerByPhone(String phone) async {
    final hasToken = _token != null && _token!.isNotEmpty;
    if (!hasToken) {
      throw StateError('No token. Call login() or setToken() first.');
    }

    final json = await _postJson(
      '/api/customers/ensure-by-phone',
      {
        'phone': phone,
      },
    );

    return EnsureByPhoneResult.fromJson(json);
  }

  // 3) Create an order
  Future<OrderCreateResult> createOrder({
    required int customerId,
    required List<Map<String, dynamic>> tests,
    Map<String, dynamic>? orderFields, // optional extra fields
  }) async {
    final hasToken = _token != null && _token!.isNotEmpty;
    if (!hasToken) {
      throw StateError('No token. Call login() or setToken() first.');
    }

    if (tests.isEmpty) {
      throw ArgumentError('tests must not be empty');
    }

    final payload = <String, dynamic>{
      'customer_id': customerId,
      'tests': tests,
    };

    if (orderFields != null) {
      // merge extra order fields
      for (final entry in orderFields.entries) {
        payload[entry.key] = entry.value;
      }
    }

    print(payload);

    final json = await _postJson('/api/orders/create', payload);
    return OrderCreateResult.fromJson(json);
  }

  // 4) Create or update customer; returns the id
  Future<int> upsertCustomer({
    required Map<String, dynamic> customer,
  }) async {
    final hasToken = _token != null && _token!.isNotEmpty;
    if (!hasToken) {
      throw StateError('No token. Call login() or setToken() first.');
    }

    final first = (customer['bill_first_name'] ?? '').toString().trim();
    if (first.isEmpty) {
      throw ArgumentError('bill_first_name is required');
    }

    // Build payload field-by-field so intent is crystal clear
    final payload = <String, dynamic>{};

    if (customer['id'] != null) payload['id'] = customer['id'];
    payload['bill_first_name'] = customer['bill_first_name'];
    if (customer['bill_last_name'] != null) {
      payload['bill_last_name'] = customer['bill_last_name'];
    }
    if (customer['bill_title'] != null) {
      payload['bill_title'] = customer['bill_title'];
    }
    if (customer['bill_street_add1'] != null) {
      payload['bill_street_add1'] = customer['bill_street_add1'];
    }
    if (customer['bill_street_add2'] != null) {
      payload['bill_street_add2'] = customer['bill_street_add2'];
    }
    if (customer['bill_townorcity'] != null) {
      payload['bill_townorcity'] = customer['bill_townorcity'];
    }
    if (customer['bill_state_id'] != null) {
      payload['bill_state_id'] = customer['bill_state_id'];
    }
    if (customer['bill_post_code'] != null) {
      payload['bill_post_code'] = customer['bill_post_code'];
    }
    if (customer['bill_phone'] != null) {
      payload['bill_phone'] = customer['bill_phone'];
    }
    if (customer['bill_cellphone'] != null) {
      payload['bill_cellphone'] = customer['bill_cellphone'];
    }
    if (customer['bill_email_id'] != null) {
      payload['bill_email_id'] = customer['bill_email_id'];
    }
    if (customer['email_id'] != null) {
      payload['email_id'] = customer['email_id'];
    }
    if (customer['dob'] != null) {
      payload['dob'] = customer['dob']; // 'YYYY-MM-DD'
    }
    if (customer['height'] != null) {
      payload['height'] = customer['height'];
    }
    if (customer['weight'] != null) {
      payload['weight'] = customer['weight'];
    }
    if (customer['gender'] != null) {
      payload['gender'] = customer['gender'];
    }
    if (customer['status'] != null) {
      payload['status'] = customer['status']; // '1','0','2'
    }
    if (customer['newsletter_subs'] != null) {
      payload['newsletter_subs'] = customer['newsletter_subs']; // '1'/'0'
    }
    if (customer['newsletter_format'] != null) {
      payload['newsletter_format'] = customer['newsletter_format']; // 'html'/'text'
    }
    if (customer['signupip'] != null) {
      payload['signupip'] = customer['signupip'];
    }

    print(payload);

    final json = await _postJson('/api/customers', payload);
    final idValue = json['id'] as num;
    return idValue.toInt();
  }

  // 5) Get orders by customer (POST-like path with query params, but using GET)
  Future<Map<String, dynamic>> getOrdersByCustomerPost({
    required int customerId,
    bool includeItems = false,
  }) async {
    final hasToken = _token != null && _token!.isNotEmpty;
    if (!hasToken) {
      throw StateError('No token. Call login() first.');
    }

    final queryParams = <String, String>{
      'customer_id': '$customerId',
    };
    if (includeItems) {
      queryParams['include_items'] = '1';
    }

    final query = Uri(queryParameters: queryParams).query;
    final pathWithQuery = '/api/orders/by-customer?$query';

    return await _getJson(pathWithQuery);
  }
}

// -----------------------------------------------------------------------------

class OrderCreateResult {
  final int orderId;
  final List<Map<String, dynamic>> items;

  OrderCreateResult({
    required this.orderId,
    required this.items,
  });

  factory OrderCreateResult.fromJson(Map<String, dynamic> json) {
    final idAny = json['order_id'];
    final parsedId = (idAny is int) ? idAny : int.parse(idAny.toString());

    final rawList = (json['items'] is List) ? json['items'] as List : const [];
    final parsedItems = <Map<String, dynamic>>[];

    for (final element in rawList) {
      if (element is Map<String, dynamic>) {
        parsedItems.add(element);
      } else {
        // If it's a Map<dynamic, dynamic>, coerce to Map<String, dynamic>
        parsedItems.add(Map<String, dynamic>.from(element as Map));
      }
    }

    return OrderCreateResult(orderId: parsedId, items: parsedItems);
  }

  @override
  String toString() {
    return 'OrderCreateResult(orderId: $orderId, items: $items)';
  }
}
