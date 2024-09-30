import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_todo/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Liste d'éléments avec la taille de chaque tuile
  final List<GridItem> items = const [
    GridItem(crossAxisCount: 3, mainAxisCount: 4, size: 3),
    GridItem(crossAxisCount: 2, mainAxisCount: 2, size: 1),
    GridItem(crossAxisCount: 2, mainAxisCount: 2, size: 1),
    GridItem(crossAxisCount: 2, mainAxisCount: 3, size: 2),
    GridItem(crossAxisCount: 3, mainAxisCount: 3, size: 2),
    GridItem(crossAxisCount: 3, mainAxisCount: 2, size: 1),
    GridItem(crossAxisCount: 2, mainAxisCount: 4, size: 3),
    GridItem(crossAxisCount: 3, mainAxisCount: 2, size: 1),
    GridItem(crossAxisCount: 2, mainAxisCount: 4, size: 3),
    GridItem(crossAxisCount: 3, mainAxisCount: 2, size: 1),
    GridItem(crossAxisCount: 3, mainAxisCount: 2, size: 1),
    GridItem(crossAxisCount: 5, mainAxisCount: 3, size: 2),
  ];

  //firestore
  final FirestoreService firestoreService = FirestoreService();

  // texts controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // open a dialog to add note or update
  void openNoteBox(String? docID, String? note, String? content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
              docID == null ? 'ADD NOTE' : 'UPDATE NOTE',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: docID == null ? 'Title' : note,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: docID == null ? 'Content' : content,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (docID != null) {
                firestoreService.updateNote(docID, titleController.text, contentController.text);
              } else {
                firestoreService.addNote(titleController.text, contentController.text);
              }
              // clear text fields
              titleController.clear();
              contentController.clear();

              Navigator.pop(context);
              //addNote();
            },
            child: const Text('Add'),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.black,
                    ),
                    Container(
                      width: 37,
                      height: 37,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'My Notes',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.search,
                                    size: 30, color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  'Search',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.mic, size: 30, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text(
                            'All Notes',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 25),
                          Text(
                            'To Do',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(width: 25),
                          Text(
                            'Personal',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(width: 25),
                          Text(
                            'Work',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(width: 25),
                          Text(
                            'Shopping',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(width: 25),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    StreamBuilder<QuerySnapshot>(
                      stream: firestoreService.getNotes(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text(
                              'Nothing here..',
                            ),
                          );
                        } else {
                          List notesList = snapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: notesList.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot note = notesList[index];
                              String docId = note.id;

                              Map<String, dynamic> data = note.data() as Map<String, dynamic>;

                              String noteTitle = data['note'];
                              String noteContent = data['content'];

                              return Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                noteTitle,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                noteContent,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ]
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                openNoteBox(docId, noteTitle, noteContent);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                firestoreService.deleteNote(docId);
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                              );
                            },
                          );
                        }
                      }
                    ),

                    // Bento grid with variable sizes generated dynamically
                    /*StaggeredGrid.count(
                      crossAxisCount: 5, // Number of columns in the grid
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: items
                          .asMap()
                          .entries
                          .map(
                            (entry) => StaggeredGridTile.count(
                          crossAxisCellCount: entry.value.crossAxisCount,
                          mainAxisCellCount: entry.value.mainAxisCount,
                          child: GridTileContent(
                            index: entry.key + 1,
                            size: entry.value.size,
                            mainAxisCount: entry.value.mainAxisCount,
                            crossAxisCount: entry.value.crossAxisCount,
                          ),
                        ),
                      )
                          .toList(),
                    ),*/
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openNoteBox(null, null, null);
        },
        backgroundColor: Colors.indigoAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Classe pour représenter un élément de la grille
class GridItem {
  final int crossAxisCount;
  final int mainAxisCount;
  final int size;

  const GridItem({
    required this.crossAxisCount,
    required this.mainAxisCount,
    required this.size,
  });
}

class GridTileContent extends StatelessWidget {
  final int index;
  final int size;
  final int mainAxisCount;
  final int crossAxisCount;
  const GridTileContent({super.key, required this.index, required this.size, required this.mainAxisCount, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titre $index',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: double.infinity,
              height: size * 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                //color: Colors.red,
              ),
              child: const Text(
                'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                overflow: TextOverflow.fade,
                //maxLines: maxligne,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

