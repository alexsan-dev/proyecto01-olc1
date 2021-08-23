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
        // NOMBRE DE LA PROPIEDAD
        String key = (String) prop[1];

        // ASIGNAR
        if (key.equals("title")) {
            if (!title.isEmpty()) {
                System.out.println("Error en linea " + prop[2] + " ya se asigno una vez el titulo.");
            } else {
                title = (String) prop[0];
            }
        } else if (key.equals("xaxis")) {
            if (xaxis.size() == 0) {
                xaxis = (ArrayList<String>) prop[0];
            } else {
                System.out.println("Error en linea " + prop[2] + " ya se asigno una vez el eje X.");
            }
        } else if (key.equals("values")) {
            if (values.size() == 0) {
                values = (ArrayList<Double>) prop[0];
            } else {
                System.out.println("Error en linea " + prop[2] + " ya se asigno una vez los valores.");
            }
        }
    }
}
