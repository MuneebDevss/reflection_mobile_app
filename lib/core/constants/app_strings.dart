/// App-wide string constants
class AppStrings {
  AppStrings._();

  // App
  static const String appTitle = 'Reflection - Goal Tracker';

  // Screen Titles
  static const String myGoalsTitle = 'My Goals';
  static const String goalDetailsTitle = 'Goal Details';
  static const String taskHistoryTitle = 'Task History';
  static const String newGoalTitle = 'New Goal';

  // Dashboard
  static const String overviewLabel = 'Overview';
  static const String totalGoalsLabel = 'Total Goals';
  static const String completedLabel = 'Completed';
  static const String inProgressLabel = 'In Progress';
  static const String overdueLabel = 'Overdue';
  static const String averageProgressLabel = 'Average Progress';

  // Goal Section
  static const String yourGoalLabel = 'Your Goal';
  static const String goalsListTitle = 'Your Goals';
  static const String progressLabel = 'Progress';
  static const String dueDateLabel = 'Due Date';
  static const String createdLabel = 'Created';
  static const String lastUpdatedLabel = 'Last Updated';

  // Tasks
  static const String todaysTasks = "Today's Tasks";
  static const String todayTasksTitle = "Today's Tasks";
  static const String completedTasksLabel = 'Completed Tasks';
  static const String taskDetailsTitle = 'Task Details';
  static const String descriptionLabel = 'Description';
  static const String statusLabel = 'Status';
  static const String dateLabel = 'Date';
  static const String performanceOverviewLabel = 'Performance Overview';
  static const String totalLabel = 'Total';
  static const String missedLabel = 'Missed';
  static const String noTasksYet = 'No tasks yet';
  static const String generateTasksHint =
      'Tap "Generate Tasks" to create your daily tasks';
  static const String generatingTasks = 'Generating your tasks...';
  static const String generateTasks = 'Generate Tasks';
  static const String noHistoryYet = 'No history yet';
  static const String completeTasksHint =
      'Complete some tasks to see them here';

  // Actions
  static const String newGoalButton = 'New Goal';
  static const String generateTasksButton = 'Generate Tasks';
  static const String refreshButton = 'Refresh';
  static const String markAsCompleteButton = 'Mark as Complete';
  static const String markAsPendingButton = 'Mark as Pending';
  static const String viewHistoryButton = 'View History';
  static const String sendButton = 'Send';
  static const String continueButton = 'Continue';

  // Messages
  static const String noGoalsMessage = 'No goals yet';
  static const String noGoalsSubMessage =
      'Start your journey by creating your first goal!';
  static const String noTasksMessage = 'No tasks for today';
  static const String noTasksSubMessage =
      'Generate tasks for today to get started!';
  static const String noHistoryMessage = 'No task history';
  static const String noHistorySubMessage =
      'Complete some tasks to see them here!';

  // Chat Messages
  static const String chatGreeting =
      "Hi! 👋 I'm here to help you create a new goal.";
  static const String chatQuestionPrompt = 'What goal do you want to work on?';
  static const String chatTypingMessage = 'Typing...';

  // Success Messages
  static const String tasksGeneratedSuccess = 'Tasks generated successfully!';
  static const String goalCreatedSuccess = 'Goal created successfully!';
  static const String taskUpdatedSuccess = 'Task updated successfully!';

  // Error Messages
  static const String errorGeneral = 'Something went wrong';
  static const String errorLoadingGoals = 'Failed to load goals';
  static const String errorLoadingTasks = 'Failed to load tasks';
  static const String errorGeneratingTasks = 'Failed to generate tasks';
  static const String errorUpdatingTask = 'Failed to update task';
  static const String errorCreatingGoal = 'Failed to create goal';
  static const String tryAgainButton = 'Try Again';
  static const String retry = 'Retry';
  static const String tasksGeneratedError = 'Failed to generate tasks';
  static const String taskToggleError = 'Failed to update task status';

  // Placeholders
  static const String typeMessagePlaceholder = 'Type your message...';
  static const String searchPlaceholder = 'Search goals...';

  // Filter Options
  static const String filterLastDay = 'Last 24 Hours';
  static const String filterLastWeek = 'Last 7 Days';
  static const String filterLastMonth = 'Last 30 Days';
  static const String filterAllTime = 'All Time';

  // Time Labels
  static const String todayLabel = 'Today';
  static const String yesterdayLabel = 'Yesterday';
  static const String dueInLabel = 'Due in';
  static const String overdueByLabel = 'Overdue by';
  static const String daysLabel = 'days';
  static const String dayLabel = 'day';

  // Status Labels
  static const String statusCompleted = 'COMPLETED';
  static const String statusPending = 'PENDING';
  static const String statusSkipped = 'SKIPPED';
}
