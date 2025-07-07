import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {

  final String labelText;
  final Color chipColor;

  const TaskCard({
    super.key,
    required this.labelText,
    required this.chipColor,
  });


  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title will be here',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text('Description', style: TextStyle(color: Colors.black54)),
            Text('Date: 12/12/12'),
            const SizedBox(height: 8),
            Row(
              children: [
              Chip(
              label: Text(
              widget.labelText,
              style: const TextStyle(color: Colors.white),
            ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: widget.chipColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}