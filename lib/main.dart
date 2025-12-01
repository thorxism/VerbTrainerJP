import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:japanese_verb_trainer/learn_page.dart';
import 'package:ruby_text/ruby_text.dart';

void main() {
  runApp(const JapaneseVerbApp());
}

class JapaneseVerbApp extends StatelessWidget {
  const JapaneseVerbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Japanese Verb Conjugation Practice',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CupertinoColors.black,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'NotoSansJP',
            color: CupertinoColors.white,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pen),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Learn',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return const ConjugationPracticeScreen();
          case 1:
            return const LearnPage();
          default:
            return const ConjugationPracticeScreen();
        }
      },
    );
  }
}

class Verb {
  final String name;
  final String furigana;
  final Map<String, Map<String, String>> conjugations;
  int strength;

  Verb({
    required this.name,
    required this.furigana,
    required this.conjugations,
    this.strength = 0,
  });
}

class ConjugationPracticeScreen extends StatefulWidget {
  const ConjugationPracticeScreen({super.key});

  @override
  State<ConjugationPracticeScreen> createState() =>
      _ConjugationPracticeScreenState();
}

class _ConjugationPracticeScreenState extends State<ConjugationPracticeScreen> {
  final Random _random = Random();
  late Verb _currentVerb;
  late String _conjugationType;
  late List<String> _conjugationOptions;
  late List<String> _translationOptions;
  String? _feedback;
  String? _selectedConjugation;
  String? _selectedTranslation;
  bool _showResult = false;
  bool _showFurigana = true;

