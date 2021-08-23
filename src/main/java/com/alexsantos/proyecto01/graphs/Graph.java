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
    public ArrayList<String> values;

    public Graph() {
        title = "";
        xaxis = new ArrayList<>();
        values = new ArrayList<>();
    }

    public void setProp(Object[] prop) {
        // NOMBRE DE LA PROPIEDAD
        String key = (String) prop[1];

        // ASIGNAR
        if (key.equals("title")) {
            title = (String) prop[0];
        } else if (key.equals("xaxis")) {
            xaxis = (ArrayList<String>) prop[0];
        } else if (key.equals("values")) {
            values = (ArrayList<String>) prop[0];
        }
    }
}
