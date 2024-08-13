import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oauth2_test/dynamicforms/model/form_model.dart';

class HiveTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hive Data Test')),
      body: FutureBuilder<List<FormModel>>(
        future: getHiveData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final form = snapshot.data![index];
                return ListTile(
                  title: Text(form.name),
                  subtitle: Text('ID: ${form.id}'),
                );
              },
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }

  Future<List<FormModel>> getHiveData() async {
    var formBox = await Hive.openBox<FormModel>('forms');
    return formBox.values.toList();
  }
}