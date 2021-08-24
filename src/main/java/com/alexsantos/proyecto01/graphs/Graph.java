package com.alexsantos.proyecto01.graphs;

import java.util.ArrayList;

/**
 *
 * @author alex
 */
public class Graph {

    // GLOBALES
    public String title;
    public ArrayList<String> xaxis;
    public ArrayList<Double> values;

    public Graph() {
        title = "";
        xaxis = new ArrayList<>();
        values = new ArrayList<>();
    }

    public void generateGraph(String name) {

    }

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
                        System.out.println("Error en linea " + prop[2] + " ya se asigno una vez el titulo.");
                    }
                    break;
                case "xaxis":
                    if (xaxis.isEmpty()) {
                        xaxis = (ArrayList<String>) prop[0];
                    } else {
                        System.out.println("Error en linea " + prop[2] + " ya se asigno una vez el eje X.");
                    }
                    break;
                case "values":
                    if (values.isEmpty()) {
                        values = (ArrayList<Double>) prop[0];
                    } else {
                        System.out.println("Error en linea " + prop[2] + " ya se asigno una vez los valores.");
                    }
                    break;
                default:
                    break;
            }
        } else {
            System.out.println("Error valor nulo en linea " + prop[2]);
        }
    }
}
