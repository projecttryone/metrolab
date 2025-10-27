import 'dart:ui';

import 'package:ecommerce_int2/api_service.dart';
import 'package:ecommerce_int2/models/categories.dart';
import 'package:ecommerce_int2/models/id.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../db_helper.dart';
import 'main/components/product_list.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/models/labpackage.dart';
import 'package:flutter/services.dart'; // for rootBundle
import 'package:ecommerce_int2/models/customerformat.dart';

import 'package:ecommerce_int2/screens/dbmain.dart';

class Dbmain {

// static Future<List<Product>> fetchAllProducts({dynamic catid = 0, dynamic prop1 = ''}) async {
//   final db = await DBHelper.instance.db;
//   int Preventive = 0  ;
//   int Highest= 0 ;
//   int Newtest= 0 ;

// if (prop1 == "Preventive")
// {
// Preventive = 1 ; //p.preventive_health_package
// }
// else if (prop1 == "Highest selling")
// {
//   Highest =1 ; //p.bestseller
// }
// else if (prop1 == "New Tests")
// {
//   Newtest =1 ; // p.newproduct 
// }


//   // base query
//   String query = '''
//     SELECT
//       p.id           AS id,
//       p.url_code     AS image,
//       pfv.value      AS name,
//       p.test_desc    AS testDesc,
//       p.test_method  AS testMethod
//     FROM products p
//     LEFT JOIN product_field_values pfv
//       ON p.id = pfv.product_id
//      AND pfv.product_field_id = 1
//   ''';

// List<String> conditions = [];
// if (Preventive == 1) conditions.add('p.preventive_health_package = 1');
// if (Highest == 1)    conditions.add('p.bestseller = 1');
// if (Newtest == 1)    conditions.add('p.newproduct = 1');

// // Append WHERE if any
// if (conditions.isNotEmpty) {
//   query += ' WHERE ' + conditions.join(' AND ');
// }
//   // add WHERE if id is provided and not zero
//   List<dynamic> args = [];
//   if (catid != null && catid != 0) {
//     query += ' WHERE p.category_id = ?';
//     args.add(catid);
//   }

//   final rows = await db.rawQuery(query, args);

//   return rows.map((row) {
//     final rawImage   = 'assets/placeholder.png';
//     final rawName    = row['name'];
//     final rawDesc    = row['testDesc'];
//     final id = (row['id'] as int?) ?? 0;
//     final imagePath  = (rawImage.isNotEmpty)
//         ? rawImage
//         : 'assets/placeholder.png';
//     final name       = rawName is String ? rawName : '';
//     final testDesc   = rawDesc is String ? rawDesc : '';
//     final testMethod = 0.00;

//     return Product(
//       imagePath,
//       name,
//       testDesc,
//       testMethod,
//       id,
//       '',
//     );
//   }).toList();
// }

static Future<List<Product>> fetchAllProducts({
  dynamic catid = 0,
  dynamic prop1 = '',
}) async {
  final db = await DBHelper.instance.db;

  // Normalize prop1 for safer matching
  final String tag = (prop1 ?? '').toString().trim().toLowerCase();

  int preventive = 0;
  int highest    = 0;
  int newtest    = 0;

  if (tag == 'preventive') {
    preventive = 1; // p.preventive_health_package
  } else if (tag == 'highest selling' || tag == 'highest') {
    highest = 1; // p.bestseller
  } else if (tag == 'new tests' || tag == 'new') {
    newtest = 1; // p.newproduct
  }

  // Base query
  // String query = '''
  //   SELECT
  //     p.id           AS id,
  //     p.url_code     AS image,
  //     pfv.value      AS name,
  //     pfv2.value      AS price,

  //     p.test_desc    AS testDesc,
  //     p.test_method  AS testMethod
  //   FROM products p
  //   LEFT JOIN product_field_values pfv
  //     ON p.id = pfv.product_id
  //    AND pfv.product_field_id = 1
  //     LEFT JOIN product_field_values pfv2
  //     ON p.id = pfv.product_id
  //    AND pfv2.product_field_id = 2
     
  // ''';
String query = '''
  SELECT
    p.id                          AS id,
    p.url_code                    AS image,

    -- name (field_id = 1): latest value
    (SELECT v.value
       FROM product_field_values v
      WHERE v.product_id = p.id AND v.product_field_id = 1
      ORDER BY v.id DESC
      LIMIT 1)                   AS name,

    -- price (field_id = 2): latest value
    (SELECT v2.value
       FROM product_field_values v2
      WHERE v2.product_id = p.id AND v2.product_field_id = 2
      ORDER BY v2.id DESC
      LIMIT 1)                   AS price,

    p.test_desc                  AS testDesc,
    p.test_method                AS testMethod,
    p.newproduct                 AS newprod,
    p.bestseller                 AS bestsellerprod,
    p.preventive_health_package  AS phpprod
  FROM products p
''';




  // Build WHERE conditions + args
  final List<String> conds = [];
  final List<dynamic> args = [];

  if (preventive == 1) conds.add('p.preventive_health_package = 1');
  if (highest    == 1) conds.add('p.bestseller = 1');
  if (newtest    == 1) conds.add('p.newproduct = 1');

  if (catid != null && catid != 0 && catid.toString().trim().isNotEmpty) {
    conds.add('p.category_id = ?');
    args.add(catid);
  }

  if (conds.isNotEmpty) {
    query += ' WHERE ' + conds.join(' AND ');
  }

  // Optional: avoid dupes if pfv has multiple rows per product_field_id
  // query += ' GROUP BY p.id';

  final rows = await db.rawQuery(query, args);

  return rows.map((row) {
    final id = (row['id'] is int)
        ? row['id'] as int
        : int.tryParse(row['id']?.toString() ?? '') ?? 0;

    final imageCol =  'assets/placeholder.png';
;
    final image = (imageCol is String && imageCol.isNotEmpty)
        ? imageCol
        : 'assets/placeholder.png';

    final name = (row['name'] is String) ? row['name'] as String : '';
    final testDesc = (row['testDesc'] is String) ? row['testDesc'] as String : '';

    final testMethodNum = row['price'];
    final testMethod = (testMethodNum is num)
        ? testMethodNum.toDouble()
        : double.tryParse(testMethodNum?.toString() ?? '') ?? 0.0;
  // Product(this.image, this.name, this.description, this.price,this.id,this.test_method);

    return Product(
      image,
      name,
      testDesc,
      testMethod,
      id,
      '',
    );
  }).toList();
}


static Future<List<LabPackage>> fetchLabPackages({required int catid}) async {
  final db = await DBHelper.instance.db;

  // base query
  // String query = '''
  //   SELECT
  //     p.id           AS id,
  //     p.url_code     AS image,
  //     pfv.value      AS name,
  //           pfv2.value      AS price,

  //     p.test_desc    AS testDesc,
  //     p.test_method  AS testMethod,
  //     p.newproduct as newprod,
  //     p.bestseller as bestsellerprod,
  //     p.preventive_health_package as phpprod

  //   FROM products p
  //   LEFT JOIN product_field_values pfv
  //     ON p.id = pfv.product_id
  //    AND pfv.product_field_id = 1
  //     LEFT JOIN product_field_values pfv2
  //     ON p.id = pfv2.product_id
  //    AND pfv2.product_field_id = 2
  // ''';
String query = '''
  SELECT
    p.id                          AS id,
    p.url_code                    AS image,

    -- name (field_id = 1): latest value
    (SELECT v.value
       FROM product_field_values v
      WHERE v.product_id = p.id AND v.product_field_id = 1
      ORDER BY v.id DESC
      LIMIT 1)                   AS name,

    -- price (field_id = 2): latest value
    (SELECT v2.value
       FROM product_field_values v2
      WHERE v2.product_id = p.id AND v2.product_field_id = 2
      ORDER BY v2.id DESC
      LIMIT 1)                   AS price,

    p.test_desc                  AS testDesc,
    p.test_method                AS testMethod,
    p.newproduct                 AS newprod,
    p.bestseller                 AS bestsellerprod,
    p.preventive_health_package  AS phpprod
  FROM products p
''';

  // add WHERE if catid is provided
  List<dynamic> args = [];
  if (catid != 0) {
    query += ' WHERE p.id = ?';
    args.add(catid);
  }

  final rows = await db.rawQuery(query, args);

  // map rows to LabPackage
  return rows.map((row) {

      // pick the right badge
  String badge = '';
  if (row['newprod'] == 1) {
    badge = 'New Tests';
  } else if (row['bestsellerprod'] == 1) {
    badge = 'Highest Selling';
  } else if (row['phpprod'] == 1) {
    badge = 'Preventive';
  } else {
    badge = '';
  }

    return LabPackage(
      id: row['id'].toString(),
      title: row['name']?.toString() ?? '',
      codeLabel: row['id'].toString(),
      mrp: 0.0, // ⚡️replace when you have MRP column
      price: row['price'] != null 
          ? double.tryParse(row['price'].toString()) ?? 0.0 
          : 0.0,
      testsCount: 0, // ⚡️replace when you have TestsCount column
      highlights: [row['testDesc']?.toString() ?? ''],
      // topBadges: [row['testMethod']?.toString() ?? ''],
          topBadges: [badge],

      // image: row['image']?.toString() ?? 'https://picsum.photos/seed/lab/600/320',
        image: 'https://picsum.photos/seed/lab/600/320',

      discountPct: 0.0, // ⚡️replace when you have discount column
      suggestionIds: const [],
    );
  }).toList();
}


