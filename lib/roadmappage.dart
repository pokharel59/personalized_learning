import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:math' as math;

class RoadmapPage extends StatefulWidget {
  final String topic;

  RoadmapPage({required this.topic});

  @override
  _RoadmapPageState createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  List<bool> _completedSections = List.filled(7, false);
  int _progress = 0;

  void _updateProgress() {
    setState(() {
      _progress = _completedSections.where((element) => element).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.topic} Adventure', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF023047),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[100]!, Colors.orange[50]!],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: _progress / 6,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            Text(
              'Progress: $_progress / 6',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoadmapSection(
                        title: 'Introduction to ${widget.topic}',
                        icon: Icons.start,
                        content: Text('Learn about the basics of ${widget.topic} and its properties.'),
                        isCompleted: _completedSections[0],
                        onTap: () => _navigateToContentPage(context, 'Introduction to ${widget.topic}', 0),
                      ),
                      RoadmapDivider(isActive: _completedSections[0]),
                      RoadmapSection(
                        title: 'Visual Concepts',
                        icon: Icons.image,
                        content: Text('See the video to understand more about heat'),
                        isCompleted: _completedSections[1],
                        onTap: () => _navigateToVideoplayer(context),
                      ),
                      RoadmapDivider(isActive: _completedSections[2]),
                      RoadmapSection(
                        title: 'Interactive Quiz',
                        icon: Icons.quiz,
                        content: ElevatedButton(
                          child: Text('Start Quiz'),
                          onPressed: () {
                            _navigateToQuizPage(context, 3);
                          },
                        ),
                        isCompleted: _completedSections[3],
                        onTap: () => _navigateToQuizPage(context, 3),
                      ),
                      RoadmapDivider(isActive: _completedSections[3]),
                      RoadmapSection(
                        title: 'Important Notes',
                        icon: Icons.note,
                        content: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Key points to remember about ${widget.topic}...'),
                          ),
                        ),
                        isCompleted: _completedSections[4],
                        onTap: () => _navigationToNotePage(context),
                      ),
                      RoadmapDivider(isActive: _completedSections[5]),
                      RoadmapSection(
                        title: 'Final Assignment',
                        icon: Icons.assignment,
                        content: Text('Complete the ${widget.topic} experiment and submit your report.'),
                        isCompleted: _completedSections[5],
                        onTap: () => _navigateToAssignmentPage(context, 5),
                      ),
                      RoadmapDivider(isActive: _completedSections[6]),
                      RoadmapSection(
                        title: 'Discuss Forum',
                        icon: Icons.people,
                        content: Text('Enter a room to discuss on ${widget.topic} topic.'),
                        isCompleted: _completedSections[6],
                        onTap: () => _navigationToForumPage(context),
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

  void _navigateToContentPage(BuildContext context, String title, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentPage(
          title: title,
          topic: widget.topic,
          onComplete: () => _markAsCompleted(index),
        ),
      ),
    );
  }

  void _navigateToQuizPage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          topic: widget.topic,
          onComplete: () => _markAsCompleted(index),
        ),
      ),
    );
  }

  void _navigateToAssignmentPage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentPage(
          topic: widget.topic,
          onComplete: () => _markAsCompleted(index),
        ),
      ),
    );
  }

  void _navigateToVideoplayer(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => VideoViewer())
    );
  }

  void _navigationToNotePage(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotePage(topic: 'Heat'))
    );
  }

  void _navigationToForumPage(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DiscussionForumPage())
    );
  }

  void _markAsCompleted(int index) {
    setState(() {
      _completedSections[index] = true;
      _updateProgress();
    });
  }
}

class RoadmapSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget content;
  final bool isCompleted;
  final VoidCallback onTap;

  RoadmapSection({
    required this.title,
    required this.icon,
    required this.content,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.green[100] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Color(0xFF023047),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isCompleted)
                  Icon(Icons.check_circle, color: Colors.green)
              ],
            ),
            SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}

class RoadmapDivider extends StatelessWidget {
  final bool isActive;

