import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'FIREBASE_DATABASE_URL', obfuscate: true)
  static  String databaseURL = _Env.databaseURL;
  @EnviedField(varName: 'FIREBASE_API_KEY_IOS', obfuscate: true)
  static  String apiKeyIos = _Env.apiKeyIos;
  @EnviedField(varName: 'FIREBASE_API_KEY_ANDROID', obfuscate: true)
  static  String apiKeyAndroid = _Env.apiKeyAndroid;
  @EnviedField(varName: 'FIREBASE_APP_ID_ANDROID', obfuscate: true)
  static String appIdAndroid = _Env.appIdAndroid;
  @EnviedField(varName: 'FIREBASE_APP_ID_IOS', obfuscate: true)
  static String appIdIOS = _Env.appIdIOS;
  @EnviedField(varName: 'MESSAGINGSENDERID', obfuscate: true)
  static String messagingSenderId = _Env.messagingSenderId;

}