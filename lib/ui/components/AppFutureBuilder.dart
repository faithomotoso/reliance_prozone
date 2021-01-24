import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppFutureBuilder extends StatefulWidget {
  // Future to be loaded in the Future Builder
  Future future;

  // The gotten response(snapshot.data) is passed to this callBack
  // Return a widget to display here
  // E.g
  // onData: (data) {
  //  List dt = data;
  //  return ListView.builder(items: dt)...
  // }
  Function onData;

  // Reload call back when an error occurs
  VoidCallback onReload;

  AppFutureBuilder({@required this.future, @required this.onReload, @required this.onData});

  @override
  _AppFutureBuilderState createState() => _AppFutureBuilderState();
}

class _AppFutureBuilderState extends State<AppFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(),);

        if (snapshot.hasError) {
          debugPrint("Error in AppFutureBuilder: ${snapshot.error}");
          return errorWidget();
        }

        return widget.onData?.call(snapshot.data);
      },
    );
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "An error occurred. Tap to reload"
          ),
          const SizedBox(height: 10,),
          IconButton(
            onPressed: widget.onReload?.call,
            icon: Icon(CupertinoIcons.refresh, color: Colors.black,),
          )
        ],
      ),
    );
  }
}
