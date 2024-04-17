# 📐Laboratorio de Diseño de Sistemas Digitales
## 📝 Práctica 4
---

### 👓 Problema a resolver

1. Generar un código, de preferencia en VHDL, que corresponda al diagrama:

![Moore Machine!](/assets/images/diagram.png "Moore Machine")

Con las siguientes características
- El alumno podrá usar los push buttons o bien los interruptores del dip switch para las entradas.
- Para las salidas se usarán dos led de la tarjeta `DE0`.
- Deberá de indicarse en qué estado se encuentra el programa, puede realizarse mediante: a) Elegir 5 leds, diferentes a los usados para la salida, de los cuales encenderá uno por cada estado de los 5. b) Ocupar los display de 7 segmentos para mostrar con número (del 0 al 4) el estado actual.
- Implementar un botón de reset para establecer el estado en `S0`.

2. Programe la tarjeta `DE0`.

3. Capture fotografías o vídeo de la tarjeta `DE0` para su reporte.

4. Genere el reporte de la práctica. Los videos pueden ser subidos a su drive de su cuenta de _@aragon.unam.mx_ y colocar la liga dentro del reporte, **no olvidar dar acceso al profesor para poder reproducir el video**.

---

### 🖥️ Características del código
- El código fue desarrollado para un FPGA `EP4CE6E22C8N`
- Utiliza un contador que sirve para encender cada display de 7 segmentos por un periodo de milisegundos, uno a la vez.
- Utiliza módulos, razón por la cual tiene dos archivos _vhd_.

#### 🧩 Archivos que componen el proyecto
- [assets/](/assets/) - Contiene recursos usados por este archivo, actualmente solo contiene una imágen del diagrama.
- [contador.vhd](/contador.vhd) - Contiene el código de un contador para encender un display de 7 segmentos por vez. Es invocado como componente por el siguiente archivo. **Característica especial de la tarjeta usada (EP4CE6E22C8N).**
- [display7s.vhd](/display7s.vhd) - Recibe un número entre 0 y 9999 para pintarlo en los display de 7 segmentos. Es invocado como componente por el siguiente archivo. **Característica especial de la tarjeta usada (EP4CE6E22C8N).**
- [moore.vhd](/moore.vhd) - Contiene la lógica principal de la máquina de moore.
- [LICENSE](/LICENSE) - Contiene la licencia de uso.
- [README.md](/README.md) - Es este documento.
- .gitignore - Elementos (archivos y directorios) ignorados en el versionado git de este repositorio.

### ⚠ Advertencias del código

- Mientras que el alumnado utilizará la tarjeta `DE0` Cyclone III. **Este código fue realizado para un FPGA Cyclone IV (EP4CE6E22C8N)**
- Para que un LED se encienda, en este modelo de FPGA, se tiene que mandar un 0 y no un 1 como lo haría la `DE0`.
- De igual forma, las entradas por defecto están en 1, cuando se activan se pasan a un estado de 0.
- Para usar los display de 7 segmentos se hace por milisegundos la selección de un display para encenderlo mostrando el número alimentado según su posición (millares, centenas, decenas o unidades). **La tarjeta `DE0` (de los alumnos) si puede encender a la vez los 4 display de 7 segmentos, se recomienda leer la documentación de los pines**.

---

_Author: @ulises-aragon1_