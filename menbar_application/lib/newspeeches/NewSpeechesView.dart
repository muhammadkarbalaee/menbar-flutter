import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:menbar_application/newspeeches/NewSpeechInstance.dart';
import 'dart:convert';

import  'package:persian_number_utility/persian_number_utility.dart';


class NewSpeeches extends StatelessWidget {

  List orators;
  List collections;
  NewSpeeches(this.orators,this.collections);

  Future<List> _getData() async {

    String apiUrl = 'http://menbar.sobhe.ir/api/sokhanranis/';
    http.Response collectionsResponse = await http.get(Uri.parse(apiUrl));
    List news = json.decode(utf8.decode(collectionsResponse.bodyBytes));
    return news;
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

          body: FutureBuilder(

            future: _getData(),

            builder: (BuildContext context,AsyncSnapshot snapshot){

              if(snapshot.data == null){
                return Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              else {

                return ListView.builder(

                  itemCount: snapshot.data.length,

                  itemBuilder: (context,index) {

                    return GestureDetector(

                      child: Container(

                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 100,),
                                  Text(
                                    getDateTime(snapshot.data[index]["performed_at"]).toPersianDateStr(showDayStr: true),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        snapshot.data[index]['title'],
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        getName(snapshot.data[index]['sokhanran']),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 120,
                                child: Image.network(getImage(snapshot.data[index]['collection'])),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => NewSpeechInstance(getImage(snapshot.data[index]['collection']))
                        )
                        );
                      },
                    );
                  },
                );
              }
            },
          )
      ),
    );
  }

  String getName(String oratorUrl) {

    List splited = oratorUrl.split("/");
    String  oratorID = splited[splited.length - 2];
    String oratorName = findNameByID(oratorID);

    return oratorName;
  }

  String findNameByID(String oratorID) {

    String name = 'failed to find';

    for(var orator in orators){
      if(orator['id'].toString() == oratorID){
        name = orator['title'];
      }
    }

    return name;
  }

  String getImage(speechUrl) {
    List splited = speechUrl.split("/");
    String  collectionID = splited[splited.length - 2];
    String collectionImage = findImageByID(collectionID);

    return collectionImage;
  }

  String findImageByID(String collectionID) {
    String image = 'failed to find';

    for(var collection in collections){
      if(collection['id'].toString() == collectionID){
        image = collection['image'];
      }
    }

    return image;
  }

  DateTime getDateTime(String date) {
    List splited = date.split('-');
    var year = int.parse(splited[0]);
    var month = int.parse(splited[1]);
    var day = int.parse(splited[2]);
    DateTime result = DateTime(year,month,day);
    return result;
  }

}