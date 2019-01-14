/*
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gss_flutter/card_data.dart';
import 'package:gss_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GssApp extends InheritedWidget {
  bool isDark = false;

  GssApp({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static GssApp of(BuildContext context) {
    //return context.ancestorStateOfType(const TypeMatcher<GssApp>()) as GssApp;
    return context.inheritFromWidgetOfExactType(GssApp) as GssApp;
  }

  @override
  bool updateShouldNotify(GssApp old) {
    return true;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class BottomBarModel extends InheritedWidget {
  final int cardCount;
  final double scrollPercent;

  BottomBarModel(
      {Key key, this.cardCount, this.scrollPercent, @required Widget child})
      : super(key: key, child: child);

  static BottomBarModel of(BuildContext context) {
    //return context.ancestorStateOfType(const TypeMatcher<GssApp>()) as GssApp;
    return context.inheritFromWidgetOfExactType(BottomBarModel)
        as BottomBarModel;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  double scrollPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Test"),),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: CardFlipper(
              demoCards: demoCards,
              onScroll: (double scrollPercent) {
                setState(() {

                  this.scrollPercent = scrollPercent;
                });
              },
            ),
          ),
          BottomBarModel(
            cardCount: demoCards.length,
            scrollPercent: scrollPercent,
            child: BottomBar(),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 5.0,
              child: ScrollIndicator(
                cardCount: BottomBarModel.of(context).cardCount,
                scrollPercent: BottomBarModel.of(context).scrollPercent,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  final CardViewModel viewModel;
  final double parallaxPercent;

  const Card({Key key, this.viewModel, this.parallaxPercent = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            child: FractionalTranslation(
              translation: Offset(parallaxPercent * 2.0, 0.0),
              child: OverflowBox(
                maxWidth: double.infinity,
                child: Image.asset(
                  '${viewModel.backdropAssetPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: Text(
                  "${viewModel.address}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'petita',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ),
              new Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${viewModel.minHeightInFeet} - ${viewModel.maxHeightInFeet}",
                    style: TextStyle(
                      fontSize: 140,
                      color: Colors.white,
                      fontFamily: 'petita',
                      letterSpacing: -5.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 30.0),
                    child: Text(
                      "Ft",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontFamily: 'petita',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.wb_sunny,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "${viewModel.tempInDegrees}°",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'petita',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  )
                ],
              ),
              new Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0, top: 50.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "${viewModel.weatherType}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'petita'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Icon(
                            Icons.wb_cloudy,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${viewModel.windSpeedInMph}mph ${viewModel.cardinalDirection}',
                          style: TextStyle(
                            fontFamily: 'petita',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardFlipper extends StatefulWidget {
  final List<CardViewModel> demoCards;
  final Function(double scrollPercent) onScroll;

  const CardFlipper({Key key, this.demoCards, this.onScroll}) : super(key: key);

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper>
    with TickerProviderStateMixin {
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishAnimationController;

  @override
  void initState() {
    finishAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
    )..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(finishScrollStart, finishScrollEnd,
              finishAnimationController.value);
          if (widget.onScroll != null) {
            widget.onScroll(scrollPercent);
          }
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    this.finishAnimationController.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final currentDrag = details.globalPosition;
    final dragDistance = currentDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    setState(() {
      scrollPercent = (startDragPercentScroll +
              (-singleCardDragPercent / widget.demoCards.length))
          .clamp(0.0, 1.0 - (1 / widget.demoCards.length));

      if (widget.onScroll != null) {
        widget.onScroll(scrollPercent);
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    finishScrollStart = scrollPercent;
    finishScrollEnd = (scrollPercent * widget.demoCards.length).round() /
        widget.demoCards.length;
    finishAnimationController.forward(from: 0.0);

    setState(() {
      startDragPercentScroll = null;
      startDrag = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildCards(),
    );
  }

  List<Widget> _buildCards() {
    int index = -1;
    return widget.demoCards.map((CardViewModel cardViewModel) {
      ++index;
      return buildCard(
          cardViewModel, index, widget.demoCards.length, scrollPercent);
    }).toList();
    */
