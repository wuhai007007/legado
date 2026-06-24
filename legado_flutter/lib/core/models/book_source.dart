
class BookSource {
  String bookSourceUrl = '';
  String bookSourceName = '';
  String? bookSourceGroup;
  int bookSourceType = 0;
  String? bookUrlPattern;
  int customOrder = 0;
  bool enabled = true;
  bool enabledExplore = true;
  String? jsLib;
  bool? enabledCookieJar;
  String? concurrentRate;
  String? header;
  String? loginUrl;
  String? loginUi;
  String? loginCheckJs;
  String? coverDecodeJs;
  String? bookSourceComment;
  String? variableComment;
  int lastUpdateTime = 0;
  int respondTime = 180000;
  int weight = 0;
  String? exploreUrl;
  String? exploreScreen;
  String? searchUrl;

  BookSource({
    this.bookSourceUrl = '',
    this.bookSourceName = '',
    this.bookSourceGroup,
    this.bookSourceType = 0,
    this.bookUrlPattern,
    this.customOrder = 0,
    this.enabled = true,
    this.enabledExplore = true,
    this.jsLib,
    this.enabledCookieJar,
    this.concurrentRate,
    this.header,
    this.loginUrl,
    this.loginUi,
    this.loginCheckJs,
    this.coverDecodeJs,
    this.bookSourceComment,
    this.variableComment,
    this.lastUpdateTime = 0,
    this.respondTime = 180000,
    this.weight = 0,
    this.exploreUrl,
    this.exploreScreen,
    this.searchUrl,
  });

  factory BookSource.fromMap(Map<String, dynamic> map) => BookSource(
    bookSourceUrl: map['bookSourceUrl']?.toString() ?? '',
    bookSourceName: map['bookSourceName']?.toString() ?? '',
    bookSourceGroup: map['bookSourceGroup']?.toString(),
    bookSourceType: map['bookSourceType'] as int? ?? 0,
    bookUrlPattern: map['bookUrlPattern']?.toString(),
    customOrder: map['customOrder'] as int? ?? 0,
    enabled: (map['enabled'] as int? ?? 1) == 1,
    enabledExplore: (map['enabledExplore'] as int? ?? 1) == 1,
    jsLib: map['jsLib']?.toString(),
    enabledCookieJar: map['enabledCookieJar'] == 1 ? true : null,
    concurrentRate: map['concurrentRate']?.toString(),
    header: map['header']?.toString(),
    loginUrl: map['loginUrl']?.toString(),
    loginUi: map['loginUi']?.toString(),
    loginCheckJs: map['loginCheckJs']?.toString(),
    coverDecodeJs: map['coverDecodeJs']?.toString(),
    bookSourceComment: map['bookSourceComment']?.toString(),
    variableComment: map['variableComment']?.toString(),
    lastUpdateTime: map['lastUpdateTime'] as int? ?? 0,
    respondTime: map['respondTime'] as int? ?? 180000,
    weight: map['weight'] as int? ?? 0,
    exploreUrl: map['exploreUrl']?.toString(),
    exploreScreen: map['exploreScreen']?.toString(),
    searchUrl: map['searchUrl']?.toString(),
  );

  Map<String, dynamic> toMap() => {
    'bookSourceUrl': bookSourceUrl, 'bookSourceName': bookSourceName,
    'bookSourceGroup': bookSourceGroup, 'bookSourceType': bookSourceType,
    'bookUrlPattern': bookUrlPattern, 'customOrder': customOrder,
    'enabled': enabled ? 1 : 0, 'enabledExplore': enabledExplore ? 1 : 0,
    'jsLib': jsLib, 'enabledCookieJar': enabledCookieJar == true ? 1 : 0,
    'concurrentRate': concurrentRate, 'header': header,
    'loginUrl': loginUrl, 'loginUi': loginUi, 'loginCheckJs': loginCheckJs,
    'coverDecodeJs': coverDecodeJs, 'bookSourceComment': bookSourceComment,
    'variableComment': variableComment, 'lastUpdateTime': lastUpdateTime,
    'respondTime': respondTime, 'weight': weight, 'exploreUrl': exploreUrl,
    'exploreScreen': exploreScreen, 'searchUrl': searchUrl,
  };
}
