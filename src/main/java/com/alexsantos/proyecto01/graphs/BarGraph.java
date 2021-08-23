package com.alexsantos.proyecto01.graphs;

import java.io.File;
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

    private CategoryDataset createDataset() {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        // AGREGAR DATOS
        for (int i = 0; i < values.size(); i++) {
            dataset.addValue(values.get(i), xaxis.get(i), "");
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
            ChartUtils.saveChartAsJPEG(file, chart, 300, 300);
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }
}
