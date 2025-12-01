import 'package:flutter/cupertino.dart';

class ConjugationDiagram extends StatelessWidget {
  const ConjugationDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle =
        CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 14);
    final headerStyle = textStyle.copyWith(fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Godan Verb Conjugation (五段動詞)',
          style: headerStyle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          'Godan verbs conjugate by changing the last hiragana character of the verb stem according to the hiragana table vowel sounds (a, i, u, e, o).',
          style: textStyle,
        ),
        const SizedBox(height: 16),
        _buildGodanConjugationTable(context),
        const SizedBox(height: 24),
        Text(
          'Ichidan Verb Conjugation (一段動詞)',
          style: headerStyle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          'Ichidan verbs are simpler. Remove the final 「る」 (ru) and add the appropriate ending.',
          style: textStyle,
        ),
        const SizedBox(height: 16),
        _buildIchidanConjugationTable(context),
        const SizedBox(height: 24),
        Text(
          'Irregular Verbs (不規則動詞)',
          style: headerStyle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          'The verbs 「する」 (suru) and 「来る」 (kuru) are irregular and have unique conjugation patterns.',
          style: textStyle,
        ),
        const SizedBox(height: 16),
        _buildIrregularConjugationTable(context),
      ],
    );
  }

  Widget _buildGodanConjugationTable(BuildContext context) {
    final cellStyle =
        CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 12);
    final headerStyle = cellStyle.copyWith(fontWeight: FontWeight.bold);

    return Table(
      border: TableBorder.all(color: CupertinoColors.systemGrey, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: CupertinoColors.systemGrey4),
          children: [
            _buildTableCell('Form', headerStyle),
            _buildTableCell('Vowel Sound', headerStyle),
            _buildTableCell('Suffix/Rule', headerStyle),
            _buildTableCell('Example (書く - kaku)', headerStyle),
          ],
        ),
        _buildGodanRow('Dictionary (辞書形)', 'う', '', '書く (kaku)', cellStyle),
        _buildGodanRow('Negative (ない形)', 'あ', 'ない', '書かない (kakanai)', cellStyle),
        _buildGodanRow('Polite (ます形)', 'い', 'ます', '書きます (kakimasu)', cellStyle),
        _buildGodanRow('Volitional (意向形)', 'お', 'う', '書こう (kakou)', cellStyle),
        _buildGodanRow('Conditional (ば形)', 'え', 'ば', '書けば (kakeba)', cellStyle),
        _buildGodanRow('Imperative (命令形)', 'え', '', '書け (kake)', cellStyle),
        _buildGodanRow('Te-form (て形)', 'Special', '', '書いて (kaite)', cellStyle),
        _buildGodanRow('Past (た形)', 'Special', '', '書いた (kaita)', cellStyle),
      ],
    );
  }

  TableRow _buildGodanRow(String form, String vowel, String suffix,
      String example, TextStyle style) {
    return TableRow(
      children: [
        _buildTableCell(form, style),
        _buildTableCell(vowel, style),
        _buildTableCell(suffix, style),
        _buildTableCell(example, style),
      ],
    );
  }

  Widget _buildIchidanConjugationTable(BuildContext context) {
    final cellStyle =
        CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 12);
    final headerStyle = cellStyle.copyWith(fontWeight: FontWeight.bold);

    return Table(
      border: TableBorder.all(color: CupertinoColors.systemGrey, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2.5),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: CupertinoColors.systemGrey4),
          children: [
            _buildTableCell('Form', headerStyle),
            _buildTableCell('Rule (食べる - taberu)', headerStyle),
            _buildTableCell('Example', headerStyle),
          ],
        ),
        _buildIchidanRow('Dictionary', '-ru + る', '食べる (taberu)', cellStyle),
        _buildIchidanRow('Negative', '-ru + ない', '食べない (tabenai)', cellStyle),
        _buildIchidanRow('Polite', '-ru + ます', '食べます (tabemasu)', cellStyle),
        _buildIchidanRow('Te-form', '-ru + て', '食べて (tabete)', cellStyle),
        _buildIchidanRow('Past', '-ru + た', '食べた (tabeta)', cellStyle),
        _buildIchidanRow('Potential', '-ru + られる', '食べられる (taberareru)', cellStyle),
        _buildIchidanRow('Volitional', '-ru + よう', '食べよう (tabeyou)', cellStyle),
      ],
    );
  }

  TableRow _buildIchidanRow(
      String form, String rule, String example, TextStyle style) {
    return TableRow(
      children: [
        _buildTableCell(form, style),
        _buildTableCell(rule, style),
        _buildTableCell(example, style),
      ],
    );
  }

  Widget _buildIrregularConjugationTable(BuildContext context) {
    final cellStyle =
        CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 12);
    final headerStyle = cellStyle.copyWith(fontWeight: FontWeight.bold);

    return Table(
      border: TableBorder.all(color: CupertinoColors.systemGrey, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: CupertinoColors.systemGrey4),
          children: [
            _buildTableCell('Form', headerStyle),
            _buildTableCell('する (suru)', headerStyle),
            _buildTableCell('来る (kuru)', headerStyle),
          ],
        ),
        _buildIrregularRow('Dictionary', 'する', '来る', cellStyle),
        _buildIrregularRow('Negative', 'しない', '来ない', cellStyle),
        _buildIrregularRow('Polite', 'します', '来ます', cellStyle),
        _buildIrregularRow('Te-form', 'して', '来て', cellStyle),
        _buildIrregularRow('Past', 'した', '来た', cellStyle),
        _buildIrregularRow('Potential', 'できる', '来られる', cellStyle),
        _buildIrregularRow('Volitional', 'しよう', '来よう', cellStyle),
      ],
    );
  }

  TableRow _buildIrregularRow(
      String form, String suruExample, String kuruExample, TextStyle style) {
    return TableRow(
      children: [
        _buildTableCell(form, style),
        _buildTableCell(suruExample, style),
        _buildTableCell(kuruExample, style),
      ],
    );
  }

  Widget _buildTableCell(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}
