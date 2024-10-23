import 'package:flutter/material.dart';
import 'add_question_page.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/flashcards': (context) => FlashCardApp(),
        // '/add_question': (context) => AddQuestionPage(),  // Add this line
      },
    );
  }
}


class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,  // Hide the AppBar
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/land.png',  // Replace with your generated image file name
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),  // Adjust the sigma values to control blur intensity
            child: Container(
              color: Colors.black.withOpacity(0.7),  // Optional: Add a semi-transparent overlay
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome, Learner!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/flashcards');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),  // Increase button size
                    textStyle: TextStyle(fontSize: 20),  // Increase text size
                    backgroundColor: Colors.white,  // Button background color
                    foregroundColor: Colors.black,  // Button text color
                  ),
                  child: Text('Start Flashcards'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}



class FlashCardApp extends StatefulWidget {
  @override
  _FlashCardAppState createState() => _FlashCardAppState();
}

class _FlashCardAppState extends State<FlashCardApp> {
  List<FlashCard> flashCards = [
    FlashCard('What is 2 + 2?', ['3', '4', '5', '6'], 1, 'Easy'),
    FlashCard('What is 3 + 5?', ['5', '7', '8', '9'], 2, 'Medium'),
  ];

  void _addNewQuestion(FlashCard newQuestion) {
    setState(() {
      flashCards.add(newQuestion);
    });
  }

  void _handleAnswer(bool isCorrect) {
    if (isCorrect) {
      // Move to the next flashcard
      // Logic to update the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flash Card App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddQuestionPage(
                    existingQuestions: flashCards,
                    onAddQuestion: _addNewQuestion,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: flashCards.length,
        itemBuilder: (context, index) {
          return FlashCardWidget(
            flashCard: flashCards[index],
            // onAnswerSelected: _handleAnswer,
          );
        },
      ),
    );
  }
}


// class FlashCard {
//   final String question;
//   final List<String> options;
//   final int correctAnswer;
//   final String difficulty;
//
//   FlashCard(this.question, this.options, this.correctAnswer , this.difficulty);
// }

class FlashCard {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String difficulty; // Added for difficulty

  FlashCard(this.question, this.options, this.correctAnswer, this.difficulty);
}

class FlashCardWidget extends StatelessWidget {
  final FlashCard flashCard;

  FlashCardWidget({required this.flashCard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: _getCardColor(flashCard.difficulty), // Set color based on difficulty
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                flashCard.question,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              _buildDifficultyLabel(flashCard.difficulty),  // Difficulty label
              SizedBox(height: 20),
              ...flashCard.options.map((option) {
                int index = flashCard.options.indexOf(option);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      if (index == flashCard.correctAnswer) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Correct!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Wrong! Try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyLabel(String difficulty) {
    return Text(
      difficulty,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Color _getCardColor(String difficulty) {
    switch (difficulty) {
      case 'Hard':
        return Colors.redAccent.withOpacity(0.8);
      case 'Medium':
        return Colors.orangeAccent.withOpacity(0.8);
      case 'Easy':
      default:
        return Colors.greenAccent.withOpacity(0.8);
    }
  }
}