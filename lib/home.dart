import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/details_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _noteController = TextEditingController();

  final List<Note> _notes = [];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Nouvelle Note'),
                  content: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your note',
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Noter'),
                      onPressed: () {
                        setState(() {
                          _notes.add(Note(
                              note: _noteController.text,
                              date: DateTime.now()));
                          _noteController.clear();
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        body: _notes.length == 0
            ? const Center(
                child: Text("NO NOTES AVAILABLE"),
              )
            : OrientationBuilder(builder: (context, orientation) {
                final isLandscape = orientation == Orientation.landscape;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Notes',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Center(
                                child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _notes.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider();
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 100,
                                  child: ListTile(
                                    onTap: () {
                                      if (isLandscape) {
                                        setState(() {
                                          _selectedIndex = index;
                                        });
                                        return;
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsPage(note: _notes[index]),
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Delete Note'),
                                              content: const Text(
                                                  'Are you sure you want to delete this note?'),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Yes'),
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedIndex = 0;
                                                      _notes.removeAt(index);
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    leading: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/avatar.png'),
                                    ),
                                    title: const Text(
                                      'Abdallah',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      _notes[index].note,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              },
                            )),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: isLandscape,
                          child: Expanded(
                              flex: 2,
                              child:
                                  NoteDetailsCol(note: _notes[_selectedIndex])))
                    ],
                  ),
                );
              }),
      ),
    );
  }
}

class Note {
  final String note;
  final DateTime date;

  Note({
    required this.note,
    required this.date,
  });
}
