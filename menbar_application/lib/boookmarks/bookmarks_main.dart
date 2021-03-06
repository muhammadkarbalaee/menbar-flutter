import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:menbar_application/collections/collection_speeches_widget.dart';
import 'package:menbar_application/managers/hive_manager.dart';


class Bookmarks extends StatelessWidget {
  List orators;
  Bookmarks(this.orators);

  Future<Iterable> _getData() async {
    Iterable values = await HiveManager.getBookmarkBoxValues();
    List collections = [];
    for(var i in values){
      collections.add(i);
    }
    return collections;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(
                  child: CircularProgressIndicator()
              );
            }
            else {
              return GridView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,index) {
                  return GestureDetector(
                    child: Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        elevation: 20,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data[index]['image'],
                                fadeInDuration:Duration(milliseconds: 500),
                                fadeInCurve:Curves.easeInExpo,
                              ),
                            ),
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black,
                                        ]
                                    )
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10,bottom: 10),
                                  child: Container(
                                    height: 50,
                                    width: 1000,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                snapshot.data[index]['title'],
                                                textDirection: TextDirection.rtl,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily: 'sans'
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                snapshot.data[index]["sokhanran"],
                                                textDirection: TextDirection.rtl,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily: 'sans'
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
                          builder: (context) => CollectionInstance(
                            snapshot.data[index]['image'],
                            snapshot.data[index]['title'],
                            snapshot.data[index]['id'],
                            snapshot.data[index]['is_squenced'],
                            snapshot.data[index]["sokhanran"],
                            snapshot.data[index]["origin_url"],
                            snapshot.data[index]['downloads'],
                          ),
                          fullscreenDialog: true
                      )
                      );
                    },
                  );
                }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              );
            }
          },
        )
    );
  }
}