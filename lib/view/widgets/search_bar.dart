
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchBar(
      hintText: 'Enter Destination',
      onChanged: null,
      
    );
  }
}
