// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ConfiguracaoFirebase {
  final bool licenca;
  final bool serviceRecorder;
  final bool cleanFiles;
  final bool uploadFiles;

  ConfiguracaoFirebase({
    required this.licenca,
    required this.serviceRecorder,
    required this.cleanFiles,
    required this.uploadFiles,
  });

  ConfiguracaoFirebase copyWith({
    bool? licenca,
    bool? serviceRecorder,
    bool? cleanFiles,
    bool? uploadFiles,
  }) {
    return ConfiguracaoFirebase(
      licenca: licenca ?? this.licenca,
      serviceRecorder: serviceRecorder ?? this.serviceRecorder,
      cleanFiles: cleanFiles ?? this.cleanFiles,
      uploadFiles: uploadFiles ?? this.uploadFiles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'licenca': licenca,
      'service_recorder': serviceRecorder,
      'clean_files': cleanFiles,
      'upload_files': uploadFiles,
    };
  }

  factory ConfiguracaoFirebase.fromMap(Map<String, dynamic> map) {
    return ConfiguracaoFirebase(
      licenca: (map['licenca'] ?? false) as bool,
      serviceRecorder: (map['service_recorder'] ?? false) as bool,
      cleanFiles: (map['clean_files'] ?? false) as bool,
      uploadFiles: (map['upload_files'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfiguracaoFirebase.fromJson(String source) => ConfiguracaoFirebase.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ConfiguracaoFirebase(licenca: $licenca, serviceRecorder: $serviceRecorder, cleanFiles: $cleanFiles, uploadFiles: $uploadFiles)';
  }

  @override
  bool operator ==(covariant ConfiguracaoFirebase other) {
    if (identical(this, other)) return true;
  
    return 
      other.licenca == licenca &&
      other.serviceRecorder == serviceRecorder &&
      other.cleanFiles == cleanFiles &&
      other.uploadFiles == uploadFiles;
  }

  @override
  int get hashCode {
    return licenca.hashCode ^
      serviceRecorder.hashCode ^
      cleanFiles.hashCode ^
      uploadFiles.hashCode;
  }
}
