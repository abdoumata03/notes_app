import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/Models/note_mode.dart';
import 'package:notes/Services/db.dart';
import 'package:notes/details_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _noteController = TextEditingController();
  final dbService = SqfliteDB();

  List<Note> _notes = [];
  List<NoteModel> _dbNotes = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateNotes();
  }

  void updateNotes() async {
    _dbNotes = await dbService.getNotes();
    for (var note in _dbNotes) {
      print(note.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.blue[100],
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            actions: [
              IconButton(
                icon: Icon(Icons.edit_document),
                onPressed: () async {
                  print(await dbService.getNotes());
                },
              )
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
                            /*  _notes.add(Note(
                                note: _noteController.text,
                                date: DateTime.now())); */
                            dbService.insert(NoteModel(
                                description: _noteController.text,
                                date: DateTime.now().toString()));
                            _noteController.clear();
                            updateNotes();
                          });
                   
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.add_circle_outline_outlined),
          ),
          body: _dbNotes.length == 0
              ? const Center(
                  child: Text(""),
                )
              : OrientationBuilder(builder: (context, orientation) {
                  final isLandscape = orientation == Orientation.landscape;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: _dbNotes.length,
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
                                            builder: (context) => DetailsPage(
                                                note: _dbNotes[index]),
                                          ),
                                        );
                                      },
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Delete Note'),
                                                content: const Text(
                                                    'Are you sure you want to delete this note?'),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () {
                                                      setState(() {
                                                        _selectedIndex = 0;
                                                        dbService.delete(
                                                            _dbNotes[index].id!);
                                                        updateNotes();
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
                                        _dbNotes[index].description,
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
                                child: NoteDetailsCol(
                                    note: _dbNotes[_selectedIndex])))
                      ],
                    ),
                  );
                }),
        ),
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
