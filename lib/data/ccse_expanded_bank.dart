import '../models/question_model.dart';

final List<QuestionModel> expandedCcseQuestions =
    _buildOfficialAlignedCcseExpansion();

List<QuestionModel> _buildOfficialAlignedCcseExpansion() {
  final specs = <_CcseFactSpec>[
    ..._governmentExpansionSpecs,
    ..._rightsExpansionSpecs,
    ..._territoryExpansionSpecs,
    ..._cultureExpansionSpecs,
    ..._societyExpansionSpecs,
  ];
  final questions = <QuestionModel>[];
  var nextId = 301;

  for (final spec in specs) {
    for (var variantIndex = 0; variantIndex < 5; variantIndex++) {
      final options = _buildCcseOptions(spec, variantIndex);
      final correctOptionId = options
          .firstWhere((option) => option.isCorrect)
          .id;

      questions.add(
        QuestionModel(
          id: 'ccse-$nextId',
          exam: 'CCSE',
          task: spec.task,
          topic: spec.topic,
          prompt: _buildCcsePrompt(spec, variantIndex),
          options: options,
          correctOptionId: correctOptionId,
          explanation:
              '${spec.explanation} Pregunta elaborada a partir de contenidos públicos del CCSE 2026, con redacción parafraseada.',
          difficulty: _resolveCcseDifficulty(spec.difficulty, variantIndex),
          sourceReference:
              'Instituto Cervantes 2026 (manual e inventario, contenido parafraseado) + elaboración propia',
          contentVersion: 'v3',
        ),
      );
      nextId++;
    }
  }

  return questions;
}

List<QuestionOption> _buildCcseOptions(_CcseFactSpec spec, int variantIndex) {
  final optionTexts = <String>[spec.correctAnswer, ...spec.distractors];
  final correctText = optionTexts.removeAt(0);
  optionTexts.insert(variantIndex % 4, correctText);
  final ids = ['a', 'b', 'c', 'd'];

  return List<QuestionOption>.generate(optionTexts.length, (index) {
    return QuestionOption(
      id: ids[index],
      text: optionTexts[index],
      isCorrect: optionTexts[index] == spec.correctAnswer,
    );
  });
}

String _buildCcsePrompt(_CcseFactSpec spec, int variantIndex) {
  final topic = spec.topic.toLowerCase();
  final templates = switch (spec.task) {
    'Gobierno, legislación y participación ciudadana' => [
      'En relación con $topic, ¿qué opción es correcta en el sistema público español?',
      'Si en la prueba CCSE aparece una pregunta sobre $topic, ¿qué respuesta sería válida?',
      'Marca la opción correcta sobre $topic en España.',
      '¿Cuál de estas afirmaciones encaja mejor con $topic dentro de la organización política española?',
      'Pensando en $topic, ¿qué respuesta se ajusta al funcionamiento institucional de España?',
    ],
    'Derechos y deberes fundamentales' => [
      'En materia de $topic, ¿qué opción refleja correctamente el marco constitucional español?',
      '¿Qué respuesta es adecuada si la pregunta trata sobre $topic?',
      'Marca la afirmación correcta sobre $topic en España.',
      'Si piensas en $topic, ¿qué opción encaja mejor con los derechos y deberes fundamentales?',
      '¿Cuál de estas respuestas es compatible con el tratamiento de $topic en España?',
    ],
    'Organización territorial de España. Geografía física y política' => [
      'En relación con $topic, ¿qué opción describe correctamente la organización territorial o geográfica de España?',
      'Si la pregunta trata de $topic, ¿qué respuesta deberías seleccionar?',
      'Marca la opción correcta sobre $topic en el territorio español.',
      '¿Cuál de estas afirmaciones encaja mejor con $topic dentro de España?',
      'Pensando en $topic, ¿qué respuesta se ajusta a la geografía o estructura territorial española?',
    ],
    'Cultura e historia de España' => [
      'En relación con $topic, ¿qué opción es correcta dentro de la cultura o la historia de España?',
      'Si en el CCSE aparece una cuestión sobre $topic, ¿qué respuesta sería válida?',
      'Marca la afirmación correcta sobre $topic en España.',
      '¿Cuál de estas opciones encaja mejor con $topic desde el punto de vista cultural o histórico?',
      'Pensando en $topic, ¿qué respuesta corresponde mejor a la realidad cultural o histórica española?',
    ],
    _ => [
      'En relación con $topic, ¿qué opción refleja mejor una situación habitual de la sociedad española?',
      'Si la pregunta del CCSE trata de $topic, ¿qué respuesta sería correcta?',
      'Marca la opción adecuada sobre $topic en la vida cotidiana en España.',
      '¿Cuál de estas afirmaciones encaja mejor con $topic dentro de la sociedad española?',
      'Pensando en $topic, ¿qué respuesta se ajusta mejor a la realidad social española?',
    ],
  };

  return templates[variantIndex % templates.length];
}

