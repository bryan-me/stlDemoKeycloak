import 'package:flutter/material.dart';
import 'package:oauth2_test/dynamicforms/model/dynamic_model.dart';
import 'package:oauth2_test/dynamicforms/model/item_model.dart';
import 'package:oauth2_test/service/form_service.dart';


class DynamicForm extends StatefulWidget {
  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  late Future<List<DynamicModel>> formConfig;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    formConfig = fetchFormConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM Form'),
      ),
      body: FutureBuilder<List<DynamicModel>>(
        future: formConfig,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final fields = snapshot.data!;
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: fields.map((field) => _buildFormField(field)).toList()
                  ..add(
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFormField(DynamicModel field) {
    _controllers[field.controlName] = TextEditingController(text: field.value);

    switch (field.formType) {
      case FormType.Text:
        return TextFormField(
          controller: _controllers[field.controlName],
          decoration: InputDecoration(labelText: field.controlName),
          validator: (value) {
            if (field.isRequired && (value == null || value.isEmpty)) {
              return 'Please enter ${field.controlName}';
            }
            for (var validator in field.validators) {
              if (!validator.validate(value!)) {
                return validator.message;
              }
            }
            return null;
          },
        );
      case FormType.Multiline:
        return TextFormField(
          controller: _controllers[field.controlName],
          decoration: InputDecoration(labelText: field.controlName),
          maxLines: null,
          validator: (value) {
            if (field.isRequired && (value == null || value.isEmpty)) {
              return 'Please enter ${field.controlName}';
            }
            for (var validator in field.validators) {
              if (!validator.validate(value!)) {
                return validator.message;
              }
            }
            return null;
          },
        );
      case FormType.Dropdown:
        return DropdownButtonFormField<ItemModel>(
          decoration: InputDecoration(labelText: field.controlName),
          value: field.selectedItem,
          items: field.items.map((item) {
            return DropdownMenuItem<ItemModel>(
              value: item,
              child: Text(item.display),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              field.selectedItem = newValue;
              _controllers[field.controlName]!.text = newValue?.value ?? '';
            });
          },
          validator: (value) {
            if (field.isRequired && value == null) {
              return 'Please select ${field.controlName}';
            }
            return null;
          },
        );
        
      // Add more form types like AutoComplete, RTE, DatePicker here...
      default:
        return Container();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect form data and submit to backend
      final formData = _controllers.map((key, controller) => MapEntry(key, controller.text));
      print(formData); // or send it to the backend
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }
}