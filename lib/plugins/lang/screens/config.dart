import 'package:app2/elements/infinity_button.dart';
import 'package:app2/elements/text_field.dart';
import 'package:app2/plugins/lang/application/config.dart';
import 'package:app2/theme.dart';
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
    return Scaffold(
      backgroundColor: DarkTheme.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: DarkTheme.background,
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
                DefaultTextWidget(
                    controller: _aiApiKeyText,
                    hint: '...',
                ),
                const SizedBox(height: 30.0),
                const Text(
                  'API Key (for exercises and words):',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10.0),
                DefaultTextWidget(
                  controller: _apiKeyText,
                  hint: '...',
                ),
                const SizedBox(height: 16.0),
                InfinityButton(
                    onPressed: () {
                      widget.onSave(_aiApiKeyText.text, _apiKeyText.text);
                      Navigator.pop(context);
                    },
                    text: 'Save Configuration',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}