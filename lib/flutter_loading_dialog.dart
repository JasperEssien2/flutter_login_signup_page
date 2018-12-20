import 'package:flutter/material.dart';

class DialogProgress extends StatefulWidget {
  @override
  _DialogProgressState createState() => _DialogProgressState();

}

class _DialogProgressState extends State<DialogProgress> {
  @override
  Widget build(BuildContext context) {

    return Container();
  }

  closeProgressBar(){
    Navigator.pop(context);
  }

  openProgressDialog({String text: "Loading..", themeColor: Colors.white70, progressBarColor: Colors.blueAccent, textColor: Colors.blue}) => showDialog(
      context: context,
      builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: new Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: new Container(
            height: 70.0,
            color: themeColor,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(text),
                new CircularProgressIndicator(valueColor: progressBarColor,)
              ],
            ),
          ),)));
}