/*  return [
      buildCard(0, 3, scrollPercent),
      buildCard(1, 3, scrollPercent),
      buildCard(2, 3, scrollPercent),
    ];*//*

  }

  Widget buildCard(CardViewModel cardViewModel, int cardIndex, int cardCount,
      double scrollPercent) {
    final cardScrollPercent = scrollPercent / (1 / cardCount);
    final parallax = scrollPercent - (cardIndex / cardCount);

    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onHorizontalDragStart: _onHorizontalDragStart,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          behavior: HitTestBehavior.translucent,
          child: Transform(
            transform: _buildCardProjection(cardScrollPercent - cardIndex),
            alignment: FractionalOffset.center,
            child: Card(
              viewModel: cardViewModel,
              parallaxPercent: parallax,
            ),
          ),
        ),
      ),
    );
  }

  Matrix4 _buildCardProjection(double scrollPercent) {
    // Pre-multiplied matrix of a projection matrix and a view matrix.
    //
    // Projection matrix is a simplified perspective matrix
    // http://web.iitd.ac.in/~hegde/cad/lecture/L9_persproj.pdf
    // in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, 0.0],
    //  [0.0, 0.0, -perspective, 1.0]]
    //
    // View matrix is a simplified camera view matrix.
    // Basically re-scales to keep object at original size at angle = 0 at
    // any radius in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, -radius],
    //  [0.0, 0.0, 0.0, 1.0]]
    final perspective = 0.002;
    final radius = 1.0;
    final angle = scrollPercent * pi / 16;
    final horizontalTranslation = 0.0;
    Matrix4 projection = new Matrix4.identity()
      ..setEntry(0, 0, 1 / radius)
      ..setEntry(1, 1, 1 / radius)
      ..setEntry(3, 2, -perspective)
      ..setEntry(2, 3, -radius)
      ..setEntry(3, 3, perspective * radius + 1.0);

    // Model matrix by first translating the object from the origin of the world
    // by radius in the z axis and then rotating against the world.
    final rotationPointMultiplier = angle > 0.0 ? angle / angle.abs() : 1.0;
    print('Angle: $angle');
    projection *= new Matrix4.translationValues(
        horizontalTranslation + (rotationPointMultiplier * 300.0), 0.0, 0.0) *
        new Matrix4.rotationY(angle) *
        new Matrix4.translationValues(0.0, 0.0, radius) *
        new Matrix4.translationValues(-rotationPointMultiplier * 300.0, 0.0, 0.0);

    return projection;

  }


}


class ShowTest extends StatefulWidget {
  @override
  _ShowTestState createState() => _ShowTestState();
}



class _ShowTestState extends State<ShowTest> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: MyApp.of(context).theme,
          onChanged: (isChecked) async {
            setState(() {
              MyApp.of(context).setTheme(isChecked);
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('app_theme', isChecked);
          },
        ),
        Text("Is Dark ? "),
      ],
    );
    //return Text(GssApp.of(context).isDark.toString());
  }
}

class ScrollIndicator extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  ScrollIndicator({
    this.cardCount,
    this.scrollPercent,
  });

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new ScrollIndicatorPainter(
        cardCount: cardCount,
        scrollPercent: scrollPercent,
      ),
      child: new Container(),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final int cardCount;
  final double scrollPercent;

  final Paint trackPaint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.fill;
  final Paint thumbPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  ScrollIndicatorPainter({this.cardCount, this.scrollPercent});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(0.0, 0.0, size.width, size.height,
          topLeft: Radius.circular(3.0),
          topRight: Radius.circular(3.0),
          bottomLeft: Radius.circular(3.0),
          bottomRight: Radius.circular(3.0)),
      trackPaint,
    );

    final thumbWidth = size.width / cardCount;
    final thumbLeft = scrollPercent * size.width;

    print(" tuumb left : ${thumbLeft} ");
    print(" scrollPercent : ${scrollPercent} ");
    print(" thumb Width : ${thumbWidth} ");
    print(" rect ${ RRect.fromLTRBAndCorners(thumbLeft,0.0,thumbWidth,size.height)}");

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(thumbLeft, 0.0, thumbLeft + thumbWidth, size.height,
          topLeft: Radius.circular(3.0),
          topRight: Radius.circular(3.0),
          bottomLeft: Radius.circular(3.0),
          bottomRight: Radius.circular(3.0)),
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
*/
