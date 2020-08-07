import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'friend.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 5;
  List<Friend> _friends = [];
  var url = "https://randomuser.me/api/?results=30";

  void initState() {
    super.initState();
    _loadFriendsList();
  }

  _loadFriendsList() async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    var jsonString = await response.transform(utf8.decoder).join();

    setState(() {
      _friends = Friend.resolveDataFromReponse(jsonString);
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> rows =
        List.generate(_counter, (index) => 'index $index');

    return Scaffold(
      appBar: AppBar(title: Text("好友列表"), centerTitle: true),
      body: new ListView.separated(
        padding: const EdgeInsets.all(5.0),
        itemCount: rows.length,
        itemBuilder: _buildItem,
        // itemBuilder: (BuildContext context, int index) {
        //   return Container(
        //     height: 50,
        //     // color: Colors.amber[colorCodes[index]],
        //     child: Center(child: Text(rows[index])),
        //   );
        // },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    var friend = _friends[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(friend.avatar),
      ),
      title: Text(friend.name),
      subtitle: Text(friend.email),
      trailing: Icon(Icons.arrow_right),
    );
  }
}
