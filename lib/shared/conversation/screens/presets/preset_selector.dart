import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/conversation/domain/preset.dart';
import 'package:app2/shared/conversation/interfaces/presets_provider.dart';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/theme.dart';
import 'package:provider/provider.dart';

class PresetSelector<T extends Preset> extends StatelessWidget {
  final Function() redirectToCreateScreen;
  final Function(Preset item) redirectToPresetScreen;
  final Function(int item) redirectToUpdateScreen;
  final Function(int item) deleteExercise;
  final Function(int item) redirectToCopyScreen;

  const PresetSelector({
    Key? key,
    required this.redirectToCreateScreen,
    required this.redirectToPresetScreen,
    required this.redirectToUpdateScreen,
    required this.deleteExercise,
    required this.redirectToCopyScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      body: _buildListTiles(context),
      floatingButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: redirectToCreateScreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListTiles(BuildContext context) {
    final provider = context.watch<PresetsProvider<T>>();
    return ListView.builder(
      itemCount: provider.count,
      itemBuilder: (context, index) {
        final item = provider.item(index);
        return _buildListItem(context, item, index);
      },
    );
  }

  Widget _buildListItem(BuildContext context, Preset item, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              offset: const Offset(-3, 3),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => redirectToPresetScreen(item),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    item.title ?? "some err",
                    style: const TextStyle(
                        color: DarkTheme.textColor, fontSize: 16),
                  ),
                ),
              ),
            ),
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.edit),
              onPressed: () => redirectToUpdateScreen(index),
            ),
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.delete),
              onPressed: () => deleteExercise(index),
            ),
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.copy),
              onPressed: () => redirectToCopyScreen(index),
            )
          ],
        ),
      ),
    );
  }
}
