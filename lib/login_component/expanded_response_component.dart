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
  final List<Object> _keys = [];

  extractKeys(Map<String, dynamic> json) {
    if (_keys.isEmpty) {
      json.forEach((key, value) {
        if (value != null) {
          if (value! is Map<String, dynamic>) {
            _keys.add(key);
          } else {
            _keys.add(key);
          }
        }
      });
    }
  }

  @override
  void initState() {
    _thisResponse = widget.responseObject;
    extractKeys(_thisResponse);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //extractKeys(_thisResponse);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: IconButton(
                  alignment: AlignmentDirectional.centerStart,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.green,
                  )),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _keys.length,
                itemBuilder: (BuildContext context, int index1) {
                  List<Object> extractSubKeys(Map<String, dynamic> json) {
                    List<Object> subKeys = [];

                    if (subKeys.isEmpty) {
                      json.forEach((key, value) {
                        subKeys.add(key);
                      });
                      return subKeys;
                    } else {
                      return [];
                    }
                  }

                  bool doesFunctionError() {
                    try {
                      extractSubKeys(_thisResponse[_keys[index1]]).isNotEmpty;
                      return false;
                    } catch (e) {
                      return true; // If an error occurs
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      doesFunctionError()
                          ? Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '> ' + _keys[index1].toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '/ ' +
                                        _thisResponse[_keys[index1]].toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  extractSubKeys(_thisResponse[_keys[index1]])
                                      .length,
                              itemBuilder: (BuildContext context, int index2) {
                                bool doesFunctionError() {
                                  try {
                                    extractSubKeys(_thisResponse[_keys[index1]][
                                        extractSubKeys(
                                                _thisResponse[_keys[index1]])[
                                            index2]]);
                                    return false;
                                  } catch (e) {
                                    return true; // If an error occurs
                                  }
                                }

                                return doesFunctionError()
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              '> ' +
                                                  extractSubKeys(_thisResponse[
                                                              _keys[index1]])[
                                                          index2]
                                                      .toString(),
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              '/ ' +
                                                  _thisResponse[_keys[
                                                          index1]][extractSubKeys(
                                                              _thisResponse[
                                                                  _keys[
                                                                      index1]])[
                                                          index2]]
                                                      .toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          )
                                        ],
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '> ' +
                                                  extractSubKeys(_thisResponse[
                                                              _keys[index1]])[
                                                          index2]
                                                      .toString(),
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                            IconButton(
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
                                              icon: const Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              })
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
