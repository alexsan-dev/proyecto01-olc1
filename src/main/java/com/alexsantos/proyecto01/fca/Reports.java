package com.alexsantos.proyecto01.fca;

import java.util.HashMap;

/**
 *
 * @author alex
 */
public class Reports {

    // GLOBALES
    public static Reports reports;
    public static String path1, path2;
    public static HashMap<String, Object> properties;

    // INSTANCIA
    public static Reports getInstance() {
        if (reports == null) {
            properties = new HashMap<String, Object>();
            reports = new Reports();
            path1 = "";
            path2 = "";
        }

        return reports;
    }

    // ASIGNAR RUTAS DE COMPARACION
    public static void setComparePaths(String pathA, String pathB, int line, int col) {
        if (path1.equals("") && path2.equals("")) {
            properties = new HashMap<String, Object>();
            path1 = pathA;
            path2 = pathB;
        } else {
            System.out.println("Error en linea: " + line + " ya se ejecuto COMPARE una vez.");
        }
    }

    // ASIGNAR VARIABLES GLOBALES
    public static void setGlobalProp(String key, Object value) {
        properties.put(key, value);
    }

    // OBTENER VARIABLES GLOBALES
    public static Object getGlobalProp(String key) {
        return properties.getOrDefault(key, null);
    }
}
