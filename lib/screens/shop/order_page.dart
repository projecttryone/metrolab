import 'package:ecommerce_int2/api_service.dart';
import 'package:ecommerce_int2/models/id.dart';
import 'package:ecommerce_int2/screens/shop/components/orderstatepagestub.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_int2/screens/dbmain.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // ---------- 1) DATA (will be replaced by API later) ----------
  // start with sample data; API will overwrite these
  List<OrderItem> ongoing = [
    OrderItem(
      title: 'Metrolabs Welcome',
      orderNo: '#1234',
      testsCount: 40,
      status: 'Current Order',
      createdAt: DateTime(2025, 6, 12, 12, 55),
    ),
    OrderItem(
      title: 'Metrolabs Welcome',
      orderNo: '#1234',
      testsCount: 40,
      status: 'Awaiting Technician',
      createdAt: DateTime(2025, 6, 12, 12, 55),
    ),
    OrderItem(
      title: 'Metrolabs Welcome',
      orderNo: '#1234',
      testsCount: 40,
      status: 'Current Order',
      createdAt: DateTime(2025, 6, 12, 12, 55),
    ),
  ];

  List<OrderItem> history = [
    OrderItem(
      title: 'Metrolabs Welcome',
      orderNo: '#7777',
      testsCount: 12,
      status: 'Completed',
      createdAt: DateTime(2025, 5, 2, 10, 15),
    ),
    OrderItem(
      title: 'Metrolabs Welcome',
      orderNo: '#6666',
      testsCount: 7,
      status: 'Cancelled',
      createdAt: DateTime(2025, 4, 22, 9, 05),
    ),
  ];

  // ---------- 2) UI STATE ----------
  // 0 = History, 1 = Ongoing   (screenshot shows Ongoing active)
  int _tab = 1;
  String _filter = 'All';
Map<String, dynamic>? customer;

  // ---------- 3) LIFECYCLE ----------
  @override
  void initState() {
    super.initState();
    _loadOrders();
    _loadCustomer() ; // move async work out of class body
  }

