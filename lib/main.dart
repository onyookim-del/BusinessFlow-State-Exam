import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BusinessFlow());
}

const navy = Color(0xFF17365D);
const blue = Color(0xFF2563EB);
const pale = Color(0xFFF3F7FC);

class Customer {
  String id, name, phone, email, nationality, notes;
  Customer(
      this.id, this.name, this.phone, this.email, this.nationality, this.notes);
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'nationality': nationality,
        'notes': notes
      };
  factory Customer.fromJson(Map<String, dynamic> j) => Customer(
      '${j['id']}',
      '${j['name']}',
      '${j['phone']}',
      '${j['email']}',
      '${j['nationality']}',
      '${j['notes'] ?? ''}');
}

class Booking {
  String id, customerId, service, date, time, driver, status, notes;
  double price;
  Booking(this.id, this.customerId, this.service, this.date, this.time,
      this.driver, this.status, this.price, this.notes);
  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'service': service,
        'date': date,
        'time': time,
        'driver': driver,
        'status': status,
        'price': price,
        'notes': notes
      };
  factory Booking.fromJson(Map<String, dynamic> j) => Booking(
      '${j['id']}',
      '${j['customerId']}',
      '${j['service']}',
      '${j['date']}',
      '${j['time']}',
      '${j['driver']}',
      '${j['status']}',
      (j['price'] as num).toDouble(),
      '${j['notes'] ?? ''}');
}

