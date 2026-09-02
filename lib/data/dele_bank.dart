import '../models/dele_exercise_model.dart';

List<DeleExerciseModel> buildDeleBank() {
  final questions = <DeleExerciseModel>[];
  final sections = <String, List<_QuestionSpec>>{
    'Comprensión de lectura': _readingSpecs(),
    'Expresión e interacción escritas': _writingSpecs(),
    'Comprensión auditiva': _listeningSpecs(),
    'Expresión e interacción orales': _oralSpecs(),
  };

  var sectionOrder = 0;
  sections.forEach((section, specs) {
    sectionOrder++;
    for (var index = 0; index < specs.length; index++) {
      final spec = specs[index];
      final sectionId = _normalizeSection(section);
      questions.add(
        DeleExerciseModel(
          id: '$sectionId-${sectionOrder.toString().padLeft(2, '0')}-${(index + 1).toString().padLeft(2, '0')}',
          section: section,
          title: spec.title,
          groupId: '$sectionId-${_normalizeSection(spec.taskType)}',
          groupTitle: _formatGroupTitle(section, spec.taskType),
          contextTitle: spec.contextTitle,
          contextText: spec.contextText,
          prompt: _formatPrompt(section, spec.taskType, spec.prompt),
          options: _buildOptions(spec.correctOptionId, spec.optionTexts),
          correctOptionId: spec.correctOptionId,
          explanation: spec.explanation,
          difficulty: _resolveDifficulty(section, spec.taskType, index),
        ),
      );
    }
  });

  return questions;
}

String _normalizeSection(String section) => section
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'-+'), '-');

List<DeleOption> _buildOptions(String correctOptionId, List<String> texts) {
  final ids = ['a', 'b', 'c', 'd'];
  final options = <DeleOption>[];

  for (var i = 0; i < texts.length; i++) {
    options.add(
      DeleOption(
        id: ids[i],
        text: texts[i],
        isCorrect: ids[i] == correctOptionId,
      ),
    );
  }

  return options;
}

List<String> _buildOptionTextsForTask(
  String taskType,
  String correctAnswer,
  int index,
) {
  final distractorPools = <String, List<String>>{
    'Avisos y horarios': [
      'Que el horario no cambia esta semana',
      'Que el servicio abrirá también por la noche',
      'Que solo atenderán con cita el fin de semana',
      'Que la actividad se traslada definitivamente a otro barrio',
      'Que el acceso será gratuito todos los días',
      'Que el cierre se adelanta solo para menores',
    ],
    'Mensajes cotidianos': [
      'Que el plan queda cancelado hasta nuevo aviso',
      'Que la persona llegará mucho antes de lo previsto',
      'Que no hace falta responder ni hacer nada',
      'Que otra persona resolverá el asunto esa misma noche',
      'Que la cita pasa automáticamente a la semana siguiente',
      'Que debe presentarse sin avisar en otro lugar',
    ],
    'Anuncios y publicidad': [
      'Que la actividad exige experiencia profesional previa',
      'Que solo se puede participar en invierno',
      'Que la inscripción ya está cerrada para todo el curso',
      'Que el servicio no incluye ningún material adicional',
      'Que la oferta es válida únicamente para grupos grandes',
      'Que el anuncio obliga a pagar una cuota extra semanal',
    ],
    'Normas e instrucciones': [
      'Que se puede entrar y salir libremente a cualquier hora',
      'Que las normas solo se aplican a visitantes ocasionales',
      'Que basta con avisar por teléfono para saltarse la regla',
      'Que el uso del servicio no requiere ninguna precaución',
      'Que la prohibición afecta solo a los fines de semana',
      'Que todo el material se puede llevar a casa sin permiso',
    ],
    'Opiniones y reseñas': [
      'Que todo fue perfecto y no hubo ningún inconveniente',
      'Que la única valoración posible es negativa',
      'Que el comentario se centra solo en el precio',
      'Que la persona no llegó a usar realmente el servicio',
      'Que el problema principal fue encontrar aparcamiento',
      'Que recomienda evitar el lugar sin dar ninguna razón',
    ],
    'Pedir información': [
      'Hola, decidme rápido cuánto cuesta porque tengo prisa.',
      'Apuntadme y luego ya veré si esa actividad me interesa.',
      'Mandadme toda la información hoy mismo sin falta.',
      'No sé bien de qué trata, pero guardadme una plaza.',
      'Contestad solo con el precio, no necesito más detalles.',
      'Quiero saberlo ya, así que responded cuanto antes.',
    ],
    'Gestionar planes': [
      'Llegaré cuando pueda, así que no preguntes más.',
      'Cambio todo el plan y luego te lo explico si eso.',
      'No sé si iré o no, pero mejor espérame igualmente.',
      'Haz otro plan por tu cuenta, que yo veré después.',
      'Puede que llegue tarde o puede que no, ya se verá.',
      'Al final no confirmo nada hasta el último momento.',
    ],
    'Hacer gestiones': [
      'Esto está mal. Arregladlo ya porque sí.',
      'No explico nada más; ya sabréis lo que pasa.',
      'Si hoy no lo solucionáis, luego no me responsabilizo.',
      'Necesito ayuda, pero prefiero no dar detalles concretos.',
      'Resuelvan el problema cuanto antes y sin preguntarme nada.',
      'Ya me diréis si os apetece atender esta incidencia.',
    ],
    'Confirmar y aceptar': [
      'Vale, caeré por ahí si al final me acuerdo.',
      'Supongo que sí, aunque tampoco prometo mucho.',
      'Voy o no voy, ya lo verás ese mismo día.',
      'Si puedo apareceré; si no, pues nada.',
      'No te confirmo todavía, pero cuenta casi seguro conmigo.',
      'Quizá sí, aunque prefiero dejarlo completamente abierto.',
    ],
    'Quejas y agradecimientos': [
      'Esto ha sido un desastre, así que ya sabéis por qué escribo.',
      'Bueno, gracias o no, según se mire la situación.',
      'Me debéis una respuesta inmediata sin más explicaciones.',
      'Lo ocurrido no tiene nombre y no quiero entrar en detalles.',
      'Agradezco algo, pero tampoco demasiado, la verdad.',
      'Arregladlo primero y luego quizá os vuelva a escribir.',
    ],
    'Avisos de transporte': [
      'Que el trayecto queda suspendido durante todo el mes',
      'Que hay que comprar un billete distinto en otra estación',
      'Que el vehículo llegará exactamente a la misma hora',
      'Que el cambio afecta solo al personal de la estación',
      'Que la salida pasa automáticamente al día siguiente',
      'Que el aviso solo es válido para quienes viajan sin equipaje',
    ],
    'Recados y mensajes': [
      'Que el plan desaparece y no habrá nuevas noticias',
      'Que debe presentarse inmediatamente y sin avisar',
      'Que otra persona solucionará el problema en secreto',
      'Que el mensaje no requiere ninguna acción posterior',
      'Que todo cambia de lugar, pero sin confirmar la hora',
      'Que la persona ya ha resuelto el asunto por completo',
    ],
    'Anuncios públicos': [
      'Que el servicio desaparece de forma definitiva',
      'Que todo será gratuito durante un año entero',
      'Que solo atenderán a personas de fuera del barrio',
      'Que la promoción se aplicará a partir del año que viene',
      'Que el aviso está pensado solo para empleados',
      'Que la actividad cambia de ciudad sin fecha concreta',
    ],
    'Conversaciones cotidianas': [
      'Que todo depende de una persona que no participa en la conversación',
      'Que han decidido vender sus cosas y mudarse de inmediato',
      'Que hablan de un viaje internacional urgente',
      'Que el problema real es no encontrar aparcamiento',
      'Que la decisión está tomada desde hace meses y no cambiará',
      'Que discuten sobre un tema distinto al que parece',
    ],
    'Instrucciones y consejos': [
      'Dónde debe irse de vacaciones la próxima semana',
      'Qué regalo debería comprar para otra persona',
      'Cómo cambiar de trabajo de manera inmediata',
      'Por qué conviene cancelar el plan sin explicaciones',
      'Qué opinión personal tiene sobre un asunto político',
      'A quién debe prestar dinero cuanto antes',
    ],
    'Presentarse y saludar': [
      'Yo estar aquí y ya veremos qué pasa luego.',
      'Nombre, ciudad y poco más. Fin de la conversación.',
      'No sé muy bien quién soy para contar nada ahora.',
      'Hola, aquí estoy, pero prefiero no presentarme de verdad.',
      'Soy alguien normal y ya está, no hay mucho que decir.',
      'Vengo por aquí y luego si acaso ya hablamos.',
    ],
    'Pedir ayuda e información': [
      'Oye, arréglame esto ahora mismo sin más.',
      'Eso está mal, tú sabrás qué hacer.',
      'No entiendo nada, así que dilo como quieras.',
      'Explícamelo rápido porque no tengo paciencia.',
      'Yo pregunto, pero tampoco hace falta que contestes bien.',
      'Hazme el favor sin que tenga que darte detalles.',
    ],
    'Invitar y responder': [
      'Ya veré si aparezco o no sin avisar.',
      'Haz lo que quieras, luego improvisamos.',
      'No prometo nada y prefiero no pensar ahora.',
      'Si me apetece, iré; si no, desaparezco.',
      'Quedamos algún día, pero mejor sin concretar demasiado.',
      'Tal vez sí, aunque mejor no organizar nada todavía.',
    ],
    'Expresar opiniones': [
      'Fue una cosa de esas que pasan y ya está.',
      'No sé, todo era muy abstracto y extraño sin motivo.',
      'Prefiero no decir nada concreto sobre eso jamás.',
      'Estuvo ahí, sin más, y tampoco importa mucho por qué.',
      'No tengo una opinión clara, pero suena todo bastante raro.',
      'Es difícil decir algo útil, así que mejor lo dejo así.',
    ],
    'Rutinas y planes': [
      'Mi rutina es muy rutinaria y no tiene explicación posible.',
      'Cada día ocurre algo y prefiero no ordenarlo con palabras.',
      'Vivo el tiempo de forma tan abstracta que no sabría decir nada.',
      'Hago cosas normales, pero no sé contarlas con precisión.',
      'Mis planes cambian siempre, así que mejor no explicarlos.',
      'Todo depende del momento y no suelo pensarlo demasiado.',
    ],
  };

  final pool =
      distractorPools[taskType] ??
      const [
        'La opción propuesta no responde con precisión a la tarea.',
        'La respuesta cambia el tema principal de la situación.',
        'La alternativa ofrece un dato que no aparece en el contexto.',
        'La formulación no encaja con la intención comunicativa.',
      ];

  final distractors = <String>[];
  for (
    var offset = 0;
    offset < pool.length && distractors.length < 3;
    offset++
  ) {
    final candidate = pool[(index + offset) % pool.length];
    if (candidate != correctAnswer && !distractors.contains(candidate)) {
      distractors.add(candidate);
    }
  }

  return [correctAnswer, ...distractors];
}

