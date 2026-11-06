import 'package:flutter_test/flutter_test.dart';
import 'package:businessflow/main.dart';

void main() {
  test('Customer JSON roundtrip', () {
    final c=Customer('1','Test','+77771234567','test@example.com','Kazakh','note');
    final restored=Customer.fromJson(c.toJson());
    expect(restored.name,'Test');
    expect(restored.phone,'+77771234567');
  });
  test('Booking JSON roundtrip', () {
    final b=Booking('B1','C1','City Tour','2026-11-06','10:00','Alex','Pending',20000,'');
    expect(Booking.fromJson(b.toJson()).price,20000);
  });
}
