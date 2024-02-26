import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobList extends StatefulWidget {
  const JobList({super.key});

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
          List<Future<Object>> apiJobs = [];
          for (var jobObject in jsonResponse['Results']) {
            apiJobs.add(getJobDetails(jobObject));
          }
          List<dynamic> resolvedJobs = await Future.wait(apiJobs);
          // print(resolvedJobs);
          return resolvedJobs;
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
      print('CALLING OBJECT');
      print(jobObject);
      final url = Uri.parse('http://xivapi.com${jobObject['Url']}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 429) {
        return {};
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
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data?[index]['Name'] ?? 'No Name'),
                subtitle: Text(
                    snapshot.data?[index]['Abbreviation'] ?? 'No Abbreviation'),
              );
            },
          );
        }
      },
    );
  }
}
