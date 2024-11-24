import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foofi/color.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellow_001,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.black.withOpacity(0.15),
        shape:
            Border(bottom: BorderSide(color: Colors.black.withOpacity(0.15))),
        leading: const Icon(
          Icons.menu,
        ),
      ),
    );
  }
}
