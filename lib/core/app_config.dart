class AppConfig {
  static const bool useSandbox = true; // set false untuk production
  static const String sandboxUrl = 'http://192.168.1.100:8000';
  static const String productionUrl = 'https://api.produkmu.com';
  static String get baseUrl => useSandbox ? sandboxUrl : productionUrl;

  static String categoriesEndpoint() => '$baseUrl/api/categories';
  static String productsEndpoint({int page = 1}) =>
      '$baseUrl/api/products?page=$page';
}
