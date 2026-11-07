# Pruebas del vídeo: prompts para copiar

Estos son los textos utilizados en las grabaciones. Abre una conversación nueva para cada prueba de texto, salvo la corrección de la aplicación: envíala en la misma conversación donde se generó el código. Las respuestas pueden cambiar entre ejecuciones.

## Elegir una tarifa eléctrica · Qwen

```text
Tengo que elegir entre dos tarifas eléctricas:
- Tarifa A: 0,18 € por kWh + 6 € fijos al mes.
- Tarifa B: 0,13 € por kWh + 16 € fijos al mes.
Mi consumo mensual es de 240 kWh.
Calcula cuánto pagaría con cada tarifa, cuál me conviene y cuánto ahorraría.
Después, encuentra el consumo exacto a partir del cual resulta más barata la tarifa B.
Explícamelo de forma sencilla, sin tecnicismos y sin incluir impuestos.
```

## Comparar descuentos · Qwen y MiMo

```text
Una tienda vende tres productos:
- Producto A: cuesta 35 € y tiene un descuento del 20 %.
- Producto B: cuesta 48 € y tiene un descuento del 15 %.
- Producto C: cuesta 25 € y no tiene descuento.
Tengo un presupuesto máximo de 75 €.
Si compro dos productos diferentes, recibo un descuento adicional del 10 % sobre el total ya rebajado.
Quiero comprar exactamente dos productos distintos, gastar como máximo 75 € y llevarme la combinación cuyo precio original total sea el más alto.
¿Qué productos debería comprar? Calcula las tres combinaciones, aplica los descuentos en el orden correcto y explica tu decisión.
```

## Crear una aplicación de tareas · MiMo

```text
Crea una aplicación web completa en un único archivo HTML, con CSS y JavaScript incluidos, para gestionar una lista de tareas.
Requisitos:
- Añadir tareas nuevas.
- Marcar tareas como completadas.
- Eliminar tareas.
- Filtrar entre todas, pendientes y completadas.
- Guardar automáticamente las tareas en localStorage para que no desaparezcan al recargar la página.
- Diseño moderno, oscuro y adaptable a móviles.
Devuélveme el código completo, listo para guardar como index.html y abrir directamente en el navegador, sin instalar dependencias.
```

## Corregir la aplicación · MiMo

```text
He probado la aplicación y tiene errores.
Puedo añadir tareas, pero los botones para marcarlas como completadas y eliminarlas no funcionan.
Revisa tu código anterior, identifica la causa y corrige los errores. Comprueba también que los filtros y el almacenamiento local funcionen correctamente.
Devuélveme el archivo HTML completo corregido, sin eliminar ninguna funcionalidad ni cambiar innecesariamente el diseño.
```

## Generar el velero · FLUX

```text
A small red sailboat on a calm blue lake, mountains in the background, soft morning light, photograph.
```

## Generar el vídeo · Wan: positivo

```text
A small red sailboat gently moving on a calm blue lake, mountains in the background, steady camera, soft morning light.
```

## Generar el vídeo · Wan: negativo

```text
blurry, low quality, distorted, text, watermark, still image
```

## Comprueba el resultado

- Tarifas: A cuesta 49,20 € y B cuesta 47,20 €. Se igualan con 200 kWh; por encima sale mejor B.
- Descuentos: A+B cuesta 61,92 €, A+C cuesta 47,70 € y B+C cuesta 59,22 €. La respuesta pedida es A+B: su precio original es el mayor y su precio final cabe en el presupuesto.
- Aplicación: guarda el código como `index.html` y ábrelo con doble clic. Añade tareas, márcalas, desmárcalas, elimínalas y prueba los tres filtros. Recarga la página para comprobar que conserva los cambios. Una afirmación del modelo no sustituye estas pruebas.
- Imagen: busca el velero rojo, el lago azul y las montañas.
- Vídeo: comprueba también el movimiento y la estabilidad. En la demostración se configuraron 17 fotogramas a 16 FPS, aproximadamente un segundo, con resultados visuales limitados.
