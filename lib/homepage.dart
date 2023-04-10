import 'package:flutter/material.dart';
import 'package:localhive_storage_flutter/models/notes_models.dart';
import 'boxes/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter hive"),
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: Boxes.getData().listenable(),
        builder: (context, box, child) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context,index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(data[index].title.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                          const Spacer(),
                          InkWell(
                            onTap: (){
                              updatefields(data[index], data[index].title.toString(),data[index].description.toString());
                            },
                            child: const Icon(Icons.edit),
                          ),
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: (){
                              delete(data[index]);
                            },
                            child: const Icon(Icons.delete),
                          )
                        ],
                      ),
                    
                    Text(data[index].description.toString())
                  ]),
                ),
              );
            }
            );
        },)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          showDialogMethod();
        },
        child: const Icon(Icons.add),
        ),
    );
  }

  void delete(NotesModel notesModel) async{
    await notesModel.delete();

  }

  Future<void> updatefields(NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Edit Notes"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Enter Title",
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Enter description",
                    border: OutlineInputBorder()
                  ),
                )
              ],
            )
            ),
          actions: [
            TextButton(onPressed: 
            (){
              notesModel.title = titleController.text;
              notesModel.description = descriptionController.text;
              notesModel.save();
              titleController.clear();
              descriptionController.clear();
              Navigator.pop(context);
            }, 
            child: const Text("Edit")),

            TextButton(
              onPressed: 
            (){
              Navigator.pop(context);
            },
            child: const Text("Cancel"))
          ],
        );
      }
    );
  }

  Future <void> showDialogMethod() async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Add Notes"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Enter Title",
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Enter description",
                    border: OutlineInputBorder()
                  ),
                )
              ],
            )
            ),
          actions: [
            TextButton(onPressed: 
            (){
              if(titleController.text.isNotEmpty && descriptionController.text.isNotEmpty)
              {
                final data = NotesModel(
                title: titleController.text, 
                description: descriptionController.text);
                final box = Boxes.getData();
                box.add(data);
                // data.save();
                print(data);
                titleController.clear();
                descriptionController.clear();
              Navigator.pop(context);
              }else{
                Navigator.pop(context);
              }
            }, 
            child: const Text("Add")),
            TextButton(onPressed: 
            (){
              Navigator.pop(context);
            }, 
            child: const Text("Cancel"))
          ],
        );
      }
    );
  }
}