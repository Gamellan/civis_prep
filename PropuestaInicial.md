Quiero que construyas desde cero una aplicación móvil profesional para Android (y preparada para portar a iOS en el futuro) que ayude a extranjeros a preparar los dos exámenes necesarios para obtener la nacionalidad española por residencia: el **CCSE** (Conocimientos Constitucionales y Socioculturales de España) y el **DELE A2** (idioma español). A continuación tienes todos los requisitos del proyecto.

### 1. Alcance del contenido

- La app debe cubrir **ambos exámenes**, con secciones claramente diferenciadas.
- **CCSE**: banco de preguntas organizado en las 5 tareas oficiales:
  1. Gobierno, legislación y participación ciudadana
  2. Derechos y deberes fundamentales
  3. Organización territorial de España. Geografía física y política
  4. Cultura e historia de España
  5. Sociedad española
- **DELE A2**: material de práctica para las 4 pruebas oficiales (comprensión de lectura, expresión e interacción escritas, comprensión auditiva, expresión e interacción orales). Ten en cuenta que la prueba auditiva requiere audio; como no se ha priorizado una funcionalidad de audio en esta primera versión, propón cómo abordarlo (por ejemplo: transcripciones escritas con la funcionalidad de audio marcada como mejora futura, o una versión simplificada basada en texto) y coméntalo conmigo antes de descartarlo del todo.

### 2. Origen y generación del banco de preguntas

- Usa como base el contenido público que publica el Instituto Cervantes (Manual de preparación CCSE, especificaciones y modelos de examen DELE A2), pero **parafraseando siempre las preguntas y explicaciones con tus propias palabras** — no reproduzcas el texto original literalmente.
- Complementa ese banco con **preguntas originales creadas por ti**, inspiradas en los mismos temas oficiales, para ampliar la variedad y evitar depender solo de las 300 preguntas oficiales del CCSE.
- **Cita siempre la fuente oficial** (Instituto Cervantes) en los créditos/ajustes de la app, y deja claro en la propia app que no es una aplicación oficial ni está afiliada al Instituto Cervantes.
- Estructura cada pregunta con, al menos: id, examen (CCSE/DELE), tarea/tema, enunciado, opciones de respuesta, respuesta correcta, explicación breve, nivel de dificultad.

### 3. Idiomas

- Interfaz completa (menús, botones, instrucciones, explicaciones de la app) disponible en **español, inglés, francés y portugués**.
- Las preguntas del examen deben mostrarse **siempre en español**, igual que en el examen oficial real (así el usuario practica en las condiciones reales), aunque el resto de la experiencia esté traducida.

### 4. Funcionalidades requeridas

- Banco de preguntas navegable por tema/tarea.
- **Simulacro de examen cronometrado** que replique las condiciones reales (25 preguntas / 45 minutos para el CCSE; estructura equivalente para el DELE A2).
- **Tarjetas de repaso (flashcards)** para memorizar datos clave (fechas, instituciones, cifras, vocabulario, etc.).
- **Modo sin conexión (offline)**: toda la app debe funcionar sin necesidad de internet una vez descargada, salvo la carga de anuncios.
- **Notificaciones de estudio diario** configurables por el usuario (recordatorios tipo "racha de estudio").
- Seguimiento de progreso: preguntas dominadas, fallos recurrentes, porcentaje de acierto por tema.
- No se requiere sistema de cuentas/login ni sincronización en la nube en esta primera versión.

### 5. Monetización

- App **gratuita con anuncios** (banner + intersticial, por ejemplo vía Google AdMob).
- Los anuncios deben ser poco intrusivos: nunca durante un simulacro de examen en curso, solo entre pantallas o al finalizar sesiones.

### 6. Enfoque técnico

- Desarrollo **multiplataforma con Flutter** (o React Native si justificas que aporta ventajas claras), pensando en Android como prioridad y dejando la puerta abierta a iOS.
- Persistencia de datos local (SQLite, Hive o similar) ya que no hay backend ni presupuesto para servicios de pago.
- Arquitectura simple y mantenible, ya que el desarrollo lo llevará una sola persona apoyándose en IA, sin equipo técnico.
- No hay plazo de lanzamiento fijado: prioriza una base de código sólida y bien documentada sobre la velocidad de entrega.

### 7. Estilo visual

- Diseño **profesional, serio e institucional**, transmitiendo confianza y seriedad (algo cercano a la estética de un organismo oficial, pero con una interfaz moderna y cuidada, no anticuada).
- Colores y tipografía sobrios; evita un aspecto "app de juego casual".

### 8. Nombre de la app