String _formatGroupTitle(String section, String taskType) {
  switch (section) {
    case 'Comprensión de lectura':
      return 'Tarea de lectura: $taskType';
    case 'Expresión e interacción escritas':
      return 'Tarea de escritura: $taskType';
    case 'Comprensión auditiva':
      return 'Tarea de audición: $taskType';
    case 'Expresión e interacción orales':
      return 'Tarea de interacción oral: $taskType';
  }

  return taskType;
}

String _formatPrompt(String section, String taskType, String prompt) {
  switch (section) {
    case 'Comprensión de lectura':
      return 'Lee el texto y responde. $prompt';
    case 'Expresión e interacción escritas':
      return 'Elige el mensaje escrito más adecuado para la tarea. $prompt';
    case 'Comprensión auditiva':
      return 'Escucha la situación y responde. $prompt';
    case 'Expresión e interacción orales':
      return 'Selecciona la intervención oral más natural. $prompt';
  }

  return prompt;
}

String _resolveDifficulty(String section, String taskType, int index) {
  final advancedTaskTypes = {
    'Opiniones y reseñas',
    'Quejas y agradecimientos',
    'Conversaciones cotidianas',
    'Instrucciones y consejos',
    'Expresar opiniones',
    'Rutinas y planes',
  };
  final intermediateTaskTypes = {
    'Anuncios y publicidad',
    'Normas e instrucciones',
    'Gestionar planes',
    'Hacer gestiones',
    'Confirmar y aceptar',
    'Anuncios públicos',
    'Recados y mensajes',
    'Invitar y responder',
  };

  if (advancedTaskTypes.contains(taskType)) {
    const levels = [
      'A2 consolidacion',
      'A2 intermedio',
      'A2 alto',
      'A2 consolidacion',
    ];
    return levels[index % levels.length];
  }

  if (intermediateTaskTypes.contains(taskType)) {
    const levels = [
      'A2 intermedio',
      'A2 consolidacion',
      'A2 intermedio',
      'A2 alto',
    ];
    return levels[index % levels.length];
  }

  if (section == 'Comprensión de lectura' ||
      section == 'Comprensión auditiva') {
    const levels = [
      'A2 basico',
      'A2 intermedio',
      'A2 basico',
      'A2 consolidacion',
    ];
    return levels[index % levels.length];
  }

  const levels = [
    'A2 basico',
    'A2 intermedio',
    'A2 consolidacion',
    'A2 intermedio',
  ];
  return levels[index % levels.length];
}

List<_QuestionSpec> _readingSpecs() {
  return [
    ..._readingNoticeSpecs(),
    ..._readingMessageSpecs(),
    ..._readingAdSpecs(),
    ..._readingRuleSpecs(),
    ..._readingReviewSpecs(),
  ];
}

