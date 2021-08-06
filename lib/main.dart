import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = new QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  void setScoreKeeper(bool ans) {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    int score = quizBrain.getScore();
    int numberOfQuestions = quizBrain.getQuestionsLength();
    if (scoreKeeper.length == numberOfQuestions) {
      Alert(
          context: context,
          style: AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
          type: AlertType.success,
          title: "Quiz Over!",
          desc: "Score: $score/$numberOfQuestions.\n Thanks for playing.",
          buttons: [
            DialogButton(
              color: Colors.grey[900],
              width: 120,
              child: Text(
                "Restart",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  scoreKeeper = [];
                  quizBrain.resetQuiz();
                  Navigator.pop(context);
                });
              },
            )
          ]).show();
    } else {
      if (correctAnswer == ans) {
        setState(() {
          scoreKeeper.add(Icon(
            Icons.check,
            color: Colors.green,
          ));
        });
        quizBrain.setScore();
      } else {
        setState(() {
          scoreKeeper.add(Icon(
            Icons.close,
            color: Colors.red,
          ));
        });
      }
    }

    setState(() {
      quizBrain.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Container(
                child: Text(
                  'True',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onPressed: () {
                setScoreKeeper(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Container(
                child: Text(
                  'False',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                setScoreKeeper(false);
              },
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: scoreKeeper,
          ),
        )
      ],
    );
  }
}
