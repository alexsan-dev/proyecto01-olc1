# Manual Técnico
Descripcion de todos los metodos, clases y funciones utilizadas en el desarollo de la aplicacion FIUSAC Copy Analyzer.

### App.java
Esta clase contiene el inicio de la aplicacion
```java
public void start(Stage stage) throws IOException
```
Inicia la aplicación FXML
* @param {[Stage](#)} stage
	* Escena a mostrar
---
```java
public static void setRoot(String  fxml) throws IOException
```
Cambiar archivo FXML
* @param {[String](#)} fxml
	* Ruta de archivo fxml

---
```java
private static Parent loadFXML(String  fxml) throws IOException
```
Cargar archivo FXML
*  @return {[Parent](#)}
* @param {[String](#)} fxml
	* Ruta de archivo fxml

---
```java
public static void main(String[] args)
```
Iniciar aplicación

### package utils
#### Tools.java
Esta clase contiene herramientas utilizadas en todo el proyecto

---
```java
public static String trimStr(String str)
```
Cortar textos
* @return {[String](#)}
* @param {[String](#)} str
	* String a cortar
	
### package graphs
#### BarGraph.java, LineGraph.java, PieGraph.java
Esta clase genera graficas de barras, lineas y pie

```java
public TypeGraph()
```
Constructor

---
```java
public void setProp(Object[] prop)
```
Asignar propiedad de gráfica
* param {[Object[]](#)} prop
	* Arreglo nombre: valor
---
```java
private CategoryDataset createDataset()
```
Crear lista de datos de freechart

---
```java
public void generateGraph(String path)
```
Generar imagen de gráfica
* param {[String](#)} path
	* Ruta de imagen generada

#### Graph.java
Esta clase es la clase padre del resto de sub graficas como clase abstracta

```java
public Graph()
```
Constructor

---
```java
public void setProp(Object[] prop)
```
Asignar propiedad de gráfica
* param {[Object[]](#)} prop
	* Arreglo nombre: valor

### package fca
#### AnalyticsReport.java,  ErrorsReport.java, TokensReport.java
Genera un reporte estadístico, de errores, de tokens
```java
public TypeReport(ArrayList<ElementCounter> elements, String project1, String project2) 
```
Constructor
* param {[ArrayList<ElementCounter>](#)} elements
	* Ast generado por el parser
* param {[String](#)} project1
	* Nombre de proyecto 1
* param {[String](#)} project2
	* Nombre de proyecto 2
---
```java
public String getTable()
```
Generar tabla HTML de total de elementos en cada proyecto

---

```java
private void modifyFile(String filePath, String oldString, String newString)
```
Edita un archivo con el nuevo contenido y lo guarda
* param {[String](#)} filePath
	* Ruta de archivo original
* param {[String](#)} oldString
	* Contenido a buscar
* param {[String](#)} newString
	* Contenido a remplazar

#### Reports.java
```java
public static void cleanProps() 
```
Reiniciar instancia

```java
public static Reports getInstance() 
```
Obtener instancia
@return {[Reports](#)}

