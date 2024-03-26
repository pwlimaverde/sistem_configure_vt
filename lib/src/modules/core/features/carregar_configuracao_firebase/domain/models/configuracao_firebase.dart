// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

 final class ConfiguracaoFirebase {
  final bool licenca;
  final bool serviceRecorder;

  ConfiguracaoFirebase({
    required this.licenca,
    required this.serviceRecorder,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'licenca': licenca,
      'service_recorder': serviceRecorder,
    };
  }

  factory ConfiguracaoFirebase.fromMap(Map<String, dynamic> map) {
    return ConfiguracaoFirebase(
      licenca: (map['licenca'] ?? false) as bool,
      serviceRecorder: (map['service_recorder'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfiguracaoFirebase.fromJson(String source) => ConfiguracaoFirebase.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ConfiguracaoFirebase(licenca: $licenca, serviceRecorder: $serviceRecorder)';

  @override
  bool operator ==(covariant ConfiguracaoFirebase other) {
    if (identical(this, other)) return true;
  
    return 
      other.licenca == licenca &&
      other.serviceRecorder == serviceRecorder;
  }

  @override
  int get hashCode => licenca.hashCode ^ serviceRecorder.hashCode;
}
