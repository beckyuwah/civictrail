import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'state_project.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StatesTab extends StatefulWidget {
  const StatesTab({super.key});
  

  @override
  State<StatesTab> createState() => _StatesTabState();
}

class _StatesTabState extends State<StatesTab> {
  List<String> states = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  Future<void> fetchStates() async {
    final apiKey = dotenv.env['API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        error = "API key not found";
        loading = false;
      });
      debugPrint('API key not found in environment variables');
      return;
    }
    const url = "https://api.countrystatecity.in/v1/countries/NG/states";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-CSCAPI-KEY': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        states = data.map((e) => e['name'].toString()).toList();
        loading = false;
      });
    } else {
      setState(() {
        error = "Failed to load states (code: ${response.statusCode})";
        loading = false;
      });
    }
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('States')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView.builder(
                  itemCount: states.length,
                  itemBuilder: (context, index) {
                    final state = states[index];
                    return ListTile(
                      title: Text(state),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProjectsByStateScreen(stateName: state),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