 static Future<List<categories>> fetchLabPackagesparent({required int catid}) async {
    final db = await DBHelper.instance.db;

    final rows = await db.rawQuery('''
      SELECT  cat_nam, cat_image, cat_id
      FROM category
      WHERE par_cod = 0
    ''');

    Color _toColor(String s) {
      s = s.trim();
      if (s.startsWith('0x')) return Color(int.parse(s));
      if (s.startsWith('#')) return Color(int.parse('0xff${s.substring(1)}'));
      if (s.length == 6) return Color(int.parse('0xff$s'));
      return Color(int.parse(s));
    }
   String _assetOrDefault(String v) {
  final raw = v.trim();
  if (raw.isEmpty) return 'assets/vlood_icon.png';
  return raw.startsWith('assets/') ? raw : 'assets/vlood_icon.png';
}


    return rows.map((r) {
      // final redStr = (r['red'] ?? '').toString();
      // final parts = redStr.split(',');
      final c1 = Color(0xff56C596);
      final c2 = Color(0xff56C596);
final img = _assetOrDefault((r['cat_image'] ?? '').toString());
      
  
  //   final int highselling ;
  // final int preventive ;
  // final int newtest ;

    return categories(
      c1,
      c2,
      (r['cat_nam'] ?? '').toString(),
      img.toString(),
      r['cat_id'] as int,0,0,0,
    );


    }).toList();
  }

 
static Future<int> fetchnooftest({required int catid}) async {
  final db = await DBHelper.instance.db;

  final result = await db.rawQuery(
    'SELECT COUNT(child_product_id) as cnt FROM package_test WHERE product_id = ?',
    [catid],
  );

  // If no rows, return 0
  if (result.isNotEmpty) {
    return result.first['cnt'] as int? ?? 0;
  } else {
    return 0;
  }

  // return 0;
}

static Future<List<Map<String, dynamic>>> testrelated({required int catid}) async {
  final db = await DBHelper.instance.db;

  // Step 1: get all child_product_ids for this product_id
  final childRows = await db.rawQuery(
    'SELECT child_product_id FROM package_test WHERE product_id = ?',
    [catid],
  );

  if (childRows.isEmpty) return [];

  // Extract IDs into a list
  final childIds = childRows.map((row) => row['child_product_id']).toList();

  // Build placeholders (?, ?, ?)
  final placeholders = List.filled(childIds.length, '?').join(',');

  // Step 2: fetch all products where id is in childIds
   final productRows = await db.rawQuery('''
    SELECT p.id,
         
    pfv.value AS name,
    pfv2.value AS price

    FROM products p
    LEFT JOIN product_field_values pfv
      ON p.id = pfv.product_id
     AND pfv.product_field_id = 1
      LEFT JOIN product_field_values pfv2
      ON p.id = pfv2.product_id
     AND pfv2.product_field_id = 2
    WHERE p.id IN ($placeholders)
  ''', childIds);
  return productRows; // plain array of maps

 
}


// static Future<int> insertCustomerFromForm({required Map<String, dynamic> form}) async {
//   final Database db = await DBHelper.instance.db;

//   // --- minimal validation (do more in your _submitForm if you like) ---
//   final firstName = (form['firstName'] ?? '').toString().trim();
//   if (firstName.isEmpty) {
//     throw ArgumentError('firstName is required');
//   }

//   final email = (form['email'] ?? '').toString().trim();
//   if (email.isNotEmpty &&
//       !RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(email)) {
//     throw ArgumentError('Invalid email format');
//   }

//   final phone = (form['phone'] ?? '').toString().trim();
//   if (phone.isNotEmpty && phone.length < 7) {
//     throw ArgumentError('Phone looks too short');
//   }

//   // Normalize DOB to 'YYYY-MM-DD' if possible
//   String? _toIsoDob(String? dob) {
//     if (dob == null) return null;
//     final s = dob.trim();
//     if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(s)) return s;            // already ISO
//     final dmy = RegExp(r'^(\d{1,2})[-/](\d{1,2})[-/](\d{4})$').firstMatch(s);
//     if (dmy != null) {
//       final d = dmy.group(1)!, m = dmy.group(2)!, y = dmy.group(3)!;
//       return '$y-${m.padLeft(2, '0')}-${d.padLeft(2, '0')}';
//     }
//     return null; // omit if unknown format
//   }

//   // Map form -> DB columns; omit nulls so SQLite defaults apply
//   final lastName = (form['lastName'] ?? '').toString().trim();
//   final address  = (form['address']  ?? '').toString().trim();
//   final height   = (form['height']   ?? '').toString().trim();
//   final weight   = (form['weight']   ?? '').toString().trim();
//   final gender   = (form['gender']   ?? '').toString().trim();
//   final dobIso   = _toIsoDob((form['dob'] ?? '').toString());

//   final row = <String, dynamic>{
//     'bill_first_name'  : firstName,
//     if (lastName.isNotEmpty)  'bill_last_name'   : lastName,
//     if (address.isNotEmpty)   'bill_street_add1' : address,
//     if (phone.isNotEmpty)     'bill_phone'       : phone,
//     if (email.isNotEmpty)     'bill_email_id'    : email,
//     if (email.isNotEmpty)     'email_id'         : email, // keep both if you want
//     if (dobIso != null)       'dob'              : dobIso,
//     if (height.isNotEmpty)    'height'           : height,
//     if (weight.isNotEmpty)    'weight'           : weight,
//     if (gender.isNotEmpty)    'gender'           : gender,
//     // DO NOT set newsletter/status/israndom here -> let defaults/constraints handle it
//     // signup_date will auto-fill via DEFAULT CURRENT_TIMESTAMP
//   };

//   // Insert (abort on constraint errors so you see them)
//   final id = await db.insert('customer', row, conflictAlgorithm: ConflictAlgorithm.abort);
//   return id;
// }

static Future<int> insertCustomerFromForm({required Map<String, dynamic> form}) async {
  final Database db = await DBHelper.instance.db;

  // --- minimal validation ---
  final firstName = (form['firstName'] ?? '').toString().trim();
  if (firstName.isEmpty) {
    throw ArgumentError('firstName is required');
  }

  final email = (form['email'] ?? '').toString().trim();
  if (email.isNotEmpty &&
      !RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(email)) {
    throw ArgumentError('Invalid email format');
  }

  final phone = (form['phone'] ?? '').toString().trim();
  if (phone.isNotEmpty && phone.length < 7) {
    throw ArgumentError('Phone looks too short');
  }

  // Normalize DOB to 'YYYY-MM-DD'
  String? _toIsoDob(String? dob) {
    if (dob == null) return null;
    final s = dob.trim();
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(s)) return s;
    final m = RegExp(r'^(\d{1,2})[-/](\d{1,2})[-/](\d{4})$').firstMatch(s);
    if (m != null) {
      final d = m.group(1)!, mm = m.group(2)!, y = m.group(3)!;
      return '$y-${mm.padLeft(2, '0')}-${d.padLeft(2, '0')}';
    }
    return null;
  }