- Propón tú un nombre para la app. Debe:
  - Sonar profesional y transmitir confianza.
  - Reflejar claramente que ayuda a preparar el examen de nacionalidad española.
  - Funcionar razonablemente bien en español, inglés, francés y portugués (evita palabras que suenen mal o signifiquen otra cosa en alguno de esos idiomas).
  - Ser corto y fácil de recordar/buscar en Google Play.
- Propón 3-5 alternativas con una breve justificación de cada una.

### 9. Qué espero que entregues primero

Antes de escribir código, dame:
1. Una arquitectura general de la app (pantallas principales y navegación).
2. El modelo de datos (esquema de la base de datos local).
3. Una muestra representativa del banco de preguntas (10-15 preguntas de distintos temas, ya parafraseadas y con su explicación) para validar el tono y el formato antes de generar el resto.
4. Las 3-5 propuestas de nombre de la app.
5. Un plan de desarrollo por fases (MVP primero: CCSE completo + simulacro + flashcards; después DELE A2; después notificaciones y refinamientos).

## 10. Propuesta inicial de solución

### 10.1. Arquitectura general de la app

La propuesta se construirá con Flutter como base principal porque ofrece una ruta de desarrollo rápida, buen rendimiento en Android y una evolución razonable hacia iOS sin reescribir la lógica de negocio. La arquitectura será simple, modular y fácil de mantener por una sola persona.

#### Capas de la app
- Capa de presentación: pantallas, widgets reutilizables, navegación y estados de UI.
- Capa de dominio: reglas de negocio simples, como selección de preguntas, generación de simulacros, lógica de repaso y cálculo de progreso.
- Capa de datos: repositorios locales sobre SQLite, con semillas de contenido inicial y almacenamiento de sesiones de estudio.
- Capa de servicios: notificaciones locales, configuración del usuario, gestión de anuncios y recursos de idioma.

#### Pantallas principales y navegación
1. Pantalla de inicio
   - Acceso rápido a CCSE, DELE A2, simulacros, flashcards y progreso.
2. Selección de examen
   - Elección entre CCSE y DELE A2.
3. Banco de preguntas
   - Navegación por tarea/tema, filtrado por dificultad y búsqueda simple.
4. Práctica guiada
   - Modo de estudio con preguntas individuales, feedback inmediato y explicación.
5. Simulacro de examen
   - Modo cronometrado con límites reales de tiempo y número de preguntas.
6. Flashcards
   - Revisión de conceptos clave con sistema básico de repetición.
7. Progreso
   - Estadísticas por tema, porcentaje de acierto y preguntas dominadas.
8. Ajustes
   - Idioma de la interfaz, notificaciones, frecuencia de estudio y preferencia de anuncios.
9. Créditos y fuentes
   - Información sobre la app, fuente oficial del contenido y aclaración de que no es una app oficial del Instituto Cervantes.

#### Flujo de navegación recomendado
- Inicio → Selección de examen → Banco de preguntas o Simulacro → Resultado → Progreso → Revisión con flashcards.

### 10.2. Modelo de datos local

Se recomienda usar SQLite con una capa de acceso simple y estable. El esquema debe ser suficientemente flexible para crecer sin reescribir toda la estructura.

#### Tablas propuestas
- questions
  - id: texto o entero
  - exam: CCSE o DELE
  - topic: tarea o tema
  - difficulty: fácil / medio / difícil
  - statement: enunciado de la pregunta
  - explanation: explicación breve
  - source: referencia oficial o original
  - is_active: booleano
- question_options
  - id
  - question_id
  - text
  - is_correct
  - order_index
- study_sessions
  - id
  - exam
  - session_type: practice / mock
  - started_at
  - finished_at
  - duration_seconds
  - total_questions
  - correct_answers
  - score_percent
  - status: completed / abandoned / timed_out
- answers
  - id
  - session_id
  - question_id
  - selected_option_id
  - is_correct
  - answered_at
- flashcards
  - id
  - front_text
  - back_text
  - category
  - difficulty
  - last_reviewed_at
  - next_review_at
  - mastery_score
- progress_stats
  - id
  - topic
  - exam
  - questions_seen
  - correct_answers
  - incorrect_answers
  - mastered
  - last_practiced_at
- user_settings
  - id
  - locale
  - daily_reminder_enabled
  - reminder_time
  - study_goal_daily
  - mock_timer_enabled

#### Relación entre tablas
- Una pregunta tiene varias opciones.
- Una sesión de estudio contiene muchas respuestas.
- Cada respuesta apunta a una pregunta y a una sesión.
- Los flashcards son independientes de las preguntas, pero pueden alinearse por tema.

### 10.3. Muestra representativa del banco de preguntas

A continuación se muestran 12 preguntas de ejemplo, ya parafraseadas y con un formato cercano al que se usará en la app. Se han mezclado temas de CCSE y DELE para validar el tono y la estructura.

#### Ejemplos CCSE