  RoadmapDivider({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 4,
            color: isActive ? Colors.green : Colors.grey[300],
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.green : Colors.grey[300],
            ),
            child: Icon(
              Icons.arrow_downward,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  final String title;
  final String topic;
  final VoidCallback onComplete;

  ContentPage({required this.title, required this.topic, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comprehensive Explanation of Heat',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Heat is a fundamental concept in physics and a form of energy associated with the movement of particles within a substance. It\'s often misunderstood as being the same as temperature, but while temperature measures the average kinetic energy of particles, heat represents the total energy transferred between systems or bodies due to a temperature difference.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Key Concepts Related to Heat:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildSection('Thermodynamics', [
                'First Law of Thermodynamics: Also known as the law of energy conservation, it states that energy cannot be created or destroyed, only transferred or converted from one form to another.',
                'Second Law of Thermodynamics: This law introduces the concept of entropy, stating that heat energy spontaneously flows from a body of higher temperature to one of lower temperature.',
                'Third Law of Thermodynamics: As the temperature of a system approaches absolute zero, the entropy approaches a constant minimum.',
              ]),
              _buildSection('Heat Transfer Methods', [
                'Conduction: The transfer of heat through a material without the movement of the material itself.',
                'Convection: The transfer of heat by the physical movement of a fluid (liquid or gas).',
                'Radiation: The transfer of heat through electromagnetic waves without involving particles.',
              ]),
              _buildSection('Specific Heat Capacity', [
                'This is the amount of heat required to raise the temperature of a unit mass of a substance by one degree Celsius.',
              ]),
              _buildSection('Latent Heat', [
                'Latent Heat of Fusion: The heat required to change a substance from a solid to a liquid without changing its temperature.',
                'Latent Heat of Vaporization: The heat required to change a substance from a liquid to a gas without changing its temperature.',
              ]),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    onComplete();
                    Navigator.pop(context);
                  },
                  child: Text('Mark as Completed'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ...points.map((point) => Padding(
          padding: EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            '• $point',
            style: TextStyle(fontSize: 16),
          ),
        )).toList(),
        SizedBox(height: 16),
      ],
    );
  }
}

class QuizPage extends StatefulWidget {
  final String topic;
  final VoidCallback onComplete;

  QuizPage({required this.topic, required this.onComplete});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  List<int?> _userAnswers = List.filled(5, null);
  int _score = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _timeLeft = 30;
  late Timer _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What does the First Law of Thermodynamics state?',
      'options': [
        'Energy can be created and destroyed',
        'Energy cannot be created or destroyed, only transferred',
        'Heat always flows from cold to hot',
        'Temperature is constant during phase changes'
      ],
      'correctAnswer': 1
    },
    {
      'question': 'Which method of heat transfer occurs in solids?',
      'options': ['Conduction', 'Convection', 'Radiation', 'All of the above'],
      'correctAnswer': 0
    },
    {
      'question': 'What is specific heat capacity?',
      'options': [
        'The heat required to change the temperature of a substance by 1 degree Celsius',
        'The temperature at which a substance changes phase',
        'The ability of a material to conduct heat',
        'The amount of energy released during condensation'
      ],
      'correctAnswer': 0
    },
    {
      'question': 'What happens during the process of condensation?',
      'options': [
        'A liquid turns into a solid',
        'A gas turns into a liquid and releases heat',
        'A solid turns into a liquid',
        'A liquid turns into a gas and absorbs heat'
      ],
      'correctAnswer': 1
    },
    {
      'question': 'Why does water have a high thermal inertia?',
      'options': [
        'Because it has a low specific heat capacity',
        'Because it heats up and cools down quickly',
        'Because it requires a lot of energy to change its temperature',
        'Because it does not conduct heat well'
      ],
      'correctAnswer': 2
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_timeLeft < 1) {
            timer.cancel();
            _answerQuestion(null);
          } else {
            _timeLeft = _timeLeft - 1;
          }
        },
      ),
    );
  }

  void _answerQuestion(int? answerIndex) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = answerIndex;
      if (answerIndex == _questions[_currentQuestionIndex]['correctAnswer']) {
        _score += (_timeLeft * 10); // Score based on remaining time
      }
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _timeLeft = 30;
        _animationController.reset();
        _animationController.forward();
      } else {
        _timer.cancel();
        _submitQuiz();
      }
    });
  }

  void _submitQuiz() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your score: $_score'),
              SizedBox(height: 20),
              Text('Correct answers: ${_userAnswers.where((answer) => answer == _questions[_userAnswers.indexOf(answer)]['correctAnswer']).length} out of ${_questions.length}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onComplete();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz on ${widget.topic}'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100]!, Colors.purple[300]!],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Score: $_score',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: _animation.value,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _timeLeft > 10 ? Colors.green : Colors.red,
                ),
              ),
              Text(
                'Time left: $_timeLeft seconds',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    _questions[_currentQuestionIndex]['question'],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),
