package com.alexsantos.proyecto01.graphs;

import com.alexsantos.proyecto01.analyzer.comparator.FilePoints;
import java.util.HashMap;

/**
 *
 * @author alex
 */
public class LineGraph extends Graph {

    String file;

    /**
     * Constructor
     */
    public LineGraph() {
        file = "";
    }

    /**
     * Asignar propiedades de grafica
     *
     * @param prop
     */
    @Override
    public void setProp(Object[] prop) {
        if (prop[0] != null) {
            // ENVIAR OTRAS PROPIEDADES
            super.setProp(prop);

            // NOMBRE DE LA PROPIEDAD
            String key = (String) prop[1];

            // ASIGNAR
            if (key.equals("file")) {
                if (file.isEmpty()) {
                    file = (String) prop[0];
                } else {
                    System.err.println("\nError en linea " + prop[2] + " ya se asigno una vez el titulo del Eje X.\n");
                }
            }
        } else {
            System.err.println("\nError valor nulo en linea " + prop[2] + "\n");
        }
    }

    @Override
    public void generateGraph(String name, HashMap<String, FilePoints> points, float generalPoints) {
    }
}
