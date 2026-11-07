# IA local con 8 GB de VRAM: chat, imágenes y vídeo

En este tutorial vamos a conversar con Qwen y MiMo, crear la imagen de un velero con FLUX y probar la generación de vídeo con Wan. Todo desde Windows, con interfaces gráficas y sin pagar una API para estas generaciones.

El vídeo muestra lo que conseguimos en un portátil concreto. FLUX produjo una imagen aprovechable; Wan generó clips de aproximadamente un segundo, con resultados visuales bastante limitados. Los modelos de texto también se equivocaron: conviene comprobar sus respuestas.

## Antes de empezar

El equipo de las pruebas es un **Gigabyte A16**, con una **RTX 5060 Laptop de 8 GB**, Intel Core i7-13620H, **32 GB de RAM**, SSD de 1 TB y Windows. Es nuestra referencia comprobada; no hemos establecido un mínimo de RAM o una garantía para cualquier tarjeta de 8 GB. El SSD de 1 TB describe el equipo, no el espacio que necesitas reservar.

Necesitas conexión para descargar los programas y los modelos. Después, las generaciones de este tutorial se ejecutan en tu equipo. Descarga solo la parte que quieras probar: los archivos de imágenes y vídeo ocupan varios gigabytes cada uno.

**Ejecuta una herramienta cada vez.** Apaga llama.cpp antes de abrir ComfyUI. Cerrar una pestaña del navegador no apaga el servidor ni libera necesariamente su memoria.

### Qué vas a utilizar

| Modelo | Para qué lo probamos | Programa |
| --- | --- | --- |
| Qwen3.5-9B Q4_K_M | Conversación y cuentas cotidianas | llama.cpp y su interfaz Llama UI |
| MiMo-V2.6-Distill-Qwen-9B Q4_K_M | Razonamiento y una aplicación HTML | llama.cpp y su interfaz Llama UI |
| FLUX.2 Klein 4B FP8 | Una imagen de un velero rojo | ComfyUI |
| Wan2.2 TI2V 5B | Un clip de un velero | ComfyUI |

## 1. Prepara la carpeta

1. En GitHub, pulsa el botón verde **Code → Download ZIP**. No necesitas instalar Git ni crear una cuenta para descargarlo.
2. Extrae el ZIP. No ejecutes los archivos desde dentro del archivo comprimido.
3. Coloca la carpeta en `C:\IA\IA-local-8GB`. Si el nombre termina en `-main`, puedes renombrarla como `IA-local-8GB`.

Los ejemplos usan esa ubicación para que sea fácil seguirlos. Los lanzadores también admiten otra carpeta, porque buscan los archivos a partir de su propia ubicación.

Dentro encontrarás esta guía, los [prompts de las pruebas](PROMPTS.md), `configuraciones` y `workflows`. Los modelos y los programas grandes se descargan por separado.

## 2. Qwen y MiMo: instala llama.cpp

### Descarga el programa

En el portátil se utilizó **llama.cpp b12144**, commit `69ee2ecc0`, con CUDA. La interfaz de conversación viene dentro de `llama-server.exe`: no hay que instalar otra aplicación llamada Llama UI.

