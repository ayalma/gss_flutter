import 'package:flutter/material.dart';
import 'package:gss_flutter/pages/my_overlap_injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _tabs = ["first", "second", "third"];

  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
        child: NestedScrollView(headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              // This widget takes the overlapping behavior of the SliverAppBar,
              // and redirects it to the SliverOverlapInjector below. If it is
              // missing, then it is possible for the nested "inner" scroll view
              // below to end up under the SliverAppBar even when the inner
              // scroll view thinks it has not been scrolled.
              // This is not necessary if the "headerSliverBuilder" only builds
              // widgets that do not overlap the next sliver.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                title: const Text('Suggestion system'),
                // This is the title in the app bar.
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    "assets/board_walk.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                expandedHeight: 250.0,
                // The "forceElevated" property causes the SliverAppBar to show
                // a shadow. The "innerBoxIsScrolled" parameter is true when the
                // inner scroll view is scrolled beyond its "zero" point, i.e.
                // when it appears to be scrolled below the SliverAppBar.
                // Without this, there are cases where the shadow would appear
                // or not appear inappropriately, because the SliverAppBar is
                // not actually aware of the precise position of the inner
                // scroll views.
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        }, body: Builder(
          // This Builder is needed to provide a BuildContext that is "inside"
          // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
          // find the NestedScrollView.
          builder: (BuildContext context) {
            return Column(

              children: <Widget>[
                MyOverlapInjector(
                  handle:
                  NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        subtitle: Text("hello"),
                        title: Text("test"),
                      ),
                      TabBar(
                        indicatorColor: Theme.of(context).accentColor,
                        labelColor: Theme.of(context).textTheme.button.color,
                        // These are the widgets to put in each tab in the tab bar.
                        tabs: _tabs
                            .map((String name) => Tab(text: name))
                            .toList(),
                      )
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: TabBarView(
                    // These are the contents of the tab views, below the tabs.
                    children: _tabs.map((String name) {
                      return SafeArea(
                        top: false,
                        bottom: false,
                        child: CustomScrollView(
                          // The "controller" and "primary" members should be left
                          // unset, so that the NestedScrollView can control this
                          // inner scroll view.
                          // If the "controller" property is set, then this scroll
                          // view will not be associated with the NestedScrollView.
                          // The PageStorageKey should be unique to this ScrollView;
                          // it allows the list to remember its scroll position when
                          // the tab view is not on the screen.
                          key: PageStorageKey<String>(name),
                          slivers: <Widget>[
                            SliverPadding(
                              padding: const EdgeInsets.all(8.0),
                              // In this example, the inner scroll view has
                              // fixed-height list items, hence the use of
                              // SliverFixedExtentList. However, one could use any
                              // sliver widget here, e.g. SliverList or SliverGrid.
                              sliver: SliverFixedExtentList(
                                // The items in this example are fixed to 48 pixels
                                // high. This matches the Material Design spec for
                                // ListTile widgets.
                                itemExtent: 48.0,
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    // This builder is called for each child.
                                    // In this example, we just number each list item.
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        icon:
                                            Icon(Icons.add, color: Colors.red),
                                        onPressed: () {},
                                        color: Colors.amber,
                                        highlightColor: Colors.indigo,
                                        splashColor: Colors.indigo,
                                      ),
                                    );
                                  },
                                  // The childCount of the SliverChildBuilderDelegate
                                  // specifies how many children this inner list
                                  // has. In this example, each tab has a list of
                                  // exactly 30 items, but this is arbitrary.
                                  childCount: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        )),
      ),
    );
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              padding: EdgeInsets.zero,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "http://mostbeautifulworld.com/images/rankings_images/most-beautiful-tom-cruise-1.jpg"))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('first'),
              leading: CircleAvatar(child: Icon(Icons.dashboard)),
            ),
            ListTile(
              title: Text('first'),
              onTap: () {},
              leading: CircleAvatar(child: Icon(Icons.phone_android)),
            ),
            ListTile(
              title: Text('first'),
              leading: CircleAvatar(child: Icon(Icons.close)),
            )
          ],
        ),
      ),
      body: new CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          title: const Text('Sliver App Bar'),
          bottom: PreferredSize(
              child: Column(
                children: <Widget>[
                  _headerView(context),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      //border: Border.all(width: 1.0, color: Colors.white),
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(32.0),
                      //boxShadow: [BoxShadow(color: Colors.grey,offset: Offset.zero,blurRadius: 2.0,spreadRadius: 1.0)]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Chip(
                          backgroundColor: Colors.black12,
                          label: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "1.6 K",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  " Total ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        Chip(
                          backgroundColor: Colors.black12,
                          label: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "1.0 K",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "confirmed",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        Chip(
                          backgroundColor: Colors.black12,
                          label: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "1.6 K",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "rejected",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(250)),
          floating: false,
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 16.0),
          sliver: SliverList(
            delegate: new SliverChildListDelegate(
              buildTextViews(50, context),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 4.0, spreadRadius: 2)
        ]),
        child: BottomNavigationBar(
          onTap: (index) {
            print(index);
          },
          type: BottomNavigationBarType.fixed,
          fixedColor: Theme.of(context).primaryColor,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.cast), title: Text("Garrison")),
            BottomNavigationBarItem(
                icon: Icon(Icons.remove_from_queue), title: Text("Request's")),
            BottomNavigationBarItem(
                icon: Icon(Icons.memory), title: Text("Memory's")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Profile")),
          ],
        ),
      ),
    );
  }

  _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('access_token', "");
  }

  Widget _headerView(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          // color: Colors.black12,
          // border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 120.0,
              height: 120.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          "https://www.indiewire.com/wp-content/uploads/2018/02/screen-shot-2018-02-27-at-11-07-34-am.png?w=780"))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Ali Mohammadi",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        onPressed: () {},
                        icon: Icon(Icons.people),
                        label: Text("Profile"),
                        textColor: Colors.white,
                        color: Colors.white54,
                      ),
                    ),
                    RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      color: Colors.red,
                      onPressed: () {},
                      icon: Icon(Icons.exit_to_app),
                      label: Text("Exit"),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Image.network("http://www.sabzafzar.com/images/sabzimg/danesh/sabzafzar-danesh-bonyan.jpg",fit: BoxFit.fitWidth,width: 150,height: 150,)
        ],
      ),
    );
  }

  List buildTextViews(int count, BuildContext context) {
    List<Widget> strings = List();
    /*for (int i = 0; i < count; i++) {
      strings.add(new Padding(
          padding: new EdgeInsets.all(16.0),
          child: Card(
            child: new Text("Item number " + i.toString(),
                style: new TextStyle(fontSize: 20.0)),
          )));
    }*/
    strings.add(
      Padding(
        padding: const EdgeInsets.only(left: 8, top: 4.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "News",
              style: TextStyle(fontSize: 18),
            ),
            FlatButton(
              onPressed: () {},
              child: Text("More ... "),
            )
          ],
        ),
      ),
    );
    strings.add(Container(
      margin: EdgeInsets.all(8.0),
      height: 350,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: 'img',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                "https://cdn.cheapism.com/images/011618_most_beautiful_views_in_the_world_sli.max-784x410.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /*  Text(
                "This is title",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
              Expanded(
                child: Container(),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: Colors.black38,
                      onPressed: () {
                        _showDetailDialoag(context);
                      },
                      icon: Icon(Icons.details),
                      label: Text("Show details"),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 32.0, right: 32.0, top: 16.0, bottom: 8.0),
                width: double.infinity,
                height: 5.0,
                child: ScrollIndicator(
                  cardCount: 5,
                  scrollPercent: 0.0,
                ),
              ),
            ],
          ),
        ],
      ),
    ));

    strings.add(
      Padding(
        padding: const EdgeInsets.only(left: 8, top: 4.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "My proposal's",
              style: TextStyle(fontSize: 18),
            ),
            FlatButton(
              onPressed: () {},
              child: Text("More ... "),
            )
          ],
        ),
      ),
    );

    strings.add(
      Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 200,
        child: Center(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                  ),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Title goes here dfdfdf ddfsdfd ",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(
                          backgroundColor: Colors.white,
                          label: Text(
                            "status goes here",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("1397/02/03"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("#252526"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                  ),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Title goes here dfdfdf ddfsdfd ",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(
                          backgroundColor: Colors.white,
                          label: Text(
                            "status goes here",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("1397/02/03"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("#252526"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                  ),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Title goes here dfdfdf ddfsdfd ",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(
                          backgroundColor: Colors.white,
                          label: Text(
                            "status goes here",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("1397/02/03"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("#252526"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    strings.add(
      Padding(
        padding: const EdgeInsets.only(left: 8, top: 4.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Report's",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );

    strings.add(
      Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 80,
        child: Center(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0))),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("reports name goes here"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "887",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0))),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("reports name goes here"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "887",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0))),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("reports name goes here"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "887",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0))),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("reports name goes here"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "887",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return strings;
  }

  void _showDetailDialoag(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          /*return Column(children: <Widget>[
          Stack(fit: StackFit.expand,children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                "https://cdn.cheapism.com/images/011618_most_beautiful_views_in_the_world_sli.max-784x410.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ],)

      ],);*/
          final List<Widget> body = <Widget>[];

          body.add(
            Hero(
              tag: 'img',
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                child: Image.network(
                  "https://cdn.cheapism.com/images/011618_most_beautiful_views_in_the_world_sli.max-784x410.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );

          body.add(Flexible(
              child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Title goes here!!",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('''
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porta eget dui vel porta. Cras tincidunt dapibus ligula non pharetra. Nam nec auctor est. Sed iaculis orci id velit condimentum pulvinar. Morbi ut velit lorem. Sed a purus sollicitudin, iaculis eros ac, sollicitudin massa. Aliquam accumsan, ante sit amet dignissim blandit, orci turpis ullamcorper orci, et pulvinar turpis tortor et nisl. Nullam malesuada consectetur elit. Aenean sodales erat nibh. Ut ut suscipit ante, vitae vulputate mauris. Fusce condimentum ex eu urna porta, sit amet bibendum dolor vehicula.

Cras eget ligula in purus efficitur dapibus et sed risus. Donec vestibulum dapibus aliquam. Praesent imperdiet ultrices enim, vel pulvinar odio lobortis sed. Ut ac dui arcu. Aenean non sapien condimentum, congue enim at, sollicitudin turpis. Phasellus faucibus est auctor, placerat lorem vitae, condimentum turpis. Donec turpis libero, sagittis eu tortor hendrerit, viverra euismod metus. Nunc feugiat sem volutpat, convallis risus sed, finibus ex. Aenean accumsan orci ut eros tempus, vitae tempor velit fringilla. Cras sed pulvinar ex. Suspendisse eleifend est elementum felis varius posuere sit amet porta libero. Cras vel libero ac sapien aliquam venenatis id ac sapien. In eros augue, ullamcorper a facilisis nec, tristique ac diam. Morbi sagittis sodales eros nec iaculis. Vestibulum laoreet, enim quis faucibus interdum, est erat finibus ante, sed viverra tellus nibh quis massa. Proin nec risus velit.

Aliquam ultrices sit amet justo auctor ullamcorper. Aenean sed semper velit, id fermentum lectus. Etiam et felis ligula. Nam elementum consequat mauris. Cras dolor nibh, fermentum nec nibh nec, placerat ultrices nunc. Vivamus hendrerit sit amet leo ut faucibus. Ut ut interdum turpis. Mauris efficitur urna vel ante cursus, porttitor semper lacus aliquet. Vivamus ultrices enim non condimentum feugiat. Phasellus enim purus, feugiat nec ipsum ut, interdum suscipit libero. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vestibulum nunc nulla, convallis at odio in, vehicula luctus ante. Integer purus sapien, tincidunt eu turpis vel, hendrerit tempus ante. Curabitur molestie dolor in venenatis sagittis.
            
            '''),
                ),
              ],
            ),
          )));

          body.add(
            Center(
                child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("ok"),
            )),
          );

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: body,
            ),
          );
        });
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
    ..color = Colors.black54
    ..style = PaintingStyle.fill;
  final Paint thumbPaint = Paint()
    ..color = Colors.pinkAccent
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
    print(
        " rect ${RRect.fromLTRBAndCorners(thumbLeft, 0.0, thumbWidth, size.height)}");

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
          thumbLeft, 0.0, thumbLeft + thumbWidth, size.height,
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