  final List<Verb> _verbs = [
    Verb(
      name: '食べる',
      furigana: 'たべる',
      conjugations: {
        'present': {'japanese': '食べる', 'english': 'to eat'},
        'negative': {'japanese': '食べない', 'english': 'not to eat'},
        'past': {'japanese': '食べた', 'english': 'ate'},
        'past negative': {'japanese': '食べなかった', 'english': 'did not eat'},
        'te-form': {'japanese': '食べて', 'english': 'eating / eat and...'},
        'potential': {'japanese': '食べられる', 'english': 'can eat'},
        'volitional': {'japanese': '食べよう', 'english': 'let\'s eat'},
        'imperative': {'japanese': '食べろ', 'english': 'eat! (command)'},
        'causative': {'japanese': '食べさせる', 'english': 'make someone eat'},
        'passive': {'japanese': '食べられる', 'english': 'is eaten'},
      },
    ),
    Verb(
      name: '見る',
      furigana: 'みる',
      conjugations: {
        'present': {'japanese': '見る', 'english': 'to see'},
        'negative': {'japanese': '見ない', 'english': 'not to see'},
        'past': {'japanese': '見た', 'english': 'saw'},
        'past negative': {'japanese': '見なかった', 'english': 'did not see'},
        'te-form': {'japanese': '見て', 'english': 'seeing / see and...'},
        'potential': {'japanese': '見られる', 'english': 'can see'},
        'volitional': {'japanese': '見よう', 'english': 'let\'s see'},
        'imperative': {'japanese': '見ろ', 'english': 'see! (command)'},
        'causative': {'japanese': '見させる', 'english': 'make someone see'},
        'passive': {'japanese': '見られる', 'english': 'is seen'},
      },
    ),
    Verb(
      name: '寝る',
      furigana: 'ねる',
      conjugations: {
        'present': {'japanese': '寝る', 'english': 'to sleep'},
        'negative': {'japanese': '寝ない', 'english': 'not to sleep'},
        'past': {'japanese': '寝た', 'english': 'slept'},
        'past negative': {'japanese': '寝なかった', 'english': 'did not sleep'},
        'te-form': {'japanese': '寝て', 'english': 'sleeping / sleep and...'},
        'potential': {'japanese': '寝られる', 'english': 'can sleep'},
        'volitional': {'japanese': '寝よう', 'english': 'let\'s sleep'},
        'imperative': {'japanese': '寝ろ', 'english': 'sleep! (command)'},
        'causative': {'japanese': '寝させる', 'english': 'make someone sleep'},
        'passive': {'japanese': '寝られる', 'english': 'is slept in'},
      },
    ),
    Verb(
      name: '起きる',
      furigana: 'おきる',
      conjugations: {
        'present': {'japanese': '起きる', 'english': 'to wake up'},
        'negative': {'japanese': '起きない', 'english': 'not to wake up'},
        'past': {'japanese': '起きた', 'english': 'woke up'},
        'past negative': {'japanese': '起きなかった', 'english': 'did not wake up'},
        'te-form': {'japanese': '起きて', 'english': 'waking up / wake up and...'},
        'potential': {'japanese': '起きられる', 'english': 'can wake up'},
        'volitional': {'japanese': '起きよう', 'english': 'let\'s wake up'},
        'imperative': {'japanese': '起きろ', 'english': 'wake up! (command)'},
        'causative': {'japanese': '起きさせる', 'english': 'make someone wake up'},
        'passive': {'japanese': '起きられる', 'english': 'is woken up'},
      },
    ),
    Verb(
      name: 'いる',
      furigana: 'いる',
      conjugations: {
        'present': {'japanese': 'いる', 'english': 'to be (animate)'},
        'negative': {'japanese': 'いない', 'english': 'not to be (animate)'},
        'past': {'japanese': 'いた', 'english': 'was (animate)'},
        'past negative': {'japanese': 'いなかった', 'english': 'was not (animate)'},
        'te-form': {'japanese': 'いて', 'english': 'being / be and...'},
        'potential': {'japanese': 'いられる', 'english': 'can be (animate)'},
        'volitional': {'japanese': 'いよう', 'english': 'let\'s be (animate)'},
        'imperative': {'japanese': 'いろ', 'english': 'be! (animate, command)'},
        'causative': {'japanese': 'いさせる', 'english': 'make someone be (animate)'},
        'passive': {'japanese': 'いられる', 'english': 'is... (animate, passive)'},
      },
    ),
    Verb(
      name: '話す',
      furigana: 'はなす',
      conjugations: {
        'present': {'japanese': '話す', 'english': 'to speak'},
        'negative': {'japanese': '話さない', 'english': 'not to speak'},
        'past': {'japanese': '話した', 'english': 'spoke'},
        'past negative': {'japanese': '話さなかった', 'english': 'did not speak'},
        'te-form': {'japanese': '話して', 'english': 'speaking / speak and...'},
        'potential': {'japanese': '話せる', 'english': 'can speak'},
        'volitional': {'japanese': '話そう', 'english': 'let\'s speak'},
        'imperative': {'japanese': '話せ', 'english': 'speak! (command)'},
        'causative': {'japanese': '話させる', 'english': 'make someone speak'},
        'passive': {'japanese': '話される', 'english': 'is spoken'},
      },
    ),
    Verb(
      name: '聞く',
      furigana: 'きく',
      conjugations: {
        'present': {'japanese': '聞く', 'english': 'to listen'},
        'negative': {'japanese': '聞かない', 'english': 'not to listen'},
        'past': {'japanese': '聞いた', 'english': 'listened'},
        'past negative': {'japanese': '聞かなかった', 'english': 'did not listen'},
        'te-form': {'japanese': '聞いて', 'english': 'listening / listen and...'},
        'potential': {'japanese': '聞ける', 'english': 'can listen'},
        'volitional': {'japanese': '聞こう', 'english': 'let\'s listen'},
        'imperative': {'japanese': '聞け', 'english': 'listen! (command)'},
        'causative': {'japanese': '聞かせる', 'english': 'make someone listen'},
        'passive': {'japanese': '聞かれる', 'english': 'is listened to'},
      },
    ),
    Verb(
      name: '飲む',
      furigana: 'のむ',
      conjugations: {
        'present': {'japanese': '飲む', 'english': 'to drink'},
        'negative': {'japanese': '飲まない', 'english': 'not to drink'},
        'past': {'japanese': '飲んだ', 'english': 'drank'},
        'past negative': {'japanese': '飲まなかった', 'english': 'did not drink'},
        'te-form': {'japanese': '飲んで', 'english': 'drinking / drink and...'},
        'potential': {'japanese': '飲める', 'english': 'can drink'},
        'volitional': {'japanese': '飲もう', 'english': 'let\'s drink'},
        'imperative': {'japanese': '飲め', 'english': 'drink! (command)'},
        'causative': {'japanese': '飲ませる', 'english': 'make someone drink'},
        'passive': {'japanese': '飲まれる', 'english': 'is drunk'},
      },
    ),
    Verb(
      name: '買う',
      furigana: 'かう',
      conjugations: {
        'present': {'japanese': '買う', 'english': 'to buy'},
        'negative': {'japanese': '買わない', 'english': 'not to buy'},
        'past': {'japanese': '買った', 'english': 'bought'},
        'past negative': {'japanese': '買わなかった', 'english': 'did not buy'},
        'te-form': {'japanese': '買って', 'english': 'buying / buy and...'},
        'potential': {'japanese': '買える', 'english': 'can buy'},
        'volitional': {'japanese': '買おう', 'english': 'let\'s buy'},
        'imperative': {'japanese': '買え', 'english': 'buy! (command)'},
        'causative': {'japanese': '買わせる', 'english': 'make someone buy'},
        'passive': {'japanese': '買われる', 'english': 'is bought'},
      },
    ),
    Verb(
      name: '待つ',
      furigana: 'まつ',
      conjugations: {
        'present': {'japanese': '待つ', 'english': 'to wait'},
        'negative': {'japanese': '待たない', 'english': 'not to wait'},
        'past': {'japanese': '待った', 'english': 'waited'},
        'past negative': {'japanese': '待たなかった', 'english': 'did not wait'},
        'te-form': {'japanese': '待って', 'english': 'waiting / wait and...'},
        'potential': {'japanese': '待てる', 'english': 'can wait'},
        'volitional': {'japanese': '待とう', 'english': 'let\'s wait'},
        'imperative': {'japanese': '待て', 'english': 'wait! (command)'},
        'causative': {'japanese': '待たせる', 'english': 'make someone wait'},
        'passive': {'japanese': '待たれる', 'english': 'is waited for'},
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      _feedback = null;
      _selectedConjugation = null;
      _selectedTranslation = null;
      _showResult = false;
      _currentVerb = _verbs[_random.nextInt(_verbs.length)];
      _conjugationType = _getRandomConjugationType();
      _conjugationOptions = _generateConjugationOptions();
      _translationOptions = _generateTranslationOptions();
    });
  }