  // Map form -> DB columns (only non-empty fields)
  final lastName = (form['lastName'] ?? '').toString().trim();
  final address  = (form['address']  ?? '').toString().trim();
  final height   = (form['height']   ?? '').toString().trim();
  final weight   = (form['weight']   ?? '').toString().trim();
  final gender   = (form['gender']   ?? '').toString().trim();
  final dobIso   = _toIsoDob((form['dob'] ?? '').toString());

  final row = <String, dynamic>{
    'bill_first_name'  : firstName,
    if (lastName.isNotEmpty)  'bill_last_name'   : lastName,
    if (address.isNotEmpty)   'bill_street_add1' : address,
    if (phone.isNotEmpty)     'bill_phone'       : phone,
    if (email.isNotEmpty)     'bill_email_id'    : email,
    if (email.isNotEmpty)     'email_id'         : email,
    if (dobIso != null)       'dob'              : dobIso,
    if (height.isNotEmpty)    'height'           : height,
    if (weight.isNotEmpty)    'weight'           : weight,
    if (gender.isNotEmpty)    'gender'           : gender,
  };

  // If a row exists, UPDATE the first row; otherwise INSERT a new one.
  final existing = await db.query(
    'customer',
    columns: ['id'],
    orderBy: 'id ASC',
    limit: 1,
  );

