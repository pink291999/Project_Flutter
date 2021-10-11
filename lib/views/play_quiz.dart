import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/views/count_down.dart';
import 'package:quiz_app/views/result.dart';
import 'package:quiz_app/widgets/quiz_play_widgets.dart';
import 'package:quiz_app/widgets/widgets.dart';


class PlayQuiz extends StatefulWidget {
  final String quizId;
  String quizTime;
  PlayQuiz(this.quizId,this.quizTime);
  @override
  _PlayQuizState createState() => _PlayQuizState();
}
int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

int quizTime1 ;

class _PlayQuizState extends State<PlayQuiz> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionsSnapshot;

  bool isLoading = true;
  final limitTime = 50;

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot){
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot.data["question"];

    List<String> options =
    [
      questionSnapshot.data["option1"],
      questionSnapshot.data["option2"],
      questionSnapshot.data["option3"],
      questionSnapshot.data["option4"],
    ];

    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.data["option1"];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void dispose(){
    if(_controller.isAnimating || _controller.isCompleted)
      _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print("${widget.quizTime}");
    print("${widget.quizId}");
    databaseService.getQuizData(widget.quizId).then((value){
      questionsSnapshot = value;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionsSnapshot.documents.length;
      print("$total this is total");
      setState(() {

      });
    });
    super.initState();
    _controller = AnimationController(
        vsync: this,duration: Duration(seconds: int.parse(widget.quizTime)));
    _controller.addListener(() {
      if(_controller.isCompleted)
      {

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Results
          (correct: _correct, incorrect: _incorrect, total: total ,)));
      }
    });
    _controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black54
        ),
        brightness: Brightness.light,
      ),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              questionsSnapshot.documents == null
                  ? Container(
                child: Center(child: Text("No Data"),),
              )
                  : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24 ),
                  itemCount: questionsSnapshot.documents.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return QuizPlayTitle(
                      questionModel: getQuestionModelFromDatasnapshot(
                          questionsSnapshot.documents[index]),
                      index: index,
                    );
                  })
            ],
          ),
        ),
      ),

      floatingActionButton:  FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Results
            (correct: _correct, incorrect: _incorrect, total: total ,)));
        },
      ),

      bottomNavigationBar : BottomAppBar(

          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              Countdown(animation: StepTween(
                  begin: int.parse(widget.quizTime),
                  end: 0
              ).animate(_controller)),
            ],
          )
      ),
    );
  }
}

class QuizPlayTitle extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizPlayTitle({this.questionModel, this.index});

  @override
  _QuizPlayTitleState createState() => _QuizPlayTitleState();
}

class _QuizPlayTitleState extends State<QuizPlayTitle> {

  String optionSelected ="";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Q${widget.index+1}:  ${widget.questionModel.question}", style: TextStyle(fontSize: 17, color: Colors.black87),),
            //String option, description, correctAnswer, optionSelected;
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: (){
                if(!widget.questionModel.answered){
                  //correct
                  if(widget.questionModel.option1 == widget.questionModel.correctOption){
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {

                    });
                  }else{
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true ;
                    _incorrect = _incorrect + 1 ;
                    _notAttempted = _notAttempted - 1;
                    setState(() {

                    });
                  }
                }
              },
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.option1,
                option: "A",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(height: 4,),
            GestureDetector(
              onTap: (){
                if(!widget.questionModel.answered){
                  //correct
                  if(widget.questionModel.option2 == widget.questionModel.correctOption){
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                    print("${widget.questionModel.correctOption}");
                    setState(() {

                    });
                  }else{
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true ;
                    _incorrect = _incorrect + 1 ;
                    _notAttempted = _notAttempted - 1;
                    setState(() {

                    });
                  }
                }
              },

              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.option2,
                option: "B",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(height: 4,),
            GestureDetector(
              onTap: (){
                if(!widget.questionModel.answered){
                  //correct
                  if(widget.questionModel.option3 == widget.questionModel.correctOption){
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {

                    });
                  }else{
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true ;
                    _incorrect = _incorrect + 1 ;
                    _notAttempted = _notAttempted - 1;
                    setState(() {

                    });
                  }
                }
              },

              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.option3,
                option: "C",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(height: 4,),
            GestureDetector(
              onTap: (){
                if(!widget.questionModel.answered){
                  //correct
                  if(widget.questionModel.option4 == widget.questionModel.correctOption){
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {

                    });
                  }else{
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true ;
                    _incorrect = _incorrect + 1 ;
                    _notAttempted = _notAttempted - 1;
                    setState(() {

                    });
                  }
                }
              },

              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.option4,
                option: "D",
                optionSelected: optionSelected,
              ),

            ),
            SizedBox(height: 20,)
          ],),
      ),
    );
  }
}

