package com.alexsantos.proyecto01.fca;

import com.alexsantos.proyecto01.analyzer.errors.ErrorHandler;
import com.alexsantos.proyecto01.analyzer.errors.ErrorSymbol;
import java.io.FileWriter;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 *
 * @author alex
 */
public class ErrorsReport {

    // GLOBALES
    private ErrorHandler errs;

    /**
     * Constructor
     */
    public ErrorsReport() {
        errs = ErrorHandler.getInstance();
    }

    /**
     * Generar filas
     *
     * @return
     */
    public String getTokenTable() {
        String content = "";

        // RECORRER
        for (int errIndex = 0; errIndex < errs.symbols.size(); errIndex++) {
            ErrorSymbol err = errs.symbols.get(errIndex);
            content += "<tr><td>" + (String) err.lex + "</td><td>No reconocido</td><td>" + Integer.toString(err.line) + "</td><td>" + Integer.toString(err.col) + "</td><td>" + err.file + "</td></tr>";
        }

        return content;
    }

    /**
     * Editar archivo
     *
     * @param filePath
     * @param oldString
     * @param newString
     */
    private void modifyFile(String filePath, String oldString, String newString) {
        try {
            byte[] encoded = Files.readAllBytes(Paths.get(filePath));
            String content = new String(encoded, "utf-8");

            FileWriter writer = new FileWriter("report/errors/index.html");
            writer.write(content.replace(oldString, newString));
            writer.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /**
     * Seleccionar template
     */
    public void generateReport() {
        modifyFile("report/errors/template.html", "{table_content}", getTokenTable());
    }
}
