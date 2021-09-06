package com.alexsantos.proyecto01.fca;

import com.alexsantos.proyecto01.analyzer.tokens.TokenSymbol;
import com.alexsantos.proyecto01.analyzer.tokens.TokensHandler;
import java.io.FileWriter;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 *
 * @author alex
 */
public class TokensReport {

    // GLOBALES
    private TokensHandler tokens;

    /**
     * Constructor
     */
    public TokensReport() {
        tokens = TokensHandler.getInstance();
    }

    /**
     * Generar filas
     *
     * @return
     */
    public String getTokenTable() {
        String content = "";

        // RECORRER
        for (int tokenIndex = 0; tokenIndex < tokens.symbols.size(); tokenIndex++) {
            TokenSymbol token = tokens.symbols.get(tokenIndex);
            content += "<tr><td>" + token.lex + "</td><td>" + token.key + "</td><td>" + Integer.toString(token.line) + "</td><td>" + Integer.toString(token.col) + "</td><td>" + token.file + "</td></tr>";
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

            FileWriter writer = new FileWriter("report/tokens/index.html");
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
        modifyFile("report/tokens/template.html", "{table_content}", getTokenTable());
    }
}
