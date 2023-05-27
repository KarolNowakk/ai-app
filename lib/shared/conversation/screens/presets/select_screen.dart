import 'package:app2/shared/conversation/domain/preset.dart';
import 'package:app2/shared/conversation/domain/preset_chat.dart';
import 'package:app2/shared/conversation/interfaces/conversation_provider.dart';
import 'package:app2/shared/conversation/interfaces/presets_provider.dart';
import 'package:app2/shared/conversation/screens/chat/main_chat.dart';
import 'package:app2/shared/conversation/screens/presets/create_preset.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PresetsSelectorScreen extends StatefulWidget {
  static const String route = "preset_selection";

  const PresetsSelectorScreen({super.key});

  @override
  State<PresetsSelectorScreen> createState() => _PresetsSelectorScreenState();
}

class _PresetsSelectorScreenState extends State<PresetsSelectorScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PresetsProvider<PresetChat>>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: _buildListTiles(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.pushNamed(context, CreatePresetScreen.route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListTiles() {
    return Consumer<PresetsProvider<PresetChat>>(
      builder: (context, presetsProvider, _) {
        return ListView.builder(
          itemCount: presetsProvider.count,
          itemBuilder: (context, index) {
            final item = presetsProvider.item(index);
            return _buildListItem(item, index);
          },
        );
      },
    );
  }

  Widget _buildListItem(
      PresetChat item, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(-3, 3),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<PresetsProvider<PresetChat>>().setIndexToUpdate(-1);
                  context.read<ConversationProvider>().setConversation(item.id, item.conv);
                    Navigator.pushNamed(context, BasicConversationScreen.route);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    item.conv.title ?? "some err",
                    style: const TextStyle(
                        color: DarkTheme.textColor, fontSize: 16),
                  ),
                ),
              ),
            ),
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.read<PresetsProvider<PresetChat>>().setIndexToUpdate(index);
                context.read<PresetsProvider<PresetChat>>().chooseItem(index);
                Navigator.pushNamed(context, CreatePresetScreen.route);
              },
            ),
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.delete),
              onPressed: () => context.read<PresetsProvider<PresetChat>>().delete(index),
            ),
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.copy),
              onPressed: () {
                context.read<PresetsProvider<PresetChat>>().chooseItem(index);
                Navigator.pushNamed(context, CreatePresetScreen.route);
              },
            )
          ],
        ),
      ),
    );
  }
}
