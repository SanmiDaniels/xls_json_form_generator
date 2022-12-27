library xls_json_form_generator;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class XlsJsonFormGenerator extends StatefulWidget {
  /// the form schema is a
  /// String of a List of Maps [json]
  final String form;

  /// ValueChanged that send out a Map
  final ValueChanged<Map> onChanged;

  final GlobalKey<FormState> formKey;

  XlsJsonFormGenerator({required this.form, required this.onChanged, required this.formKey});
  @override
  _XlsJsonFormGeneratorState createState() =>
      _XlsJsonFormGeneratorState(json.decode(form));
}

class _XlsJsonFormGeneratorState extends State<XlsJsonFormGenerator> {
  /// map data the sentout as a responce when a value changes
  final List<dynamic> formItems;

  _XlsJsonFormGeneratorState(this.formItems);
  void _handleChanged() {
    widget.onChanged(formResults);
  }

  @override
  void initState() {
    super.initState();
  }

  final Map<String, dynamic> formResults = {};

  List<Widget> jsonToForm() {
    List<Widget> listWidget = <Widget>[];

    for (var item in formItems) {
      listWidget.add(
          Row(mainAxisSize: MainAxisSize.min, children: rowChildren(item)));
    }

    return listWidget;
  }

  List<Widget> rowChildren(dynamic rowStructure) {
    List<Widget> rowWids = [];
    int rowCount = rowStructure['rows'];

    for (var item in rowStructure['structure']) {
      if (item['type'] == 'text') {
        rowWids.add(Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 16),
          width: (MediaQuery.of(context).size.width / rowCount) - 30,
          height: 50,
          child: TextFormField(
            autofocus: false,
            onChanged: (String value) {
              formResults[item['name']] = value;
              _handleChanged();
            },
            validator: (String? value) {
              if (item['bind']['required']) {
                return null;
              }
              if (value!.isEmpty) {
                return 'Please ${item['label']} cannot be empty';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: item['label'],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ));
      } else if (item['type'] == 'text-area') {
        rowWids.add(Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 16),
          width: (MediaQuery.of(context).size.width / rowCount) - 30,
          height: 100,
          child: TextFormField(
            autofocus: false,
            onChanged: (String value) {
              formResults[item['name']] = value;
              _handleChanged();
            },
            validator: (String? value) {
              if (item['bind']['required']) {
                return null;
              }
              if (value!.isEmpty) {
                return 'Please ${item['label']} cannot be empty';
              }
              return null;
            },
            maxLines: 100,
            decoration: InputDecoration(
              labelText: item['label'],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ));
      } else if (item['type'] == 'number') {
        rowWids.add(
          Container(
            width: (MediaQuery.of(context).size.width / rowCount) - 30,
            height: 50,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 16),
            child: TextFormField(
              autofocus: false,
              onChanged: (String value) {
                formResults[item['name']] = value;
                _handleChanged();
              },
              validator: (String? value) {
                if (item['bind']['required']) {
                  return null;
                }
                if (value!.isEmpty) {
                  return 'Please ${item['label']} cannot be empty';
                }
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
              ],
              keyboardType: TextInputType.number,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: item['label'],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        );
      } else if (item['type'] == 'select') {
        rowWids.add(
          Container(
            width: (MediaQuery.of(context).size.width / rowCount) - 30,
            height: 50,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 16),
            child: DropdownButtonFormField<dynamic>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              hint: Text(
                '${item['label']}',
                style: const TextStyle(fontSize: 16),
              ),
              isExpanded: false,
              style: Theme.of(context).textTheme.headlineLarge,
              onChanged: (dynamic? value) {
                // This is called when the user selects an item.
                setState(() {
                  formResults[item['name']] = value;
                  _handleChanged();
                });
              },
              items: item['choices']
                  .map<DropdownMenuItem<dynamic>>((dynamic value) {
                return DropdownMenuItem<dynamic>(
                  value: value['label'],
                  child: Text(value['label'],
                      style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
            ),
          ),
        );
      }
    }

    return rowWids;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.widget.formKey,
      child: Column(
        children: jsonToForm(),
      ),
    );
  }
}