class Store extends ChangeNotifier {
  List<Customer> customers = [];
  List<Booking> bookings = [];
  bool loaded = false;
  String language = 'en';
  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    language = p.getString('bf_lang') ?? 'en';
    try {
      customers = (jsonDecode(p.getString('bf_customers') ?? '[]') as List)
          .map((e) => Customer.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      bookings = (jsonDecode(p.getString('bf_bookings') ?? '[]') as List)
          .map((e) => Booking.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      customers = [];
      bookings = [];
    }
    loaded = true;
    notifyListeners();
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
        'bf_customers', jsonEncode(customers.map((e) => e.toJson()).toList()));
    await p.setString(
        'bf_bookings', jsonEncode(bookings.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  Future<void> setLanguage(String s) async {
    language = s;
    final p = await SharedPreferences.getInstance();
    await p.setString('bf_lang', s);
    notifyListeners();
  }

  String customerName(String id) {
    for (final c in customers) {
      if (c.id == id) return c.name;
    }
    return 'Unknown';
  }

  bool duplicate(String phone, String id) {
    final norm = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return customers.any(
        (c) => c.id != id && c.phone.replaceAll(RegExp(r'[^0-9]'), '') == norm);
  }

  Future<void> seed() async {
    if (customers.isNotEmpty || bookings.isNotEmpty) return;
    customers = [
      Customer('C001', 'Minji Park', '+7 701 111 2233', 'minji@example.com',
          'Korean', 'Demo customer'),
      Customer('C002', 'John Smith', '+7 702 222 3344', 'john@example.com',
          'British', 'Demo customer'),
      Customer('C003', 'Aigerim Nur', '+7 777 333 4455', 'aigerim@example.com',
          'Kazakh', 'Demo customer')
    ];
    final d = DateTime.now();
    String day(int n) => DateUtils.dateOnly(d.add(Duration(days: n)))
        .toIso8601String()
        .substring(0, 10);
    bookings = [
      Booking('B001', 'C001', 'Airport Transfer', day(0), '09:00', 'Alex',
          'Confirmed', 9000, 'Airport to hotel'),
      Booking('B002', 'C002', 'City Tour', day(1), '10:30', 'Dana', 'Pending',
          24000, 'City center'),
      Booking('B003', 'C003', 'Car Rental', day(-1), '12:00', 'Alex',
          'Completed', 32000, 'SUV')
    ];
    await save();
  }
}

const labels = <String, Map<String, String>>{
  'Dashboard': {'ko': '대시보드', 'ru': 'Панель'},
  'Customers': {'ko': '고객', 'ru': 'Клиенты'},
  'Bookings': {'ko': '예약', 'ru': 'Бронирования'},
  'Schedule': {'ko': '일정', 'ru': 'Расписание'},
  'Analytics': {'ko': '통계', 'ru': 'Аналитика'},
  'Settings': {'ko': '설정', 'ru': 'Настройки'},
  'Add customer': {'ko': '고객 추가', 'ru': 'Добавить клиента'},
  'Add booking': {'ko': '예약 추가', 'ru': 'Добавить бронь'},
  'Name': {'ko': '이름', 'ru': 'Имя'},
  'Phone': {'ko': '전화번호', 'ru': 'Телефон'},
  'Email': {'ko': '이메일', 'ru': 'Почта'},
  'Nationality': {'ko': '국적', 'ru': 'Гражданство'},
  'Notes': {'ko': '메모', 'ru': 'Заметки'},
  'Save': {'ko': '저장', 'ru': 'Сохранить'},
  'Cancel': {'ko': '취소', 'ru': 'Отмена'},
  'Delete': {'ko': '삭제', 'ru': 'Удалить'},
  'Search': {'ko': '검색', 'ru': 'Поиск'},
  'Customer': {'ko': '고객', 'ru': 'Клиент'},
  'Service': {'ko': '서비스', 'ru': 'Услуга'},
  'Date': {'ko': '날짜', 'ru': 'Дата'},
  'Time': {'ko': '시간', 'ru': 'Время'},
  'Assigned staff': {'ko': '담당 직원', 'ru': 'Сотрудник'},
  'Status': {'ko': '상태', 'ru': 'Статус'},
  'Price (KZT)': {'ko': '가격 (KZT)', 'ru': 'Цена (KZT)'},
  'Total bookings': {'ko': '총 예약', 'ru': 'Всего броней'},
  'Completed': {'ko': '완료', 'ru': 'Завершено'},
  'Pending': {'ko': '대기', 'ru': 'Ожидание'},
  'Confirmed': {'ko': '확정', 'ru': 'Подтверждено'},
  'Cancelled': {'ko': '취소됨', 'ru': 'Отменено'},
  'Today': {'ko': '오늘', 'ru': 'Сегодня'},
  'Revenue': {'ko': '완료 매출', 'ru': 'Выручка'},
  'Demo data': {'ko': '시연 데이터', 'ru': 'Демо-данные'},
  'Load demo records': {'ko': '시연 데이터 불러오기', 'ru': 'Загрузить демо'},
  'No records yet': {'ko': '기록 없음', 'ru': 'Нет записей'},
  'Internal staff application': {'ko': '직원 전용 업무 앱', 'ru': 'Для сотрудников'},
  'Booking details': {'ko': '예약 상세', 'ru': 'Детали брони'},
  'Customer details': {'ko': '고객 상세', 'ru': 'Данные клиента'},
  'Edit': {'ko': '수정', 'ru': 'Изменить'},
  'Upcoming': {'ko': '예정', 'ru': 'Предстоящие'},
  'Bookings by service': {'ko': '서비스별 예약', 'ru': 'Брони по услугам'},
  'Bookings by status': {'ko': '상태별 예약', 'ru': 'Брони по статусам'},
  'Data stored on this device': {
    'ko': '이 기기에 데이터 저장',
    'ru': 'Данные на устройстве'
  },
  'Language': {'ko': '언어', 'ru': 'Язык'},
  'Duplicate phone number': {'ko': '이미 등록된 전화번호', 'ru': 'Номер уже существует'},
  'Required field': {'ko': '필수 항목', 'ru': 'Обязательное поле'},
  'No customers available': {
    'ko': '먼저 고객을 등록하세요',
    'ru': 'Сначала добавьте клиента'
  },
  'Delete customer?': {'ko': '고객을 삭제할까요?', 'ru': 'Удалить клиента?'},
  'Delete booking?': {'ko': '예약을 삭제할까요?', 'ru': 'Удалить бронь?'},
  'Cannot delete customer with bookings': {
    'ko': '예약이 있는 고객은 삭제할 수 없습니다',
    'ru': 'Нельзя удалить клиента с бронями'
  },
  'Airport Transfer': {'ko': '공항 픽업', 'ru': 'Трансфер'},
  'City Tour': {'ko': '시티 투어', 'ru': 'Экскурсия'},
  'Car Rental': {'ko': '렌터카', 'ru': 'Аренда авто'},
  'Hotel Assistance': {'ko': '호텔 지원', 'ru': 'Отель'},
  'Other': {'ko': '기타', 'ru': 'Другое'},
  'Recent bookings': {'ko': '최근 예약', 'ru': 'Последние брони'},
  'No bookings today': {'ko': '오늘 예약 없음', 'ru': 'Нет броней сегодня'},
  'Save changes': {'ko': '변경 저장', 'ru': 'Сохранить изменения'},
  'All': {'ko': '전체', 'ru': 'Все'}
};

class BusinessFlow extends StatefulWidget {
  const BusinessFlow({super.key});
  @override
  State<BusinessFlow> createState() => _BusinessFlowState();
}

class _BusinessFlowState extends State<BusinessFlow> {
  final store = Store();
  @override
  void initState() {
    super.initState();
    store.load();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: store,
      builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BusinessFlow',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: blue),
              scaffoldBackgroundColor: pale,
              appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white, foregroundColor: navy),
              cardTheme: CardThemeData(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12))),
          home: store.loaded
              ? Shell(store)
              : const Scaffold(
                  body: Center(child: CircularProgressIndicator()))));
}

