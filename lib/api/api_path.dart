class ApiPath {
  static const String baseUrl = 'http://192.168.128.246:4000/'; 
  static String SIGNUP = '${baseUrl}user';
  static String CATEGORY = '${baseUrl}category/getAll';
  static String Image = '${baseUrl}upload/show/';
  static String PRODUCT = '${baseUrl}product/getAll';
  static String Search = '${baseUrl}search';
  static String VerifyToken = '${baseUrl}user/verifyToken';
  
}