// Replace the options part in the build method with this code:

              Expanded(
                child: ListView.builder(
                  itemCount: _questions[_currentQuestionIndex]['options'].length,
                  itemBuilder: (context, idx) {
                    String option = _questions[_currentQuestionIndex]['options'][idx];
                    bool isSelected = _userAnswers[_currentQuestionIndex] == idx;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isSelected
                                ? [Colors.blue[400]!, Colors.blue[600]!]
                                : [Colors.purple[100]!, Colors.purple[300]!],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected ? Colors.blue.withOpacity(0.6) : Colors.purple.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => _answerQuestion(idx),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.white : Colors.purple[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + idx), // A, B, C, D
                                        style: TextStyle(
                                          color: isSelected ? Colors.blue[600] : Colors.purple[400],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }
}

class AssignmentPage extends StatefulWidget {
  final String topic;
  final VoidCallback onComplete;

  AssignmentPage({required this.topic, required this.onComplete});

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;
  bool _isExpanded4 = false;
  bool _isExpanded5 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment: ${widget.topic}'),
        backgroundColor: Colors.orange[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Investigating Heat Transfer and Energy Conservation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Objective: Understand the principles of heat transfer and thermodynamics through experiments and analysis.',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 24),
              _buildExpansionTile(
                'Experiment 1: Conduction in Different Materials',
                _isExpanded1,
                  (bool expanded) => setState(() => _isExpanded1 = !_isExpanded1),
                [
                  'Collect materials like metal, wood, and plastic.',
                  'Heat one end of each material and observe how heat travels along them.',
                  'Record which material conducts heat the fastest.',
                  'Question: What property of the material affects its ability to conduct heat? How is this useful in everyday applications?',
                ],
              ),
              _buildExpansionTile(
                'Experiment 2: Convection Currents in Water',
                _isExpanded2,
                    (bool expanded) => setState(() => _isExpanded2 = !_isExpanded2),
                [
                  'Heat a pot of water and add a few drops of food coloring.',
                  'Observe how the color moves as the water heats up.',
                  'Sketch the convection currents formed in the water.',
                  'Question: How do convection currents help distribute heat in fluids? Where can we observe this phenomenon in nature?',
                ],
              ),
              _buildExpansionTile(
                'Experiment 3: Radiation and Heat Absorption',
                _isExpanded3,
                    (bool expanded) => setState(() => _isExpanded3 = !_isExpanded3),
                [
                  'Place two objects, one black and one white, under a heat lamp or in sunlight.',
                  'Measure their temperature over time.',
                  'Determine which object absorbs more heat.',
                  'Question: How does color affect heat absorption? How can this knowledge be applied to design energy-efficient buildings?',
                ],
              ),
              _buildExpansionTile(
                'Analysis',
                _isExpanded4,
                    (bool expanded) => setState(() => _isExpanded4 = !_isExpanded4),
                [
                  'Write a report summarizing your experiments and the principles of heat transfer involved.',
                  'Discuss how the first and second laws of thermodynamics apply to these experiments.',
                ],
              ),
              _buildExpansionTile(
                'Submission',
                _isExpanded5,
                    (bool expanded) => setState(() => _isExpanded5 = !_isExpanded5),
                [
                  'Submit your report, along with any sketches, diagrams, or photographs, illustrating your findings.',
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showSubmissionDialog();
                  },
                  child: Text('Submit Assignment'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, bool isExpanded, Function(bool) onExpansionChanged, List<String> children) {
    return Card(
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        children: children.map((child) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text('• $child'),
        )).toList(),
        onExpansionChanged: onExpansionChanged,
        initiallyExpanded: isExpanded,
      ),
    );
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Assignment'),
          content: Text('Are you sure you want to submit your assignment?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onComplete();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class VideoViewer extends StatefulWidget {
  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isSliding = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/heatVideo.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  if (_showControls) ...[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black54,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black54,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _formatDuration(_controller.value.position),
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                                    trackShape: RectangularSliderTrackShape(),
                                    trackHeight: 2.0,
                                    activeTrackColor: Colors.red,
                                    inactiveTrackColor: Colors.grey,
                                    thumbColor: Colors.red,
                                  ),
                                  child: Slider(
                                    value: _controller.value.position.inSeconds.toDouble(),
                                    min: 0.0,
                                    max: _controller.value.duration.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        if (!_isSliding) {
                                          _isSliding = true;
                                          _controller.pause();
                                        }
                                        _controller.seekTo(Duration(seconds: value.toInt()));
                                      });
                                    },
                                    onChangeEnd: (value) {
                                      setState(() {
                                        _isSliding = false;
                                        _controller.play();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                _formatDuration(_controller.value.duration),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.replay_10, color: Colors.white),
                                onPressed: () {
                                  _controller.seekTo(_controller.value.position - Duration(seconds: 10));
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.forward_10, color: Colors.white),
                                onPressed: () {
                                  _controller.seekTo(_controller.value.position + Duration(seconds: 10));
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class NotePage extends StatefulWidget {
  final String topic;

  NotePage({required this.topic});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Note> notes = [
    Note(
      title: 'Heat Basics',
      content: 'Heat is a form of energy transfer between objects due to temperature difference.',
    ),
    Note(
      title: 'Heat Transfer Methods',
      content: 'Heat transfers through conduction, convection, and radiation.',
    ),
    Note(
      title: 'Thermodynamics',
      content: 'The laws of thermodynamics govern how heat behaves in systems.',
    ),
    Note(
      title: 'Specific Heat',
      content: 'Specific heat capacity is the amount of heat needed to raise 1g of a substance by 1°C.',
    ),
    Note(
      title: 'Thermal Applications',
      content: 'Understanding heat is crucial for various applications from engines to climate studies.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextNote() {
    if (_currentIndex < notes.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousNote() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Notes: ${widget.topic}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple[100]!, Colors.deepPurple[300]!],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: notes.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return FlashCard(note: notes[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentIndex > 0 ? _previousNote : null,
                    child: Icon(Icons.arrow_back),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                  Text(
                    '${_currentIndex + 1} / ${notes.length}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: _currentIndex < notes.length - 1 ? _nextNote : null,
                    child: Icon(Icons.arrow_forward),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Note {
  final String title;
  final String content;

  Note({required this.title, required this.content});
}

class FlashCard extends StatefulWidget {
  final Note note;

  FlashCard({required this.note});

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showContent) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _showContent = !_showContent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: _animation.value),
        duration: Duration(milliseconds: 300),
        builder: (BuildContext context, double value, Widget? child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value * math.pi),
            child: value < 0.5 ? _buildFront() : _buildBack(),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              widget.note.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                widget.note.content,
                style: TextStyle(fontSize: 18, color: Colors.deepPurple[800]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiscussionForumPage extends StatefulWidget {
  @override
  _DiscussionForumPageState createState() => _DiscussionForumPageState();
}

class _DiscussionForumPageState extends State<DiscussionForumPage> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController();
  List<Message> messages = [
    Message("How can we reduce carbon emissions in urban areas?", "Moderator", isQuestion: true),
    Message("We could promote public transportation and cycling.", "User1"),
    Message("Implementing green building standards could help too.", "User2"),
    Message("What about incentivizing electric vehicles?", "User3"),
  ];
  String? submittedSolution;
  int userScore = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void _addMessage(String text) {
    setState(() {
      messages.add(Message(text, "You"));
      userScore += 5; // Reward points for participation
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoTalk Forum'),
        backgroundColor: Colors.green[700],
        actions: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_animationController.value * 0.2),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Chip(
                    avatar: Icon(Icons.star, color: Colors.yellow),
                    label: Text('$userScore', style: TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.green[100],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.green[100]!],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(message: messages[index]);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Share your green ideas...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    child: Icon(Icons.send),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        _addMessage(_messageController.text);
                        _messageController.clear();
                      }
                    },
                    backgroundColor: Colors.green[700],
                  ),
                ],
              ),
            ),
            SolutionSubmissionSection(
              onSubmit: (solution) {
                setState(() {
                  submittedSolution = solution;
                  userScore += 50; // Bonus points for submitting a solution
                  _animationController.forward(from: 0.0);
                });
              },
              submittedSolution: submittedSolution,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class Message {
  final String text;
  final String sender;
  final bool isQuestion;

  Message(this.text, this.sender, {this.isQuestion = false});
}

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            decoration: BoxDecoration(
              color: message.isQuestion ? Colors.yellow[100] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: message.isQuestion ? 18 : 15,
                  fontWeight: message.isQuestion ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SolutionSubmissionSection extends StatefulWidget {
  final Function(String) onSubmit;
  final String? submittedSolution;

  SolutionSubmissionSection({required this.onSubmit, this.submittedSolution});

  @override
  _SolutionSubmissionSectionState createState() => _SolutionSubmissionSectionState();
}

class _SolutionSubmissionSectionState extends State<SolutionSubmissionSection> {
  final TextEditingController _solutionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.submittedSolution != null) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[300]!, Colors.green[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Collective Solution:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green[800]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                widget.submittedSolution!,
                style: TextStyle(fontSize: 16, color: Colors.green[800]),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[100]!, Colors.blue[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submit Collective Solution:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue[800]),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _solutionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Type the agreed solution here...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (_solutionController.text.isNotEmpty) {
                widget.onSubmit(_solutionController.text);
              }
            },
            child: Text('Submit Solution'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}