List<_QuestionSpec> _readingNoticeSpecs() {
  final titles = [
    'Horario de biblioteca',
    'Cambio en la piscina',
    'Atención en el centro de salud',
    'Oficina de turismo',
    'Escuela de idiomas',
    'Mercado municipal',
    'Museo local',
    'Centro deportivo',
    'Sala de estudio',
    'Línea de autobús',
  ];
  final contexts = [
    'La biblioteca del barrio abrirá en agosto de 9:00 a 14:00. Por la tarde permanecerá cerrada hasta septiembre.',
    'La piscina cubierta no abrirá este viernes por labores de limpieza. Las clases volverán a su horario normal el sábado.',
    'El centro de salud atenderá sin cita previa únicamente de 8:30 a 10:30. Después de esa hora solo habrá consultas programadas.',
    'La oficina de turismo cambia temporalmente de sede. Desde mañana atenderá junto a la plaza mayor, en el edificio del antiguo ayuntamiento.',
    'Las matrículas para los cursos intensivos de septiembre estarán abiertas hasta el día 15 y deberán hacerse en línea.',
    'El mercado municipal adelantará su cierre a las 13:30 durante las fiestas del barrio por motivos de seguridad.',
    'El museo ofrece entrada gratuita el primer domingo de cada mes, pero es necesario reservar por internet.',
    'El gimnasio informa de que la sala de pesas permanecerá cerrada dos tardes por mantenimiento de las máquinas.',
    'La sala de estudio abrirá también los domingos durante el periodo de exámenes, de 10:00 a 20:00.',
    'La línea 8 modifica su recorrido esta semana y no pasará por la avenida central debido a unas obras.',
  ];
  final prompts = [
    'Según el aviso de la biblioteca, ¿qué ocurrirá en agosto?',
    '¿Qué informa el cartel sobre la piscina cubierta?',
    '¿Qué detalle importante aparece en el aviso del centro de salud?',
    '¿Qué debe saber una persona que quiera ir a la oficina de turismo?',
    '¿Qué indica el anuncio de la escuela de idiomas?',
    '¿Qué cambio comunica el mercado municipal?',
    '¿Qué condición aparece en la información del museo?',
    '¿Qué explica el cartel del gimnasio?',
    '¿Qué novedad presenta la sala de estudio?',
    '¿Qué informa el panel sobre la línea 8?',
  ];
  final correctAnswers = [
    'Que abrirá solo por la mañana',
    'Que no abrirá el viernes',
    'Que sin cita previa solo atenderán a primera hora',
    'Que atenderá en otro edificio',
    'Que la matrícula se hace por internet hasta el día 15',
    'Que cerrará antes durante las fiestas',
    'Que la entrada gratis requiere reserva',
    'Que la sala de pesas cerrará dos tardes',
    'Que abrirá también los domingos en época de exámenes',
    'Que cambiará su recorrido por unas obras',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Avisos y horarios',
      contextTitle: 'Cartel informativo',
      contextText: contexts[i],
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Avisos y horarios',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta resume la información principal del aviso.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _readingMessageSpecs() {
  final titles = [
    'Correo de una vecina',
    'Nota en la nevera',
    'Mensaje del jefe',
    'Correo de una profesora',
    'Aviso del casero',
    'Mensaje de una amiga',
    'Correo del dentista',
    'Nota del compañero de piso',
    'Mensaje del colegio',
    'Correo de una tienda',
  ];
  final contexts = [
    'Hola, Laura. El ascensor no funciona desde esta mañana. El técnico vendrá mañana a primera hora, así que hoy tendremos que usar las escaleras.',
    'He salido a comprar fruta y pan. Vuelvo en media hora. Si llama Elena, dile que la reunión empieza a las siete y no a las seis y media.',
    'Mañana empezaremos la reunión media hora antes porque a las once viene un cliente importante y tenemos que revisar la presentación con tiempo.',
    'Os recuerdo que el examen oral del jueves será en el aula 12 y no en la 8. Traed también el documento de identidad.',
    'Buenas tardes. El viernes irán a revisar la caldera entre las 9:00 y las 11:00. Por favor, procuren estar en casa en esa franja.',
    'Al final no podré acompañarte al cine porque sigo con fiebre. Si te parece, lo dejamos para el domingo por la tarde.',
    'Le confirmamos su cita para limpieza dental el martes a las 17:40. Si no puede asistir, llámenos con 24 horas de antelación.',
    'He dejado las llaves de repuesto en el cajón de la entrada. Llegaré tarde del trabajo, así que cena sin esperarme.',
    'El autobús de la excursión saldrá a las 8:15 desde la puerta principal. Los alumnos deben llevar agua y gorra.',
    'Su pedido ya está preparado para recogida en tienda. Puede pasar hoy hasta las 20:30 con el número de compra.',
  ];
  final prompts = [
    '¿Qué problema comunica la vecina?',
    '¿Qué debe decir la persona que lee la nota si llama Elena?',
    '¿Qué cambio anuncia el jefe?',
    '¿Qué deben recordar los estudiantes para el jueves?',
    '¿Qué pide el casero a las personas que viven en el edificio?',
    '¿Qué propone la amiga en su mensaje?',
    '¿Qué debe hacer la persona si no puede ir a la cita dental?',
    '¿Qué informa el compañero de piso?',
    '¿Qué deben llevar los alumnos a la excursión?',
    '¿Qué puede hacer ya el cliente de la tienda?',
  ];
  final correctAnswers = [
    'Que el ascensor está averiado',
    'Que la reunión empieza a las siete',
    'Que la reunión será antes de lo previsto',
    'Que el examen oral será en otra aula y deben llevar identificación',
    'Que estén en casa durante la revisión de la caldera',
    'Que vayan al cine otro día',
    'Que avise con un día de antelación',
    'Que ha dejado unas llaves y llegará tarde',
    'Que lleven agua y gorra',
    'Que recoja su pedido hoy mismo',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Mensajes cotidianos',
      contextTitle: 'Mensaje breve',
      contextText: contexts[i],
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Mensajes cotidianos',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation: 'La opción correcta recoge el dato clave del mensaje.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _readingAdSpecs() {
  final titles = [
    'Curso de cocina',
    'Academia de conversación',
    'Taller de fotografía',
    'Clases de yoga',
    'Anuncio de empleo',
    'Campamento urbano',
    'Intercambio de idiomas',
    'Alquiler de bicicletas',
    'Clases de baile',
    'Viaje organizado',
  ];
  final contexts = [
    'Curso de cocina mediterránea para principiantes. Se imparte los lunes por la tarde e incluye todos los ingredientes y un recetario digital.',
    'Clases de conversación en grupos reducidos. Martes y jueves a partir de las 19:00 con profesorado nativo y material incluido.',
    'Taller de fotografía con móvil. Cuatro sesiones prácticas por la ciudad y una salida final de fin de semana.',
    'Yoga suave para personas que empiezan. Las clases son por la mañana y el centro presta esterillas a quien no tenga.',
    'Se busca dependiente para tienda de barrio. Contrato de media jornada de tarde y experiencia de al menos seis meses en atención al público.',
    'Campamento urbano para niños de 7 a 12 años. Incluye excursiones, actividades deportivas y comedor opcional.',
    'Intercambio de idiomas los viernes en una cafetería del centro. No hace falta inscripción previa, solo ganas de practicar.',
    'Alquiler de bicicletas por horas o por día completo. El casco y el candado están incluidos en el precio.',
    'Clases de baile latino para nivel inicial. Posibilidad de asistir una o dos veces por semana.',
    'Viaje organizado a Toledo con salida en autobús, guía acompañante y entrada al museo principal.',
  ];
  final prompts = [
    '¿Qué ventaja ofrece el curso de cocina?',
    '¿Qué destaca el anuncio de la academia?',
    '¿Qué incluye el taller de fotografía?',
    '¿Qué facilita el centro en las clases de yoga?',
    '¿Qué requisito aparece en la oferta de empleo?',
    '¿Qué servicio adicional se menciona en el campamento urbano?',
    '¿Qué característica tiene el intercambio de idiomas?',
    '¿Qué está incluido en el alquiler de bicicletas?',
    '¿Qué opción ofrece la escuela de baile?',
    '¿Qué incluye el viaje organizado a Toledo?',
  ];
  final correctAnswers = [
    'Que incluye ingredientes y recetario digital',
    'Que las clases son en grupos reducidos con material incluido',
    'Que termina con una salida de fin de semana',
    'Que presta esterillas a quien lo necesite',
    'Que piden experiencia previa en atención al público',
    'Que ofrece comedor opcional',
    'Que no exige inscripción previa',
    'Que el casco y el candado entran en el precio',
    'Que permite elegir entre una o dos clases semanales',
    'Que lleva guía acompañante y entrada al museo',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Anuncios y publicidad',
      contextTitle: 'Anuncio',
      contextText: contexts[i],
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Anuncios y publicidad',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La opción correcta recoge la ventaja o condición destacada en el anuncio.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _readingRuleSpecs() {
  final titles = [
    'Normas de piscina',
    'Reglas del apartamento turístico',
    'Uso de la biblioteca',
    'Acceso al laboratorio',
    'Centro deportivo',
    'Parque natural',
    'Sala de cine',
    'Concierto al aire libre',
    'Edificio de oficinas',
    'Comedor escolar',
  ];
  final contexts = [
    'Para acceder a la piscina es obligatorio usar gorro y chanclas. Los menores de doce años deben entrar acompañados de una persona adulta.',
    'No está permitido hacer ruido después de las 23:00 ni recibir visitas que no estén incluidas en la reserva inicial.',
    'Los libros de consulta no pueden salir del edificio y los ordenadores se prestan por periodos máximos de una hora.',
    'Es necesario llevar tarjeta identificativa y bata cerrada. No se puede comer ni beber dentro del laboratorio.',
    'Cada persona usuaria debe limpiar la máquina después de usarla y devolver el material a su sitio al terminar.',
    'No se permite encender fuego ni dejar basura. Los perros deben ir atados en todo momento.',
    'Una vez empezada la película, solo se permitirá el acceso durante los anuncios o en los primeros diez minutos.',
    'Por motivos de seguridad, no está permitido entrar con botellas de vidrio ni objetos punzantes.',
    'Las visitas deben registrarse en recepción y llevar visible la acreditación durante toda su estancia en el edificio.',
    'Las familias deben comunicar las alergias alimentarias antes del inicio del trimestre para adaptar los menús.',
  ];
  final prompts = [
    'Según las normas, ¿qué necesita cualquier usuario para entrar en la piscina?',
    '¿Qué está prohibido en el apartamento turístico?',
    '¿Qué limitación existe en la biblioteca?',
    '¿Qué se exige para entrar en el laboratorio?',
    '¿Qué deben hacer los usuarios del centro deportivo después de usar una máquina?',
    '¿Qué norma aparece en el parque natural?',
    '¿Cuándo se puede entrar en la sala de cine si la película ya ha empezado?',
    '¿Qué objetos no están permitidos en el concierto?',
    '¿Qué deben hacer las visitas del edificio de oficinas?',
    '¿Qué tienen que comunicar las familias al comedor escolar?',
  ];
  final correctAnswers = [
    'Llevar gorro y chanclas',
    'Hacer ruido por la noche',
    'Sacar fuera los libros de consulta',
    'Llevar tarjeta y bata cerrada',
    'Limpiarla y guardar el material',
    'Llevar a los perros atados',
    'Solo durante los anuncios o los primeros diez minutos',
    'Las botellas de vidrio y los objetos punzantes',
    'Registrarse y llevar acreditación visible',
    'Las alergias alimentarias',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Normas e instrucciones',
      contextTitle: 'Normas del servicio',
      contextText: contexts[i],
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Normas e instrucciones',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta recoge la norma o instrucción principal del texto.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _readingReviewSpecs() {
  final titles = [
    'Reseña de restaurante',
    'Comentario sobre un hotel',
    'Opinión de una app',
    'Reseña de una academia',
    'Comentario sobre una excursión',
    'Opinión de un mercado',
    'Reseña de una película',
    'Comentario sobre un gimnasio',
    'Opinión de una cafetería',
    'Reseña de una tienda en línea',
  ];
  final contexts = [
    'El menú del día tiene buena relación calidad-precio y el servicio es rápido. Lo menos cómodo es que el local suele llenarse y conviene reservar.',
    'Las habitaciones eran limpias y tranquilas, y el desayuno estaba bastante bien. Lo peor fue que el wifi falló varias veces durante la estancia.',
    'La aplicación, o app, es fácil de usar y permite guardar las tareas pendientes, pero a veces tarda demasiado en sincronizar los cambios.',
    'La profesora explica con claridad y corrige mucho la pronunciación. Las clases serían mejores si duraran un poco más.',
    'La ruta estuvo muy bien organizada y las vistas merecieron la pena. Eso sí, conviene llevar calzado cómodo porque hubo bastante caminata.',
    'Tiene productos frescos y precios razonables. Lo único incómodo es que a partir de las once se forman colas largas en varias paradas.',
    'La historia es entretenida y los actores principales están muy bien. El final, sin embargo, resulta un poco previsible.',
    'Las instalaciones son modernas y el personal es amable. En horas punta cuesta encontrar máquinas libres.',
    'El café está bueno y el ambiente es agradable para trabajar. A veces la música está más alta de lo necesario.',
    'El pedido llegó rápido y bien embalado. La devolución fue sencilla, aunque la atención por chat contestó con bastante retraso.',
  ];
  final prompts = [
    '¿Qué recomienda la reseña del restaurante?',
    '¿Qué problema menciona la persona que comenta el hotel?',
    '¿Qué inconveniente señala la opinión sobre la app?',
    '¿Qué mejora propone la reseña de la academia?',
    '¿Qué consejo da el comentario sobre la excursión?',
    '¿Qué dificultad menciona la opinión sobre el mercado?',
    '¿Qué valoración hace la reseña de la película?',
    '¿Qué inconveniente aparece en el comentario del gimnasio?',
    '¿Qué detalle menos positivo se menciona sobre la cafetería?',
    '¿Qué aspecto mejorable aparece en la reseña de la tienda en línea?',
  ];
  final correctAnswers = [
    'Reservar antes de ir',
    'Que el wifi falló varias veces',
    'Que a veces sincroniza despacio',
    'Que las clases duren un poco más',
    'Llevar calzado cómodo',
    'Que se forman colas a media mañana',
    'Que es entretenida, aunque con un final previsible',
    'Que en horas punta faltan máquinas libres',
    'Que a veces la música está demasiado alta',
    'Que el chat tardó en responder',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Opiniones y reseñas',
      contextTitle: 'Comentario en internet',
      contextText: contexts[i],
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Opiniones y reseñas',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta recoge la valoración o recomendación principal del comentario.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _writingSpecs() {
  return [
    ..._writingInfoRequestSpecs(),
    ..._writingDelayAndPlansSpecs(),
    ..._writingServiceRequestSpecs(),
    ..._writingConfirmationSpecs(),
    ..._writingComplaintAndThanksSpecs(),
  ];
}

List<_QuestionSpec> _writingInfoRequestSpecs() {
  final titles = [
    'Curso de fotografía',
    'Clases de español',
    'Visita guiada',
    'Alquiler de sala',
    'Campamento infantil',
    'Curso de cocina',
    'Gimnasio del barrio',
    'Taller de empleo',
    'Academia de música',
    'Club de senderismo',
  ];
  final prompts = [
    'Quieres saber si todavía quedan plazas en un curso de fotografía de octubre. ¿Qué mensaje elegirías?',
    'Necesitas preguntar el precio de unas clases de español por la tarde. ¿Cuál suena mejor?',
    'Quieres pedir información sobre una visita guiada del sábado. ¿Qué opción es más adecuada?',
    'Te interesa alquilar una sala para una reunión pequeña. ¿Qué correo es el más natural?',
    'Quieres consultar el horario del campamento infantil. ¿Qué mensaje encaja mejor?',
    'Necesitas preguntar si el curso de cocina incluye materiales. ¿Qué escribirías?',
    'Quieres saber si el gimnasio ofrece matrícula gratis este mes. ¿Qué mensaje es más apropiado?',
    'Te interesa un taller de empleo y quieres preguntar si hace falta inscripción previa. ¿Qué opción elegirías?',
    'Quieres consultar si la academia de música admite principiantes. ¿Cuál es la mejor redacción?',
    'Necesitas preguntar por el nivel físico necesario para un club de senderismo. ¿Qué mensaje mandarías?',
  ];
  final correctMessages = [
    'Buenos días. Me gustaría saber si todavía quedan plazas disponibles en el curso de fotografía de octubre. Muchas gracias.',
    'Buenas tardes. ¿Podrían indicarme cuál es el precio de las clases de español en horario de tarde?',
    'Hola. Quería pedir información sobre la visita guiada del sábado y saber si aún hay disponibilidad.',
    'Buenos días. Necesitaría alquilar una sala para una reunión de seis personas. ¿Podrían informarme de las condiciones?',
    'Buenas tardes. ¿Podrían decirme a qué hora empieza y termina el campamento infantil cada día?',
    'Hola. Me gustaría saber si el curso de cocina incluye los materiales necesarios para las clases.',
    'Buenos días. Quería consultar si este mes ofrecen alguna promoción de matrícula en el gimnasio.',
    'Buenas tardes. Estoy interesado en el taller de empleo y me gustaría saber si es necesario inscribirse con antelación.',
    'Hola. Quisiera saber si la academia acepta alumnado sin experiencia previa en música.',
    'Buenos días. ¿Podrían indicarme si las rutas del club de senderismo son adecuadas para personas con nivel inicial?',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Pedir información',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Pedir información',
        correctMessages[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La opción correcta formula la consulta con claridad y cortesía.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _writingDelayAndPlansSpecs() {
  final titles = [
    'Retraso por tráfico',
    'Cambio de hora',
    'Aplazar una cena',
    'Aviso por lluvia',
    'Confirmar llegada tarde',
    'Cambiar una reunión',
    'Cancelar una visita',
    'Retraso del tren',
    'Nuevo punto de encuentro',
    'Plan para el domingo',
  ];
  final prompts = [
    'Vas a llegar diez minutos tarde a una cita con una amiga porque hay tráfico. ¿Qué mensaje elegirías?',
    'Necesitas avisar de que la clase empieza media hora más tarde. ¿Cuál suena mejor?',
    'Quieres aplazar una cena porque no te encuentras bien. ¿Qué opción es más natural?',
    'Va a llover y quieres proponer otro plan. ¿Qué mensaje es adecuado?',
    'Te retrasas al salir del trabajo y quieres avisar con educación. ¿Qué escribirías?',
    'Necesitas mover una reunión de las cuatro a las cinco. ¿Cuál es la mejor formulación?',
    'No puedes ir a una visita al médico y quieres cancelarla con tiempo. ¿Qué mensaje usarías?',
    'Tu tren llega más tarde de lo previsto. ¿Qué opción informa mejor de la situación?',
    'Quieres avisar de que esperarás en otra entrada del edificio. ¿Qué mensaje encaja mejor?',
    'No podrás salir el sábado y propones quedar el domingo. ¿Qué texto resulta más natural?',
  ];
  final correctMessages = [
    'Perdona, voy a llegar unos diez minutos tarde porque hay mucho tráfico.',
    'Hola. Te escribo para avisarte de que hoy la clase empezará media hora más tarde de lo habitual.',
    'Lo siento, no me encuentro bien y prefiero dejar la cena para otro día si te parece bien.',
    'Parece que va a llover esta tarde. Si quieres, en vez de ir al parque podemos quedar en una cafetería.',
    'Perdona, estoy saliendo ahora del trabajo y llegaré un poco más tarde de lo previsto.',
    'Buenos días. ¿Te viene bien si cambiamos la reunión de las cuatro a las cinco?',
    'Buenos días. No voy a poder asistir a la cita de mañana. ¿Sería posible cancelarla o cambiarla a otro día?',
    'Mi tren lleva retraso y llegaré más tarde de lo previsto. En cuanto sepa la hora exacta, te aviso.',
    'Hola. Al final te esperaré en la entrada trasera del edificio porque la principal está cerrada.',
    'Este sábado me resulta imposible quedar. Si te va bien, podemos vernos el domingo por la tarde.',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Gestionar planes',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Gestionar planes',
        correctMessages[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta informa del cambio de plan de forma clara y educada.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _writingServiceRequestSpecs() {
  final titles = [
    'Calefacción averiada',
    'Bombilla fundida',
    'Internet inestable',
    'Ducha estropeada',
    'Consulta en recepción',
    'Solicitud de certificado',
    'Petición de factura',
    'Reserva de pista',
    'Ayuda con una matrícula',
    'Revisión del coche',
  ];
  final prompts = [
    'Necesitas pedir al propietario que revise la calefacción. ¿Cuál es la mejor redacción?',
    'Quieres avisar a mantenimiento de que la luz del pasillo no funciona. ¿Qué mensaje es adecuado?',
    'Necesitas escribir a tu compañía porque el internet, o wifi de casa, falla desde ayer. ¿Qué opción elegirías?',
    'Quieres pedir una reparación porque la ducha pierde agua. ¿Cuál suena más natural?',
    'Necesitas solicitar información en la recepción de un hotel sobre el desayuno. ¿Qué mensaje mandarías?',
    'Quieres pedir un certificado de asistencia a un curso. ¿Qué redacción es mejor?',
    'Necesitas pedir una factura de una compra reciente. ¿Qué opción es más correcta?',
    'Quieres reservar una pista de pádel para el viernes. ¿Qué mensaje usarías?',
    'Tienes un problema al completar una matrícula en línea. ¿Cuál es la mejor forma de pedir ayuda?',
    'Quieres solicitar cita para revisar el coche la próxima semana. ¿Qué escribirías?',
  ];
  final correctMessages = [
    'Buenas tardes. La calefacción no funciona bien desde ayer. ¿Podría revisarla cuando le sea posible?',
    'Hola. Quería avisar de que la bombilla del pasillo del tercer piso está fundida y sería necesario cambiarla.',
    'Buenos días. Desde ayer la conexión a internet o wifi en mi domicilio funciona con cortes continuos. ¿Podrían revisarlo?',
    'Buenas tardes. La ducha del baño pierde agua y me gustaría saber cuándo podrían venir a repararla.',
    'Buenos días. Me gustaría saber a qué hora se sirve el desayuno y si hay opciones sin gluten.',
    'Hola. Necesitaría un certificado que acredite mi asistencia al curso del mes pasado. ¿Podrían indicarme cómo solicitarlo?',
    'Buenos días. Quisiera pedir la factura de la compra realizada ayer con el número de pedido 4582.',
    'Hola. Me gustaría reservar una pista de pádel para el viernes por la tarde, si todavía hay disponibilidad.',
    'Buenas tardes. Estoy intentando completar la matrícula en línea, pero la plataforma me da error al adjuntar el documento. ¿Podrían ayudarme?',
    'Buenos días. Quisiera pedir una cita para la revisión del coche durante la próxima semana, preferiblemente por la mañana.',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Hacer gestiones',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Hacer gestiones',
        correctMessages[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La opción correcta describe la necesidad y hace la petición de manera adecuada.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _writingConfirmationSpecs() {
  final titles = [
    'Confirmar asistencia',
    'Aceptar una invitación',
    'Responder a un cumpleaños',
    'Confirmar una reserva',
    'Aceptar una entrevista',
    'Responder a una reunión',
    'Confirmar una visita',
    'Aceptar una excursión',
    'Confirmar recogida',
    'Responder a una propuesta de trabajo',
  ];
  final prompts = [
    'Te invitan a una comida familiar y quieres confirmar que irás. ¿Qué opción es más natural?',
    'Una amiga te propone cenar el sábado y quieres aceptar. ¿Qué mensaje elegirías?',
    'Quieres responder a una invitación de cumpleaños confirmando tu asistencia. ¿Qué escribirías?',
    'Necesitas confirmar una reserva en un restaurante. ¿Cuál es la mejor redacción?',
    'Te ofrecen una entrevista y quieres aceptar el horario propuesto. ¿Qué opción es adecuada?',
    'Quieres confirmar que asistirás a una reunión virtual. ¿Qué mensaje encaja mejor?',
    'Necesitas confirmar una visita a un piso de alquiler. ¿Qué mensaje mandarías?',
    'Te proponen una excursión y quieres decir que sí. ¿Qué opción elegirías?',
    'La tienda te avisa de que ya puedes recoger un pedido y quieres confirmar que pasarás hoy. ¿Qué mensaje es mejor?',
    'Quieres responder a una propuesta de trabajo diciendo que te interesa seguir en el proceso. ¿Qué escribirías?',
  ];
  final correctMessages = [
    'Gracias por la invitación. Confirmo que el domingo estaré allí a la hora acordada.',
    'Claro, me encantaría cenar contigo el sábado. Dime si te viene bien quedar sobre las nueve.',
    'Muchas gracias por invitarme. Allí estaré el viernes para celebrarlo con vosotros.',
    'Buenas tardes. Les confirmo la reserva para dos personas a nombre de Marta López para este viernes.',
    'Muchas gracias. Confirmo mi disponibilidad para la entrevista en el horario que me proponen.',
    'Buenos días. Confirmo que asistiré a la reunión virtual de mañana y me conectaré unos minutos antes.',
    'Hola. Confirmo la visita al piso para mañana por la tarde. Muchas gracias.',
    'Sí, me apetece mucho ir. Cuenta conmigo para la excursión del sábado.',
    'Hola. Gracias por avisar. Pasaré esta tarde por la tienda para recoger el pedido.',
    'Muchas gracias por su mensaje. Estoy interesado en continuar con el proceso de selección.',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Confirmar y aceptar',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Confirmar y aceptar',
        correctMessages[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta confirma o acepta el plan de forma clara y cordial.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _writingComplaintAndThanksSpecs() {
  final titles = [
    'Pedido equivocado',
    'Agradecimiento por entrevista',
    'Queja por ruido',
    'Gracias por una ayuda',
    'Reclamación de billete',
    'Mensaje después de una reunión',
    'Incidencia con una reserva',
    'Agradecimiento a una profesora',
    'Queja por retraso',
    'Gracias por una recomendación',
  ];
  final prompts = [
    'Has recibido un producto equivocado. ¿Cómo escribirías una reclamación breve y correcta?',
    'Después de una entrevista, quieres enviar un mensaje breve de agradecimiento. ¿Cuál encaja mejor?',
    'Quieres escribir a la administración por ruidos continuos en el edificio. ¿Qué opción es más adecuada?',
    'Una compañera te ha ayudado con un trámite y quieres agradecérselo. ¿Qué mensaje elegirías?',
    'Tu billete de autobús aparece duplicado en el cobro. ¿Qué redacción es mejor para reclamar?',
    'Quieres agradecer el tiempo de una reunión y resumir el siguiente paso. ¿Qué escribirías?',
    'Llegas al hotel y tu reserva no aparece. ¿Qué mensaje formal podrías enviar después?',
    'Quieres agradecer a una profesora sus consejos al final del curso. ¿Qué mensaje suena mejor?',
    'Tu pedido llegó dos días tarde y quieres comunicarlo de forma correcta. ¿Qué opción eliges?',
    'Un amigo te recomendó una clínica que te atendió muy bien y quieres dárselo las gracias. ¿Qué escribirías?',
  ];
  final correctMessages = [
    'Buenos días. Ayer recibí un pedido con un artículo distinto al que solicité. ¿Podrían indicarme cómo hacer el cambio?',
    'Muchas gracias por su tiempo y por la entrevista de esta mañana. Ha sido un placer conocer mejor el puesto.',
    'Buenas tardes. Quisiera comunicar que en el piso de arriba hay ruidos frecuentes por la noche y agradecería que revisaran la situación.',
    'Muchas gracias por ayudarme con el trámite. Con tu explicación he podido terminarlo sin problemas.',
    'Buenos días. He comprobado que el importe de mi billete se ha cobrado dos veces. ¿Podrían revisarlo, por favor?',
    'Gracias por la reunión de esta mañana. Quedo pendiente de enviarles la documentación que comentamos.',
    'Buenas noches. Al llegar al hotel me han indicado que no figura mi reserva. Les agradecería una revisión de la incidencia cuanto antes.',
    'Muchas gracias por todo lo que nos ha enseñado este curso y por las recomendaciones para seguir mejorando.',
    'Buenos días. Mi pedido llegó con dos días de retraso respecto a la fecha indicada en la compra. Quisiera dejar constancia de la incidencia.',
    'Gracias por recomendarme la clínica. Me atendieron muy bien y la experiencia fue muy positiva.',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Quejas y agradecimientos',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Quejas y agradecimientos',
        correctMessages[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La opción correcta mantiene un tono claro y adecuado para agradecer o reclamar.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _listeningSpecs() {
  return [
    ..._listeningTransportSpecs(),
    ..._listeningMessageSpecs(),
    ..._listeningAnnouncementSpecs(),
    ..._listeningConversationSpecs(),
    ..._listeningInstructionSpecs(),
  ];
}

List<_QuestionSpec> _listeningTransportSpecs() {
  final titles = [
    'Retraso de tren',
    'Cambio de andén',
    'Autobús cancelado',
    'Puerta de embarque',
    'Última parada',
    'Billete no válido',
    'Vagón cafetería',
    'Obras en metro',
    'Salida adelantada',
    'Equipaje extraviado',
  ];
  final prompts = [
    'Escuchas: "El tren con destino a Sevilla saldrá con veinte minutos de retraso desde la vía 4". ¿Qué información principal recibes?',
    'Escuchas: "Atención, el tren regional a León saldrá finalmente desde el andén 6". ¿Qué deben hacer los viajeros?',
    'Escuchas: "El autobús de las 18:00 a Toledo ha sido cancelado. El siguiente sale a las 18:45". ¿Qué se comunica?',
    'Escuchas: "Los pasajeros del vuelo 317 deben dirigirse a la puerta B12 para iniciar el embarque". ¿Qué indica el aviso?',
    'Escuchas: "Esta línea termina su recorrido en Plaza Norte. Todos los pasajeros deben bajar aquí". ¿Qué significa?',
    'Escuchas: "Ese billete corresponde al trayecto de mañana, por eso hoy no puede utilizarlo". ¿Qué problema hay?',
    'Escuchas: "El vagón cafetería permanecerá abierto hasta las nueve de la noche". ¿Qué informa el mensaje?',
    'Escuchas: "Por obras en la línea 2, recomendamos usar la línea 5 para llegar al centro". ¿Qué aconsejan?',
    'Escuchas: "El barco a la isla adelantará su salida a las 7:30 por previsión de mal tiempo". ¿Qué cambio hay?',
    'Escuchas: "Si no encuentra su maleta, acuda al mostrador de equipajes perdidos junto a la salida". ¿Qué debe hacer la persona?',
  ];
  final correctAnswers = [
    'Que el tren a Sevilla sale más tarde',
    'Que vayan al andén 6',
    'Que ese autobús no sale y deben esperar al siguiente',
    'Que ya pueden ir a la puerta B12',
    'Que todos deben bajar en Plaza Norte',
    'Que el billete es para otro día',
    'Que la cafetería estará abierta hasta las nueve',
    'Que es mejor tomar otra línea para llegar al centro',
    'Que el barco saldrá antes de lo previsto',
    'Que vaya al mostrador de equipajes perdidos',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Avisos de transporte',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Avisos de transporte',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta recoge el dato clave del aviso escuchado.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _listeningMessageSpecs() {
  final titles = [
    'Recado telefónico',
    'Mensaje de voz',
    'Aviso de una amiga',
    'Llamada del dentista',
    'Mensaje del trabajo',
    'Recado del profesor',
    'Aviso del casero',
    'Mensaje del reparto',
    'Llamada del colegio',
    'Mensaje del taller',
  ];
  final prompts = [
    'Escuchas: "Llamó Marta para decir que llegará directamente al restaurante". ¿Qué debes entender?',
    'Escuchas: "Te he dejado las llaves en el buzón pequeño porque salgo tarde de la oficina". ¿Qué informa el mensaje?',
    'Escuchas: "Al final no voy al gimnasio. Si quieres, nos vemos media hora antes para tomar un café". ¿Qué propone la amiga?',
    'Escuchas: "Le recordamos su cita de mañana a las diez y media. Si no puede venir, avise por teléfono". ¿Qué pide la clínica?',
    'Escuchas: "La reunión de equipo se adelanta a las nueve porque después viene un cliente". ¿Qué cambio se hace?',
    'Escuchas: "Recordad llevar el libro y el cuaderno porque hoy corregiremos los ejercicios en clase". ¿Qué deben llevar los alumnos?',
    'Escuchas: "Mañana pasarán a revisar el contador del agua entre las ocho y las diez". ¿Qué informa el casero?',
    'Escuchas: "No había nadie en casa, así que volveremos a repartir el paquete mañana por la mañana". ¿Qué ocurrió?',
    'Escuchas: "La excursión saldrá del aparcamiento trasero y no de la puerta principal". ¿Qué deben saber las familias?',
    'Escuchas: "Su coche estará listo a partir de las cinco. Puede recogerlo cuando quiera". ¿Qué comunica el taller?',
  ];
  final correctAnswers = [
    'Que Marta irá al restaurante sin pasar antes por otro lugar',
    'Que las llaves están en el buzón pequeño',
    'Que se vean antes para tomar un café',
    'Que avise si no puede ir a la cita',
    'Que la reunión será más temprano',
    'Que lleven el libro y el cuaderno',
    'Que revisarán el contador a primera hora',
    'Que el reparto volverá al día siguiente',
    'Que el autobús saldrá de otro punto',
    'Que el coche puede recogerse desde las cinco',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Recados y mensajes',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Recados y mensajes',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta recoge la información principal del recado.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _listeningAnnouncementSpecs() {
  final titles = [
    'Anuncio de tienda',
    'Oferta de supermercado',
    'Aviso de museo',
    'Promoción de librería',
    'Anuncio de piscina',
    'Información de cine',
    'Aviso del ayuntamiento',
    'Promoción de cafetería',
    'Anuncio de farmacia',
    'Información de gimnasio',
  ];
  final prompts = [
    'Escuchas: "Hoy tenemos un 30 % de descuento en calzado hasta las ocho de la tarde". ¿Qué se anuncia?',
    'Escuchas: "Las naranjas están hoy a precio especial y la oferta termina al cierre". ¿Qué informa el supermercado?',
    'Escuchas: "El museo abrirá también este lunes por ser festivo". ¿Qué novedad se comunica?',
    'Escuchas: "Por la compra de dos novelas, regalamos una libreta hasta fin de existencias". ¿Qué ofrece la librería?',
    'Escuchas: "Mañana la piscina abrirá una hora más tarde por una competición escolar". ¿Qué cambia?',
    'Escuchas: "Quedan entradas para la sesión de las diez, pero no para la de las ocho". ¿Qué deben saber los clientes?',
    'Escuchas: "La recogida de muebles viejos se hará este mes solo los miércoles por la mañana". ¿Qué informa el ayuntamiento?',
    'Escuchas: "Con cada desayuno completo regalamos hoy un zumo, o jugo natural". ¿Qué promoción hay?',
    'Escuchas: "Esta farmacia estará de guardia toda la noche". ¿Qué significa el anuncio?',
    'Escuchas: "La clase de pilates de hoy será en la sala 3 y no en la sala 1". ¿Qué aviso se da?',
  ];
  final correctAnswers = [
    'Una rebaja temporal en zapatos',
    'Que las naranjas tienen un precio especial hoy',
    'Que abrirá un lunes festivo',
    'Que regalan una libreta con una compra concreta',
    'Que abrirá más tarde de lo habitual',
    'Que solo quedan entradas para la sesión de las diez',
    'Que la recogida se hará los miércoles por la mañana',
    'Que hoy dan un zumo con el desayuno completo',
    'Que la farmacia permanecerá abierta toda la noche',
    'Que la clase cambia de sala',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Anuncios públicos',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Anuncios públicos',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta refleja el contenido esencial del anuncio.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _listeningConversationSpecs() {
  final titles = [
    'Plan con lluvia',
    'Cena del sábado',
    'Opinión sobre una película',
    'Elección de transporte',
    'Compra de fruta',
    'Fin de semana en casa',
    'Buscar piso',
    'Hacer deporte',
    'Vacaciones en agosto',
    'Invitación a comer',
  ];
  final prompts = [
    'Escuchas: "Si deja de llover, vamos al parque; si no, nos quedamos en casa viendo una película". ¿De qué depende el plan?',
    'Escuchas: "Me apetece cenar fuera, pero si estás cansado podemos pedir algo a domicilio". ¿Qué propone la persona?',
    'Escuchas: "La película estuvo bien, aunque me gustó más el principio que el final". ¿Qué opinión expresa?',
    'Escuchas: "Yo prefiero ir en metro porque a esta hora el autobús tarda mucho". ¿Por qué elige el metro?',
    'Escuchas: "Compra plátanos si están maduros; si no, mejor trae manzanas". ¿Qué debe hacer la otra persona?',
    'Escuchas: "Como el domingo estará todo cerrado, mejor cocinamos en casa". ¿Qué plan prefieren?',
    'Escuchas: "El piso me gusta, pero está un poco lejos del trabajo". ¿Qué duda tiene la persona?',
    'Escuchas: "Quiero apuntarme al gimnasio, aunque quizá primero pruebe la piscina". ¿Qué está valorando?',
    'Escuchas: "En agosto no viajaremos porque queremos ahorrar para cambiar de coche". ¿Por qué no viajan?',
    'Escuchas: "Ven a comer cuando salgas del trabajo, que prepararé pasta". ¿Qué invita a hacer?',
  ];
  final correctAnswers = [
    'Del tiempo que haga',
    'Que cenen fuera o pidan comida a domicilio',
    'Que le gustó, pero el final menos',
    'Porque cree que será más rápido',
    'Traer plátanos solo si están maduros',
    'Quedarse en casa y cocinar',
    'Que el piso queda lejos del trabajo',
    'Entre apuntarse al gimnasio o probar la piscina',
    'Porque quieren ahorrar dinero',
    'A ir a comer después del trabajo',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Conversaciones cotidianas',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Conversaciones cotidianas',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La opción correcta identifica la idea principal de la conversación.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _listeningInstructionSpecs() {
  final titles = [
    'Tomar un medicamento',
    'Entrega de tareas',
    'Uso del horno',
    'Instrucciones de oficina',
    'Ejercicio en clase',
    'Receta sencilla',
    'Cuidado de una planta',
    'Revisión del coche',
    'Uso del ascensor',
    'Normas del examen',
  ];
  final prompts = [
    'Escuchas: "Tómese este jarabe tres veces al día después de las comidas". ¿Qué indica la médica?',
    'Escuchas: "Recordad entregar la tarea antes del viernes porque el fin de semana no revisaré el correo". ¿Qué pide el profesor?',
    'Escuchas: "Primero precalienta el horno y después mete la bandeja durante veinte minutos". ¿Qué explica la persona?',
    'Escuchas: "Deja los documentos firmados sobre mi mesa antes de salir". ¿Qué instrucción da?',
    'Escuchas: "Trabajad en parejas y terminad los ejercicios uno y dos en diez minutos". ¿Qué deben hacer los estudiantes?',
    'Escuchas: "Añade la pasta cuando el agua esté hirviendo y remuévela al principio". ¿Qué consejo da?',
    'Escuchas: "Riega la planta solo dos veces por semana y colócala cerca de una ventana". ¿Qué recomienda?',
    'Escuchas: "Si oyes un ruido extraño al frenar, tráelo al taller cuanto antes". ¿Qué aconseja el mecánico?',
    'Escuchas: "Para subir al séptimo, use el ascensor del fondo porque el otro está averiado". ¿Qué debe hacer la persona?',
    'Escuchas: "Durante el examen no se puede usar el móvil y hay que escribir con bolígrafo azul o negro". ¿Qué norma se menciona?',
  ];
  final correctAnswers = [
    'Cómo debe tomar el medicamento',
    'Que envíen la tarea antes del viernes',
    'Cómo usar el horno en esa receta',
    'Que deje los documentos firmados en la mesa',
    'Que hagan los ejercicios en parejas y con tiempo limitado',
    'Cómo cocer la pasta correctamente',
    'Cómo cuidar mejor la planta',
    'Que lleve el coche al taller pronto',
    'Que use el ascensor del fondo',
    'Que el móvil no está permitido durante el examen',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Instrucciones y consejos',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Instrucciones y consejos',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta resume la instrucción o el consejo escuchado.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _oralSpecs() {
  return [
    ..._oralIntroductionSpecs(),
    ..._oralHelpSpecs(),
    ..._oralInviteSpecs(),
    ..._oralOpinionSpecs(),
    ..._oralRoutineSpecs(),
  ];
}

List<_QuestionSpec> _oralIntroductionSpecs() {
  final titles = [
    'Presentarte en clase',
    'Primer día de trabajo',
    'Conocer a unos vecinos',
    'Presentarte en un curso',
    'Hablar con una familia anfitriona',
    'Saludar en una reunión',
    'Presentarte en una entrevista informal',
    'Empezar una videollamada',
    'Hablar con compañeros nuevos',
    'Conocer a un amigo de un amigo',
  ];
  final prompts = [
    'Acabas de llegar a una clase nueva. ¿Qué presentación oral suena más natural?',
    'Es tu primer día de trabajo y quieres presentarte. ¿Qué dirías?',
    'Conoces a tus nuevos vecinos en el ascensor. ¿Qué opción encaja mejor?',
    'Empieza un curso y el profesor pide una breve presentación. ¿Qué respuesta es adecuada?',
    'Llegas a la casa donde vas a alojarte unos días. ¿Cómo te presentarías?',
    'Vas a hablar por primera vez en una reunión pequeña. ¿Qué frase usarías?',
    'Te piden que cuentes quién eres y a qué te dedicas. ¿Qué opción resulta natural?',
    'Empieza una videollamada y quieres saludar y presentarte. ¿Qué dirías?',
    'Hablas con compañeros nuevos durante una pausa. ¿Qué presentación encaja mejor?',
    'Un amigo te presenta a otra persona. ¿Cómo respondes con naturalidad?',
  ];
  final correctAnswers = [
    'Hola, me llamo Clara, soy de Valencia y trabajo como enfermera.',
    'Buenos días, soy Pablo y empiezo hoy en el departamento de ventas. Encantado de conoceros.',
    'Hola, soy Ana, acabo de mudarme al tercero. Encantada de conoceros.',
    'Me llamo Sergio, vivo en Granada y me he apuntado al curso para mejorar mi español.',
    'Hola, soy Lucía. Muchas gracias por recibirme estos días en vuestra casa.',
    'Buenos días. Soy Marta y voy a encargarme de la parte de comunicación del proyecto.',
    'Hola, me llamo Diego y trabajo como técnico informático en una empresa pequeña.',
    'Hola a todos. Soy Elena y os saludo desde Málaga. Gracias por conectaros.',
    'Hola, soy Raúl. Llevo poco tiempo en la empresa y estoy en el equipo de atención al cliente.',
    'Encantado, soy Laura. Carlos me ha hablado mucho de ti.',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Presentarse y saludar',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Presentarse y saludar',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La opción correcta ofrece una presentación breve, clara y natural.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _oralHelpSpecs() {
  final titles = [
    'Pedir ayuda en una tienda',
    'Preguntar una dirección',
    'Pedir que repitan una información',
    'Solicitar una talla',
    'Preguntar por un horario',
    'Pedir ayuda con una máquina',
    'Consultar un precio',
    'Pedir una aclaración al profesor',
    'Preguntar por una parada',
    'Solicitar asistencia en recepción',
  ];
  final prompts = [
    'No encuentras tu talla y quieres pedir ayuda. ¿Qué dirías?',
    'Estás en la calle y necesitas saber cómo llegar a la estación. ¿Qué opción suena mejor?',
    'No has entendido bien una dirección. ¿Qué fórmula usarías?',
    'Quieres probarte la misma camisa en otra talla. ¿Qué pedirías?',
    'Necesitas saber a qué hora cierra una oficina. ¿Qué pregunta es más natural?',
    'No sabes usar la máquina de billetes. ¿Cómo pedirías ayuda?',
    'Ves un producto sin etiqueta y quieres saber cuánto cuesta. ¿Qué dirías?',
    'En clase no entiendes una palabra. ¿Qué le dices al profesor?',
    'Viajas en autobús y quieres confirmar la parada correcta. ¿Qué preguntarías?',
    'En un hotel necesitas una toalla más. ¿Qué opción es adecuada?',
  ];
  final correctAnswers = [
    'Perdona, ¿tienes esta camiseta en una talla más grande?',
    'Perdone, ¿me puede decir cómo llegar a la estación, por favor?',
    'Perdona, ¿puedes repetirlo más despacio, por favor?',
    '¿Tendrías esta camisa en una talla menos?',
    'Perdone, ¿a qué hora cierra hoy la oficina?',
    'Perdona, no sé usar esta máquina. ¿Me puedes ayudar un momento?',
    'Perdone, ¿cuánto cuesta este producto?',
    'Perdón, no he entendido esa palabra. ¿La puede explicar otra vez?',
    'Perdone, ¿esta línea para cerca del hospital?',
    'Buenas tardes. ¿Podrían subir una toalla más a la habitación, por favor?',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Pedir ayuda e información',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Pedir ayuda e información',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta formula la petición con claridad y cortesía.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _oralInviteSpecs() {
  final titles = [
    'Aceptar una invitación',
    'Rechazar con educación',
    'Proponer una hora',
    'Quedar para tomar café',
    'Invitar a cenar',
    'Aceptar una excursión',
    'Cambiar un plan',
    'Invitar a estudiar',
    'Responder a una comida',
    'Proponer verse otro día',
  ];
  final prompts = [
    'Una compañera te invita a cenar el sábado. ¿Cuál es una respuesta oral adecuada?',
    'No puedes ir a una fiesta y quieres rechazar la invitación con educación. ¿Qué dirías?',
    'Quieres concretar la hora de un encuentro. ¿Qué opción suena natural?',
    'Te apetece quedar con un amigo para tomar café. ¿Cómo lo propondrías?',
    'Quieres invitar a una vecina a cenar en casa. ¿Qué frase elegirías?',
    'Unos amigos te proponen una excursión y quieres aceptar. ¿Qué dices?',
    'No puedes mantener el plan inicial y necesitas proponer otro. ¿Qué respuesta es mejor?',
    'Quieres invitar a un compañero a estudiar juntos en la biblioteca. ¿Qué dirías?',
    'Te invitan a comer el domingo y quieres aceptar con interés. ¿Qué contestas?',
    'No puedes quedar hoy, pero sí mañana. ¿Qué opción es más natural?',
  ];
  final correctAnswers = [
    'Claro, me encantaría. ¿A qué hora quedamos?',
    'Muchas gracias por invitarme, pero ese día no puedo ir. A ver si coincidimos otro día.',
    'Si te parece bien, podemos quedar a las seis delante de la estación.',
    '¿Te apetece que nos tomemos un café esta tarde después del trabajo?',
    'Si te viene bien, te invito a cenar en casa el viernes por la noche.',
    'Sí, me apunto. Seguro que lo pasamos bien.',
    'Hoy me resulta imposible, pero si quieres podemos dejarlo para mañana.',
    '¿Quieres que estudiemos juntos mañana en la biblioteca?',
    'Perfecto, muchas gracias. Allí estaré el domingo.',
    'Hoy no puedo, pero mañana por la tarde me viene bien si a ti te encaja.',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Invitar y responder',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Invitar y responder',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La opción correcta responde o propone el plan de forma natural y adecuada.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _oralOpinionSpecs() {
  final titles = [
    'Dar una opinión sobre una película',
    'Hablar de un restaurante',
    'Explicar una preferencia',
    'Opinar sobre una ciudad',
    'Comentar un libro',
    'Valorar una clase',
    'Hablar del tiempo',
    'Decir qué te gusta hacer',
    'Opinar sobre una app',
    'Comentar un viaje',
  ];
  final prompts = [
    'Te preguntan qué te pareció una película. ¿Qué respuesta suena natural?',
    'Un amigo te pregunta por un restaurante al que fuiste ayer. ¿Qué dirías?',
    'Quieres explicar que prefieres trabajar por la mañana. ¿Qué opción elegirías?',
    'Te preguntan si te gusta vivir en tu ciudad. ¿Qué respuesta encaja mejor?',
    'Quieres dar una opinión sencilla sobre un libro que acabas de leer. ¿Qué dirías?',
    'Te preguntan cómo fue una clase de prueba. ¿Qué contestación es más natural?',
    'Un compañero comenta que hace mucho calor y te pregunta qué tal llevas el verano. ¿Qué dirías?',
    'Quieres contar qué actividad haces en tu tiempo libre. ¿Qué respuesta es adecuada?',
    'Te preguntan si una aplicación te parece útil. ¿Qué opción suena mejor?',
    'Al volver de un viaje, te preguntan cómo estuvo. ¿Qué contestas?',
  ];
  final correctAnswers = [
    'Me gustó bastante porque la historia era entretenida y los actores estaban muy bien.',
    'Me gustó mucho. La comida estaba buena y el servicio fue bastante rápido.',
    'Prefiero trabajar por la mañana porque a esa hora me concentro mejor.',
    'Sí, me gusta vivir aquí porque es una ciudad cómoda y tengo todo cerca.',
    'Me ha parecido interesante y fácil de leer, aunque algunas partes eran un poco lentas.',
    'Me gustó la clase porque la profesora explicaba muy claro y participamos mucho.',
    'Lo llevo bastante bien, aunque por la tarde prefiero quedarme en casa porque hace demasiado calor.',
    'En mi tiempo libre suelo salir a caminar y leer un rato por la noche.',
    'Sí, me parece útil porque organiza bien las tareas y es fácil de usar en el móvil o celular.',
    'Muy bien. Descansé bastante y además pude conocer sitios nuevos.',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Expresar opiniones',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Expresar opiniones',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La respuesta correcta expresa una opinión sencilla con una razón clara.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

List<_QuestionSpec> _oralRoutineSpecs() {
  final titles = [
    'Hablar de rutinas',
    'Explicar el fin de semana',
    'Contar qué haces por la mañana',
    'Hablar del trabajo',
    'Describir un día normal',
    'Decir cómo vas al trabajo',
    'Contar qué haces al volver a casa',
    'Hablar de tus estudios',
    'Explicar tus planes de esta tarde',
    'Decir qué haces para descansar',
  ];
  final prompts = [
    'En una conversación informal te preguntan por tu rutina diaria. ¿Qué contestación encaja mejor?',
    'Te preguntan qué sueles hacer los fines de semana. ¿Qué respuesta elegirías?',
    'Quieres explicar tu mañana habitual. ¿Qué opción es más natural?',
    'Un compañero te pregunta cómo es tu trabajo. ¿Qué dirías?',
    'Necesitas describir un día normal entre semana. ¿Qué frase encaja mejor?',
    'Te preguntan cómo vas normalmente al trabajo. ¿Qué contestación es adecuada?',
    'Quieres contar lo que haces cuando llegas a casa. ¿Qué respuesta usarías?',
    'Te preguntan por tus estudios actuales. ¿Qué dirías?',
    'Un amigo te pregunta qué harás esta tarde. ¿Qué respuesta suena natural?',
    'Quieres explicar qué haces para relajarte al final del día. ¿Qué opción eliges?',
  ];
  final correctAnswers = [
    'Normalmente me levanto a las siete, desayuno en casa y entro a trabajar a las ocho y media.',
    'Suelo quedar con amigos, hacer la compra y descansar un poco en casa.',
    'Por la mañana me ducho, desayuno y salgo con tiempo para no llegar tarde.',
    'Trabajo en una oficina y atiendo a clientes por teléfono y por correo.',
    'Entre semana salgo de casa temprano, trabajo hasta la tarde y luego vuelvo para cenar tranquilo.',
    'Normalmente voy en metro porque es rápido y me deja cerca de la oficina.',
    'Cuando llego a casa, primero me cambio de ropa y después preparo algo de cenar.',
    'Ahora estoy estudiando un curso de administración porque quiero mejorar en mi trabajo.',
    'Esta tarde voy a hacer unas compras y luego he quedado para tomar algo con una amiga.',
    'Para descansar, suelo leer un rato o ver una serie antes de dormir.',
  ];

  return List<_QuestionSpec>.generate(titles.length, (i) {
    return _QuestionSpec(
      title: titles[i],
      taskType: 'Rutinas y planes',
      prompt: prompts[i],
      optionTexts: _buildOptionTextsForTask(
        'Rutinas y planes',
        correctAnswers[i],
        i,
      ),
      correctOptionId: 'a',
      explanation:
          'La opción correcta describe rutinas o planes con un lenguaje claro y cotidiano.',
      difficulty: i.isEven ? 'fácil' : 'media',
    );
  });
}

class _QuestionSpec {
  final String title;
  final String taskType;
  final String? contextTitle;
  final String? contextText;
  final String prompt;
  final List<String> optionTexts;
  final String correctOptionId;
  final String explanation;
  final String difficulty;

  const _QuestionSpec({
    required this.title,
    required this.taskType,
    this.contextTitle,
    this.contextText,
    required this.prompt,
    required this.optionTexts,
    required this.correctOptionId,
    required this.explanation,
    required this.difficulty,
  });
}
