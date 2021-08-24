package com.alexsantos.proyecto01.fca;

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

    public static void cleanProps() {
        properties = new HashMap<String, Object>();
        graphs = new ArrayList<Graph>();
        reports = new Reports();
        path1 = "";
        path2 = "";
    }

    public static Reports getInstance() {
        if (reports == null) {
            cleanProps();
        }
        return reports;
    }

    public static void setComparePaths(String pathA, String pathB, int line) {
        if (path1.equals("") && path2.equals("")) {
            path1 = pathA;
            path2 = pathB;
            System.out.println("Comparando proyectos " + path1 + " y " + path2);
        } else {
            System.out.println("Error en linea: " + line + " ya se ejecuto COMPARE una vez.");
        }
    }

    public static void setGlobalProp(String key, Object value) {
        if (value != null) {
            properties.put(key, value);
            System.out.println("Declarando variable " + key);
        } else {
            System.out.println("Error null en " + key);
        }
    }

    public static Object getGlobalProp(String key) {
        return properties.getOrDefault(key, null);
    }

    public static void addGraph(Graph graph, String title) {
        if (title != null) {
            graphs.add(graph);
            System.out.println("Agregando grafica de " + title + ": " + graph.title);
        } else {
            System.out.println("Error titulo vacio");
        }
    }

    public static void generateGraphs() {
        Thread thread = new Thread() {
            public void run() {
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
        };
        thread.start();
    }
}