class Shell extends StatefulWidget {
  final Store store;
  const Shell(this.store, {super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  String t(String s) => labels[s]?[widget.store.language] ?? s;
  void customer([Customer? c]) => showDialog(
      context: context, builder: (_) => CustomerDialog(widget.store, c));
  void booking([Booking? b]) => showDialog(
      context: context, builder: (_) => BookingDialog(widget.store, b));
  @override
  Widget build(BuildContext context) {
    final pages = [
      dashboard(),
      customers(),
      bookings(),
      schedule(),
      analytics(),
      settings()
    ];
    final icons = [
      Icons.dashboard_outlined,
      Icons.people_outline,
      Icons.event_note_outlined,
      Icons.calendar_month_outlined,
      Icons.bar_chart_outlined,
      Icons.settings_outlined
    ];
    final names = [
      'Dashboard',
      'Customers',
      'Bookings',
      'Schedule',
      'Analytics',
      'Settings'
    ];
    return Scaffold(
        appBar: AppBar(
            title: Row(children: [
              const Icon(Icons.flight_takeoff, color: blue),
              const SizedBox(width: 8),
              const Text('BusinessFlow',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              if (MediaQuery.sizeOf(context).width > 600)
                Text(t('Internal staff application'),
                    style: const TextStyle(fontSize: 12))
            ]),
            actions: [
              PopupMenuButton<String>(
                  tooltip: 'Language',
                  icon: const Icon(Icons.language),
                  onSelected: widget.store.setLanguage,
                  itemBuilder: (_) => ['en', 'ko', 'ru']
                      .map((s) => PopupMenuItem(
                          value: s,
                          child: Text({
                            'en': 'English',
                            'ko': '한국어',
                            'ru': 'Русский'
                          }[s]!)))
                      .toList())
            ]),
        body: LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth >= 850;
          return Row(children: [
            if (wide)
              NavigationRail(
                  selectedIndex: index,
                  onDestinationSelected: (v) => setState(() => index = v),
                  labelType: NavigationRailLabelType.all,
                  destinations: List.generate(
                      names.length,
                      (i) => NavigationRailDestination(
                          icon: Icon(icons[i]), label: Text(t(names[i]))))),
            Expanded(child: pages[index])
          ]);
        }),
        bottomNavigationBar: MediaQuery.sizeOf(context).width < 850
            ? NavigationBar(
                selectedIndex: index,
                onDestinationSelected: (v) => setState(() => index = v),
                destinations: List.generate(
                    names.length,
                    (i) => NavigationDestination(
                        icon: Icon(icons[i]), label: t(names[i]))))
            : null,
        floatingActionButton: index == 1
            ? FloatingActionButton.extended(
                onPressed: () => customer(),
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(t('Add customer')))
            : index == 2
                ? FloatingActionButton.extended(
                    onPressed:
                        widget.store.customers.isEmpty ? null : () => booking(),
                    icon: const Icon(Icons.add),
                    label: Text(t('Add booking')))
                : null);
  }

  Widget pageTitle(String title, {Widget? trailing}) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Expanded(
            child: Text(t(title),
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: navy))),
        if (trailing != null) trailing
      ]));
  Widget metric(String title, String value, IconData icon) => Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: blue),
            const SizedBox(height: 12),
            Text(value,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text(t(title), style: const TextStyle(color: Colors.black54))
          ])));
  Widget dashboard() {
    final s = widget.store;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final complete = s.bookings.where((b) => b.status == 'Completed').length;
    final revenue = s.bookings
        .where((b) => b.status == 'Completed')
        .fold<double>(0, (v, b) => v + b.price);
    return ListView(padding: const EdgeInsets.all(20), children: [
      pageTitle('Dashboard'),
      Wrap(spacing: 10, runSpacing: 10, children: [
        SizedBox(
            width: 190,
            child: metric('Customers', '${s.customers.length}', Icons.people)),
        SizedBox(
            width: 190,
            child:
                metric('Total bookings', '${s.bookings.length}', Icons.event)),
        SizedBox(
            width: 190,
            child:
                metric('Completed', '$complete', Icons.check_circle_outline)),
        SizedBox(
            width: 190,
            child: metric('Revenue', '${revenue.toStringAsFixed(0)} ₸',
                Icons.payments_outlined))
      ]),
      const SizedBox(height: 20),
      pageTitle('Today'),
      ...s.bookings.where((b) => b.date == today).map(bookingTile),
      if (!s.bookings.any((b) => b.date == today))
        Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(t('No bookings today')))),
      const SizedBox(height: 12),
      pageTitle('Recent bookings'),
      ...s.bookings.reversed.take(5).map(bookingTile),
      if (s.bookings.isEmpty)
        Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Text(t('No records yet')),
                  const SizedBox(height: 10),
                  FilledButton(
                      onPressed: s.seed, child: Text(t('Load demo records')))
                ])))
    ]);
  }

  Widget customers() {
    return CustomerList(store: widget.store, t: t, onEdit: customer);
  }

  Widget bookings() {
    return BookingList(store: widget.store, t: t, onEdit: booking);
  }

  Widget bookingTile(Booking b) => Card(
      child: ListTile(
          leading: const CircleAvatar(
              child: Icon(Icons.confirmation_number_outlined)),
          title: Text(
              '${t(b.service)} · ${widget.store.customerName(b.customerId)}'),
          subtitle: Text('${b.date}  ${b.time}  ·  ${b.driver}'),
          trailing: Chip(label: Text(t(b.status))),
          onTap: () => booking(b)));
  Widget schedule() {
    final ordered = [...widget.store.bookings]
      ..sort((a, b) => '${a.date} ${a.time}'.compareTo('${b.date} ${b.time}'));
    return ListView(padding: const EdgeInsets.all(20), children: [
      pageTitle('Schedule'),
      ...ordered.map((b) => bookingTile(b)),
      if (ordered.isEmpty) Text(t('No records yet'))
    ]);
  }

  Widget analytics() {
    final s = widget.store;

    final types = <String, int>{};
    final statuses = <String, int>{};

    for (final b in s.bookings) {
      types[b.service] = (types[b.service] ?? 0) + 1;
      statuses[b.status] = (statuses[b.status] ?? 0) + 1;
    }

    Widget group(String title, Map<String, int> data) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t(title),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              ...data.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${t(e.key)} — ${e.value}'),
                      const SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: s.bookings.isEmpty
                            ? 0
                            : e.value / s.bookings.length,
                        minHeight: 9,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final cancelled = statuses['Cancelled'] ?? 0;
    final cancellationRate = s.bookings.isEmpty
        ? '0'
        : (cancelled * 100 / s.bookings.length).toStringAsFixed(1);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        pageTitle('Analytics'),
        group('Bookings by service', types),
        group('Bookings by status', statuses),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Text(
              'Total bookings: ${s.bookings.length} · '
              'Cancelled: $cancelled · '
              'Cancellation rate: $cancellationRate%',
            ),
          ),
        ),
      ],
    );
  }

  Widget settings() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          pageTitle('Settings'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(t('Language')),
                  trailing: DropdownButton<String>(
                    value: widget.store.language,
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'ko', child: Text('한국어')),
                      DropdownMenuItem(value: 'ru', child: Text('Русский')),
                    ],
                    onChanged: (v) {
                      if (v != null) widget.store.setLanguage(v);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: Text(t('Data stored on this device')),
                ),
                ListTile(
                  leading: const Icon(Icons.science_outlined),
                  title: Text(t('Load demo records')),
                  subtitle: const Text('Only when the database is empty'),
                  onTap: widget.store.seed,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'BusinessFlow • State Examination • Internal prototype • Synthetic demo data only',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      );
}