String _resolveCcseDifficulty(String baseDifficulty, int variantIndex) {
  const order = ['fácil', 'media', 'alta'];
  final baseIndex = order.indexOf(baseDifficulty);

  if (baseIndex == -1) {
    return baseDifficulty;
  }

  final variantShift = switch (variantIndex % 5) {
    0 => 0,
    1 => 0,
    2 => 1,
    3 => 0,
    _ => -1,
  };
  final resolvedIndex = (baseIndex + variantShift).clamp(0, order.length - 1);
  return order[resolvedIndex];
}

class _CcseFactSpec {
  final String task;
  final String topic;
  final String correctAnswer;
  final List<String> distractors;
  final String explanation;
  final String difficulty;

  const _CcseFactSpec({
    required this.task,
    required this.topic,
    required this.correctAnswer,
    required this.distractors,
    required this.explanation,
    required this.difficulty,
  });
}

const List<_CcseFactSpec> _governmentExpansionSpecs = [
  _CcseFactSpec(
    task: 'Gobierno, legislación y participación ciudadana',
    topic: 'Constitución de 1978',
    correctAnswer: 'Fue aprobada en 1978',
    distractors: [
      'Fue aprobada en 1975',
      'Fue aprobada en 1982',
      'Fue aprobada en 1992',
    ],
    explanation:
        'La Constitución de 1978 es la norma fundamental del sistema democrático actual.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Gobierno, legislación y participación ciudadana',
    topic: 'Jefatura del Estado',
    correctAnswer: 'La desempeña el rey',
    distractors: [
      'La desempeña el presidente del Gobierno',
      'La desempeña el presidente del Congreso',
      'La desempeña el Tribunal Supremo',
    ],
    explanation:
        'España es una monarquía parlamentaria y el rey es el jefe del Estado.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Gobierno, legislación y participación ciudadana',
    topic: 'Cortes Generales',
    correctAnswer: 'Están formadas por el Congreso y el Senado',
    distractors: [
      'Están formadas por el Gobierno y el Senado',
      'Están formadas por el Tribunal Supremo y el Congreso',
      'Están formadas por los ayuntamientos y las diputaciones',
    ],
    explanation:
        'Las Cortes Generales reúnen las dos cámaras legislativas del Estado.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Gobierno, legislación y participación ciudadana',
    topic: 'Tribunal Constitucional',
    correctAnswer: 'Controla que las normas respeten la Constitución',
    distractors: [
      'Gestiona las elecciones municipales',
      'Dirige la política exterior',
      'Aprueba los presupuestos del Estado',
    ],
    explanation:
        'El Tribunal Constitucional vela por la adecuación de las leyes a la Constitución.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Gobierno, legislación y participación ciudadana',
    topic: 'Consejo de Ministros',
    correctAnswer: 'Lo forman el presidente del Gobierno y los ministros',
    distractors: [
      'Lo forman solo los diputados del Congreso',
      'Lo forman los alcaldes de capitales de provincia',
      'Lo forman los jueces del Tribunal Constitucional',
    ],
    explanation:
        'El Consejo de Ministros integra al presidente y a los ministros del Gobierno.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Gobierno, legislación y participación ciudadana',
    topic: 'Elecciones generales',
    correctAnswer: 'Pueden votar las personas mayores de 18 años',
    distractors: [
      'Pueden votar las personas mayores de 16 años',
      'Pueden votar solo quienes trabajan',
      'Pueden votar solo quienes viven en capitales de provincia',
    ],
    explanation:
        'La edad mínima para votar en elecciones generales en España es de 18 años.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Gobierno, legislación y participación ciudadana',
    topic: 'Administración municipal',
    correctAnswer: 'La encabeza el alcalde o la alcaldesa',
    distractors: [
      'La encabeza el presidente del Senado',
      'La encabeza el delegado del Gobierno',
      'La encabeza el ministro del Interior',
    ],
    explanation:
        'El alcalde o alcaldesa preside el ayuntamiento y representa al municipio.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Gobierno, legislación y participación ciudadana',
    topic: 'Boletín Oficial del Estado',
    correctAnswer: 'Publica oficialmente leyes y disposiciones estatales',
    distractors: [
      'Inscribe nacimientos, matrimonios y defunciones',
      'Convoca por sí mismo las elecciones generales',
      'Gestiona directamente la sanidad pública autonómica',
    ],
    explanation:
        'El BOE es el diario oficial en el que se publican normas y disposiciones estatales.',
    difficulty: 'media',
  ),
];

