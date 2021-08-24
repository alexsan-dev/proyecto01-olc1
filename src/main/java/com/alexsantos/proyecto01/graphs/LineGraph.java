package com.alexsantos.proyecto01.graphs;

/**
 *
 * @author alex
 */
public class LineGraph extends Graph {

    String file;

    public LineGraph() {
        file = "";
    }

    public void setProp(Object[] prop) {
        // ENVIAR OTRAS PROPIEDADES
        super.setProp(prop);

        // NOMBRE DE LA PROPIEDAD
        String key = (String) prop[1];

        // ASIGNAR
        if (key.equals("file")) {
            if (!file.isEmpty()) {
                System.out.println("Error en linea " + prop[2] + " ya se asigno una vez el titulo del Eje X.");
            } else {
                file = (String) prop[0];
            }
        }
    }

    @Override
    public void generateGraph(String path) {
    }
}
