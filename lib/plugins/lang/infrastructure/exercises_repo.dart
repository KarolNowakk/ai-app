import 'package:app2/plugins/lang/domain/settings_structure.dart';
import 'package:app2/plugins/lang/screens/prompt/create.dart';
import 'package:app2/plugins/lang/screens/prompt/select.dart';

// Please use the word "focused" in your sentence.
// TODO: implement server in GO for this shit
class ExerciseRepo implements ExercisesRepoInterface, ExerciseSaverRepoInterface {
  final List<ExerciseStructure> _exercises = [
    ExerciseStructure(
        id: '1',
        title: "This will print the list of all exercises and a message when an exercise is deleted.",
        text: '''        
          Act as german teacher, give me a sentence in German on B1 level.
          Ask me to translate this message.
          After you recieve my translation provide me a feedback, point out mistakes and give me alternative translation.
        ''',
        useSRS: true,
        messages: [
          Message(role: "system", content: "Act as german teacher, give me a sentence in German on B1 level. Ask me to translate this message. After you recieve my translation provide me a feedback, point out mistakes and give me alternative translation."),
          Message(role: "assistant", content: ''' 
              Sure, here's a sentence in German at a B2 level:
              
              "Ich bin gestern Abend ins Kino gegangen."
              
              Please provide a translation into Polish, and I'll give you feedback on any mistakes.
          '''),
          Message(role: "user", content: ''' 
            "Meine bruder war gestern in den Geschaft, er hat vile zwieblen gekauft."
            
            Prosze przetlumacz to zdanie na polski. 
          '''),
          Message(role: "assistant", content: '''
            Dobrze! Twoje tłumaczenie brzmi bardzo dobrze i jest zrozumiałe. Jednakże, jedna poprawka: słowo "film" powinno być przetłumaczone na niemiecki jako "ins Kino", a nie "auf einen Film". Więc poprawne tłumaczenie brzmi: "Ich bin gestern Abend ins Kino gegangen."
          '''),
          Message(role: "user", content: "Prosze kontynuuj z nastepnym zdaniem."),
          // Message(role: "assistant", content: '''
          //     Oczywiście, oto kolejne zdanie:
          //
          //     "Der Lehrer hat uns gebeten, die Hausaufgaben bis morgen zu erledigen."
          //
          //     Proszę przetłumaczyć to zdanie na język polski, a następnie sprawdzę, czy są jakieś błędy.
          // ''')
        ]
    ),
    ExerciseStructure(id: '2', title: "In this example, the FakeExercisesService class implements the ExercisesRepo interface.", text: 'Exercise 2', useSRS: false, messages: []),
    ExerciseStructure(id: '3', title: "No jakies calkiem spoko cwiczenie.", text: 'Exercise 3', useSRS: true, messages: []),
  ];

  @override
  Future<List<ExerciseStructure>> getAllExercises() async {
    // Return a copy of the _exercises list
    return List.from(_exercises);
  }

  @override
  void deleteExercise(ExerciseStructure exercise) {
    _exercises.remove(exercise);
    print('Exercise ${exercise.id} has been deleted.');
  }

  @override
  void saveOrUpdateExercise(ExerciseStructure exercise) {
    print(exercise.id);
    print(exercise.text);
    print(exercise.useSRS);
    print(exercise.title);
    _exercises.add(exercise);
  }
}