1. Crea `C:\IA\IA-local-8GB\llama.cpp`.
2. Descarga [llama-b12144-bin-win-cuda-13.4-x64.zip](https://github.com/ggml-org/llama.cpp/releases/download/b12144/llama-b12144-bin-win-cuda-13.4-x64.zip).
3. Extrae **todo** su contenido en esa carpeta. Debes ver `C:\IA\IA-local-8GB\llama.cpp\llama-server.exe`, acompañado de sus DLL.
4. Descarga también [cudart-llama-bin-win-cuda-13.4-x64.zip](https://github.com/ggml-org/llama.cpp/releases/download/b12144/cudart-llama-bin-win-cuda-13.4-x64.zip) y extrae sus DLL en la misma carpeta. Es el paquete de bibliotecas CUDA; no hace falta instalar el kit de desarrollo CUDA completo para usar estos binarios.

Estos enlaces son para Windows de 64 bits y NVIDIA. No elijas los archivos ARM64, Ubuntu o Vulkan para seguir esta guía. Si necesitas revisar la descarga, esta es la [publicación oficial b12144](https://github.com/ggml-org/llama.cpp/releases/tag/b12144).

### Descarga los dos modelos

Crea `C:\IA\IA-local-8GB\modelos` y guarda allí:

| Archivo exacto | Descarga |
| --- | --- |
| `Qwen3.5-9B-Q4_K_M.gguf` | [Descargar Qwen, conversión de Unsloth](https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/resolve/main/Qwen3.5-9B-Q4_K_M.gguf?download=true) |
| `MiMo-V2.6-Distill-Qwen-9B-Q4_K_M.gguf` | [Descargar MiMo, conversión de bartowski](https://huggingface.co/bartowski/MiMo-V2.6-Distill-Qwen-9B-GGUF/resolve/main/MiMo-V2.6-Distill-Qwen-9B-Q4_K_M.gguf?download=true) |

GGUF es el formato que lee llama.cpp y Q4_K_M identifica la versión comprimida que vamos a usar. No descargues Q8, BF16 ni otra variante para estos perfiles. Para las pruebas de texto no necesitas un archivo `mmproj`.

En el portátil están esos nombres y esa cuantización. No se conservó la procedencia exacta de sus GGUF: los enlaces anteriores son descargas públicas comprobadas para repetir el tutorial, sin afirmar que sus archivos sean idénticos a los instalados durante la grabación.

### Abre el chat

1. Entra en `configuraciones` y haz doble clic en **LlamaCPP.bat**.
2. Se abrirá el navegador en [127.0.0.1:8080](http://127.0.0.1:8080). Deja abierta la ventana del lanzador.
3. Elige **Qwen3.5-9B-Q4_K_M** o **MiMo-V2.6-9B-Q4_K_M** en el desplegable de modelos. El primer mensaje puede tardar mientras se carga.
4. Escribe tu pregunta y envíala. Para comparar los dos, abre un chat nuevo con cada modelo y pega el mismo enunciado.
5. Al terminar, vuelve a la ventana del lanzador y pulsa **INTRO**. Así detienes el servidor que ha abierto.

El BAT abre PowerShell únicamente para ejecutar el lanzador incluido. No modifica la política de ejecución general de Windows ni descarga programas por su cuenta.

### Qué configuración lleva

El archivo [modelos.ini](configuraciones/modelos.ini) conserva los ajustes encontrados en el portátil: contexto de 32.768 tokens, una conversación simultánea, todas las capas solicitadas en GPU, Flash Attention y caché Q8 para claves y valores. El selector mantiene un solo modelo cargado a la vez.

No hemos añadido una temperatura ni otros valores de muestreo: los perfiles originales no los fijaban. Puedes consultar los ajustes de la interfaz, pero cambiar esos valores puede cambiar las respuestas. Un contexto de 32.768 indica la capacidad configurada; no demuestra que se haya probado una conversación de ese tamaño.

Los lanzadores compartidos están adaptados: usan carpetas relativas, comprueban que existen los archivos y generan temporalmente las rutas locales. No necesitas editar una ruta personal dentro del INI.

### Repite las pruebas del vídeo

Abre [PROMPTS.md](PROMPTS.md) y copia los enunciados de tarifas y descuentos. La respuesta correcta de las tarifas es **49,20 € para A y 47,20 € para B**. En los descuentos, la combinación pedida es **A+B, por 61,92 €**.

Para la aplicación, selecciona MiMo y pega el prompt de tareas. Copia el código en el Bloc de notas, pulsa **Guardar como**, selecciona **Todos los archivos** y escribe `index.html`. Ábrelo con doble clic en el navegador. Si se ha guardado como `index.html.txt`, activa **Ver → Mostrar → Extensiones de nombre de archivo** en el Explorador y corrige el nombre.

Prueba añadir, completar, desmarcar, eliminar y filtrar tareas. Recarga para comprobar que se conservan. Si falla, envía el prompt de reparación en la misma conversación. En la grabación la primera versión tenía botones inoperantes; la segunda demostró completar, desmarcar y filtrar. La eliminación y la persistencia tras recargar necesitan su propia comprobación.

## 3. Instala y abre ComfyUI

ComfyUI representa el proceso con cajas conectadas, llamadas **nodos**. Los JSON de `workflows` ya contienen esas conexiones: no tienes que dibujarlas a mano.

En el portátil se usó una instalación local de **ComfyUI 0.44.0**, commit `2c75dc1b379a59e0880619d029607af5169a62ef`, Python 3.12.14, PyTorch 2.14.1+cu130 y frontend 1.57.6. Para empezar desde cero proponemos el paquete oficial portable de esa versión, que lleva su propio Python. Su entorno no es una copia del instalado en el portátil y esta instalación desde cero no se ha ejecutado de extremo a extremo durante la preparación del repositorio.

1. Descarga [ComfyUI_windows_portable_nvidia.7z, versión 0.44.0](https://github.com/Comfy-Org/ComfyUI/releases/download/v0.44.0/ComfyUI_windows_portable_nvidia.7z).
2. Si Windows no abre el `.7z`, instala [7-Zip desde su web oficial](https://www.7-zip.org/) y utiliza **Extraer**.
3. Coloca la carpeta extraída en `C:\IA\IA-local-8GB\ComfyUI_windows_portable`.
4. Comprueba que dentro están las carpetas `ComfyUI` y `python_embeded`. Evita que quede una carpeta portable dentro de otra con el mismo nombre.
5. Haz doble clic en **configuraciones\ComfyUI.bat**. El navegador abrirá [127.0.0.1:8188](http://127.0.0.1:8188) al arrancar.

Este BAT adapta al portable las opciones de memoria del lanzador del portátil: `--lowvram`, reserva de 1 GB y las opciones de descarga de memoria que figuran en el archivo. Abre automáticamente el navegador y muestra una consola. Para apagarlo, pulsa **Ctrl+C** en esa consola; si Windows pregunta si quieres terminar el trabajo, confirma.

No necesitas instalar Python, PyTorch ni nodos adicionales para seguir esta ruta. Los workflows utilizan nodos del núcleo de ComfyUI. Si ya tienes ComfyUI funcionando, puedes importar los JSON en tu instalación y copiar allí los modelos: no reemplaces tus lanzadores.

La [guía oficial del portable](https://docs.comfy.org/installation/comfyui_portable_windows) explica la estructura del paquete. Nuestro BAT espera exactamente la estructura indicada arriba.

## 4. FLUX: genera el velero rojo

### Coloca los tres archivos

En esta sección, todas las carpetas parten de `C:\IA\IA-local-8GB\ComfyUI_windows_portable\ComfyUI`.

| Archivo exacto | Descarga | Carpeta dentro de ComfyUI |
| --- | --- | --- |
| `flux-2-klein-4b-fp8.safetensors` | [Modelo FLUX FP8 de Black Forest Labs](https://huggingface.co/black-forest-labs/FLUX.2-klein-4b-fp8/resolve/main/flux-2-klein-4b-fp8.safetensors?download=true) | `models\diffusion_models` |
| `qwen_3_4b.safetensors` | [Codificador de texto de Comfy Org](https://huggingface.co/Comfy-Org/Flux-2-Klein-4B/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors?download=true) | `models\text_encoders` |
| `flux2-vae.safetensors` | [VAE de Comfy Org](https://huggingface.co/Comfy-Org/Flux-2-Klein-4B/resolve/main/split_files/vae/flux2-vae.safetensors?download=true) | `models\vae` |

Por ejemplo, el primer archivo debe quedar en `C:\IA\IA-local-8GB\ComfyUI_windows_portable\ComfyUI\models\diffusion_models\flux-2-klein-4b-fp8.safetensors`.

El codificador interpreta el texto y el VAE convierte el resultado en una imagen. Necesitas los tres archivos, no solo el modelo principal. Si una carpeta no existe, créala. Espera a que terminen las descargas; no uses archivos `.part` o `.crdownload`.

### Importa y ejecuta

1. Abre ComfyUI y arrastra [workflows/FLUX_velero.json](workflows/FLUX_velero.json) al lienzo. También puedes usar **Workflow → Open**, según el idioma de la interfaz.
2. Si acabas de copiar los modelos, reinicia ComfyUI para actualizar las listas.
3. Comprueba los tres desplegables: **UNETLoader** debe mostrar `flux-2-klein-4b-fp8.safetensors`; **CLIPLoader**, `qwen_3_4b.safetensors` y tipo `flux2`; **VAELoader**, `flux2-vae.safetensors`.
4. El nodo de texto ya contiene el prompt del vídeo:

   ```text
   A small red sailboat on a calm blue lake, mountains in the background, soft morning light, photograph.
   ```

5. Mantén **512 × 512**, lote **1**, **4 pasos**, **CFG 1** y muestreador **Euler**. El nodo `Flux2Scheduler` también indica cuatro pasos y 512 × 512.
6. Pulsa **Run / Ejecutar** una sola vez y espera. La primera ejecución incluye la carga de los modelos.
7. La imagen aparecerá en **SaveImage**. Puedes abrirla desde su menú contextual. También se guarda en `ComfyUI\output`, con un nombre que empieza por `FLUX_Klein`.

El JSON es el workflow original extraído del PNG **FLUX_Klein_00003_.png**, no una reconstrucción. Su semilla figura como 42 y el control está en `randomize`: puede cambiar entre ejecuciones. Para comparar con una semilla concreta, escribe 42 y cambia ese control a `fixed`. Es un cambio opcional respecto al flujo entregado; no garantiza una imagen idéntica con cualquier versión o equipo.

En la grabación la espera fue del orden de dos minutos, incluida la carga. No es una promesa de rendimiento en otros equipos.

## 5. Wan: prueba un vídeo de un segundo

### Coloca los tres archivos

Usa las mismas carpetas de ComfyUI del apartado anterior:

| Archivo exacto | Descarga | Carpeta dentro de ComfyUI |
| --- | --- | --- |
| `wan2.2_ti2v_5B_fp16.safetensors` | [Modelo Wan 5B](https://huggingface.co/Comfy-Org/Wan-2.2/resolve/main/split_files/diffusion_models/wan2.2_ti2v_5B_fp16.safetensors?download=true) | `models\diffusion_models` |
| `umt5_xxl_fp8_e4m3fn_scaled.safetensors` | [Codificador UMT5](https://huggingface.co/Comfy-Org/Wan-2.2/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors?download=true) | `models\text_encoders` |
| `wan2.2_vae.safetensors` | [VAE de Wan 2.2](https://huggingface.co/Comfy-Org/Wan-2.2/resolve/main/split_files/vae/wan2.2_vae.safetensors?download=true) | `models\vae` |

Los enlaces son del repack de Comfy Org; el antiguo nombre `Wan_2.2_ComfyUI_Repackaged` redirige a `Wan-2.2`. La difusión es FP16 y el codificador es FP8: no son todos archivos FP8.

### Importa y ejecuta

1. Arrastra [workflows/WAN_velero.json](workflows/WAN_velero.json) al lienzo de ComfyUI.
2. Revisa **UNETLoader**, **CLIPLoader** y **VAELoader** con los nombres de la tabla. En CLIPLoader el tipo es `wan`.
3. Mantén desactivado el nodo **LoadImage**, que aparece en púrpura. La prueba es de **texto a vídeo**: no tienes que descargar `example.png` ni cargar el velero de FLUX.
4. Comprueba **1280 × 704**, **17 fotogramas** y lote **1** en `Wan22ImageToVideoLatent`; **16 FPS** en `CreateVideo`.
5. En `KSampler`: **20 pasos**, **CFG 5**, `uni_pc`, `simple` y denoise **1**. `ModelSamplingSD3` lleva desplazamiento **8**.
6. Conserva `VAEDecodeTiled`: tamaño **512**, solapamiento **64**, tamaño temporal **64** y solapamiento temporal **8**. Es la decodificación por partes utilizada en las salidas recuperadas.
7. Pulsa **Run / Ejecutar** una sola vez. Revisa la cola antes de volver a pulsar: cada clic puede añadir otro trabajo.
8. Al terminar verás la previsualización en **SaveVideo**. El archivo MP4/H.264 se guarda en `ComfyUI\output\video`, con un nombre que empieza por `Wan22`. Ábrelo con doble clic para reproducirlo.

**Prompt positivo**, ya incluido:

```text
A small red sailboat gently moving on a calm blue lake, mountains in the background, steady camera, soft morning light.
```

**Prompt negativo**, ya incluido:

```text
blurry, low quality, distorted, text, watermark, still image
```

### Qué original se incluye

`WAN_velero.json` se extrajo de **Wan22_00002_.mp4**, con semilla 42. [WAN_velero_variante.json](workflows/WAN_velero_variante.json) procede de **Wan22_00003_.mp4**, con semilla 823928124234568. Conservan sus valores y conexiones originales. No se ha identificado con certeza qué archivo corresponde a cada resultado mostrado en la grabación; no asociamos una variante a una calidad concreta.

### Los límites de esta prueba

**17 fotogramas a 16 FPS son 1,0625 segundos.** La demostración produjo clips muy cortos, con movimiento limitado y defectos visibles. En uno de los resultados ni siquiera aparecía la vela pedida.

No recomendamos esta configuración como solución para vídeos largos y de gran calidad. La espera fue de varios minutos y había trabajos en cola: no contamos con un tiempo limpio por generación para dar una cifra fiable.

El lanzador utiliza opciones para ahorrar memoria, pero no se midió qué cantidad pasó a RAM ni el máximo de VRAM de cada componente. Tampoco se comprobó que todos los modelos cupieran simultáneamente en los 8 GB. Decodificar por mosaicos, por sí solo, no demuestra esas mediciones.

## Si algo falla

| Qué ocurre | Qué puedes hacer |
| --- | --- |
| El lanzador dice que falta un archivo | Comprueba el nombre y la carpeta exactos. Activa las extensiones de archivo en el Explorador. Revisa que no hayas dejado una carpeta extra al descomprimir. |
| Faltan DLL al abrir llama.cpp | Extrae completos los dos ZIP de llama.cpp y CUDA en `llama.cpp`, no solo el EXE. Si sigue fallando, consulta el mensaje y la publicación oficial de esa versión. |
| Error del controlador CUDA | Actualiza el controlador NVIDIA desde su aplicación o [su página oficial](https://www.nvidia.com/Download/index.aspx). Reinicia Windows antes de probar de nuevo. |
| El puerto 8080 o 8188 está ocupado | Cierra la instancia anterior desde su lanzador. No abras varias copias. Los scripts no cierran otros servicios para hacer sitio. |
| La página no responde | Espera al arranque y vuelve a cargarla. Comprueba que la consola sigue abierta y que utilizas la dirección y el puerto correctos. |
| Un modelo no aparece en ComfyUI | Comprueba su carpeta, espera a que termine la descarga y reinicia ComfyUI. Selecciona el archivo en el nodo que corresponda. |
| ComfyUI muestra un nodo desconocido | Estos flujos no necesitan custom nodes. Comprueba que usas ComfyUI 0.44.0 con su frontend correspondiente; un ComfyUI antiguo puede no reconocer los nodos. |
| Error de memoria / CUDA out of memory | Apaga el otro servidor y las aplicaciones que consuman GPU. Reinicia ComfyUI y lanza un único trabajo. Si reduces resolución o contexto, estarás haciendo una prueba distinta a la del vídeo. |
| Wan pide `example.png` | Comprueba que LoadImage sigue desactivado. Si lo has activado, usa Ctrl+B sobre ese nodo para volver al estado del workflow original. |
| La espera parece interminable | Mira la consola y la cola. Cargar modelos grandes puede tardar; no añadas trabajos repetidos. Si aparece un error, guarda su texto para buscar la causa. |

## Qué se ha comprobado

Los workflows se recuperaron de salidas reales del portátil y se revisaron sus conexiones, nombres de modelos y valores. El paquete de traspaso identifica los lanzadores y las versiones instaladas. Las grabaciones aportan las pruebas y resultados descritos.

Los lanzadores de este repositorio son adaptaciones para compartir, no reemplazos de los originales. Se han revisado su sintaxis y sus rutas. Los enlaces se comprobaron al preparar esta guía, el 7 de noviembre de 2026. No se ha repetido en el sobremesa una instalación completa ni una generación en el portátil con estos lanzadores adaptados. Tampoco se ha podido comprobar la identidad binaria de los GGUF públicos con los del vídeo.

## Fuentes, agradecimientos y licencias

Gracias a los autores de los modelos, a quienes preparan sus conversiones y a los equipos de llama.cpp y ComfyUI:

- [Qwen3.5-9B, modelo original](https://huggingface.co/Qwen/Qwen3.5-9B) y [GGUF de Unsloth](https://huggingface.co/unsloth/Qwen3.5-9B-GGUF): Apache 2.0 en sus fichas.
- [MiMo-V2.6-Distill-Qwen-9B, Xiaomi MiMo](https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B): MIT; [conversión GGUF de bartowski](https://huggingface.co/bartowski/MiMo-V2.6-Distill-Qwen-9B-GGUF). La ficha de la conversión identifica el modelo original, pero no declara una licencia independiente en sus metadatos.
- [FLUX.2 Klein 4B FP8, Black Forest Labs](https://huggingface.co/black-forest-labs/FLUX.2-klein-4b-fp8) y [componentes de Comfy Org](https://huggingface.co/Comfy-Org/Flux-2-Klein-4B): Apache 2.0 en sus fichas. Consulta también las condiciones y usos excluidos que publica Black Forest Labs.
- [Wan2.2 TI2V 5B, Wan-AI](https://huggingface.co/Wan-AI/Wan2.2-TI2V-5B) y [repack de Comfy Org](https://huggingface.co/Comfy-Org/Wan-2.2): Apache 2.0 en sus fichas.
- [llama.cpp](https://github.com/ggml-org/llama.cpp): MIT. [ComfyUI](https://github.com/Comfy-Org/ComfyUI): GPL 3.0. [Plantillas de workflows de Comfy Org](https://github.com/Comfy-Org/workflow_templates): MIT.

El contenido propio de este repositorio se comparte bajo [MIT](LICENSE). En ese archivo se conserva también el aviso de Comfy Org para las partes procedentes de sus plantillas. Esta licencia no cambia las licencias de los modelos, los componentes descargables ni los programas. Aquí no se redistribuyen sus pesos ni sus binarios.
