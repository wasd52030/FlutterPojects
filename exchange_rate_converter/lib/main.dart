import "dart:convert";
import "package:flutter/material.dart";
import "package:dio/dio.dart";
import "package:sprintf/sprintf.dart";

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Exchange Rate Converter",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExchangeRateConverter(title: "簡易匯率換算器"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExchangeRateConverter extends StatefulWidget {
  ExchangeRateConverter({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExchangeRateConverterState createState() => _ExchangeRateConverterState();
}

class _ExchangeRateConverterState extends State<ExchangeRateConverter> {
  List<DropdownMenuItem<String>> _ratelist;
  String _comb1Value, _comb2Value, _originRate = "", _changeResult = "";
  TextEditingController _textbox1 = TextEditingController();

  @override
  void initState() {
    super.initState();
    setcombolst();
    _textbox1.text = "0";
  }

  List<DropdownMenuItem<String>> setcomboItems(List<String> data) {
    List<DropdownMenuItem<String>> items = [];
    for (String rate in data) {
      final drop = DropdownMenuItem(
          value: rate, 
          child: Text(rate, style: TextStyle(fontSize: 20))
      );
      items.add(drop);
    }
    return items;
  }

  Future<Map> getdata() async {
    final res = await Dio().get("https://tw.rter.info/capi.php");
    Map datajson = json.decode(res.data);
    return datajson;
  }

  void setcombolst() async {
    List<String> combolst = [];
    final d = await getdata();
    d.forEach((k, v) {
      String x = k;
      RegExp reg = RegExp("USD.*");
      if (reg.hasMatch(x)) {
        final n = x.substring(3, x.length);
        if (n != "") {
          combolst.add(n);
        }
      }
    });
    combolst.sort();
    _ratelist = setcomboItems(combolst);
    setState(() {
      _comb1Value = _ratelist[0].value;
      _comb2Value = _ratelist[1].value;
      _originRate = sprintf("%.4f %s", [0.0, _comb1Value]);
      _changeResult = sprintf("%.4f %s", [0.0, _comb2Value]);
    });
  }

  void exchange(String text) async {
    double a = double.parse(_textbox1.text);
    final d = await getdata();

    if (_comb2Value == "USD") {
      a /= d["USD$_comb1Value"]["Exrate"];
    } else {
      a /= d["USD$_comb1Value"]["Exrate"];
      a *= d["USD$_comb2Value"]["Exrate"];
    }

    setState(() {
      _originRate = sprintf("%.4f %s", [double.parse(_textbox1.text), _comb1Value]);
      _changeResult = sprintf("%.4f %s", [a, _comb2Value]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.info_outlined),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.info_outline),
                              Text("關於此app")
                            ],
                          ),
                          content: Text("資料來源：https://tw.rter.info/capi.php"),
                          actions: [
                            ElevatedButton(
                                child: Text('ok'),
                                onPressed: ()=>Navigator.of(context, rootNavigator: true).pop()
                              )
                            ]
                          )
                        )
                     )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "將"),
              keyboardType: TextInputType.number,
              controller: _textbox1,
              onChanged: exchange,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("自", style: TextStyle(fontSize: 20)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 0, 10),
                  child: DropdownButton(
                    items: _ratelist,
                    value: _comb1Value,
                    onChanged: (String selected) {
                      setState(() {
                        _comb1Value = selected;
                      });
                      exchange("");
                    },
                  ),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    String temp = _comb1Value;
                    _comb1Value = _comb2Value;
                    _comb2Value = temp;
                  });
                  exchange("");
                },
                child: Text("⇅", style: TextStyle(fontSize: 20))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("轉換成", style: TextStyle(fontSize: 20)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 0, 10),
                  child: DropdownButton(
                    items: _ratelist,
                    value: _comb2Value,
                    onChanged: (String selected) {
                      setState(() {
                        _comb2Value = selected;
                      });
                      exchange("");
                    },
                  ),
                )
              ],
            ),
            Text(_originRate, style: TextStyle(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text("↓", style: TextStyle(fontSize: 20)),
            ),
            Text(_changeResult, style: TextStyle(fontSize: 20))
          ],
        ),
      ),
    );
  }
}