const List<_CcseFactSpec> _rightsExpansionSpecs = [
  _CcseFactSpec(
    task: 'Derechos y deberes fundamentales',
    topic: 'Igualdad ante la ley',
    correctAnswer:
        'Prohíbe la discriminación por razones como sexo, origen o religión',
    distractors: [
      'Permite aplicar leyes distintas a cada barrio',
      'Obliga a votar en todas las elecciones',
      'Sustituye el derecho a la educación',
    ],
    explanation:
        'La igualdad ante la ley protege frente a la discriminación y garantiza un trato jurídico igual.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Derechos y deberes fundamentales',
    topic: 'Libertad de expresión',
    correctAnswer:
        'Ampara la difusión de opiniones e información dentro de la ley',
    distractors: [
      'Permite sustituir a los tribunales',
      'Obliga a publicar datos privados',
      'Anula el derecho de reunión',
    ],
    explanation:
        'La libertad de expresión protege la posibilidad de comunicar opiniones e información respetando la ley.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Derechos y deberes fundamentales',
    topic: 'Derecho de reunión',
    correctAnswer:
        'Permite reunirse pacíficamente para expresar una posición o interés',
    distractors: [
      'Permite ocupar edificios públicos sin límites',
      'Sustituye al derecho al voto',
      'Se aplica solo a menores de edad',
    ],
    explanation:
        'La reunión pacífica es un derecho fundamental reconocido constitucionalmente.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Derechos y deberes fundamentales',
    topic: 'Educación',
    correctAnswer:
        'Favorece la formación personal y la igualdad de oportunidades',
    distractors: [
      'Sirve para eliminar los servicios públicos',
      'Se limita solo a la educación universitaria',
      'Depende exclusivamente de las empresas privadas',
    ],
    explanation:
        'El derecho a la educación contribuye a la formación y a la igualdad de oportunidades.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Derechos y deberes fundamentales',
    topic: 'Impuestos',
    correctAnswer: 'Ayudan a financiar servicios y gastos públicos',
    distractors: [
      'Se usan para elegir a los jueces',
      'Solo sirven para pagar fiestas locales',
      'Sustituyen al salario de las empresas privadas',
    ],
    explanation:
        'Los impuestos sostienen servicios y políticas públicas en un Estado social.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Derechos y deberes fundamentales',
    topic: 'Tutela judicial efectiva',
    correctAnswer:
        'Permite acudir a los tribunales para defender los propios derechos',
    distractors: [
      'Permite cambiar una ley por cuenta propia',
      'Permite votar dos veces en una misma elección',
      'Permite evitar cualquier sanción administrativa',
    ],
    explanation:
        'La tutela judicial efectiva garantiza el acceso a los tribunales para la defensa de derechos.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Derechos y deberes fundamentales',
    topic: 'Derecho de huelga',
    correctAnswer:
        'Permite defender intereses laborales mediante la suspensión colectiva del trabajo',
    distractors: [
      'Permite cerrar definitivamente una empresa',
      'Obliga a dejar el trabajo para siempre',
      'Sustituye la negociación colectiva',
    ],
    explanation:
        'La huelga es un derecho reconocido para la defensa de intereses laborales.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Derechos y deberes fundamentales',
    topic: 'Protección de datos personales',
    correctAnswer: 'Exige tratar la información privada con garantías legales',
    distractors: [
      'Permite publicar cualquier dato sin permiso',
      'Se aplica solo a datos bancarios',
      'Impide usar internet en oficinas públicas',
    ],
    explanation:
        'La normativa protege los datos personales y regula su tratamiento.',
    difficulty: 'media',
  ),
];

