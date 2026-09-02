import 'package:flutter/material.dart';

import '../services/app_storage_service.dart';

String appLocaleStorageKey() => 'app_locale';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const List<Locale> supportedLocales = [
    Locale('es'),
    Locale('en'),
    Locale('fr'),
    Locale('pt'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Locale localeFromCode(String code) {
    return supportedLocales.firstWhere(
      (supportedLocale) => supportedLocale.languageCode == code,
      orElse: () => const Locale('en'),
    );
  }

  static Locale localeFromDevice(Locale deviceLocale) {
    final languageCode = deviceLocale.languageCode;
    if (supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == languageCode,
    )) {
      return localeFromCode(languageCode);
    }
    return const Locale('en');
  }

  static AppLocalizations of(BuildContext context) {
    final localization = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    return localization ?? const AppLocalizations(Locale('es'));
  }

  String translate(String key) {
    final languageCode = locale.languageCode;
    final fallback = _translations['es']![key] ?? key;
    return _translations[languageCode]?[key] ?? fallback;
  }

  String translateWith(String key, Map<String, String> params) {
    var value = translate(key);
    for (final entry in params.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value);
    }
    return value;
  }

  String getLanguageName(String code) {
    return switch (code) {
      'es' => 'Español',
      'en' => 'English',
      'fr' => 'Français',
      'pt' => 'Português',
      _ => code.toUpperCase(),
    };
  }

  static const Map<String, Map<String, String>> _translations = {
    'es': {
      'appTitle': 'Civis Prep',
      'settings': 'Ajustes',
      'reminder': 'Recordatorio diario',
      'language': 'Idioma',
      'credits': 'Créditos y aviso legal',
      'startNow': 'Comenzar ya',
      'studySummary': 'Resumen de estudio',
      'homeHeroSubtitle':
          'Preparación oficial para la nacionalidad española con simulacros cronometrados y repaso estructurado.',
      'questionPoolSummary': 'Pool de preguntas: {ccse} CCSE • {dele} DELE A2',
      'questionPoolLoading': 'Cargando pool de preguntas...',
      'quickMock': 'Iniciar simulacro rápido',
      'resumeQuick': 'Reanudar rápido',
      'resumeOfficial': 'Reanudar oficial',
      'pendingMock': 'Tienes un simulacro pendiente',
      'continueSession':
          'Reanuda tu sesión guardada y continúa desde donde lo dejaste.',
      'reviewAndSubmit': 'Revisar y entregar',
      'next': 'Siguiente',
      'previous': 'Anterior',
      'finish': 'Finalizar',
      'answeredQuestions': 'Respondidas',
      'completedMock': 'Simulacro finalizado',
      'close': 'Cerrar',
      'continueReviewing': 'Seguir revisando',
      'submitMock': 'Entregar simulacro',
      'exitMockQuestion': '¿Salir del simulacro?',
      'exitMockDescription':
          'Tu progreso quedará guardado automáticamente para reanudar más tarde.',
      'stay': 'Seguir',
      'exit': 'Salir',
      'markDoubtful': 'Marcar como dudosa',
      'doubtfulMarked': 'Dudosa marcada',
      'doubtfulCount': 'Dudosas',
      'timeRemaining': 'Tiempo restante',
      'selectionMode': 'Selecciona modo de simulacro',
      'quick': 'Rápido',
      'officialCcse': 'Oficial CCSE',
      'practiceByTest': 'Práctica por prueba',
      'listeningGuided': 'Escucha guiada (auditiva)',
      'breveChallenge': 'Reto breve de DELE',
      'finalReview': 'Revisión final',
      'notAnswered': 'Sin responder',
      'markedDoubtful': 'Marcadas como dudosas',
      'readyToSubmit': 'Todo listo para entregar el simulacro.',
      'checkBeforeSubmit':
          'Pulsa una pregunta para revisarla antes de entregar.',
      'audioNoteTitle': 'Audio temporalmente no disponible',
      'audioNoteBody':
          'Todavía no se ha incorporado audio real. Esta práctica se ofrece en formato textual y contextual para entrenar la comprensión; cuando sea posible se añadirá apoyo de audio con hablante nativo.',
      'practiceGuide': 'Cómo trabajar esta sección',
      'startListeningExercises': 'Empezar ejercicios de escucha',
      'comprehensionAuditory': 'Comprensión auditiva guiada',
      'practiceSimplified': 'Práctica simplificada para DELE A2',
      'noExercises': 'No hay ejercicios disponibles para esta sección todavía.',
      'allQuestionsRequired':
          'Debes responder todas las preguntas antes de finalizar.',
      'thisQuestionRequired':
          'Debes responder esta pregunta antes de continuar.',
      'studyRhythm': 'Ritmo de estudio',
      'studyRhythmDescription':
          'Usa el plan de estudio, las flashcards y los simulacros para mantener una rutina constante.',
      'creditsSubtitle': 'Fuentes, contenido y aclaración de la app',
      'summaryExams': 'CCSE + DELE',
      'summaryMocks': 'Simulacros',
      'summaryFlashcards': 'Flashcards',
      'ccseSubtitle':
          'Conocimientos constitucionales, sociedad y cultura española',
      'deleSubtitle': 'Práctica de comprensión y expresión en español',
      'progressTitle': 'Progreso',
      'progressSubtitle': 'Revisa tu rendimiento y tus temas más practicados',
      'flashcardsTitle': 'Flashcards',
      'flashcardsSubtitle': 'Repasa conceptos clave con tarjetas simples',
      'studyPlanTitle': 'Plan de estudio',
      'studyPlanSubtitle': 'Sigue una rutina breve y enfocada para cada día',
      'settingsSubtitle': 'Idioma, créditos y configuración básica',
      'quickMockDescription':
          'Un simulacro breve te ayuda a ver tu nivel antes de revisar más contenido.',
      'creditsContentTitle': 'Fuentes y contenido',
      'creditsContentBody':
          'La app toma como base materiales públicos del Instituto Cervantes y criterios educativos oficiales para CCSE y DELE A2, adaptados y reformulados con fines de estudio.',
      'creditsNoticeTitle': 'Aviso importante',
      'creditsNoticeBody':
          'Esta aplicación no es una app oficial del Instituto Cervantes ni está afiliada a él. Su objetivo es apoyar la preparación de los exámenes con fines educativos y de práctica.',
      'creditsScopeTitle': 'Contenido',
      'creditsScopeBody':
          'CCSE: cuestiones sobre gobierno, derechos, organización territorial, historia, cultura y sociedad española.\n\nDELE A2: práctica de lectura, escritura, comprensión auditiva y expresión oral basada en ejercicios tipo examen y materiales didácticos adaptados.',
      'yourProgress': 'Tu progreso',
      'overallPerformance': 'Rendimiento general',
      'recordedAnswers': 'Respuestas registradas',
      'correct': 'Correctas',
      'incorrect': 'Incorrectas',
      'accuracy': 'Porcentaje',
      'weakestTopic': 'Tema más débil',
      'masteredTopics': 'Temas dominados',
      'best': 'Mejor',
      'byTopic': 'Por tema',
      'questions': 'preguntas',
      'details': 'Detalles',
      'yourAnswer': 'Tu respuesta',
      'correctAnswer': 'Respuesta correcta',
      'explanation': 'Explicación',
      'backToHome': 'Volver al inicio',
      'correctAnswers': 'Respuestas correctas',
      'percentage': 'Porcentaje',
      'sectionTitle': 'Sección',
    },
    'en': {
      'appTitle': 'Civis Prep',
      'settings': 'Settings',
      'reminder': 'Daily reminder',
      'language': 'Language',
      'credits': 'Credits and legal notice',
      'startNow': 'Start now',
      'studySummary': 'Study summary',
      'homeHeroSubtitle':
          'Official preparation for Spanish nationality with timed mock exams and structured review.',
      'questionPoolSummary': 'Question pool: {ccse} CCSE • {dele} DELE A2',
      'questionPoolLoading': 'Loading question pool...',
      'quickMock': 'Start quick mock',
      'resumeQuick': 'Resume quick',
      'resumeOfficial': 'Resume official',
      'pendingMock': 'You have a mock exam pending',
      'continueSession':
          'Resume your saved session and continue where you left off.',
      'reviewAndSubmit': 'Review and submit',
      'next': 'Next',
      'previous': 'Previous',
      'finish': 'Finish',
      'answeredQuestions': 'Answered',
      'completedMock': 'Mock exam finished',
      'close': 'Close',
      'continueReviewing': 'Keep reviewing',
      'submitMock': 'Submit mock',
      'exitMockQuestion': 'Leave the mock exam?',
      'exitMockDescription':
          'Your progress will be saved automatically so you can resume later.',
      'stay': 'Stay',
      'exit': 'Exit',
      'markDoubtful': 'Mark as doubtful',
      'doubtfulMarked': 'Doubt marked',
      'doubtfulCount': 'Doubtful',
      'timeRemaining': 'Time remaining',
      'selectionMode': 'Select mock mode',
      'quick': 'Quick',
      'officialCcse': 'Official CCSE',
      'practiceByTest': 'Practice by test',
      'listeningGuided': 'Guided listening',
      'breveChallenge': 'Quick DELE challenge',
      'finalReview': 'Final review',
      'notAnswered': 'Unanswered',
      'markedDoubtful': 'Marked as doubtful',
      'readyToSubmit': 'Everything is ready to submit the mock exam.',
      'checkBeforeSubmit': 'Tap a question to review it before submitting.',
      'audioNoteTitle': 'Audio not available yet',
      'audioNoteBody':
          'No real audio has been added yet. This practice is currently provided in text and context format to train comprehension; audio support with a native speaker will be added later.',
      'practiceGuide': 'How to work on this section',
      'startListeningExercises': 'Start listening exercises',
      'comprehensionAuditory': 'Guided listening practice',
      'practiceSimplified': 'Simplified practice for DELE A2',
      'noExercises': 'No exercises are available for this section yet.',
      'allQuestionsRequired': 'You must answer all questions before finishing.',
      'thisQuestionRequired':
          'You must answer this question before continuing.',
      'sectionTitle': 'Section',
      'studyRhythm': 'Study rhythm',
      'studyRhythmDescription':
          'Use the study plan, flashcards, and mock exams to maintain a consistent routine.',
      'creditsSubtitle': 'Sources, content and app clarification',
      'summaryExams': 'CCSE + DELE',
      'summaryMocks': 'Mock exams',
      'summaryFlashcards': 'Flashcards',
      'ccseSubtitle': 'Constitutional knowledge, Spanish society and culture',
      'deleSubtitle': 'Spanish comprehension and expression practice',
      'progressTitle': 'Progress',
      'progressSubtitle': 'Review your performance and most-practiced topics',
      'flashcardsTitle': 'Flashcards',
      'flashcardsSubtitle': 'Review key concepts with simple cards',
      'studyPlanTitle': 'Study plan',
      'studyPlanSubtitle': 'Follow a short, focused routine for each day',
      'settingsSubtitle': 'Language, credits and basic settings',
      'quickMockDescription':
          'A short mock exam helps you see your level before reviewing more content.',
      'creditsContentTitle': 'Sources and content',
      'creditsContentBody':
          'The app uses public Instituto Cervantes materials and official educational criteria for CCSE and DELE A2, adapted and reformulated for study purposes.',
      'creditsNoticeTitle': 'Important notice',
      'creditsNoticeBody':
          'This application is not an official Instituto Cervantes app and is not affiliated with it. Its goal is to support exam preparation for educational and practice purposes.',
      'creditsScopeTitle': 'Content',
      'creditsScopeBody':
          'CCSE: questions about government, rights, territorial organization, history, culture, and Spanish society.\n\nDELE A2: reading, writing, listening, and oral expression practice based on exam-style exercises and adapted learning materials.',
      'yourProgress': 'Your progress',
      'overallPerformance': 'Overall performance',
      'recordedAnswers': 'Recorded answers',
      'correct': 'Correct',
      'incorrect': 'Incorrect',
      'accuracy': 'Accuracy',
      'weakestTopic': 'Weakest topic',
      'masteredTopics': 'Mastered topics',
      'best': 'Best',
      'byTopic': 'By topic',
      'questions': 'questions',
      'details': 'Details',
      'yourAnswer': 'Your answer',
      'correctAnswer': 'Correct answer',
      'explanation': 'Explanation',
      'backToHome': 'Back to home',
      'correctAnswers': 'Correct answers',
      'percentage': 'Percentage',
    },
    'fr': {
      'appTitle': 'Civis Prep',
      'settings': 'Paramètres',
      'reminder': 'Rappel quotidien',
      'language': 'Langue',
      'credits': 'Crédits et mentions légales',
      'startNow': 'Commencer',
      'studySummary': 'Résumé d’étude',
      'homeHeroSubtitle':
          'Préparation officielle à la nationalité espagnole avec examens blancs chronométrés et révision structurée.',
      'questionPoolSummary':
          'Banque de questions : {ccse} CCSE • {dele} DELE A2',
      'questionPoolLoading': 'Chargement de la banque de questions...',
      'quickMock': 'Démarrer un faux test rapide',
      'resumeQuick': 'Reprendre rapide',
      'resumeOfficial': 'Reprendre officiel',
      'pendingMock': 'Vous avez un exercice en cours',
      'continueSession':
          'Reprenez votre session enregistrée où vous l’avez laissée.',
      'reviewAndSubmit': 'Vérifier et soumettre',
      'next': 'Suivant',
      'previous': 'Précédent',
      'finish': 'Terminer',
      'answeredQuestions': 'Répondues',
      'completedMock': 'Exercice terminé',
      'close': 'Fermer',
      'continueReviewing': 'Continuer à relire',
      'submitMock': 'Soumettre l’examen',
      'exitMockQuestion': 'Quitter le simulateur ?',
      'exitMockDescription':
          'Votre progression sera enregistrée automatiquement pour reprendre plus tard.',
      'stay': 'Continuer',
      'exit': 'Quitter',
      'markDoubtful': 'Marquer comme incertain',
      'doubtfulMarked': 'Incertain marqué',
      'doubtfulCount': 'Incertaines',
      'timeRemaining': 'Temps restant',
      'selectionMode': 'Choisir le mode de simulateur',
      'quick': 'Rapide',
      'officialCcse': 'Officiel CCSE',
      'practiceByTest': 'Pratique par test',
      'listeningGuided': 'Écoute guidée',
      'breveChallenge': 'Défi rapide DELE',
      'finalReview': 'Révision finale',
      'notAnswered': 'Non répondu',
      'markedDoubtful': 'Marquées comme incertaines',
      'readyToSubmit': 'Tout est prêt pour envoyer le simulateur.',
      'checkBeforeSubmit':
          'Appuyez sur une question pour la vérifier avant de soumettre.',
      'audioNoteTitle': 'Audio pas encore disponible',
      'audioNoteBody':
          'L’audio réel n’a pas encore été ajouté. Cette pratique est actuellement présentée sous forme textuelle et contextuelle pour entraîner la compréhension; un support audio avec locuteur natif sera ajouté plus tard.',
      'practiceGuide': 'Comment travailler cette section',
      'startListeningExercises': 'Commencer les exercices d’écoute',
      'comprehensionAuditory': 'Pratique d’écoute guidée',
      'practiceSimplified': 'Pratique simplifiée pour DELE A2',
      'noExercises':
          'Aucun exercice n’est disponible pour cette section pour le moment.',
      'allQuestionsRequired':
          'Vous devez répondre à toutes les questions avant de terminer.',
      'thisQuestionRequired':
          'Vous devez répondre à cette question avant de continuer.',
      'sectionTitle': 'Section',
      'studyRhythm': 'Rythme d’étude',
      'studyRhythmDescription':
          'Utilisez le plan d’étude, les flashcards et les simulateurs pour maintenir une routine constante.',
      'creditsSubtitle': 'Sources, contenu et clarification de l’application',
      'summaryExams': 'CCSE + DELE',
      'summaryMocks': 'Simulateurs',
      'summaryFlashcards': 'Flashcards',
      'ccseSubtitle':
          'Connaissances constitutionnelles, société et culture espagnoles',
      'deleSubtitle': 'Pratique de compréhension et d’expression en espagnol',
      'progressTitle': 'Progression',
      'progressSubtitle':
          'Consultez vos résultats et les thèmes les plus travaillés',
      'flashcardsTitle': 'Flashcards',
      'flashcardsSubtitle': 'Révisez les notions clés avec des cartes simples',
      'studyPlanTitle': 'Plan d’étude',
      'studyPlanSubtitle':
          'Suivez une routine courte et ciblée pour chaque jour',
      'settingsSubtitle': 'Langue, crédits et configuration de base',
      'quickMockDescription':
          'Un court simulateur vous aide à voir votre niveau avant de réviser davantage.',
      'creditsContentTitle': 'Sources et contenu',
      'creditsContentBody':
          'L’application s’appuie sur des matériaux publics de l’Instituto Cervantes et sur des critères éducatifs officiels pour le CCSE et le DELE A2, adaptés et reformulés à des fins d’étude.',
      'creditsNoticeTitle': 'Avis important',
      'creditsNoticeBody':
          'Cette application n’est pas une application officielle de l’Instituto Cervantes et n’y est pas affiliée. Son objectif est d’aider à préparer les examens à des fins éducatives et de pratique.',
      'creditsScopeTitle': 'Contenu',
      'creditsScopeBody':
          'CCSE : questions sur le gouvernement, les droits, l’organisation territoriale, l’histoire, la culture et la société espagnole.\n\nDELE A2 : pratique de lecture, écriture, compréhension orale et expression orale à partir d’exercices de type examen et de matériels pédagogiques adaptés.',
      'yourProgress': 'Votre progression',
      'overallPerformance': 'Performance globale',
      'recordedAnswers': 'Réponses enregistrées',
      'correct': 'Correctes',
      'incorrect': 'Incorrectes',
      'accuracy': 'Précision',
      'weakestTopic': 'Sujet le plus faible',
      'masteredTopics': 'Sujets maîtrisés',
      'best': 'Mieux',
      'byTopic': 'Par thème',
      'questions': 'questions',
      'details': 'Détails',
      'yourAnswer': 'Votre réponse',
      'correctAnswer': 'Bonne réponse',
      'explanation': 'Explication',
      'backToHome': 'Retour à l’accueil',
      'correctAnswers': 'Bonnes réponses',
      'percentage': 'Pourcentage',
    },
    'pt': {
      'appTitle': 'Civis Prep',
      'settings': 'Configurações',
      'reminder': 'Lembrete diário',
      'language': 'Idioma',
      'credits': 'Créditos e aviso legal',
      'startNow': 'Começar agora',
      'studySummary': 'Resumo de estudo',
      'homeHeroSubtitle':
          'Preparação oficial para a nacionalidade espanhola com simulados cronometrados e revisão estruturada.',
      'questionPoolSummary': 'Banco de perguntas: {ccse} CCSE • {dele} DELE A2',
      'questionPoolLoading': 'Carregando banco de perguntas...',
      'quickMock': 'Iniciar simulado rápido',
      'resumeQuick': 'Continuar rápido',
      'resumeOfficial': 'Continuar oficial',
      'pendingMock': 'Você tem um simulado pendente',
      'continueSession': 'Retome sua sessão salva e continue de onde parou.',
      'reviewAndSubmit': 'Revisar e enviar',
      'next': 'Próximo',
      'previous': 'Anterior',
      'finish': 'Finalizar',
      'answeredQuestions': 'Respondidas',
      'completedMock': 'Simulado concluído',
      'close': 'Fechar',
      'continueReviewing': 'Continuar revisando',
      'submitMock': 'Enviar simulado',
      'exitMockQuestion': 'Sair do simulado?',
      'exitMockDescription':
          'Seu progresso será salvo automaticamente para continuar mais tarde.',
      'stay': 'Continuar',
      'exit': 'Sair',
      'markDoubtful': 'Marcar como duvidosa',
      'doubtfulMarked': 'Dúvida marcada',
      'doubtfulCount': 'Duvidosas',
      'timeRemaining': 'Tempo restante',
      'selectionMode': 'Selecione o modo do simulado',
      'quick': 'Rápido',
      'officialCcse': 'Oficial CCSE',
      'practiceByTest': 'Prática por teste',
      'listeningGuided': 'Escuta guiada',
      'breveChallenge': 'Desafio rápido DELE',
      'finalReview': 'Revisão final',
      'notAnswered': 'Sem responder',
      'markedDoubtful': 'Marcadas como duvidosas',
      'readyToSubmit': 'Tudo está pronto para enviar o simulado.',
      'checkBeforeSubmit':
          'Toque em uma pergunta para revisá-la antes de enviar.',
      'audioNoteTitle': 'Áudio ainda indisponível',
      'audioNoteBody':
          'O áudio real ainda não foi incorporado. Esta prática é apresentada em formato textual e contextual para treinar a compreensão; o suporte com áudio de falante nativo será adicionado mais tarde.',
      'practiceGuide': 'Como trabalhar esta seção',
      'startListeningExercises': 'Começar exercícios de escuta',
      'comprehensionAuditory': 'Prática de escuta guiada',
      'practiceSimplified': 'Prática simplificada para DELE A2',
      'noExercises': 'Ainda não há exercícios disponíveis para esta seção.',
      'allQuestionsRequired':
          'Você precisa responder a todas as perguntas antes de finalizar.',
      'thisQuestionRequired':
          'Você precisa responder a esta pergunta antes de continuar.',
      'sectionTitle': 'Seção',
      'studyRhythm': 'Ritmo de estudo',
      'studyRhythmDescription':
          'Use o plano de estudo, as flashcards e os simulados para manter uma rotina constante.',
      'creditsSubtitle': 'Fontes, conteúdo e esclarecimento do aplicativo',
      'summaryExams': 'CCSE + DELE',
      'summaryMocks': 'Simulados',
      'summaryFlashcards': 'Flashcards',
      'ccseSubtitle':
          'Conhecimentos constitucionais, sociedade e cultura espanhola',
      'deleSubtitle': 'Prática de compreensão e expressão em espanhol',
      'progressTitle': 'Progresso',
      'progressSubtitle': 'Revise seu desempenho e os temas mais praticados',
      'flashcardsTitle': 'Flashcards',
      'flashcardsSubtitle': 'Revise conceitos-chave com cartões simples',
      'studyPlanTitle': 'Plano de estudo',
      'studyPlanSubtitle': 'Siga uma rotina curta e focada para cada dia',
      'settingsSubtitle': 'Idioma, créditos e configuração básica',
      'quickMockDescription':
          'Um simulado curto ajuda você a ver seu nível antes de revisar mais conteúdo.',
      'creditsContentTitle': 'Fontes e conteúdo',
      'creditsContentBody':
          'O aplicativo usa materiais públicos do Instituto Cervantes e critérios educacionais oficiais para CCSE e DELE A2, adaptados e reformulados para fins de estudo.',
      'creditsNoticeTitle': 'Aviso importante',
      'creditsNoticeBody':
          'Este aplicativo não é um aplicativo oficial do Instituto Cervantes nem é afiliado a ele. Seu objetivo é apoiar a preparação para os exames com fins educacionais e de prática.',
      'creditsScopeTitle': 'Conteúdo',
      'creditsScopeBody':
          'CCSE: questões sobre governo, direitos, organização territorial, história, cultura e sociedade espanhola.\n\nDELE A2: prática de leitura, escrita, compreensão auditiva e expressão oral com base em exercícios no estilo do exame e materiais didáticos adaptados.',
      'yourProgress': 'Seu progresso',
      'overallPerformance': 'Desempenho geral',
      'recordedAnswers': 'Respostas registradas',
      'correct': 'Corretas',
      'incorrect': 'Incorretas',
      'accuracy': 'Precisão',
      'weakestTopic': 'Tema mais fraco',
      'masteredTopics': 'Temas dominados',
      'best': 'Melhor',
      'byTopic': 'Por tema',
      'questions': 'perguntas',
      'details': 'Detalhes',
      'yourAnswer': 'Sua resposta',
      'correctAnswer': 'Resposta correta',
      'explanation': 'Explicação',
      'backToHome': 'Voltar para o início',
      'correctAnswers': 'Respostas corretas',
      'percentage': 'Percentual',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

class AppLocaleScope extends InheritedWidget {
  final Locale locale;
  final Future<void> Function(Locale locale) setLocale;

  const AppLocaleScope({
    super.key,
    required this.locale,
    required this.setLocale,
    required super.child,
  });

  static AppLocaleScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant AppLocaleScope oldWidget) {
    return locale != oldWidget.locale;
  }
}

Future<Locale> loadSavedAppLocale() async {
  final storage = AppStorageService();
  final localeCode = await storage.getString(appLocaleStorageKey());
  if (localeCode != null && localeCode.isNotEmpty) {
    return AppLocalizations.localeFromCode(localeCode);
  }
  return AppLocalizations.localeFromDevice(
    WidgetsBinding.instance.platformDispatcher.locale,
  );
}
