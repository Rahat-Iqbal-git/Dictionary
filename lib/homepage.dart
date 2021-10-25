import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class sub_dictionary extends StatefulWidget {
  // const sub_dictionary({ Key? key }) : super(key: key);

  @override
  _sub_dictionaryState createState() => _sub_dictionaryState();
}

class _sub_dictionaryState extends State<sub_dictionary> {
  String url = "https://owlbot.info/api/v4/dictionary/";
  String token = "0e2f85eda82d5f8bb2b20c6bc6595c03203720ed";

  TextEditingController _textEditingController = TextEditingController();

  StreamController _streamController;
  Stream _stream;

  Timer _timer;

  searchtext() async {
    if (_textEditingController.text == null ||
        _textEditingController.text.length == 0) {
      _streamController.add(null);
      return;
    }
    _streamController.add("waiting");
    http.Response response =
        await http.get(Uri.parse(url+ _textEditingController.text.trim()));
    // response.headers:{"Authorization" : "Token "+ toke};
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    // TODO: implement initState

    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text(
          "The Dictionary",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Center(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    onChanged: (String text) {
                      if (_timer?.isActive ?? false) _timer?.cancel();
                      _timer = Timer(const Duration(milliseconds: 1000), () {
                        searchtext();
                      });
                    },
                    controller: _textEditingController,

                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: " Search your word here",
                    ), //TO DO
                  ),
                )),
                IconButton(
                    onPressed: () {
                      searchtext();
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment(0.0, -1.0),
        margin: EdgeInsets.all(5),
        child: StreamBuilder(
          builder: (BuildContext context,
          AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(
                child: Text("Search something"),
              ); 
            };
            if(snapshot.data == "waiting"){
              return Center(
                child: CircularProgressIndicator(),
              );
            };
            return ListView.builder(
              itemCount: snapshot.data["definitions"]?.length,
              itemBuilder: (BuildContext context, int index){
                return ListBody(
                  children: [
                    Container(
                      color: Colors.grey,
                      child: ListTile(
                        leading: snapshot.data["definitions"]["image_url"]== null ? null:
                        CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data["definitions"][index]["image_url"]),
                        ),
                        title: Text(_textEditingController.text.trim() + "(" + snapshot.data["definitions"][index]["type"]+ ")",),

                      ),),
                      Padding(padding: 
                      const EdgeInsets.all(8),
                      child: 
                      Text(snapshot.data["definitions"][index]["definitions"]))
                  ],
                );
              },
            );
           
          },
           stream : _stream,
           )
        // Container(
        //   height: 200,
        //   width: 350,
        //   margin: EdgeInsets.all(7),
        //   padding: EdgeInsets.all(15),
        //   decoration: BoxDecoration(
        //     color: Colors.purple[100],
        //     borderRadius: BorderRadius.circular(5),
        //   ),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "happy",
        //         style: TextStyle(
        //           color: Colors.black87,
        //           // fontFamily:
        //           // fontWeight: FontWeight.bold,
        //           fontSize: 20,
        //           // fontFamily: 'RobotoMono',
        //         ),
        //       ),
        //       SizedBox(
        //         height: 15,
        //       ),
        //       Text(
        //         "-adjective",
        //         style: TextStyle(
        //           fontStyle: FontStyle.italic,
        //           color: Colors.white,
        //         ),
        //       ),
        //       SizedBox(
        //         height: 8,
        //       ),
        //       Text(
        //         "1.  feeling or showing pleasure or contentment.",
        //         style: TextStyle(
        //           color: Colors.black87,
        //           // fontFamily:
        //           // fontWeight: FontWeight.bold,
        //           // fontSize: 20,
        //           // fontFamily: 'RobotoMono',
        //         ),
        //       ),
        //       SizedBox(
        //         height: 5,
        //       ),
        //       Text(
        //         "Example - Melissa came in looking happy and excited",
        //         style: TextStyle(
        //           color: Colors.black87,
        //           // fontFamily:
        //           // fontWeight: FontWeight.bold,
        //           fontSize: 11,
        //           fontStyle: FontStyle.italic,
        //           // fontFamily: 'RobotoMono',
        //         ),
        //       ),
        //       SizedBox(
        //         height: 11,
        //       ),
        //       Text(
        //         "2.  fortunate and convenient.",
        //         style: TextStyle(
        //           color: Colors.black87,
        //           // fontFamily:
        //           // fontWeight: FontWeight.bold,
        //           // fontSize: 20,
        //           // fontFamily: 'RobotoMono',
        //         ),
        //       ),
        //       SizedBox(
        //         height: 5,
        //       ),
        //       Text(
        //         "Example - he had the happy knack of making people like him",
        //         style: TextStyle(
        //           color: Colors.black87,
        //           // fontFamily:
        //           // fontWeight: FontWeight.bold,
        //           fontSize: 11,
        //           fontStyle: FontStyle.italic,
        //           // fontFamily: 'RobotoMono',
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple[300],
        selectedItemColor: Colors.white,
        // unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            title: Text("Home"),
            // backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Favourite words"),
            // backgroundColor: Colors.black,
          )
        ],
      ),
    );
  }
}
