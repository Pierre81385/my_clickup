import 'dart:convert';

import 'package:flutter/material.dart';

class ExpandedResponseComponent extends StatefulWidget {
  const ExpandedResponseComponent({
    super.key,
    required this.responseObject,
  });
  final Map<String, dynamic> responseObject;

  @override
  State<ExpandedResponseComponent> createState() =>
      _ExpandedResponseComponentState();
}

class _ExpandedResponseComponentState extends State<ExpandedResponseComponent> {
  late Map<String, dynamic> _thisResponse = {};
  List<Object> _keys = [];

  List<Object> _extractKeys(Map<String, dynamic> json) {
    if (_keys.isEmpty) {
      json.forEach((key, value) {
        if (value != null) {
          if (value! is Map<String, dynamic>) {
            _keys.add(key);
          }
        }
      });
    }
    return _keys;
  }

  @override
  void initState() {
    _thisResponse = widget.responseObject;
    _extractKeys(_thisResponse);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_extractKeys(_thisResponse);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Origin')),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _keys.length,
                itemBuilder: (BuildContext context, int index1) {
                  List<Object> _extractSubKeys(Map<String, dynamic> json) {
                    List<Object> _subKeys = [];

                    if (_subKeys.isEmpty) {
                      json.forEach((key, value) {
                        _subKeys.add(key);
                      });
                      return _subKeys;
                    } else {
                      return [];
                    }
                  }

                  return Card(
                    child: Column(children: [
                      Text(
                        _keys[index1].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      _extractSubKeys(_thisResponse[_keys[index1]]).isNotEmpty
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  _extractSubKeys(_thisResponse[_keys[index1]])
                                      .length,
                              itemBuilder: (BuildContext context, int index2) {
                                bool doesFunctionError() {
                                  try {
                                    _extractSubKeys(_thisResponse[_keys[index1]]
                                        [_extractSubKeys(
                                                _thisResponse[_keys[index1]])[
                                            index2]]);
                                    return false;
                                  } catch (e) {
                                    return true; // If an error occurs
                                  }
                                }

                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_extractSubKeys(
                                                  _thisResponse[_keys[index1]])[
                                              index2]
                                          .toString()),
                                      doesFunctionError()
                                          ? Text(_thisResponse[_keys[index1]][
                                                  _extractSubKeys(_thisResponse[
                                                      _keys[index1]])[index2]]
                                              .toString())
                                          : IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ExpandedResponseComponent(
                                                              responseObject:
                                                                  _thisResponse[
                                                                      _keys[
                                                                          index1]],
                                                            )));
                                              },
                                              icon: Icon(
                                                  Icons.arrow_circle_right)),
                                    ]);
                              })
                          : Text(_thisResponse[_keys[index1]].toString())
                    ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
