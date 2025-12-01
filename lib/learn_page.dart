import 'package:flutter/cupertino.dart';
import 'package:japanese_verb_trainer/conjugation_diagram.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle =
        CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 16);
    final headerStyle =
        textStyle.copyWith(fontSize: 22, fontWeight: FontWeight.bold);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Learn Conjugations'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verb Conjugation Basics', style: headerStyle),
              const SizedBox(height: 16),
              Text(
                'Japanese verbs are divided into two main groups: Ichidan verbs and Godan verbs. Their conjugation patterns are different.',
                style: textStyle,
              ),
              const SizedBox(height: 24),
              const ConjugationDiagram(),
            ],
          ),
        ),
      ),
    );
  }
}