class CustomerList extends StatefulWidget {
  final Store store;
  final String Function(String) t;
  final void Function(Customer?) onEdit;

  const CustomerList({
    super.key,
    required this.store,
    required this.t,
    required this.onEdit,
  });

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final items = widget.store.customers
        .where((c) => '${c.name} ${c.phone} ${c.email} ${c.nationality}'
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          widget.t('Customers'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (v) => setState(() => query = v),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: widget.t('Search'),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (c) => Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(c.name.isEmpty ? '?' : c.name[0].toUpperCase()),
              ),
              title: Text(c.name),
              subtitle: Text('${c.phone} · ${c.nationality}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => widget.onEdit(c),
            ),
          ),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.t('No records yet')),
          ),
      ],
    );
  }
}

class BookingList extends StatefulWidget {
  final Store store;
  final String Function(String) t;
  final void Function(Booking?) onEdit;

  const BookingList({
    super.key,
    required this.store,
    required this.t,
    required this.onEdit,
  });

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    final data = widget.store.bookings
        .where((b) => filter == 'All' || b.status == filter)
        .toList()
      ..sort((a, b) => '${b.date} ${b.time}'.compareTo('${a.date} ${a.time}'));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          widget.t('Bookings'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Pending', 'Confirmed', 'Completed', 'Cancelled']
                .map(
                  (v) => Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      label: Text(widget.t(v)),
                      selected: filter == v,
                      onSelected: (_) => setState(() => filter = v),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        ...data.map(
          (b) => Card(
            child: ListTile(
              title: Text(
                '${widget.store.customerName(b.customerId)} · ${widget.t(b.service)}',
              ),
              subtitle: Text('${b.date} ${b.time} | ${b.driver}'),
              trailing: Chip(label: Text(widget.t(b.status))),
              onTap: () => widget.onEdit(b),
            ),
          ),
        ),
        if (data.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(widget.t('No records yet')),
          ),
      ],
    );
  }
}

