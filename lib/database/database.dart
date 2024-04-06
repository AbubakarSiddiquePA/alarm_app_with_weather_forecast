import 'package:hive_flutter/hive_flutter.dart';
part 'database.g.dart';

@HiveType(typeId: 0)
class Alarm {
  @HiveField(0)
  String? label;

  @HiveField(1)
  DateTime? time;

  @HiveField(3)
  int? key;

  Alarm({
    this.label,
    this.time,
    this.key,
  });
}
