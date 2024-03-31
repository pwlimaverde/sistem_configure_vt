// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

final class ComandosFirebase {
  final bool record;
  final bool debug;
  final int timeStart;

  ComandosFirebase({required this.record, required this.debug, required this.timeStart,});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'record': record,
      'debug': debug,
      'time_start': timeStart,
    };
  }

  factory ComandosFirebase.fromMap(Map<String, dynamic> map) {
    return ComandosFirebase(
      record: (map['record'] ?? false) as bool,
      debug: (map['debug'] ?? false) as bool,
      timeStart: (map['time_start'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComandosFirebase.fromJson(String source) => ComandosFirebase.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ComandosFirebase(record: $record, debug: $debug, timeStart: $timeStart)';

  @override
  bool operator ==(covariant ComandosFirebase other) {
    if (identical(this, other)) return true;
  
    return 
      other.record == record &&
      other.debug == debug &&
      other.timeStart == timeStart;
  }

  @override
  int get hashCode => record.hashCode ^ debug.hashCode ^ timeStart.hashCode;
}
