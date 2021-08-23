package com.alexsantos.proyecto01.graphs;

/**
 *
 * @author alex
 */
public class BarGraph extends Graph {

    // GLOBALES
    String xaxisTitle, yaxisTitle;

    public BarGraph() {
        xaxisTitle = "";
        yaxisTitle = "";
    }

    public void setProp(Object[] prop) {
        // ENVIAR OTRAS PROPIEDADES
        super.setProp(prop);

        // NOMBRE DE LA PROPIEDAD
        String key = (String) prop[1];

        // ASIGNAR
        if (key.equals("xaxisTitle")) {
            if (!xaxisTitle.isEmpty()) {
                System.out.println("Error en linea " + prop[2] + " ya se asigno una vez el titulo del Eje X.");
            } else {
                xaxisTitle = (String) prop[0];
            }
        } else if (key.equals("yaxisTitle")) {
            if (!yaxisTitle.isEmpty()) {
                System.out.println("Error en linea " + prop[2] + " ya se asigno una vez el titulo del Eje Y.");
            } else {
                yaxisTitle = (String) prop[0];
            }
        }
    }
}