class CustomerDialog extends StatefulWidget {
  final Store store;
  final Customer? initial;

  const CustomerDialog(this.store, this.initial, {super.key});

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog> {
  final key = GlobalKey<FormState>();

  late final name = TextEditingController(text: widget.initial?.name ?? '');
  late final phone = TextEditingController(text: widget.initial?.phone ?? '');
  late final email = TextEditingController(text: widget.initial?.email ?? '');
  late final nationality =
      TextEditingController(text: widget.initial?.nationality ?? '');
  late final notes = TextEditingController(text: widget.initial?.notes ?? '');

  String t(String s) => labels[s]?[widget.store.language] ?? s;

  @override
  void dispose() {
    for (final c in [name, phone, email, nationality, notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget field(
    String label,
    TextEditingController controller, {
    bool required = true,
    String? Function(String?)? validate,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: t(label)),
        validator: validate ??
            (v) => required && (v == null || v.trim().isEmpty)
                ? t('Required field')
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        t(widget.initial == null ? 'Add customer' : 'Customer details'),
      ),
      content: SizedBox(
        width: 430,
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                field('Name', name),
                field(
                  'Phone',
                  phone,
                  validate: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return t('Required field');
                    }
                    if (v.replaceAll(RegExp(r'[^0-9]'), '').length < 7) {
                      return 'Invalid phone number';
                    }
                    if (widget.store.duplicate(v, widget.initial?.id ?? '')) {
                      return t('Duplicate phone number');
                    }
                    return null;
                  },
                ),
                field(
                  'Email',
                  email,
                  required: false,
                  validate: (v) => v != null &&
                          v.isNotEmpty &&
                          !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)
                      ? 'Invalid email'
                      : null,
                ),
                field('Nationality', nationality),
                field('Notes', notes, required: false),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (widget.initial != null)
          TextButton(
            onPressed: () {
              if (widget.store.bookings
                  .any((b) => b.customerId == widget.initial!.id)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t('Cannot delete customer with bookings')),
                  ),
                );
                return;
              }
              widget.store.customers.remove(widget.initial);
              widget.store.save();
              Navigator.pop(context);
            },
            child: Text(t('Delete')),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t('Cancel')),
        ),
        FilledButton(
          onPressed: () {
            if (!key.currentState!.validate()) return;

            final c = Customer(
              widget.initial?.id ?? 'C${DateTime.now().microsecondsSinceEpoch}',
              name.text.trim(),
              phone.text.trim(),
              email.text.trim(),
              nationality.text.trim(),
              notes.text.trim(),
            );

            if (widget.initial == null) {
              widget.store.customers.add(c);
            } else {
              widget.store.customers[
                  widget.store.customers.indexOf(widget.initial!)] = c;
            }

            widget.store.save();
            Navigator.pop(context);
          },
          child: Text(t('Save')),
        ),
      ],
    );
  }
}