const List<_CcseFactSpec> _territoryExpansionSpecs = [
  _CcseFactSpec(
    task: 'Organización territorial de España. Geografía física y política',
    topic: 'Capital del Estado',
    correctAnswer: 'Es Madrid',
    distractors: ['Es Barcelona', 'Es Sevilla', 'Es Valencia'],
    explanation: 'Madrid es la capital del Estado español.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Organización territorial de España. Geografía física y política',
    topic: 'Comunidades autónomas',
    correctAnswer:
        'Son la base principal de la organización territorial descentralizada',
    distractors: [
      'Son solo divisiones electorales temporales',
      'Sustituyen a todos los municipios',
      'Dependen del Parlamento europeo para sus normas básicas',
    ],
    explanation:
        'Las comunidades autónomas son el principal nivel de descentralización política y administrativa.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Organización territorial de España. Geografía física y política',
    topic: 'Municipios',
    correctAnswer: 'Atienden la gestión más cercana de la vida local',
    distractors: [
      'Aprueban las leyes estatales',
      'Dirigen la política exterior',
      'Nombran a los magistrados del Tribunal Supremo',
    ],
    explanation:
        'El municipio es la entidad territorial básica y cercana a la ciudadanía.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Organización territorial de España. Geografía física y política',
    topic: 'Provincias',
    correctAnswer:
        'Agrupan municipios dentro de la organización territorial española',
    distractors: [
      'Agrupan únicamente comunidades autónomas',
      'Sustituyen a los barrios de las ciudades grandes',
      'Funcionan solo durante las elecciones generales',
    ],
    explanation:
        'La provincia es una división territorial que agrupa municipios.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Organización territorial de España. Geografía física y política',
    topic: 'Ceuta y Melilla',
    correctAnswer:
        'Son ciudades autónomas españolas situadas en el norte de África',
    distractors: [
      'Son provincias portuguesas',
      'Son comunidades autónomas insulares',
      'Son capitales de provincia andaluzas',
    ],
    explanation:
        'Ceuta y Melilla son ciudades autónomas españolas localizadas en el norte de África.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Organización territorial de España. Geografía física y política',
    topic: 'Islas Canarias',
    correctAnswer: 'Forman un archipiélago en el océano Atlántico',
    distractors: [
      'Forman un archipiélago en el mar Cantábrico',
      'Pertenecen a las Islas Baleares',
      'Se encuentran en la frontera con Francia',
    ],
    explanation: 'Las Islas Canarias están situadas en el Atlántico.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Organización territorial de España. Geografía física y política',
    topic: 'Cabildos insulares',
    correctAnswer:
        'Son instituciones de gobierno propias de las islas Canarias',
    distractors: [
      'Son instituciones exclusivas de las provincias peninsulares',
      'Son cámaras del Parlamento estatal',
      'Son tribunales especializados en materia electoral',
    ],
    explanation:
        'Los cabildos insulares ejercen funciones de gobierno en las islas Canarias.',
    difficulty: 'alta',
  ),
  _CcseFactSpec(
    task: 'Organización territorial de España. Geografía física y política',
    topic: 'Consejos insulares',
    correctAnswer: 'Desempeñan funciones de gobierno en las islas Baleares',
    distractors: [
      'Desempeñan funciones diplomáticas en el extranjero',
      'Sustituyen a los ayuntamientos de Madrid',
      'Gestionan exclusivamente el Congreso de los Diputados',
    ],
    explanation:
        'Los consejos insulares forman parte de la organización institucional balear.',
    difficulty: 'alta',
  ),
];

