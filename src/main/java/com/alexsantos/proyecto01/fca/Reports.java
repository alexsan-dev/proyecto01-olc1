package com.alexsantos.proyecto01.fca;

import com.alexsantos.proyecto01.analyzer.comparator.*;
import com.alexsantos.proyecto01.graphs.*;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author alex
 */
public class Reports {

    // GLOBALES
    public static Reports reports;
    public static double genPoints;
    public static String path1, path2;
    public static ArrayList<Graph> graphs;
    public static ArrayList<String> project1Paths;
    public static ArrayList<ElementCounter> elements;
    public static HashMap<String, FilePoints> points;
    public static HashMap<String, Object> properties;

    /**
     * Reiniciar instancia
     */
    public static void cleanProps() {
        points = new HashMap<String, FilePoints>();
        properties = new HashMap<String, Object>();
        elements = new ArrayList<ElementCounter>();
        graphs = new ArrayList<Graph>();
        reports = new Reports();
        path1 = "";
        path2 = "";
        genPoints = 0;
    }

    /**
     * Obtener instancia
     *
     * @return
     */
    public static Reports getInstance() {
        if (reports == null) {
            cleanProps();
        }
        return reports;
    }

    /**
     * Asignar rutas de comparacion
     *
     * @param pathA
     * @param pathB
     * @param line
     */
    public static void setComparePaths(String pathA, String pathB, int line) {
        // NO ESTAN VACIA
        if (path1.equals("") && path2.equals("")) {
            path1 = pathA.charAt(pathA.length() - 1) == '/' ? pathA : pathA + "/";
            path2 = pathB.charAt(pathB.length() - 1) == '/' ? pathB : pathB + "/";
            System.out.println("Comparando proyectos " + path1 + " y " + path2);
        }
    }

    /**
     * Asignar propiedad global
     *
     * @param key
     * @param value
     */
    public static void setGlobalProp(String key, Object value) {
        if (value != null) {
            properties.put(key, value);
            System.out.println("Declarando variable " + key);
        } else {
            System.err.println("\nError valor nulo en " + key + "\n");
        }
    }

    /**
     * Obtener variable global
     *
     * @param key
     * @return
     */
    public static Object getGlobalProp(String key) {
        return properties.getOrDefault(key, null);
    }

    /**
     * Agregar grafica
     *
     * @param graph
     * @param title
     */
    public static void addGraph(Graph graph, String title) {
        if (title != null) {
            graphs.add(graph);
            System.out.println("Agregando grafica de " + title + ": " + graph.title);
        } else {
            System.err.println("\nError titulo vacio\n");
        }
    }

    /**
     * Inicia el analisis de copias
     */
    public static void compare() {
        // COMPARE
        if (path1.length() > 0 && path2.length() > 0) {
            Compare compare = new Compare(path1, path2);
            project1Paths = compare.getPaths(path1);
            points = compare.getRange();
            genPoints = compare.getGeneralPoints(points);
            elements = compare.getElements();
        }
    }

    /**
     * Obtener reporte JSON
     */
    public static void getJSONReport() {
        JSONReport jsonReport = new JSONReport(project1Paths, genPoints, points);
        jsonReport.getJSONFile();
    }

    /**
     * Reporte de tokens
     */
    public static void getTokensReport() {
        TokensReport report = new TokensReport();
        report.generateReport();
    }

    /**
     * Reporte de errores
     */
    public static void getErrsReport() {
        ErrorsReport report = new ErrorsReport();
        report.generateReport();
    }

    /**
     * Reporte estadistico
     */
    public static void getAnalyticsReport() {
        String series1 = path1.substring(0, path1.length() - 1);
        series1 = series1.substring(series1.lastIndexOf("/") + 1);
        String series2 = path2.substring(0, path2.length() - 1);
        series2 = series2.substring(series2.lastIndexOf("/") + 1);

        AnalyticsReport report = new AnalyticsReport(elements, series1, series2);
        report.generateReport();
    }

    /**
     * Obtener puntaje especifico
     */
    public static double getFilePoints(String path, String key, String id) {
        double filePoints = 0;

        // PUNTOS
        if (points.size() > 0) {
            FilePoints pathPoints = points.get(path);

            String lowerKey = key.toLowerCase();

            // CALCULAR PARA CLASES
            if (lowerKey.equals("clase")) {
                HashMap<String, Element> points = pathPoints.classPoints;
                Element element = points.get(id);
                if (element != null) {
                    filePoints += element.points;
                }
            } else if (lowerKey.equals("metodo")) {
                HashMap<String, Element> points = pathPoints.methodPoints;
                Element element = points.get(id);
                if (element != null) {
                    filePoints += element.points;
                }
            } else if (lowerKey.equals("variable")) {
                HashMap<String, Element> points = pathPoints.varPoints;
                Element element = points.get(id);
                if (element != null) {
                    filePoints += element.points;
                }
            } else if (lowerKey.equals("comentario")) {
                HashMap<String, Element> points = pathPoints.commentPoints;
                Element element = points.get(id);
                if (element != null) {
                    filePoints += element.points;
                }
            }
        }

        return filePoints;
    }

    /**
     * Generar imagenes de todas las graficas
     */
    public static void generateGraphs() {
        // CREAR CARPETA SI NO EXISTE
        String path = "./report/assets/";
        File projectDir = new File(path);
        if (!projectDir.exists()) {
            projectDir.mkdirs();
        }

        // GRAFICAR
        System.out.println("Generando todas las graficas");

        for (int i = 0; i < graphs.size(); i++) {
            graphs.get(i).generateGraph(path);
        }

        System.out.println("Fin de analisis lexico");
    }
}
