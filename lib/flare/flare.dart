import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import "package:flare_flutter/flare_actor.dart";

const String ANIM_JUST_FAV = "favorite";
const String ANIM_JUST_REG = "regular";
const String ANIM_FAV_TO_REG = "favorite_to_regular";
const String ANIM_REG_TO_FAV = "regular_to_favorite";

const String COLOR_RED = "red";
const String COLOR_ORANGE = "orange";
const String COLOR_GREEN = "green";

const List colors = [COLOR_GREEN, COLOR_ORANGE, COLOR_RED];

class FlarePage extends StatefulWidget {
  @override
  _FlarePageState createState() => _FlarePageState();
}

class _FlarePageState extends State<FlarePage> with FlareController {
  bool _isFavorite = false;

  String _animation = ANIM_JUST_REG;
  String _color = COLOR_RED;
  List<DropdownMenuItem<String>> _colorItems;

  @override
  void initState() {
    _colorItems = _getColorItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flare",
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 500,
              height: 500,
              child: FlareActor(
                "assets/bike_icon.flr",
                alignment: Alignment.center,
                animation: _animation,
                callback: (String name) {
                  switch (name) {
                    case ANIM_FAV_TO_REG:
                      setState(() {
                        _isFavorite = false;
                        _animation = ANIM_JUST_REG;
                      });
                      break;
                    case ANIM_REG_TO_FAV:
                      setState(() {
                        _isFavorite = true;
                        _animation = ANIM_JUST_FAV;
                      });
                      break;
                  }
                },
                isPaused: !mounted,
                controller: this,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text(_getLabel()),
                  onPressed: () {
                    setState(() {
                      if (_isFavorite) {
                        _animation = ANIM_FAV_TO_REG;
                      } else {
                        _animation = ANIM_REG_TO_FAV;
                      }
                    });
                  },
                ),
                DropdownButton(
                  value: _color,
                  items: _colorItems,
                  onChanged: _changedColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getLabel() {
    if (_isFavorite) {
      return "Unmark";
    } else {
      return "Mark";
    }
  }

  void _changedColor(String color) {
    setState(() {
      _color = color;
    });
  }

  List<DropdownMenuItem<String>> _getColorItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String color in colors) {
      print("added $color");
      items.add(new DropdownMenuItem(value: color, child: new Text(color)));
    }
    return items;
  }

  Color _getColor(String color) {
    if (color == COLOR_GREEN) {
      return Colors.teal;
    } else if (color == COLOR_ORANGE) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  FlutterColorFill _favoriteFill;
  FlutterColorFill _regularFill;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    var realColor = _getColor(_color);
    if (_favoriteFill != null) {
      _favoriteFill.uiColor = realColor;
    }
    if (_regularFill != null) {
      _regularFill.uiColor = realColor;
    }
    return false;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    // Find our "Num 2" shape and get its fill so we can change it programmatically.
    FlutterActorShape favoriteShape = artboard.getNode("Star Shape");
    FlutterActorShape regularShape = artboard.getNode("Regular Shape");
    _favoriteFill = favoriteShape?.fill as FlutterColorFill;
    _regularFill = regularShape?.fill as FlutterColorFill;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