    try {
    final api = ApiService(baseUrl: 'http://127.0.0.1:8000');
    await api.login(email: 'admin@example.com', password: 'password');
    await api.upsertCustomer(customer: row); // do NOT send local id; match by email on server
  } catch (e) {
    debugPrint('upsertCustomer failed: $e'); // don’t block local success
  }

  if (existing.isNotEmpty) {
    final firstId = (existing.first['id'] as num).toInt();
    await db.update(
      'customer',
      row,                           // only updates provided fields
      where: 'id = ?',
      whereArgs: [firstId],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return firstId;                  // no new ID created
  } else {
    final id = await db.insert(
      'customer',
      row,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return id;                       // first insert creates the first row
  }
}

static Future<Map<String, dynamic>?> getLastInsertedCustomer() async {
  final db = await DBHelper.instance.db;

  final result = await db.query(
    'customer',
    orderBy: 'id DESC',
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first;
  } else {
    return null;
  }
}
static Future<int?> getLastInsertedCustomerId() async {
  final db = await DBHelper.instance.db;

  final result = await db.query(
    'customer',
    orderBy: 'id DESC',
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['id'] as int;
  } else {
    return null;
  }
}


static Future<List<Map<String, dynamic>>> getCartItems() async {
  final db = await DBHelper.instance.db;

  final sql = '''
    SELECT 
      c.id                   AS id,
      c.product_id           AS product_id,
      p.url_code             AS image,
      COALESCE(pfv.value, '') AS title,      -- name comes from PFV (field_id=1)
      p.test_desc            AS description,
      COALESCE(c.price, 0)   AS price,       -- use cart.price primarily
      c.qty                  AS qty
    FROM cart c
    JOIN products p 
         ON p.id = c.product_id
    LEFT JOIN product_field_values pfv 
         ON pfv.product_id = p.id 
        AND pfv.product_field_id = 1
    ORDER BY c.id DESC
  ''';

  return db.rawQuery(sql);
}


static Future<int> insertCartLineFromProduct({
  required int productId,
  int qty = 1,
  double? overridePrice,
}) async {
  final db = await DBHelper.instance.db;

  // Clamp qty to at least 1
  final q = qty <= 0 ? 1 : qty;

final prod = await db.rawQuery('''
  SELECT 
    p.id                        AS product_id,
    p.url_code                  AS image,
    COALESCE(name.value, '')    AS title,        -- product_field_id = 1
    p.test_desc                 AS description,
    COALESCE(price.value, '0')  AS product_price -- product_field_id = 2
  FROM products p
  LEFT JOIN product_field_values name
         ON name.product_id = p.id
        AND name.product_field_id = 1
  LEFT JOIN product_field_values price
         ON price.product_id = p.id
        AND price.product_field_id = 2
  WHERE p.id = ?
  LIMIT 1
''', [productId]);



  if (prod.isEmpty) {
    throw StateError('Product $productId not found');
  }

  // 2) Extract fields safely
  String _s(dynamic v, [String f = '']) => (v == null) ? f : v.toString();
  double _d(dynamic v, [double f = 0.0]) {
    if (v == null) return f;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? f;
  }

  final r     = prod.first;
  final title = _s(r['title']);
  final image = _s(r['image']);
  final desc  = _s(r['description']);
  final price = overridePrice ?? _d(r['product_price'], 0.0);

  // 3) Always INSERT a new line (do not update existing)
  final row = <String, dynamic>{
    'product_id': productId,
    'title'     : title,
    'description': desc,
    'image'     : image,
    'price'     : price,
    'qty'       : q,
  };
  return await db.insert('cart', row, conflictAlgorithm: ConflictAlgorithm.abort);
}


static Future<int> removeCartItem(int id) async {
    print('🗑️ Trying to remove from cart, id = $id');

  final db = await DBHelper.instance.db;
  return await db.delete(
    'cart',
    where: 'id = ?',
    whereArgs: [id],
  );
}
static Future<int> removeCartItemall() async {

  final db = await DBHelper.instance.db;
  return await db.delete(
    'cart',

  );
}


//after api call saves what is returned from laravel app
static Future<int> insertOrReplaceCustomerFromServer(EnsureByPhoneResult result) async {
  final db = await DBHelper.instance.db;
  final data = result.data;

  // Map server column names → form-style keys your insert function understands
  final form = <String, dynamic>{
    'firstName' : (data['bill_first_name'] ?? '').toString(),
    'lastName'  : (data['bill_last_name'] ?? '').toString(),
    'address'   : (data['bill_street_add1'] ?? '').toString(),
    'phone'     : (data['bill_phone'] ?? data['bill_cellphone'] ?? '').toString(),
    'email'     : (data['bill_email_id'] ?? data['email_id'] ?? '').toString(),
    'dob'       : (data['dob'] ?? '').toString(),
    'height'    : (data['height'] ?? '').toString(),
    'weight'    : (data['weight'] ?? '').toString(),
    'gender'    : (data['gender'] ?? '').toString(),
  };

  // Prepare row for SQLite
  final row = <String, dynamic>{
    'id'                : result.id, // force same as server
    'bill_first_name'   : form['firstName'],
    if (form['lastName'] != '')  'bill_last_name'   : form['lastName'],
    if (form['address']  != '')  'bill_street_add1' : form['address'],
    if (form['phone']    != '')  'bill_phone'       : form['phone'],
    if (form['email']    != '')  'bill_email_id'    : form['email'],
    if (form['email']    != '')  'email_id'         : form['email'],
    if (form['dob']      != '')  'dob'               : form['dob'],
    if (form['height']   != '')  'height'             : form['height'],
    if (form['weight']   != '')  'weight'             : form['weight'],
    if (form['gender']   != '')  'gender'             : form['gender'],
  };

  // Upsert (replace on conflict so it always stores latest copy from server)
  await db.insert(
    'customer',
    row,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  return result.id;
}



}

