enum TaskCategory { work, school, family, personal }

extension TaskCategoryX on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.school:
        return 'School';
      case TaskCategory.family:
        return 'Family';
      case TaskCategory.personal:
        return 'Personal';
    }
  }
}

class TaskItem {
  final String id;
  final String title;
  final TaskCategory category;
  final Duration estimated;
  final String? whyItMatters;
  final bool done;

  const TaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.estimated,
    this.whyItMatters,
    this.done = false,
  });

  TaskItem copyWith({bool? done}) => TaskItem(
        id: id,
        title: title,
        category: category,
        estimated: estimated,
        whyItMatters: whyItMatters,
        done: done ?? this.done,
      );
}
