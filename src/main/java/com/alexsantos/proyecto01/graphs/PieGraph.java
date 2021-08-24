package com.alexsantos.proyecto01.graphs;

import java.io.File;
import java.io.IOException;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.general.PieDataset;

/**
 *
 * @author alex
 */
public class PieGraph extends Graph {

    public PieGraph() {
    }

    private PieDataset createDataset() {
        DefaultPieDataset dataset = new DefaultPieDataset();

        // AGREGAR DATOS
        if (xaxis.size() >= values.size()) {
            for (int i = 0; i < values.size(); i++) {
                dataset.setValue(xaxis.get(i), values.get(i));
            }
        } else {
            System.out.println("Error faltan valores en el eje X en grafica de pie " + title);
        }

        return dataset;
    }

    @Override
    public void generateGraph(String path) {
        // DATASET
        PieDataset dataset = createDataset();

        // CREAR GRAFICA
        JFreeChart chart = ChartFactory.createPieChart(
                title,
                dataset,
                true,
                true,
                false
        );

        // GUARDAR IMAGEN
        try {
            File file = new File(path + "piechart_" + title + ".jpeg");
            ChartUtils.saveChartAsJPEG(file, chart, 600, 400);
        } catch (IOException ex) {
            System.out.println(ex);
        }
    }
}
