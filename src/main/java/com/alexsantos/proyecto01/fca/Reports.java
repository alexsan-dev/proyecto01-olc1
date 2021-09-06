package com.alexsantos.proyecto01.fca;

import com.alexsantos.proyecto01.analyzer.comparator.Compare;
import com.alexsantos.proyecto01.analyzer.comparator.FilePoints;
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
    public static String path1, path2;
    public static ArrayList<Graph> graphs;
    public static HashMap<String, Object> properties;

    /**
     * Reiniciar instancia
     */
    public static void cleanProps() {
        properties = new HashMap<String, Object>();
        graphs = new ArrayList<Graph>();
        reports = new Reports();
        path1 = "";
        path2 = "";
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
        } else {
            System.err.println("\nError en linea: " + line + " ya se ejecuto COMPARE una vez.\n");
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
     * Generar imagenes de todas las graficas
     */
    public static void generateGraphs() {
        // COMPARE
        HashMap<String, FilePoints> points = null;
        float generalPoints = 0;

        if (path1.length() > 0 && path2.length() > 0) {
            Compare compare = new Compare(path1, path2);
            points = compare.getRange();
            generalPoints = compare.getGeneralPoints(points);
        }

        // CREAR CARPETA SI NO EXISTE
        String path = "./report/assets/";
        File projectDir = new File(path);
        if (!projectDir.exists()) {
            projectDir.mkdirs();
        }

        // GRAFICAR
        System.out.println("Generando todas las graficas");

        for (int i = 0; i < graphs.size(); i++) {
            graphs.get(i).generateGraph(path, points, generalPoints);
        }

        System.out.println("Fin de analisis lexico");
    }
}
