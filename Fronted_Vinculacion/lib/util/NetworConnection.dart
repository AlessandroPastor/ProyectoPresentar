import 'package:data_connection_checker_tv/data_connection_checker.dart';

Future<bool> isConected() async{
  return await DataConnectionChecker().hasConnection;
}