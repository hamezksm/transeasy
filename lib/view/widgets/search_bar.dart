import 'package:flutter/material.dart';
import 'package:trans_e/model/service.dart'; // Import your DataService

class SearchWidget extends StatefulWidget {
  final void Function(String)? onDestinationSelected; // Add this line

  const SearchWidget({Key? key, this.onDestinationSelected}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final DataService _dataService = DataService();
  Set<String> _destinationSet = {}; // Use Set to store unique destinations
  String? _selectedDestination;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    final destinations = await _dataService.getDestinations();
    setState(() {
      _destinationSet.addAll(destinations); // Add destinations to the set
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedDestination,
      items: _destinationSet.map((destination) {
        return DropdownMenuItem<String>(
          value: destination,
          child: Text(destination),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDestination = value;
        });
        if (widget.onDestinationSelected != null) {
          widget.onDestinationSelected!(value!); // Pass selected destination back to HomeScreen
        }
      },
      hint: const Text('Select a destination'),
    );
  }
}
