import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import './services/image.service.dart';
import './models/image.model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageService>(
            create: (context) => ImageService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carsome Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Carsome Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> _isSelected = List.generate(2, (_) => false);
  List<ImageModel> _imageList;
  bool isUpdated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(widget.title),
    );
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final appBarHeight = appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: OrientationBuilder(
        builder: (ctx, orientation) {
          if (orientation == Orientation.portrait) {
            return _portraitMode(screenHeight, screenWidth, appBarHeight);
          } else {
            return _landscapeMode(appBarHeight);
          }
        },
      ),
    );
  }

  Widget _portraitMode(screenHeight, screenWidth, appBarHeight) {
    return Container(
      height: (screenHeight - appBarHeight),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: ToggleButtons(
              children: [
                Text('Btn 1'),
                Text('Btn 2'),
              ],
              isSelected: _isSelected,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }

                  if (Provider.of<ImageService>(context, listen: false)
                      .imageList
                      .isNotEmpty) {
                    Provider.of<ImageService>(context, listen: false)
                        .clearList();
                  }

                  if (index == 0) {
                    Provider.of<ImageService>(context, listen: false)
                        .fetchDataFromAlbum('1')
                        .then(
                      (Response resp) {
                        Provider.of<ImageService>(context, listen: false)
                            .populateList(resp.data);
                      },
                    );
                  } else {
                    Provider.of<ImageService>(context, listen: false)
                        .fetchDataFromAlbum('2')
                        .then(
                      (Response resp) {
                        Provider.of<ImageService>(context, listen: false)
                            .populateList(resp.data);
                      },
                    );
                  }
                });
              },
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,
              child: SafeArea(
                child: Consumer<ImageService>(
                  builder: (ctx, image, widget) {
                    return GridView.builder(
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: ctx.watch<ImageService>().imageList.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Flexible(
                                flex: 7,
                                child: Image.network(
                                  image.imageList[index].thumbnailUrl,
                                ),
                              ),
                              Flexible(
                                // flex: 1,
                                child: Text(
                                  image.imageList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _landscapeMode(appBarHeight) {
    return Container(
      height: MediaQuery.of(context).size.height - appBarHeight,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: ToggleButtons(
              children: [
                Text('Btn 1'),
                Text('Btn 2'),
              ],
              isSelected: _isSelected,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }

                  if (Provider.of<ImageService>(context, listen: false)
                      .imageList
                      .isNotEmpty) {
                    Provider.of<ImageService>(context, listen: false)
                        .clearList();
                  }

                  if (index == 0) {
                    Provider.of<ImageService>(context, listen: false)
                        .fetchDataFromAlbum('1')
                        .then(
                      (Response resp) {
                        Provider.of<ImageService>(context, listen: false)
                            .populateList(resp.data);
                      },
                    );
                  } else {
                    Provider.of<ImageService>(context, listen: false)
                        .fetchDataFromAlbum('2')
                        .then(
                      (Response resp) {
                        Provider.of<ImageService>(context, listen: false)
                            .populateList(resp.data);
                      },
                    );
                  }
                });
              },
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.9,
              child: SafeArea(
                child: Consumer<ImageService>(
                  builder: (ctx, image, widgets) {
                    return GridView.builder(
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      itemCount: ctx.watch<ImageService>().imageList.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          height: 200,
                          // padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Flexible(
                                flex: 7,
                                child: Image.network(
                                  image.imageList[index].thumbnailUrl,
                                ),
                              ),
                              Flexible(
                                // flex: 1,
                                child: Text(
                                  image.imageList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
