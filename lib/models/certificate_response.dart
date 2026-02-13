class CertificateStatus {
  final bool canGet;
  final String fullname;

  CertificateStatus({
    required this.canGet,
    required this.fullname,
  });

  factory CertificateStatus.fromJson(Map<String, dynamic> json) {
    return CertificateStatus(
      canGet: json["canGetCertificate"] ?? false,
      fullname: json["fullName"] ?? "",
    );
  }
}
