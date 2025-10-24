# AEM-RB Nspire (alias "OpenRSE")

Programa de **Análisis Estructural Matricial de Reticulados Bidimensionales (AEM-RB)** para la calculadora **TI-Nspire CX CAS** y **TI-Nspire CX II-T CAS**.

*(Este proyecto también fue conocido durante su fase de desarrollo como **OpenRSE**)*.

Este programa utiliza el método matricial de rigidez (Método Directo de Rigidez) para calcular desplazamientos, reacciones y esfuerzos internos (fuerza axial, cortante y momento flector) en cualquier estructura 2D de barras (Pórticos, Vigas Continuas y Cerchas).


*(Aquí puedes insertar una captura de pantalla del programa en funcionamiento)*

---

## 📥 Instalación (Para Usuarios)

La instalación es muy sencilla:

1.  Descarga el archivo `AEM-RB.tns` desde este repositorio (puedes encontrarlo en la sección "Releases" o en la lista de archivos).
2.  Usa el software **TI-Nspire CX Student Software** (o el TI Connect) en tu computadora.
3.  Conecta tu calculadora TI-Nspire.
4.  Arrastra el archivo `AEM-RB.tns` a la carpeta "MyLib" de tu calculadora.

¡Listo! Al guardarlo en "MyLib", podrás usar el programa como una librería o función en cualquier documento (cuaderno de notas o calculadora) simplemente llamándolo desde el Catálogo (📒).

---

## 📁 Archivos en este Repositorio

Encontrarás dos versiones del programa:

* **`AEM-RB.tns`**: Es el **documento de la calculadora ya listo para usar**. Este es el archivo que la mayoría de los usuarios necesitan para instalar el programa.
* **`AEM-RB.lua`**: Es el **código fuente puro** escrito en lenguaje LUA. Este archivo es para desarrolladores, estudiantes o curiosos que quieran leer, estudiar o modificar el código.

---

## 👨‍💻 Para Desarrolladores (El Código LUA)

### ¿Cómo funciona el LUA en la Nspire?

La calculadora TI-Nspire no "compila" el código LUA de la forma tradicional (como C++ o Java). El LUA es un lenguaje *interpretado*.

El archivo `.tns` actúa como un **contenedor** que almacena el script LUA (el texto) junto con otros elementos del documento (como las páginas de la interfaz gráfica). El archivo `.lua` es solo el texto del script.

### ¿Cómo "re-compilar" el .tns desde el .lua?

Si modificas el archivo `.lua` en tu computadora y quieres crear un nuevo `.tns` para probarlo en la calculadora, debes seguir estos pasos:

1.  Abre el software **TI-Nspire CX Student Software** en tu PC/Mac.
2.  Crea un nuevo documento en blanco.
3.  Ve al menú: **Insertar > Programación > Editor de Programas > Añadir LUA**.
4.  Se abrirá una página de script. **Copia todo** el contenido de tu archivo `.lua` modificado y **pégalo** en este editor (reemplazando cualquier texto existente).
5.  **Guarda** el documento (Archivo > Guardar) con el nombre que desees (ej. `Mi_Version_AEM-RB.tns`).
6.  Transfiere ese nuevo archivo `.tns` a tu calculadora para probarlo.

---

## 📜 Licencia

Este proyecto es totalmente libre y de código abierto. Está publicado bajo la **Licencia MIT**.
