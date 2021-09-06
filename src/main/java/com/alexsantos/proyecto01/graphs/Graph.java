package com.alexsantos.proyecto01.graphs;

import com.alexsantos.proyecto01.analyzer.comparator.FilePoints;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author alex
 */
public class Graph {

    // GLOBALES
    public String title;
    public ArrayList<String> xaxis;
    public ArrayList<Double> values;

    /**
     * Constructor
     */
    public Graph() {
        title = "";
        xaxis = new ArrayList<>();
        values = new ArrayList<>();
    }

    public void generateGraph(String name, HashMap<String, FilePoints> points, float generalPoints) {

    }

    /**
     * Asignar propiedad de grafica
     *
     * @param prop
     */
    public void setProp(Object[] prop) {
        if (prop[0] != null) {
            // NOMBRE DE LA PROPIEDAD
            String key = (String) prop[1];

            // ASIGNAR
            switch (key) {
                case "title":
                    if (title.isEmpty()) {
                        title = (String) prop[0];
                    } else {
                        System.err.println("\nError en linea " + prop[2] + " ya se asigno una vez el titulo.\n");
                    }
                    break;
                case "xaxis":
                    if (xaxis.isEmpty()) {
                        xaxis = (ArrayList<String>) prop[0];
                    } else {
                        System.err.println("\nError en linea " + prop[2] + " ya se asigno una vez el eje X.\n");
                    }
                    break;
                case "values":
                    if (values.isEmpty()) {
                        values = (ArrayList<Double>) prop[0];
                    } else {
                        System.err.println("\nError en linea " + prop[2] + " ya se asigno una vez los valores.\n");
                    }
                    break;
                default:
                    break;
            }
        } else {
            System.err.println("\nError valor nulo en linea " + prop[2] + "\n");
        }
    }
}
