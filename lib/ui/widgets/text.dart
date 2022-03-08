import 'package:flutter/material.dart';

class PageName extends StatelessWidget {
  const PageName({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 26.0,
            height: 1.2,
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class Subtitle extends StatelessWidget {
  const Subtitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontSize: 14.0,
          ),
    );
  }
}

class Label extends StatelessWidget {
  const Label({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontSize: 15.0,
          ),
    );
  }
}
