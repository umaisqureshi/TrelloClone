import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertask/Features/home/Controller/homeControllerImp.dart';
import 'package:fluttertask/Widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Components/buildItemComp.dart';
import '../Components/buildListComp.dart';
import '../Components/homeMiddleComp.dart';
import '../Components/homeTopComp.dart';
import '../model/tasksModel.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  List<AllTasksModel> _lists = [];
  // List<Tasks> completeList = [];
  // List<Tasks> todoList = [];
  // List<Tasks> inProgressList = [];

  String? dateTime;
  @override
  void initState() {
    super.initState();

    getAllTaskList();

    dateTime = DateFormat.yMMMM().format(DateTime.now());
  }

  getAllTaskList() {
    ref.read(allTaskListProvider.stream).forEach((value) {
      _lists = List.generate(3, (outerIndex) {
        return AllTasksModel(
            children: List.generate(value.length, (index) => value[index]));
      });
      //  getSeparatedList();
      setState(() {});
    });
  }

  // getSeparatedList() {
  //   completeList = ref.watch(completeTaskListProvider);

  //   todoList = ref.watch(todoTaskListProvider);
  //   inProgressList = ref.watch(inProgressTaskListProvider);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 20,
        hoverColor: Theme.of(context).primaryColor,
        hoverElevation: 50,
        shape: const StadiumBorder(),
        child: const Icon(Icons.add),
        onPressed: () {
          context.push("/CREATETASK");
        },
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _lists.isEmpty
          ? progressIndicator(context)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                homeTopWidget(context),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    dateTime!,
                    style: GoogleFonts.aBeeZee(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ref.watch(allTaskListProvider).when(
                      data: (data) => homeMiddleWidget(
                        data,
                        context,
                      ),
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => progressIndicator(context),
                    ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Expanded(
                  child: DragAndDropLists(
                    children: List.generate(_lists.length,
                        (index) => buildList(index, context, _lists)),
                    onItemReorder: _onItemReorder,
                    onListReorder: _onListReorder,
                    axis: Axis.horizontal,
                    listWidth: 300,
                    listDraggingWidth: 300,
                    listPadding: const EdgeInsets.all(8.0),
                  ),
                ),
              ],
            ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
      _lists[newListIndex].children.insert(newItemIndex, movedItem);
    });
    String getId = _lists[newListIndex].children[newItemIndex].id;
    ref.read(statusUpdateProvider(UpdateStatus(
        status: newListIndex == 0
            ? "Todo"
            : newListIndex == 1
                ? "In Progress"
                : "Complete",
        id: getId)));
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _lists.removeAt(oldListIndex);
      _lists.insert(newListIndex, movedList);
    });
  }
}
