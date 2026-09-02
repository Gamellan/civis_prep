enum ExamType {
  ccse,
  dele,
}

extension ExamTypeX on ExamType {
  String get code => switch (this) {
        ExamType.ccse => 'CCSE',
        ExamType.dele => 'DELE',
      };

  String get displayName => switch (this) {
        ExamType.ccse => 'CCSE',
        ExamType.dele => 'DELE A2',
      };

  bool get isCcse => this == ExamType.ccse;
}

enum MockExamMode {
  quick,
  official,
}

extension MockExamModeX on MockExamMode {
  String get label => switch (this) {
        MockExamMode.quick => 'Rápido',
        MockExamMode.official => 'Oficial',
      };

  int get questionCount => switch (this) {
        MockExamMode.quick => 10,
        MockExamMode.official => 25,
      };

  int get durationMinutes => switch (this) {
        MockExamMode.quick => 15,
        MockExamMode.official => 45,
      };

  String get storageSuffix => switch (this) {
        MockExamMode.quick => 'quick',
        MockExamMode.official => 'official',
      };
}