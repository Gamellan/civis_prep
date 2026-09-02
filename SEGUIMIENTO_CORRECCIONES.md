# Seguimiento de correcciones y mejoras

## Objetivo
Registrar las incidencias detectadas en la prueba funcional y priorizar la corrección en el orden óptimo para dejar la app lista para uso.

## Estado general
- Versión de trabajo: 2026-09-01
- Alcance: app móvil Flutter para preparación CCSE + DELE A2
- Nota: se mantiene fuera de alcance la funcionalidad de notificaciones para esta etapa, salvo lo que sea necesario para compilación o soporte base.

## Incidencias detectadas y prioridad

### 1. Simulacro rápido: volver al menú principal tras finalizar
- Estado: En trabajo
- Problema: al cerrar el detalle del resultado del simulacro rápido, la vista no vuelve al flujo principal; además la navegación de retorno queda bloqueada tras terminar la prueba.
- Acción: cerrar la pantalla del simulacro tras la revisión final y asegurar un retorno consistente al menú.

### 2. Sección “Temas y tareas” de CCSE
- Estado: Corregido
- Problema: la opción solo muestra un listado fijo y no aporta valor real en la experiencia actual.
- Acción: se ha retirado la pantalla estática mientras no exista una experiencia útil basada en el banco real.

### 3. DELE: botón Siguiente activa validación incorrecta
- Estado: Corregido parcialmente
- Problema: la validación se está haciendo sobre todas las preguntas en lugar de sólo la pregunta actual, por lo que se bloquea el avance aunque solo se esté viendo una pregunta.
- Acción: validar únicamente la respuesta actual cuando el usuario avanza; validar el conjunto completo solo al finalizar la práctica.

### 4. Idioma por defecto del dispositivo
- Estado: En trabajo
- Problema: la app usa un idioma por defecto fijo en vez de seguir el idioma del sistema.
- Acción: detectar el idioma del teléfono al iniciar, respetando la lista soportada; usar inglés como fallback si no existe coincidencia; conservar la selección manual dentro de la app.

### 5. Traducciones pendientes en la UI
- Estado: En trabajo
- Problema: aún hay textos hardcodeados en español en pantallas principales.
- Acción: revisar la interfaz principal y traducir los textos visibles, excluyendo solo las preguntas y respuestas del contenido académico.

### 6. Audio de DELE / comprensión auditiva
- Estado: En trabajo
- Problema: la app no tiene audio real implementado aún.
- Acción: dejar una nota clara en la pantalla para informar de que se trabaja con contexto textual y, si procede, reforzar la práctica con un hablante nativo.

## Registro de cambios por iteración

### Iteración 1
- Corregida la validación de `Siguiente` en la práctica DELE.
- Ajustado el flujo de retorno del simulacro tras entregar y cerrar el detalle de resultados.
- Añadido documento de seguimiento al proyecto.

### Iteración 2
- Comprobación de idioma por defecto del sistema.
- Revisión de pantallas principales y traducciones visibles.
- Ocultación/retirada de la opción de temas sin valor.
- Nota explicativa para la parte de audio DELE.

### Iteración 3
- Reorganización del banco CCSE en archivos de datos dedicados.
- Recuperación del bloque curado `ccse-204` a `ccse-224`.
- Retirada de la pantalla estática de tareas de CCSE y refuerzo de tests editoriales del banco.

## Criterio de cierre
La incidencia estará cerrada cuando:
- el flujo de simulacro finaliza y retorna al menú principal,
- la práctica DELE permite avanzar pregunta a pregunta,
- el idioma inicial coincide con el del dispositivo cuando es compatible,
- la UI principal queda traducida de forma consistente,
- la experiencia de audio queda claramente indicada como texto/guía temporal.
