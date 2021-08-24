package com.alexsantos.proyecto01.graphs;

import java.io.File;
import java.io.IOException;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;

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

    @Override
    public void setProp(Object[] prop) {
        if (prop[0] != null) {
            // ENVIAR OTRAS PROPIEDADES
            super.setProp(prop);

            // NOMBRE DE LA PROPIEDAD
            String key = (String) prop[1];

            // ASIGNAR
            if (key.equals("xaxisTitle")) {
                if (xaxisTitle.isEmpty()) {
                    xaxisTitle = (String) prop[0];
                } else {
                    System.out.println("Error en linea " + prop[2] + " ya se asigno una vez el titulo del Eje X.");
                }
            } else if (key.equals("yaxisTitle")) {
                if (yaxisTitle.isEmpty()) {
                    yaxisTitle = (String) prop[0];
                } else {
                    System.out.println("Error en linea " + prop[2] + " ya se asigno una vez el titulo del Eje Y.");
                }
            }
        } else {
            System.out.println("Error valor nulo en linea " + prop[2]);
        }
    }

    private CategoryDataset createDataset() {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        // AGREGAR DATOS
        if (values.size() > 0 && xaxis.size() >= values.size()) {
            for (int i = 0; i < values.size(); i++) {
                dataset.addValue(values.get(i), xaxis.get(i), "");
            }
        } else {
            System.out.println("Error faltan valores en el eje X en grafica de barras " + title);
        }

        return dataset;
    }

    @Override
    public void generateGraph(String path) {
        // DATASET
        CategoryDataset dataset = createDataset();

        // CREAR GRAFICA
        JFreeChart chart = ChartFactory.createBarChart(
                title,
                xaxisTitle,
                yaxisTitle,
                dataset,
                PlotOrientation.VERTICAL,
                true, true, false
        );

        // GUARDAR IMAGEN
        try {
            File file = new File(path + "barchart_" + title + ".jpeg");
            ChartUtils.saveChartAsJPEG(file, chart, 600, 400);
        } catch (IOException ex) {
            System.out.println(ex);
        }
    }
}