class BookingDialog extends StatefulWidget {
  final Store store;
  final Booking? initial;

  const BookingDialog(this.store, this.initial, {super.key});

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final key = GlobalKey<FormState>();

  late String? customerId = widget.initial?.customerId ??
      (widget.store.customers.isEmpty ? null : widget.store.customers.first.id);

  late String service = widget.initial?.service ?? 'Airport Transfer';
  late String status = widget.initial?.status ?? 'Pending';

  late DateTime date =
      DateTime.tryParse(widget.initial?.date ?? '') ?? DateTime.now();

  late TimeOfDay time = TimeOfDay(
    hour: int.tryParse(widget.initial?.time.split(':').first ?? '09') ?? 9,
    minute: int.tryParse(widget.initial?.time.split(':').last ?? '00') ?? 0,
  );

  late final driver = TextEditingController(text: widget.initial?.driver ?? '');

  late final price = TextEditingController(
      text: widget.initial?.price.toStringAsFixed(0) ?? '0');

  late final notes = TextEditingController(text: widget.initial?.notes ?? '');

  String t(String s) => labels[s]?[widget.store.language] ?? s;

  @override
  void dispose() {
    driver.dispose();
    price.dispose();
    notes.dispose();
    super.dispose();
  }

  String get dateString => date.toIso8601String().substring(0, 10);

  String get timeString =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        t(widget.initial == null ? 'Add booking' : 'Booking details'),
      ),
      content: SizedBox(
        width: 430,
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: customerId,
                  decoration: InputDecoration(labelText: t('Customer')),
                  items: widget.store.customers
                      .map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => customerId = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: service,
                  decoration: InputDecoration(labelText: t('Service')),
                  items: [
                    'Airport Transfer',
                    'City Tour',
                    'Car Rental',
                    'Hotel Assistance',
                    'Other'
                  ]
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(t(s)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => service = v!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final v = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (!mounted) return;
                          if (v != null) setState(() => date = v);
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(dateString),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final v = await showTimePicker(
                            context: context,
                            initialTime: time,
                          );
                          if (!mounted) return;
                          if (v != null) setState(() => time = v);
                        },
                        child: Text(timeString),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: driver,
                  decoration: InputDecoration(labelText: t('Assigned staff')),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? t('Required field')
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: price,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: t('Price (KZT)')),
                  validator: (v) {
                    final amount = double.tryParse(v ?? '');
                    return amount == null || !amount.isFinite || amount < 0
                        ? 'Enter a valid price'
                        : null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  decoration: InputDecoration(labelText: t('Status')),
                  items: ['Pending', 'Confirmed', 'Completed', 'Cancelled']
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(t(s)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => status = v!),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: notes,
                  decoration: InputDecoration(labelText: t('Notes')),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (widget.initial != null)
          TextButton(
            onPressed: () {
              widget.store.bookings.remove(widget.initial);
              widget.store.save();
              Navigator.pop(context);
            },
            child: Text(t('Delete')),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t('Cancel')),
        ),
        FilledButton(
          onPressed: () {
            if (customerId == null || !key.currentState!.validate()) {
              return;
            }

            final b = Booking(
              widget.initial?.id ?? 'B${DateTime.now().microsecondsSinceEpoch}',
              customerId!,
              service,
              dateString,
              timeString,
              driver.text.trim(),
              status,
              double.parse(price.text),
              notes.text.trim(),
            );

            if (widget.initial == null) {
              widget.store.bookings.add(b);
            } else {
              widget.store
                  .bookings[widget.store.bookings.indexOf(widget.initial!)] = b;
            }

            widget.store.save();
            Navigator.pop(context);
          },
          child: Text(t('Save')),
        ),
      ],
    );
  }
}