const List<_CcseFactSpec> _cultureExpansionSpecs = [
  _CcseFactSpec(
    task: 'Cultura e historia de España',
    topic: 'Miguel de Cervantes',
    correctAnswer: 'Es el autor de Don Quijote de la Mancha',
    distractors: [
      'Es el autor de La Regenta',
      'Es el arquitecto de la Sagrada Familia',
      'Es el pintor de Las Meninas',
    ],
    explanation:
        'Miguel de Cervantes es una figura central de la literatura española y autor de Don Quijote.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Cultura e historia de España',
    topic: 'Pablo Picasso',
    correctAnswer: 'Es conocido, entre otras obras, por Guernica',
    distractors: [
      'Es conocido por escribir el himno nacional',
      'Es conocido por fundar el Museo del Prado',
      'Es conocido por dirigir la Constitución de 1978',
    ],
    explanation:
        'Pablo Picasso es uno de los artistas españoles más reconocidos internacionalmente y Guernica es una de sus obras emblemáticas.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Cultura e historia de España',
    topic: 'La Alhambra',
    correctAnswer: 'Se encuentra en Granada',
    distractors: [
      'Se encuentra en Córdoba',
      'Se encuentra en Sevilla',
      'Se encuentra en Toledo',
    ],
    explanation:
        'La Alhambra está en Granada y es uno de los conjuntos monumentales más conocidos de España.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Cultura e historia de España',
    topic: 'Museo del Prado',
    correctAnswer: 'Está en Madrid',
    distractors: ['Está en Valencia', 'Está en Málaga', 'Está en Santander'],
    explanation:
        'El Museo del Prado se encuentra en Madrid y es una institución cultural de referencia.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Cultura e historia de España',
    topic: 'Fiesta Nacional de España',
    correctAnswer: 'Se celebra el 12 de octubre',
    distractors: [
      'Se celebra el 6 de diciembre',
      'Se celebra el 2 de mayo',
      'Se celebra el 1 de enero',
    ],
    explanation: 'La Fiesta Nacional de España se celebra el 12 de octubre.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Cultura e historia de España',
    topic: 'Camino de Santiago',
    correctAnswer:
        'Es una ruta histórica de peregrinación con gran importancia cultural',
    distractors: [
      'Es una línea de tren de alta velocidad',
      'Es una red exclusiva de museos estatales',
      'Es un sistema de carreteras autonómicas',
    ],
    explanation:
        'El Camino de Santiago es una ruta histórica y cultural de gran relevancia en España.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Cultura e historia de España',
    topic: 'Flamenco',
    correctAnswer:
        'Es una manifestación cultural asociada especialmente al sur de España',
    distractors: [
      'Es una lengua cooficial del norte de España',
      'Es un órgano del poder legislativo',
      'Es un tipo de impuesto municipal',
    ],
    explanation:
        'El flamenco es una manifestación cultural muy vinculada a España, especialmente a Andalucía.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Cultura e historia de España',
    topic: 'Sagrada Familia',
    correctAnswer: 'Es un templo emblemático situado en Barcelona',
    distractors: [
      'Es un palacio real situado en Madrid',
      'Es un monasterio situado en Toledo',
      'Es una universidad histórica situada en Salamanca',
    ],
    explanation:
        'La Sagrada Familia es uno de los monumentos más conocidos de Barcelona.',
    difficulty: 'media',
  ),
];

