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
            if (jobObject['ID'] >= 19 &&
                jobObject['ID'] <= 40 &&
                jobObject['ID'] != 26 &&
                jobObject['ID'] != 29 &&
                jobObject['ID'] != 36) {
              apiJobs.add(getJobDetails(jobObject));
            }
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
              String imageUrl = '${snapshot.data![index]['Name']}';
              // print(imageUrl.replaceAll(' ', ''));
              return GestureDetector(
                onTap: () {
                  print(snapshot.data![index]);
                  _extraJobDetails(snapshot.data![index]);
                },
                child: Card(
                  elevation: 3,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data![index]['Name'] ?? "No Name",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${snapshot.data![index]['ID']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Image.network(
                          'http://xivapi.com/cj/companion/${imageUrl.replaceAll(' ', '')}.png',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _extraJobDetails(Map<String, dynamic> jobDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(jobDetails['Name']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Abbreviation: ${jobDetails['Abbreviation']}'),
              Text('Job Category: ${jobDetails['ClassJobCategory']['Name']}'),
              // Add more job details here as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