  String _getRandomConjugationType() {
    final conjugationTypes = [
      'present',
      'negative',
      'past',
      'past negative',
      'te-form',
      'potential',
      'volitional',
      'imperative',
      'causative',
      'passive',
    ];
    return conjugationTypes[_random.nextInt(conjugationTypes.length)];
  }

  List<String> _generateConjugationOptions() {
    final correctAnswer =
        _currentVerb.conjugations[_conjugationType]!['japanese']!;
    final allConjugations = _currentVerb.conjugations.values
        .map((c) => c['japanese']!)
        .toSet()
        .toList();
    allConjugations.remove(correctAnswer);
    allConjugations.shuffle(_random);

    final options = <String>[correctAnswer];
    while (options.length < 4 && allConjugations.isNotEmpty) {
      options.add(allConjugations.removeAt(0));
    }

    options.shuffle(_random);
    return options;
  }

  List<String> _generateTranslationOptions() {
    final correctAnswer =
        _currentVerb.conjugations[_conjugationType]!['english']!;
    final allTranslations = _currentVerb.conjugations.values
        .map((c) => c['english']!)
        .toSet()
        .toList();
    allTranslations.remove(correctAnswer);
    allTranslations.shuffle(_random);

    final options = <String>[correctAnswer];
    while (options.length < 4 && allTranslations.isNotEmpty) {
      options.add(allTranslations.removeAt(0));
    }
    options.shuffle(_random);
    return options;
  }

  void _checkAnswers() {
    setState(() {
      _showResult = true;
      final correctConjugation =
          _currentVerb.conjugations[_conjugationType]!['japanese'];
      final correctTranslation =
          _currentVerb.conjugations[_conjugationType]!['english'];
      final isConjugationCorrect = _selectedConjugation == correctConjugation;
      final isTranslationCorrect = _selectedTranslation == correctTranslation;

      if (isConjugationCorrect && isTranslationCorrect) {
        _feedback = 'Correct! Well done!';
        _currentVerb.strength = min(10, _currentVerb.strength + 1);
      } else {
        var error = '';
        if (!isConjugationCorrect) {
          error += 'Conjugation is wrong. Correct is $correctConjugation. ';
        }
        if (!isTranslationCorrect) {
          error += 'Translation is wrong. Correct is $correctTranslation.';
        }
        _feedback = error;
        _currentVerb.strength = max(0, _currentVerb.strength - 1);
      }
    });
  }

  Widget _buildOptionButton(
      String option, String? selectedOption, Function(String) onSelect) {
    bool isSelected = selectedOption == option;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: CupertinoButton(
        color: isSelected
            ? CupertinoColors.activeBlue
            : CupertinoColors.secondarySystemFill,
        onPressed: _showResult ? null : () => onSelect(option),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 18,
            color: isSelected
                ? CupertinoColors.white
                : CupertinoTheme.of(context).textTheme.textStyle.color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Japanese Verb Practice'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Furigana'),
            CupertinoSwitch(
              value: _showFurigana,
              onChanged: (value) {
                setState(() {
                  _showFurigana = value;
                });
              },
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 150,
              child: ListView.builder(
                itemCount: _verbs.length,
                itemBuilder: (context, index) {
                  final verb = _verbs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RubyText(
                            [
                              RubyTextData(verb.name,
                                  ruby: _showFurigana ? verb.furigana : '')
                            ],
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          verb.strength.toString(),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Conjugate the verb to the $_conjugationType form:',
                        style: const TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      RubyText(
                        [
                          RubyTextData(
                            _currentVerb.name,
                            ruby: _showFurigana ? _currentVerb.furigana : '',
                          ),
                        ],
                        style: const TextStyle(fontSize: 50),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: _conjugationOptions.map((option) {
                                  return _buildOptionButton(
                                      option, _selectedConjugation, (value) {
                                    setState(() {
                                      _selectedConjugation = value;
                                    });
                                  });
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                children: _translationOptions.map((option) {
                                  return _buildOptionButton(
                                      option, _selectedTranslation, (value) {
                                    setState(() {
                                      _selectedTranslation = value;
                                    });
                                  });
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_showResult)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            _feedback!,
                            style: const TextStyle(
                                fontSize: 20,
                                color: CupertinoColors.destructiveRed),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 20),
                      CupertinoButton.filled(
                        onPressed: (_selectedConjugation != null &&
                                _selectedTranslation != null)
                            ? (_showResult ? _nextQuestion : _checkAnswers)
                            : null,
                        child: Text(
                          _showResult ? 'Next' : 'Check',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}