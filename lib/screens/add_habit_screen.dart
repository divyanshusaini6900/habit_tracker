import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/constants.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _habitNameController = TextEditingController();
  String _selectedEmoji = '⭐';
  Color _selectedColor = Colors.blue;
  
  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }
  
  void _saveHabit() {
    final habitName = _habitNameController.text.trim();
    
    if (habitName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a habit name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // create new habit
    final newHabit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: habitName,
      emoji: _selectedEmoji,
      habitColor: _selectedColor,
    );
    
    // add to provider
    context.read<HabitProvider>().addNewHabit(newHabit);
    
    // go back with success
    Navigator.pop(context, true);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Habit'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // habit name input
            const Text(
              'Habit Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _habitNameController,
              decoration: InputDecoration(
                hintText: 'e.g., Drink 8 glasses of water',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                prefixIcon: const Icon(Icons.edit),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 30),
            
            // emoji selection
            const Text(
              'Choose an Icon',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            _buildEmojiGrid(),
            
            const SizedBox(height: 30),
            
            // color selection
            const Text(
              'Pick a Color',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            _buildColorPalette(),
            
            const SizedBox(height: 40),
            
            // save button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Habit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmojiGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: AppEmojis.habitEmojis.length,
      itemBuilder: (context, index) {
        final emoji = AppEmojis.habitEmojis[index];
        final isSelected = emoji == _selectedEmoji;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedEmoji = emoji;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.deepPurple.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.deepPurple : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildColorPalette() {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: AppColors.habitColors.map((color) {
        final isSelected = color == _selectedColor;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}