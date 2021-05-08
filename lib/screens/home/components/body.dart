import 'dart:convert';

import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz_info.dart';
import 'package:amrita_quizzes/screens/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'categorries.dart';
import 'quiz_card.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List test = [];
  String SelectedCategory = "CSE";
  int selectedIndex = 0;


  Future<void> readJsonProducttemp() async {
    final String response = await rootBundle.loadString('assets/QuizInfo.json');
    final data = await json.decode(response);
    //_items = data["Categories"];
    setState(() {
      test = data["QuizInfo"];
      products.clear();
      productstest.clear();

      //print(test);
      for (int i = 0; i < test.length; i++) {
        var tempid = int.parse(test[i]["id"]);
        var temptitle = test[i]["title"];
        var tempprice = test[i]["price"];
        var tempsize = test[i]["size"];
        var tempimage = test[i]["image"];
        var tempcolor = Color(int.parse(test[i]["colorcode"]));
        //var tempdescription = test[i]["description"];
        var tempdescription ="This quiz will assess your knowledge on the topics covered in the first four weeks of the semester. Marks will be taken into account for continuous assessment.";
        var tempfaculty = test[i]["faculty"];
        var tempmarks = test[i]["marks"];
        var tempduration = test[i]["duration"];

        var temp_quiz_info = Quiz_info(
            id: tempid,
            title: temptitle,
            price: tempprice,
            size: tempsize,
            image: tempimage,
            color: tempcolor,
            description: tempdescription,
            faculty: tempfaculty,
            marks: tempmarks,
            duration: tempduration);

        if(test[i]["category"] == SelectedCategory) {
          productstest.add(temp_quiz_info);
          products.add(temp_quiz_info);
          print(temp_quiz_info.image);
          print(SelectedCategory);
        }
        //productstest.add(temp_quiz_info);

        //products.add(temp_quiz_info);// comment this later, used for test

        //print(temp_quiz_info.image);
        //print(SelectedCategory);

    }
    });
  }

  callback(newSelectedCategory) {
    setState(() {
      SelectedCategory = newSelectedCategory;
      readJsonProducttemp();
    });
  }


  @override
  void initState() {
    super.initState();
    readJsonProducttemp();
  }

  @override
  Widget build(BuildContext context) {
    return quizDisplay();
  }

  Widget quizDisplay(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Text(
            "$SelectedCategory Quizzes ",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        Categories(SelectedCategory, callback),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPaddin,
                  crossAxisSpacing: kDefaultPaddin,
                  childAspectRatio: 0.75 ,
                ),
                itemBuilder: (context, index) => ItemCard(
                  quiz_info: products[index],
                  press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          quiz_info: products[index],
                        ),
                      )),
                )),
          ),
        ),
      ],
    );
  }
}
