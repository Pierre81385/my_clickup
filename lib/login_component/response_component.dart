import 'package:flutter/material.dart';
import 'package:my_clickup/login_component/expanded_response_component.dart';

class MapResponseComponent extends StatefulWidget {
  const MapResponseComponent({super.key, required this.mapResponse});
  final Map<String, dynamic> mapResponse;

  @override
  State<MapResponseComponent> createState() => _MapResponseComponentState();
}

class _MapResponseComponentState extends State<MapResponseComponent> {
  late Map<String, dynamic> _mapResponse = {};
  List<String> _keys = [];
  List<String> _objectKeys = [];

  _extractKeys(Map<String, dynamic> json) {
    if (_keys.length == 0) {
      json.forEach((key, value) {
        if (value != null) {
          if (value! is Map<String, dynamic>) {
            _keys.add(key);
            _objectKeys.add(key);
          } else {
            _keys.add(key);
          }
        }
      });
    }
  }

  @override
  void initState() {
    _mapResponse = widget.mapResponse;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _extractKeys(_mapResponse);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back')),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _keys.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(
                        _keys[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: _objectKeys.contains(_keys[index])
                          ? IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ExpandedResponseComponent(
                                          responseObject:
                                              _mapResponse[_keys[index]],
                                        )));
                              },
                              icon: Icon(Icons.arrow_circle_right))
                          : SizedBox(),
                      subtitle: _objectKeys.contains(_keys[index])
                          ? SizedBox()
                          : Text(_mapResponse[_keys[index]].toString()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
