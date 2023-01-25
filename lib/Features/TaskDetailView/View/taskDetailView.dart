import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertask/Features/TaskDetailView/Component/statusChangeComp.dart';
import 'package:fluttertask/Features/TaskDetailView/Controller/taskViewControllerImp.dart';
import 'package:fluttertask/Features/home/model/tasksModel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Widgets/widgets.dart';
import '../Component/taskDetailedBottomComp.dart';

class TaskDetailedView extends ConsumerStatefulWidget {
  final Tasks task;
  const TaskDetailedView({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TaskDetailedViewState();
}

class _TaskDetailedViewState extends ConsumerState<TaskDetailedView> {
  bool editable = false;
  TextEditingController taskName = TextEditingController();
  TextEditingController projectName = TextEditingController();
  TextEditingController assigneeName = TextEditingController();
  TextEditingController descriptionName = TextEditingController();
  TextEditingController statusName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime formattedDate =
        DateTime.fromMillisecondsSinceEpoch(widget.task.createdAt);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Task Detail",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.aBeeZee(
                      color: Theme.of(context).primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    height: size.height,
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).backgroundColor.withOpacity(0.9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          titleAndDetailedWidget("Task Name", widget.task.name,
                              context, size, editable, taskName, 1, 30),
                          titleAndDetailedWidget(
                              "Project Name",
                              widget.task.project,
                              context,
                              size,
                              editable,
                              projectName,
                              1,
                              20),
                          titleAndDetailedWidget(
                              "Assigned to",
                              widget.task.assignee,
                              context,
                              size,
                              editable,
                              assigneeName,
                              1,
                              20),
                          titleAndDetailedWidget("Status", widget.task.status,
                              context, size, editable, statusName, 1, 10),
                          titleAndDetailedWidget(
                              "Created at",
                              "${formattedDate.day.toString()}-${formattedDate.month.toString()}-${formattedDate.year.toString()}",
                              context,
                              size,
                              false,
                              null,
                              0,
                              0),
                          titleAndDetailedWidget(
                              "Time Spend",
                              "${widget.task.timeInHour} : ${widget.task.timeInMin} : ${widget.task.timeInSec}",
                              context,
                              size,
                              false,
                              null,
                              0,
                              0),
                          titleAndDetailedWidget(
                              "Description",
                              widget.task.description,
                              context,
                              size,
                              editable,
                              descriptionName,
                              8,
                              200),
                          editable
                              ? SizedBox(
                                  height: size.height * 0.02,
                                )
                              : SizedBox(
                                  height: size.height * 0.1,
                                ),
                          editable
                              ? raisedTextButton(() {
                                  ref.read(updateTasksProvider(Tasks(
                                      name: taskName.text,
                                      description: descriptionName.text,
                                      id: widget.task.id,
                                      timeInHour: widget.task.timeInHour,
                                      timeInMin: widget.task.timeInMin,
                                      assignee: assigneeName.text,
                                      timeInSec: widget.task.timeInSec,
                                      project: projectName.text,
                                      isCompleted: widget.task.isCompleted,
                                      status:
                                          ref.read(statusValueProvider) == ""
                                              ? widget.task.status
                                              : ref.read(statusValueProvider),
                                      createdAt: widget.task.createdAt)));
                                  setState(() {
                                    editable = false;
                                  });
                                  context.push("/HOME");
                                }, " Save ", Theme.of(context).primaryColor)
                              : TaskDetailedTopComp(
                                  size: size,
                                  widget: widget,
                                  onEdit: () {
                                    setState(() {
                                      editable = true;
                                    });
                                    taskName.text = widget.task.name;
                                    projectName.text = widget.task.project;
                                    descriptionName.text =
                                        widget.task.description;
                                    statusName.text = widget.task.status;
                                    assigneeName.text = widget.task.assignee;
                                  },
                                  onDelete: () {
                                    showDialogBox(context, "Delete Task",
                                        "You Really want to delete this task",
                                        (() {
                                      ref.read(
                                          deleteTaskProvider(widget.task.id));
                                      showSnackBar(
                                          context, "Task Deleted Successfully");
                                      context.push("/HOME");
                                    }));
                                  })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
