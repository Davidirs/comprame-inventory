class AppInfo {
  final String? version;
  final String? linkupdate;

  const AppInfo({this.version, this.linkupdate});

  factory AppInfo.fromMap(Map<String, dynamic> json) => AppInfo(
        version: json["version"],
        linkupdate: json["linkupdate"],
      );

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'linkupdate': linkupdate,
    };
  }
}
