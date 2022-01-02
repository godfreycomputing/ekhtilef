import 'package:flutter/material.dart';
import '../data/data.dart';

class Emojies extends StatefulWidget {
  @override
  _EmojiesState createState() => _EmojiesState();
}

class _EmojiesState extends State<Emojies> {
  List emojes = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.9, color: Colors.grey[400]!)]),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text("Select Emoji"),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            const  SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 315,
              child: GridView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 0.0, maxCrossAxisExtent: 60.0),
                  children: emojis.map((String emoji) {
                    return GridTile(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, emoji);
                      },
                      child: Container(
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                    ));
                  }).toList()),
            ),
          ],
        ));
  }

  List<String> emojis = [];
  @override
  void initState() {
    super.initState();
    emojis = getSmileys();
  }
}