const List<_CcseFactSpec> _societyExpansionSpecs = [
  _CcseFactSpec(
    task: 'Sociedad española',
    topic: 'Tarjeta sanitaria',
    correctAnswer: 'Facilita el acceso a la atención sanitaria pública',
    distractors: [
      'Sirve para votar en elecciones generales',
      'Sustituye al permiso de conducir',
      'Permite matricular un vehículo',
    ],
    explanation:
        'La tarjeta sanitaria se utiliza habitualmente para acceder a servicios sanitarios públicos.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Sociedad española',
    topic: 'Cita previa',
    correctAnswer:
        'Permite organizar la atención en muchas oficinas y servicios',
    distractors: [
      'Sustituye al empadronamiento en el municipio',
      'Es un documento para autorizar viajes al extranjero',
      'Se usa únicamente en clínicas privadas',
    ],
    explanation:
        'La cita previa es habitual en trámites administrativos y en muchos servicios públicos.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Sociedad española',
    topic: 'Teléfono 112',
    correctAnswer: 'Es el número general de emergencias',
    distractors: [
      'Es el número para pedir cita en el ayuntamiento',
      'Es el número exclusivo de Correos',
      'Es el número para renovar el DNI',
    ],
    explanation: 'El 112 centraliza la atención de emergencias en España.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Sociedad española',
    topic: 'Padrón municipal',
    correctAnswer: 'Registra a las personas que residen en un municipio',
    distractors: [
      'Sustituye al Registro Civil',
      'Se usa para declarar impuestos estatales',
      'Sirve para pedir plaza universitaria',
    ],
    explanation:
        'El padrón municipal recoge la residencia habitual en un municipio.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Sociedad española',
    topic: 'Reciclaje de papel y cartón',
    correctAnswer: 'Se deposita habitualmente en el contenedor azul',
    distractors: [
      'Se deposita habitualmente en el contenedor amarillo',
      'Se deposita habitualmente en el contenedor verde',
      'Se deposita habitualmente en el contenedor marrón',
    ],
    explanation: 'El contenedor azul se usa normalmente para papel y cartón.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Sociedad española',
    topic: 'Escolarización obligatoria',
    correctAnswer: 'Se extiende hasta los 16 años',
    distractors: [
      'Se extiende hasta los 12 años',
      'Se extiende hasta los 14 años',
      'Se extiende hasta los 18 años en todos los casos',
    ],
    explanation: 'La enseñanza básica es obligatoria hasta los 16 años.',
    difficulty: 'media',
  ),
  _CcseFactSpec(
    task: 'Sociedad española',
    topic: 'Convivencia vecinal',
    correctAnswer:
        'Mejora cuando se respetan normas comunes y horarios de descanso',
    distractors: [
      'Mejora evitando toda comunicación con los vecinos',
      'Mejora ignorando las normas del edificio',
      'Mejora usando las zonas comunes sin cuidado',
    ],
    explanation:
        'La convivencia se favorece con respeto mutuo y atención a las normas comunes.',
    difficulty: 'fácil',
  ),
  _CcseFactSpec(
    task: 'Sociedad española',
    topic: 'Participación social',
    correctAnswer:
        'Puede realizarse mediante asociaciones, voluntariado y colaboración vecinal',
    distractors: [
      'Solo puede realizarse por medio de partidos políticos',
      'Solo puede realizarse en campañas electorales',
      'No forma parte de la vida cotidiana en democracia',
    ],
    explanation:
        'La participación social incluye asociaciones, voluntariado y otros cauces de colaboración ciudadana.',
    difficulty: 'media',
  ),
];
