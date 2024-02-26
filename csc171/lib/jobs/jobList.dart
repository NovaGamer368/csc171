import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  Future<List<dynamic>> getJobList() async {
    try {
      var url = Uri.parse('http://xivapi.com/ClassJob');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['Results'] is List) {
          return jsonResponse['Results'];
        }
        throw Exception('Unexpected response format');
      } else {
        throw Exception('Failed to load job list: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching job list: $error');
      rethrow;
    }
  }

  Future<Object> getJobDetails(jobObject) async {
    try {
      final url = Uri.parse('http://xivapi.com/ClassJob/${jobObject.ID}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('2nd call');
        print(jsonResponse);
      }
      if (response.statusCode == 200) {
        // final jsonResponse = jsonDecode(response.body);
        // if (jsonResponse['Results'] is List) {
        //   return jsonResponse['Results'];
        // }
        throw Exception('Unexpected response format');
      } else {
        throw Exception('Failed to load job list: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching job list: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getJobList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          print(snapshot.data);
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data?[index]['Name'] ?? 'No Name'),
                  subtitle:
                      Text(snapshot.data?[index]['ID'].toString() ?? 'No ID'),
                );
              },
            ),
          );
        }
      },
    );
  }
}
