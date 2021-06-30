import 'package:mysql1/mysql1.dart';
class SqlConnect {
  
  MySqlConnection conn;
  Future sqlInitial() async {
      var s = ConnectionSettings(
        host: '192.168.116.1', 
        port: 3306, 
        user: 'a',
        password: '123456', 
        db: 'n'
      );

      await MySqlConnection.connect(s).then((_) {
        this.conn = _;
        print('連接成功');
      });
  }
}