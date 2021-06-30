//如果套件有關係到特定平台的話需要重新編譯
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'news.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TSVS NEWS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Mainpage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {

  List<News> data;
  int pages=0;
  var scroolctr = ScrollController();

  @override
  void initState() {
    super.initState();
    setdata();
    scroolctr.addListener((){
      //檢查是否滑到最下面
      if(scroolctr.position.pixels==scroolctr.position.maxScrollExtent){
        setState(()=>pages+=1);
        setdata();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TSVS NEWS'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: (){
              showDialog(
                context: context, 
                builder: (context)=>AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.info_outline),
                      Text('關於此app')
                    ],
                  ),
                  content: Text(
                    '這個App簡易的實現了從東工網站的校園資訊中取得內容，並整理成整齊的頁面'
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text('ok'),
                      onPressed: ()=>Navigator.of(context,rootNavigator: true).pop()
                    )
                  ]
                )
              );
            },
          )
        ],
      ),
      //大致上的流程為: 檢查資料是否為空 ? 是的話顯示轉圈圈動畫 : 不是的話以ListView顯示
      body: data==null 
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
            controller: scroolctr,
            itemCount: data.length,
            itemBuilder: (_,index){
              final news=data[index];
              return ListTile(
                title: Text(news.message),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(news.department),
                    Text(news.date)
                  ],
                ),
                onTap: (){
                  launch(news.link);
                },
              );
            },
            separatorBuilder: (context,index){
              return Divider(height: 1.0);
            },
          )
    );
  }

  void setdata() async{
    if(pages>0){
      for (var item in await getNews(pages)) {
        data.add(item);
      }
    }else{
      data=await getNews(pages);
    }
    setState((){});
  }

  Future<List<News>> getNews(pages) async{
    final dio=new Dio();

    final res=await dio.post(
      'https://tsvs.tc.edu.tw/app/index.php?Action=mobilercglist',
      data: FormData.fromMap({
        "Rcg":"1668",
        "Op":"getpartlist",
        "Page":"$pages",
      })
    );

    List<News> data=[];
    final dataJson=jsonDecode(res.data);
    final rawhtml=dataJson['content'];
    final doc=parse(rawhtml);
    final trs=doc.getElementsByTagName('tr');
    for (var tr in trs) {
      final tds=tr.getElementsByTagName('td');
      if(tds.length<3) continue;
      data.add(
        News(
          tds[0].text.trim(),
          tds[1].text.trim(),
          tds[2].text.trim(),
          tds[1].getElementsByTagName('a').first.attributes['href']
        )
      );
    }
    return data;
  }
}