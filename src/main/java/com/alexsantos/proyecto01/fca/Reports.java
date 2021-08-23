package com.alexsantos.proyecto01.fca;

import com.alexsantos.proyecto01.graphs.*;
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

    private static void cleanProps() {
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

    public static void setComparePaths(String pathA, String pathB, int line, int col) {
        if (path1.equals("") && path2.equals("")) {
            path1 = pathA;
            path2 = pathB;
        } else {
            System.out.println("Error en linea: " + line + " ya se ejecuto COMPARE una vez.");
        }
    }

    public static void setGlobalProp(String key, Object value) {
        properties.put(key, value);
    }

    public static Object getGlobalProp(String key) {
        return properties.getOrDefault(key, null);
    }
}