1. ID: CCSE-001
   - Examen: CCSE
   - Tarea: Gobierno, legislación y participación ciudadana
   - Enunciado: ¿Cuál de las siguientes opciones describe mejor el papel del Parlamento en un Estado democrático?
   - Opciones:
     - A. Aprobar leyes y controlar la acción del Gobierno.
     - B. Nombrar a todos los jueces del país.
     - C. Dirigir directamente la política exterior.
     - D. Sustituir al Gobierno en todas sus funciones.
   - Respuesta correcta: A
   - Explicación: El Parlamento es la institución encargada de representar a la ciudadanía y de controlar, con funciones legislativas y de fiscalización, la acción del Gobierno.
   - Dificultad: media

2. ID: CCSE-002
   - Examen: CCSE
   - Tarea: Derechos y deberes fundamentales
   - Enunciado: ¿Cuál de estos derechos está reconocido como fundamento de la vida democrática en España?
   - Opciones:
     - A. Libertad de expresión.
     - B. Derecho a la esclavitud.
     - C. Privilegio hereditario de clase.
     - D. Exención automática del cumplimiento de la ley.
   - Respuesta correcta: A
   - Explicación: La libertad de expresión es un derecho fundamental que permite la participación política y el debate público.
   - Dificultad: fácil

3. ID: CCSE-003
   - Examen: CCSE
   - Tarea: Organización territorial de España. Geografía física y política
   - Enunciado: ¿Cuál es la unidad territorial básica de la organización administrativa española?
   - Opciones:
     - A. La provincia.
     - B. El municipio.
     - C. La región autónoma.
     - D. La comarca.
   - Respuesta correcta: B
   - Explicación: El municipio es la entidad local básica en la organización territorial española.
   - Dificultad: fácil

4. ID: CCSE-004
   - Examen: CCSE
   - Tarea: Cultura e historia de España
   - Enunciado: ¿Qué periodo histórico se asocia tradicionalmente con la Constitución de 1978?
   - Opciones:
     - A. La Transición democrática.
     - B. La Guerra de la Independencia.
     - C. La Edad Media.
     - D. La Restauración borbónica.
   - Respuesta correcta: A
   - Explicación: La Constitución de 1978 fue aprobada en el contexto de la Transición democrática, que abrió un nuevo sistema político en España.
   - Dificultad: media

5. ID: CCSE-005
   - Examen: CCSE
   - Tarea: Sociedad española
   - Enunciado: ¿Qué fenómeno describe mejor la diversidad cultural presente en España?
   - Opciones:
     - A. La coexistencia de diferentes lenguas y tradiciones regionales.
     - B. La uniformidad absoluta del idioma.
     - C. La desaparición de las comunidades autónomas.
     - D. El cierre total de fronteras culturales.
   - Respuesta correcta: A
   - Explicación: España es un país plural, con una rica variedad de lenguas, cultura y tradiciones regionales.
   - Dificultad: fácil

#### Ejemplos DELE A2

6. ID: DELE-001
   - Examen: DELE
   - Tarea: Comprensión de lectura
   - Enunciado: Lee el siguiente mensaje: “Mañana voy a la biblioteca para devolver un libro y buscar otro.” ¿Qué quiere decir el mensaje?
   - Opciones:
     - A. Va a comprar un libro.
     - B. Va a devolver un libro y coger otro.
     - C. Va a trabajar en la biblioteca.
     - D. Va a visitar a un amigo.
   - Respuesta correcta: B
   - Explicación: El mensaje indica que la persona va a devolver un libro y escoger otro para leer.
   - Dificultad: fácil

7. ID: DELE-002
   - Examen: DELE
   - Tarea: Expresión e interacción escritas
   - Enunciado: Completa la frase: “Hoy yo ___ a la farmacia porque necesito medicinas.”
   - Opciones:
     - A. voy
     - B. vas
     - C. va
     - D. vamos
   - Respuesta correcta: A
   - Explicación: La forma correcta es “voy” porque el sujeto es “yo”.
   - Dificultad: fácil

8. ID: DELE-003
   - Examen: DELE
   - Tarea: Comprensión auditiva
   - Enunciado: En la versión inicial de la app, la práctica auditiva se mostrará mediante una transcripción breve y una pregunta de comprensión. ¿Cuál es la mejor forma de abordar esta limitación?
   - Opciones:
     - A. Descartar la prueba auditiva por completo.
     - B. Incluir transcripciones y dejar el audio como mejora futura.
     - C. Mostrar solo imágenes.
     - D. Redirigir al usuario a otra app.
   - Respuesta correcta: B
   - Explicación: Esta opción permite practicar la comprensión oral de forma útil sin bloquear el desarrollo de la app en la primera versión.
   - Dificultad: media

