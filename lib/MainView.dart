import 'package:practice_2/category_model/category.dart';
import 'package:flutter/material.dart';
import 'package:practice_2/product_model/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class MyMainView extends StatefulWidget {
  @override
  _MyMainViewState createState() => _MyMainViewState();
}

List<Category> categories = new List<Category>();
List<Product> products = new List<Product>();

class _MyMainViewState extends State<MyMainView> {
  Future<List<String>> getdata2() async {
    http.Response response;
    http.Response response2;

    response = await http.get(
        Uri.encodeFull(
            "https://foodapps-57804.firebaseio.com/categories/.json"),
        headers: {"Accept": "application/json"});

    var jsondata = json.decode(response.body);
    print(response.body);
    for (var u in jsondata) {
      categories
          .add(new Category(u["image"], u["category_name"], u["item_count"]));
    }

    /// product
    response2 = await http.get(
        Uri.encodeFull("https://foodapps-57804.firebaseio.com/product/.json"),
        headers: {"Accept": "application/json"});

    var jsondata2 = json.decode(response2.body);
    print(response2.body);
    for (var u in jsondata2) {
      products.add(new Product(u["image"], u["text1"], u["text2"], u["text3"],
          u["text4"], u["price"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: a1(),
      body: b1(),
    );
  }

  AppBar a1() {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.short_text,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ]);
  }

  Column b1() {
    return Column(
      children: [
        searchline(),
        category_list(),
        popularline(),
        listview_product_item()
      ],
    );
  }

  Row searchline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "What do you want\nto eat today?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        )
      ],
    );
  }

  SizedBox category_list() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: FutureBuilder(
          future: getdata2(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(500)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.blueGrey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 30,
                                      offset: Offset(0, 3))
                                ]),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              child: Image.network(
                                categories[index].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(categories[index].category_name,
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                              Text(
                                "" + categories[index].item_count,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Container popularline() {
    return Container(
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.only(left: 10),
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Popular",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Monggo, entekno duwekmu!",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.only(right: 10),
                  icon: Icon(Icons.navigate_next),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Expanded listview_product_item() {
    return Expanded(
      child: Container(
        color: Colors.grey[200],
        child: SizedBox(
          child: FutureBuilder(
              future: getdata2(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ListView.builder(
                  itemCount: products.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.all(17),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            product_image(index),
                            product_info_text(index),
                          ],
                        )),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Expanded product_image(index) {
    return Expanded(
        flex: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.network(
            products[index].image,
            fit: BoxFit.cover,
          ),
        ));
  }

  Expanded product_info_text(index) {
    return Expanded(
      flex: 6,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(products[index].text1,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    height: 20,
                    child: RaisedButton(
                      onPressed: () {},
                      color: Colors.deepOrange[100],
                      shape: StadiumBorder(),
                      child: Text(
                        products[index].text2,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 20,
                    child: RaisedButton(
                      onPressed: () {},
                      color: Colors.lightBlue[100],
                      shape: StadiumBorder(),
                      child: Text(
                        products[index].text3,
                        style: TextStyle(
                            fontSize: 9,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      products[index].text4,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      products[index].price,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
