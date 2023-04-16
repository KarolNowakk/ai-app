import 'package:app2/plugins/lang/application/config.dart';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class BasicConfigScreen extends StatefulWidget {
  final Config _configManager = KiwiContainer().resolve<Config>();

  void onSave(String openAIApiKeyValue, apiKeyValue) {
    _configManager.saveConfig(openAIKey, openAIApiKeyValue);
    _configManager.saveConfig(apiKey, apiKeyValue);
  }

  @override
  _BasicConfigScreenState createState() => _BasicConfigScreenState();
}

class _BasicConfigScreenState extends State<BasicConfigScreen> {
  final TextEditingController _aiApiKeyText = TextEditingController();
  final TextEditingController _apiKeyText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _aiApiKeyText.text = widget._configManager.getEntry(openAIKey);
    _apiKeyText.text = widget._configManager.getEntry(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('Provide necessary keys.'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OpenAI API Key:',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _aiApiKeyText,
                    decoration: const InputDecoration(
                      hintText: '...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textColor, // Change this to the desired color
                          width: 1.0, // Change this to the desired width
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: accentColor, // Change this to the desired color
                          width: 2.0, // Change this to the desired width
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Text(
                    'API Key (for exercises and words):',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _apiKeyText,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: '...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textColor, // Change this to the desired color
                          width: 1.0, // Change this to the desired width
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: accentColor, // Change this to the desired color
                          width: 2.0, // Change this to the desired width
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              mainColor, // Set the button's background color to blue
                        ),
                        onPressed: () {
                          widget.onSave(_aiApiKeyText.text, _apiKeyText.text);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Save Configuration',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}