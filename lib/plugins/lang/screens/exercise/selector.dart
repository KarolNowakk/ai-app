import 'dart:io';

import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/lang/interfaces/exercises_provider.dart';
import 'package:app2/plugins/lang/screens/chat/exercise_screen.dart';
import 'package:app2/plugins/lang/screens/exercise/creator.dart';
import 'package:app2/shared/conversation/domain/preset.dart';
import 'package:app2/shared/conversation/interfaces/presets_provider.dart';
import 'package:app2/shared/conversation/screens/presets/create_preset.dart';
import 'package:app2/shared/conversation/screens/presets/preset_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseSelectorScreen extends StatefulWidget {
  static const String route = "exercise_selection";

  const ExerciseSelectorScreen({super.key});

  @override
  State<ExerciseSelectorScreen> createState() => _ExerciseSelectorScreenState();
}

class _ExerciseSelectorScreenState extends State<ExerciseSelectorScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PresetsProvider<ExerciseStructure>>().loadItems();
  }

  void _redirectToCreate() {
    context.read<PresetsProvider<ExerciseStructure>>().setIndexToUpdate(-1);
    Navigator.pushNamed(context, CreatePresetScreen.route);
  }

  void _redirectToExerciseScreen(Preset preset) {
    if (preset is! ExerciseStructure) throw Exception("preset is not exercise class in exercise selector");

    context.read<PresetsProvider<ExerciseStructure>>().setIndexToUpdate(-1);
    context.read<ExerciseProvider>().setExercise(preset);
    Navigator.pushNamed(context, ExerciseScreen.route);
  }

  void _redirectToCreateScreen(int index) {
    context.read<PresetsProvider<ExerciseStructure>>().setIndexToUpdate(index);
    context.read<PresetsProvider<ExerciseStructure>>().chooseItem(index);
    Navigator.pushNamed(context, ExerciseCreatorScreen.route);
  }

  void _deleteExercise(int index) {
    context.read<PresetsProvider<ExerciseStructure>>().delete(index);
  }

  void _redirectToCopyExercise(int index) {
    context.read<PresetsProvider<ExerciseStructure>>().chooseItem(index);
    Navigator.pushNamed(context, ExerciseCreatorScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return PresetSelector<ExerciseStructure>(
        redirectToCreateScreen: _redirectToCreate,
        redirectToPresetScreen: _redirectToExerciseScreen,
        redirectToUpdateScreen: _redirectToCreateScreen,
        deleteExercise: _deleteExercise,
        redirectToCopyScreen: _redirectToCopyExercise,
    );
  }
}
