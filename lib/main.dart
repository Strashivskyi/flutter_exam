import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Lists(),
    );
  }
}

class Lists extends StatefulWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  _ListsState createState() => _ListsState();
}

class ListElement {
  final String name;
  Color color;

  ListElement({required String this.name, required Color this.color});
}

class _ListsState extends State<Lists> {
  Random random = Random();

  late List<ListElement> arrayLeft = [];
  late List<ListElement> arrayRight = [];

  bool showSecondButton = false;

  @override
  void initState() {
    super.initState();
    int randomNumber = random.nextInt(10) + 5;

    late List<ListElement> left = [];
    late List<ListElement> right = [];

    for (var i = 0; i < randomNumber; i++) {
      left.add(ListElement(name: 'Left${i}', color: Colors.grey));
      right.add(ListElement(name: 'Right${i}', color: Colors.grey));
    }

    setState(() {
      arrayLeft = left;
      arrayRight = right;
    });
  }

  moveRandomRedElement() {
    final allElements = [...arrayLeft, ...arrayRight];

    final allRed =
        allElements.where((item) => item.color == Colors.red).toList();
    int randomElementIndex = random.nextInt(allRed.length);
    final randomElement = allRed[randomElementIndex];
    randomElement.color = Colors.grey;
    if (arrayLeft.contains(randomElement)) {
      setState(() {
        arrayRight.add(randomElement);
        arrayLeft.remove(randomElement);
      });
    } else {
      setState(() {
        arrayLeft.add(randomElement);
        arrayRight.remove(randomElement);
      });
    }

    if (allRed.length - 1 <= 0) {
      setState(() {
        showSecondButton = false;
      });
    }
  }

  moveRandomElement() {
    int randomListIndex = random.nextInt(2);

    if (arrayLeft.isEmpty) randomListIndex = 2;

    if (arrayRight.isEmpty) randomListIndex = 1;

    final bool isArr1 = randomListIndex == 1;
    final selectedArr = isArr1 ? arrayLeft : arrayRight;

    int randomElementIndex = random.nextInt(selectedArr.length);

    if (isArr1) {
      if (!selectedArr[randomElementIndex].name.contains('Right')) {
        selectedArr[randomElementIndex].color = Colors.red;
      } else {
        selectedArr[randomElementIndex].color = Colors.grey;
      }
      setState(() {
        arrayRight.add(selectedArr[randomElementIndex]);
        arrayLeft.removeAt(randomElementIndex);
      });
    } else {
      if (!selectedArr[randomElementIndex].name.contains('Left')) {
        selectedArr[randomElementIndex].color = Colors.red;
      } else {
        selectedArr[randomElementIndex].color = Colors.grey;
      }

      setState(() {
        arrayLeft.add(selectedArr[randomElementIndex]);
        arrayRight.removeAt(randomElementIndex);
      });
    }

    final allElements = [...arrayLeft, ...arrayRight];

    final allRed =
        allElements.where((item) => item.color == Colors.red).toList();
    final moreThanFiveRed = allRed.length >= 5;

    setState(() {
      showSecondButton = moreThanFiveRed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Row(
            children: <Widget>[
              const SizedBox(
                width: 30,
              ),
              ListWidget(
                list: arrayLeft,
              ),
              const SizedBox(
                width: 30,
              ),
              ListWidget(
                list: arrayRight,
              ),
              const SizedBox(
                width: 30,
              )
            ],
          ),
          Positioned(
            right: 100,
            bottom: 50,
            child: FloatingActionButton(
              backgroundColor: Colors.yellow,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              onPressed: () {
                moveRandomElement();
              },
            ),
          ),
          if (showSecondButton)
            Positioned(
              left: 100,
              bottom: 50,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                onPressed: () {
                  moveRandomRedElement();
                },
              ),
            ),
        ],
      )),
    ));
  }
}

class ListWidget extends StatelessWidget {
  final List<ListElement> list;

  const ListWidget({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: list.map((item) => ListItem(element: item)).toList(),
    ));
  }
}

class ListItem extends StatelessWidget {
  final ListElement element;

  ListItem({required this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        height: 25,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(color: element.color),
        child: Center(
          child: Text(
            element.name,
            style: const TextStyle(color: Colors.black),
          ),
        ));
  }
}
