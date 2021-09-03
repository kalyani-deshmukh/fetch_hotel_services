import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   late StreamController _streamController;
  final _saved = <dynamic>{};  

  //Fetch data from JSON
  Future fetchServices() async {
    var response = await rootBundle.loadString('assets/list.json');
    return json.decode(response);
  }

  loadServices() async{
    fetchServices().then((value) async{
      _streamController.add(value);
      //print(value);
      return value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController= StreamController();
    loadServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services for You'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() {
  return StreamBuilder(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapShot){

        if(snapShot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if(snapShot.hasError){
          return Text('${snapShot.error}');
        }
        else{
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapShot.data.length,
                  itemBuilder: (context,index){
                    var services = snapShot.data[index];
                    var title = services['title'];
                    var icon = services['leading'];
                     return _buildRow(title);              
                      } 
                    ),        
                  ),
            ],
          );
        }    
      }
    );
}
Widget _buildRow( pair) {
  final alreadySaved = _saved.contains(pair);
  return ListTile(
    title: Text(
      pair,
     
    ),
    trailing: Icon(   // NEW from here... 
      alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
      color: alreadySaved ? Colors.red : null,
    ), 
    onTap: () {      // NEW lines from here...
      setState(() {
        if (alreadySaved) {
          _saved.remove(pair);
        } else { 
          _saved.add(pair);
        } 
      });
    }  
  );
}
void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
        final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: Text('Services you want'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }
}