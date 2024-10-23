import 'package:flutter/material.dart';
import 'main.dart';
class AddQuestionPage extends StatefulWidget {
  final List<FlashCard> existingQuestions;
  final Function(FlashCard) onAddQuestion;

  AddQuestionPage({required this.existingQuestions, required this.onAddQuestion});

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  final _correctOptionController = TextEditingController();
  String _selectedDifficulty = 'Easy';  // Default difficulty level

  void _submitQuestion() {
    if (_formKey.currentState?.validate() ?? false) {
      final newQuestion = FlashCard(
        _questionController.text,
        [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ],
        int.parse(_correctOptionController.text),
        _selectedDifficulty,  // Include difficulty level
      );

      widget.onAddQuestion(newQuestion);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question added!')),
      );

      _questionController.clear();
      _option1Controller.clear();
      _option2Controller.clear();
      _option3Controller.clear();
      _option4Controller.clear();
      _correctOptionController.clear();
      setState(() {
        _selectedDifficulty = 'Easy';  // Reset to default difficulty
      });
    }
  }

  void _removeQuestion(int index) {
    setState(() {
      widget.existingQuestions.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Question removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _questionController,
                      decoration: InputDecoration(labelText: 'Question'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a question';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _option1Controller,
                      decoration: InputDecoration(labelText: 'Option 1'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter option 1';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _option2Controller,
                      decoration: InputDecoration(labelText: 'Option 2'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter option 2';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _option3Controller,
                      decoration: InputDecoration(labelText: 'Option 3'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter option 3';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _option4Controller,
                      decoration: InputDecoration(labelText: 'Option 4'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter option 4';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _correctOptionController,
                      decoration: InputDecoration(labelText: 'Correct Option (1-4)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) < 1 || int.parse(value) > 4) {
                          return 'Please enter a valid option number (1-4)';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedDifficulty,
                      decoration: InputDecoration(labelText: 'Difficulty Level'),
                      items: ['Easy', 'Medium', 'Hard'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDifficulty = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitQuestion,
                      child: Text('Add Question'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.existingQuestions.length,
                itemBuilder: (context, index) {
                  final question = widget.existingQuestions[index];
                  return ListTile(
                    title: Text(question.question),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _removeQuestion(index);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