9. ID: DELE-004
   - Examen: DELE
   - Tarea: Expresión e interacción orales
   - Enunciado: ¿Qué opción es la más adecuada para responder a la frase “¿Qué te gusta hacer los fines de semana?”
   - Opciones:
     - A. “Me gusta salir con mis amigos.”
     - B. “Mi casa es grande.”
     - C. “Tengo dos hermanas.”
     - D. “Hoy hace frío.”
   - Respuesta correcta: A
   - Explicación: La respuesta muestra una respuesta natural y sencilla a una pregunta sobre hábitos personales.
   - Dificultad: fácil

10. ID: DELE-005
   - Examen: DELE
   - Tarea: Comprensión de lectura
   - Enunciado: ¿Qué significa “tener prisa” en un contexto cotidiano?
   - Opciones:
     - A. Estar en un lugar bonito.
     - B. Tener mucha urgencia.
     - C. Dormir poco.
     - D. Tener hambre.
   - Respuesta correcta: B
   - Explicación: “Tener prisa” significa tener poco tiempo y necesidad de actuar rápido.
   - Dificultad: fácil

11. ID: DELE-006
   - Examen: DELE
   - Tarea: Expresión e interacción escritas
   - Enunciado: Elige la opción correcta: “___ sábado voy al mercado con mi madre.”
   - Opciones:
     - A. El
     - B. La
     - C. Los
     - D. Las
   - Respuesta correcta: A
   - Explicación: “El sábado” es la forma correcta para referirse a un día concreto.
   - Dificultad: media

12. ID: DELE-007
   - Examen: DELE
   - Tarea: Comprensión auditiva
   - Enunciado: En la propuesta de MVP, ¿qué se prioriza para la prueba auditiva?
   - Opciones:
     - A. Reproducir audio de alta calidad desde el primer día.
     - B. Crear una versión simplificada basada en texto y transcripción.
     - C. Eliminar por completo esa parte del contenido.
     - D. Reemplazarla por preguntas de gramática.
   - Respuesta correcta: B
   - Explicación: El enfoque inicial debe ser viable, útil y escalable, por lo que una versión basada en texto es la mejor alternativa para la primera entrega.
   - Dificultad: media

### 10.4. Propuestas de nombre de la app

1. CivisPrep
   - Justificación: suena profesional, recuerda a “civismo” y preparación, y es corto y fácil de recordar.
2. Nacionalidad Prep
   - Justificación: comunica claramente el objetivo de preparación para la nacionalidad y es muy directo.
3. PrepEspaña
   - Justificación: simple, claro y fácil de buscar; transmite la relación con el proceso de preparación en España.
4. CivisAula
   - Justificación: transmite un ambiente serio y formativo, muy adecuado para una app de estudio institucional.
5. SpainCivis
   - Justificación: combina el contexto español con un tono estable y profesional.

#### Recomendación
- La opción más sólida para esta propuesta es CivisPrep, porque equilibra profesionalidad, claridad y facilidad de branding.

### 10.5. Plan de desarrollo por fases

#### Fase 1 — MVP inicial
- Crear la estructura base de Flutter.
- Implementar navegación principal y diseño visual institucional.
- Desarrollar el banco de preguntas de CCSE con al menos 100 preguntas iniciales.
- Implementar práctica por tema y simulacro cronometrado de 25 preguntas.
- Crear flashcards básicas y seguimiento de progreso simple.

#### Fase 2 — Expansión del contenido
- Añadir DELE A2 con contenido de práctica en formato texto.
- Implementar la ruta de simulacro equivalente para DELE.
- Añadir sistema de repetición de flashcards y mejora de estadísticas.
- Preparar la base para incorporar audio en una fase posterior.

#### Fase 3 — Refinamiento y viabilidad de lanzamiento
- Añadir notificaciones diarias configurables.
- Integrar anuncios con criterio de no intrusión.
- Mejorar la experiencia offline y la estabilidad general.
- Preparar contenidos adicionales, traducciones y ajustes de accesibilidad.

#### Fase 4 — Mejora futura
- Incorporar audio real para la prueba auditiva de DELE.
- Añadir más contenido adaptado a los cambios del examen.
- Explorar una versión iOS si el producto demuestra aceptación.

### 10.6. Recomendación adicional sobre DELE A2

Para la primera versión, la mejor estrategia es incluir una experiencia de comprensión auditiva basada en transcripción y ejercicios de selección múltiple, dejando la reproducción de audio real como mejora futura. Esto permite entregar una app útil y completa sin bloquear el proyecto por una funcionalidad que no es prioritaria en esta fase.

Con esta base, el siguiente paso lógico es convertir esta propuesta en un plan técnico más detallado: estructura de carpetas, stack de dependencias, flujo de datos y primer conjunto de pantallas de alto nivel.