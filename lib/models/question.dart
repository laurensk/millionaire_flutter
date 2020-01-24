import 'package:millionaire/data/quetions.dart';
import 'package:millionaire/models/questionAnswers.dart';

class Question {

  int id;
  String question;
  List<QuestionAnswers> answers;
  int correctAnswer;

  Question({this.id, this.question, this.answers, this.correctAnswer});
  
}