Future<void> _loadCustomer() async {
  final data = await Dbmain.getLastInsertedCustomer();
  if (!mounted) return;
  setState(() {
    customer = data;
  });
}

  Future<void> _loadOrders() async {
    try {
      
      final api = ApiService(baseUrl: 'http://127.0.0.1:8000');
      await api.login(email: 'admin@example.com', password: 'password');

      // call your client method (POST variant or GET if you added _getJson)
      final json = await api.getOrdersByCustomerPost(
            // print(customer?['id']) ;

        customerId: customer?['id'],         // <-- replace with your real customer id
        includeItems: false,
      );

      final raw = (json['orders'] as List?) ?? const [];
      final mapped = raw
          .map((e) => _mapOrder(e as Map<String, dynamic>))
          .toList();

      final og = <OrderItem>[];
      final hs = <OrderItem>[];
      for (final o in mapped) {
        if (_isOngoing(o.status)) {
          og.add(o);
        } else {
          hs.add(o);
        }
      }

      if (!mounted) return;
      setState(() {
        ongoing = og;
        history = hs;
      });
    } catch (e) {
      debugPrint('getOrdersByCustomer failed: $e'); // keep sample data on failure
    }
  }

  bool _isOngoing(String status) {
    final s = status.toLowerCase();
    return !(s.contains('completed') || s.contains('cancel') || s.contains('delivered'));
  }

  OrderItem _mapOrder(Map<String, dynamic> r) {
    final id = r['id'];
    final statusName = (r['status_name'] ?? '').toString();
    final testsCount = int.tryParse((r['tests_count'] ?? '0').toString()) ?? 0;
    final orderDateStr = (r['order_date'] ?? '').toString();
    final createdAt = DateTime.tryParse(orderDateStr) ?? DateTime.now();
    final first = (r['bill_first_name'] ?? '').toString();
    final last  = (r['bill_last_name']  ?? '').toString();
    final title = (('$first $last').trim().isEmpty) ? 'Order $id' : '$first $last';

    return OrderItem(
      title: title,
      orderNo: '#$id',
      testsCount: testsCount,
      status: statusName,
      createdAt: createdAt,
    );
  }

  // ---------- 4) HELPERS ----------
  List<OrderItem> get _currentList => _tab == 1 ? ongoing : history;

  List<OrderItem> get _filtered {
    if (_filter == 'All') return _currentList;
    return _currentList.where((e) => e.status == _filter).toList();
    }

  Map<String, int> get _statusCounts {
    final map = <String, int>{};
    for (final o in _currentList) {
      map[o.status] = (map[o.status] ?? 0) + 1;
    }
    return map;
  }

  // ---------- 5) BUILD ----------
  @override
  Widget build(BuildContext context) {
       final name = [
      customer?['bill_first_name'] ?? '',
      customer?['bill_last_name'] ?? ''
    ].where((s) => s.isNotEmpty).join(' ');
   final address = [
      customer?['bill_street_add1'] ?? '',
    ].where((s) => s.isNotEmpty).join(' ');

    final gender = customer?['gender'] ?? 'N/A';
    const green = Color(0xFF1F7A53);
    const greenDark = Color(0xFF0F5C3F);
    const border = Color(0xFFE6E6E6);
    const subtle = Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(
                    color: greenDark, fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 2),
            Text(address,
                style: TextStyle(color: subtle, fontSize: 12)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // segmented header card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 3))
                  ],
                ),
                child: Column(
                  children: [
                    _Segmented(
                      left: 'History',
                      right: 'Ongoing',
                      value: _tab,
                      onChanged: (v) {
                        setState(() {
                          _tab = v;
                          _filter = 'All';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _FiltersBar(
                      allCount: _currentList.length,
                      statusCounts: _statusCounts,
                      selected: _filter,
                      onChange: (v) => setState(() => _filter = v),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 24, thickness: 1, color: Color(0xFFE0E8F5)),
                itemBuilder: (context, i) {
                  final item = _filtered[i];
                  return _OrderTile(
                    item: item,
                    onTap: _tab == 1
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderStatePage(
                                  orderNo: item.orderNo,
                                  title: item.title,
                                  currentStep: 5, // e.g., at "sample_collected"
                                  times: {
                                    'new': DateTime(2025, 6, 5),
                                    'payment_received': DateTime(2025, 6, 6, 12, 55),
                                  },
                                ),
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- SMALL, PLAIN WIDGETS ----------

class _Segmented extends StatelessWidget {
  final String left;
  final String right;
  final int value; // 0=left, 1=right
  final ValueChanged<int> onChanged;
  const _Segmented({
    Key? key,
    required this.left,
    required this.right,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F7A53);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onChanged(0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: value == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: value == 0 ? green : Colors.transparent,
                    width: value == 0 ? 2 : 0,
                  ),
                ),
                child: Text(
                  left,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: value == 0 ? green : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onChanged(1),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: value == 1 ? green : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  right,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: value == 1 ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltersBar extends StatelessWidget {
  final int allCount;
  final Map<String, int> statusCounts; // e.g. {'Current Order':3,'Awaiting Technician':2}
  final String selected;
  final ValueChanged<String> onChange;
  const _FiltersBar({
    Key? key,
    required this.allCount,
    required this.statusCounts,
    required this.selected,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F7A53);
    final chips = <Widget>[
      _ChipBtn(
        label: 'All',
        count: allCount,
        selected: selected == 'All',
        onTap: () => onChange('All'),
      ),
      for (final e in statusCounts.entries)
        _ChipBtn(
          label: e.key,
          count: e.value,
          selected: selected == e.key,
          onTap: () => onChange(e.key),
        ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        const SizedBox(width: 4),
        ...chips.expand((w) => [w, const SizedBox(width: 8)]),
      ]),
    );
  }
}

class _ChipBtn extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  const _ChipBtn({
    Key? key,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F7A53);
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE7F3EE) : Colors.white,
          border: Border.all(color: selected ? green : const Color(0xFFE6E6E6)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: green,
              ),
            ),
            if (label != 'All') ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ] else ...[
              const SizedBox(width: 6),
              Text(
                '$count',
                style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderItem item;
  final VoidCallback? onTap;
  const _OrderTile({Key? key, required this.item, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1F7A53);
    const grey = Color(0xFF6B7280);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // status pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F3EE),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: green),
              ),
              child: Text(
                item.status,
                style: const TextStyle(color: green, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            // title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.edit, size: 16, color: green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ),
                const Text('•', style: TextStyle(fontSize: 16, color: grey)),
                const SizedBox(width: 8),
                Text('Order ${item.orderNo}',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 8),
            // meta row
            Wrap(
              spacing: 12,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('${item.testsCount} Tests', style: const TextStyle(color: grey)),
                _Dot(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, size: 14, color: grey),
                    const SizedBox(width: 4),
                    Text(_fmtTime(item.createdAt), style: const TextStyle(color: grey)),
                  ],
                ),
                _Dot(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: grey),
                    const SizedBox(width: 4),
                    Text(_fmtDate(item.createdAt), style: const TextStyle(color: grey)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Text('•', style: TextStyle(color: Color(0xFF6B7280)));
}

// ---------- MODEL + UTIL ----------

class OrderItem {
  final String title;
  final String orderNo;
  final int testsCount;
  final String status;       // e.g., 'Current Order', 'Awaiting Technician'
  final DateTime createdAt;  // use one DateTime for both date+time

  OrderItem({
    required this.title,
    required this.orderNo,
    required this.testsCount,
    required this.status,
    required this.createdAt,
  });
}

String _fmtTime(DateTime dt) {
  final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final m = dt.minute.toString().padLeft(2, '0');
  final ampm = dt.hour >= 12 ? 'pm' : 'am';
  return '$h:$m $ampm';
}

String _fmtDate(DateTime dt) {
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final y = dt.year.toString();
  return '$d-$m-$y';
}

// ---------- STUB PAGE (opens when tapping ongoing item) ----------

