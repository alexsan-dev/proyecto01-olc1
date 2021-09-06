package com.alexsantos.proyecto01.controllers;

import com.alexsantos.proyecto01.analyzer.fca.FCAParser;
import com.alexsantos.proyecto01.analyzer.fca.FCAScanner;
import com.alexsantos.proyecto01.fca.Reports;
import com.jfoenix.controls.JFXTabPane;
import java.io.*;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Tab;
import javafx.scene.control.TextArea;
import javafx.scene.effect.BoxBlur;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

public class Primary {

    // GLOBALES
    private int selectedEditor = 0;
    private char dotSymbol = '•';

    // ELEMENTOS
    @FXML
    private JFXTabPane tabs;
    @FXML
    private TextFlow output;
    @FXML
    private StackPane mainPane;
    @FXML
    private VBox mainContainer;

    /**
     * Iniciar vista
     */
    public void initialize() {
        // INICIAR Y LIMPIAR
        addEditorTab();
        clearOutput(true);

        // ASIGNAR SALIDA DE SYSTEM
        System.setOut(getConsole(false));
        System.setErr(getConsole(true));
    }

    /**
     * Obtener pestaña actual
     *
     * @return
     */
    public Tab getCurrentTab() {
        Tab currentTab = tabs.getTabs().get(selectedEditor);
        return currentTab;
    }

    /**
     * Obtener contendor actual
     *
     * @return
     */
    public AnchorPane getCurrentAnchor() {
        Tab currentTab = getCurrentTab();
        AnchorPane anchorPane = (AnchorPane) currentTab.getContent();
        return anchorPane;
    }

    /**
     * Obtener editor actual
     *
     * @return
     */
    public TextArea getCurrentEditor() {
        AnchorPane anchorPane = getCurrentAnchor();
        TextArea textArea = (TextArea) anchorPane.getChildren().get(0);
        return textArea;
    }

    /**
     * Crea una instancia de PrintStream para las consolas en System
     *
     * @param isErr
     * @return
     */
    public PrintStream getConsole(boolean isErr) {
        PrintStream out = new PrintStream(new OutputStream() {
            @Override
            public void write(int b) throws IOException {
                // TEXTO
                Text line = new Text("" + (char) (b & 0xFF));
                line.setStyle("-fx-font-smoothing-type: lcd;-fx-fill:" + (isErr ? "#F44336;-fx-font-weight:bold;" : "#fff;") + "-fx-font-family: Fira Code;");

                // AGREGAR CARACTER
                output.getChildren().add(line);
            }
        });
        return out;
    }

    /**
     * Borrar consola y agregar placeholder
     *
     * @param isPlaceholder
     */
    private void clearOutput(boolean isPlaceholder) {
        // PLACEHOLDER
        Text placeholder = new Text("Salida de consola y errores.");
        placeholder.setStyle("-fx-font-smoothing-type: lcd;-fx-fill: #fff;-fx-font-family: Fira Code;");

        // LIMPIAR
        output.getChildren().clear();

        // AGREGAR PLACEHOLDER
        if (isPlaceholder) {
            output.getChildren().add(placeholder);
        }
    }

    /**
     * Mostrar mensaje de confirmacion
     *
     * @param title
     * @param content
     * @return
     */
    public ButtonType showDialog(String title, String content) {
        // EFECTO
        BoxBlur blur = new BoxBlur(5, 5, 5);
        mainContainer.setEffect(blur);

        // ALERTA
        Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
        alert.setContentText(content);
        alert.setTitle(title);

        // ESPERAR Y REINICIAR
        alert.showAndWait();
        mainContainer.setEffect(null);
        return alert.getResult();
    }

    /**
     * Leer archivo File a String
     *
     * @param file
     * @return
     */
    private String readFile(File file) {
        // BUFFER
        StringBuilder stringBuffer = new StringBuilder();
        BufferedReader bufferedReader = null;

        try {
            // LEER
            bufferedReader = new BufferedReader(new FileReader(file));
            String text;
            while ((text = bufferedReader.readLine()) != null) {
                stringBuffer.append(text + "\n");
            }
        } catch (Exception ex) {
            System.out.println(ex);
        } finally {
            try {
                // CERRAR BUFFER
                bufferedReader.close();
            } catch (Exception ex) {
                System.out.println(ex);
            }
        }

        // CONTENIDO
        return stringBuffer.toString();
    }

    /**
     * Guardar archivo actual en ruta
     *
     * @param path
     */
    @FXML
    private void saveFileOnPath(String path) {
        // PESTAÑA Y EDITOR ACTUALES
        Tab currentTab = getCurrentTab();
        TextArea editor = getCurrentEditor();

        // BUFFER
        BufferedWriter writer = null;
        try {
            // GUARDAR
            writer = new BufferedWriter(new FileWriter(path));
            writer.write(editor.getText());

            // BORRAR SIMBOLO DE GUARDADO
            currentTab.setText(currentTab.getText().replace(" " + dotSymbol, ""));
        } catch (IOException ex) {
            System.out.println(ex);
        } finally {
            try {
                if (writer != null) {
                    writer.close();
                }
            } catch (IOException ex) {
                System.out.println(ex);
            }
        }
    }

    /**
     * Guardar archivo actual como
     */
    @FXML
    private void saveFileAs() {
        // FILE CHOOSER
        FileChooser fileChooser = new FileChooser();
        FileChooser.ExtensionFilter extFilter = new FileChooser.ExtensionFilter("Archivos FCA (*.fca)", "*.fca");
        fileChooser.getExtensionFilters().add(extFilter);
        File file = fileChooser.showSaveDialog(new Stage());

        if (file != null) {
            // CONFIGURAR PESTAÑA
            Tab currentTab = getCurrentTab();
            currentTab.setText(file.getName().replace(Character.toString(dotSymbol), ""));
            currentTab.setId(file.toString());

            // GUARDAR
            saveFileOnPath(file.toString());
        }
    }

    /**
     * Guardar archivo actual
     */
    @FXML
    private void saveFile() {
        String path = getCurrentTab().getId();

        // ES UN EDITOR VACIO
        if (path == null) {
            saveFileAs();
        } else {
            saveFileOnPath(path);
        }
    }

    /**
     * Abrir archivo
     */
    @FXML
    private void openFile() {
        // ABRIR
        FileChooser chooser = new FileChooser();
        chooser.setTitle("Abrir FCA");

        // GUARDAR
        File file = chooser.showOpenDialog(new Stage());

        // ASIGNAR A EDITOR ACTUAL
        if (file != null) {
            Tab currentTab = getCurrentTab();
            TextArea editor = getCurrentEditor();

            // CONFIGURAR PESTAÑA Y EDITOR
            String content = readFile(file);
            editor.setText(content);
            currentTab.setId(file.toString());
            currentTab.setText(file.getName().replaceAll(Character.toString(dotSymbol), ""));
        }
    }

    @FXML
    /**
     * Generar reporte json
     */
    private void genJSON() {
        Reports reports = Reports.getInstance();
        reports.getJSONReport();
    }

    @FXML
    /**
     * Generar reporte tokens
     */
    private void genTokens() {
        Reports reports = Reports.getInstance();
        reports.getTokensReport();
    }

    @FXML
    /**
     * Generar reporte errores
     */
    private void genErrors() {
        Reports reports = Reports.getInstance();
        reports.getErrsReport();
    }

    @FXML
    /**
     * Generar estadistico
     */
    private void genAnalytics() {
        Reports reports = Reports.getInstance();
        reports.getAnalyticsReport();
    }

    /**
     * Cerrar pestaña actual
     */
    @FXML
    private void closeEditorTab() {
        if (tabs.getTabs().size() > 1) {
            // PESTAÑA ACTUAL
            Tab currentTab = getCurrentTab();

            // PREGUNTAR PRIMERO ANTES DE CERRAR
            if (currentTab.getText().charAt(currentTab.getText().length() - 1) == dotSymbol) {
                ButtonType confirm = showDialog("Guardar archivo", "No se han guardado los cambios de esta pestaña,\nes posible que todos los cambios podrian perderse.");

                // GUARDAR ARCHIVO
                if (confirm == ButtonType.OK) {
                    saveFile();
                }
            }

            // CERRAR
            tabs.getTabs().remove(selectedEditor);
        }
    }

    /**
     * Agregar pestaña nueva
     */
    @FXML
    private void addEditorTab() {
        // PESTAÑA
        Tab newTab = new Tab();
        int size = tabs.getTabs().size();
        newTab.setText("Editor");

        // CONTENEDOR
        AnchorPane anchorPane = new AnchorPane();
        anchorPane.setMinHeight(0);
        anchorPane.setMinWidth(0);
        anchorPane.setPrefHeight(219.0);
        anchorPane.setPrefWidth(650.0);
        anchorPane.setStyle("-fx-background-color: #37474F;-fx-background-radius:0 10 10 10;");

        // CONTADOR DE LINEAS
        TextArea linesArea = new TextArea();
        linesArea.setMaxHeight(1.7976931348623157E308);
        linesArea.setLayoutX(5);
        linesArea.setPrefHeight(245.0);
        linesArea.setPrefWidth(37.0);
        linesArea.setMinWidth(0);
        linesArea.setWrapText(true);
        linesArea.setStyle("-fx-text-fill: #ccc;");
        linesArea.getStyleClass().add("line-area");
        linesArea.setFont(Font.font("Fira Code SemiBold", 13));
        linesArea.setEditable(false);
        linesArea.setText("1");

        // EDITOR
        TextArea textArea = new TextArea();
        textArea.setMaxHeight(1.7976931348623157E308);
        textArea.setPrefHeight(245.0);
        textArea.setPrefWidth(565.0);
        textArea.setLayoutX(42);
        textArea.setPromptText("Escribe tu codigo aqui.");
        textArea.setStyle("-fx-text-fill: #fff;");
        textArea.setFont(Font.font("Fira Code SemiBold", 13));
        textArea.setId("");

        // EVENTOS DEL EDITOR
        textArea.textProperty().addListener(new ChangeListener<String>() {
            @Override
            public void changed(ObservableValue<? extends String> observable,
                    String oldValue, String newValue) {

                // OBTENER NUMERO DE LINEAS
                int lines = newValue.split("\n").length;
                Double caretPosition = textArea.scrollTopProperty().get();
                String newLines = "";

                // AGREGAR A CONTADOR DE LINEAS
                for (int i = 0; i < lines; i++) {
                    newLines += (i + 1) + "\n";
                }
                linesArea.setText(newLines);
                linesArea.scrollTopProperty().setValue(caretPosition);

                // AGREGAR SIMBOLO DE GUARDADO
                if (!newTab.getText().isEmpty()) {
                    if (newTab.getText().charAt(newTab.getText().length() - 1) != dotSymbol) {
                        newTab.setText(newTab.getText() + " " + dotSymbol);
                    }
                }
            }
        });

        // SINCRONIZAR SCROLL DE LINEAS Y EDITOR
        textArea.scrollTopProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> ov, Number oldVal, Number newVal) {
                linesArea.scrollTopProperty().setValue(newVal.intValue());
            }
        });

        // SELECCIONAR PESTAÑA
        newTab.setOnSelectionChanged(e -> {
            selectedEditor = tabs.getSelectionModel().getSelectedIndex();
        });

        // AGREGAR ELEMENTOS
        anchorPane.getChildren().add(textArea);
        anchorPane.getChildren().add(linesArea);
        newTab.setContent(anchorPane);
        tabs.getTabs().add(newTab);
        tabs.getSelectionModel().selectLast();
        selectedEditor = size;
        textArea.requestFocus();
    }

    /**
     * Limpiar consola
     */
    @FXML
    private void clear() {
        clearOutput(true);
    }

    /**
     * Compilar editor actual
     */
    @FXML
    private void compile() {
        // GUARDAR EL EDITOR PRIMERO
        saveFile();

        // LIMPIAR REPORTES ANTERIORES
        Reports reports = Reports.getInstance();
        reports.cleanProps();

        // SELECCIONAR EDITOR
        Tab currentTab = getCurrentTab();
        TextArea editor = getCurrentEditor();

        // LIMPIAR CONSOLA
        clearOutput(false);

        try {
            // ANALIZADOR
            FCAParser parser = new FCAParser(new FCAScanner(new StringReader(editor.getText())));
            parser.setFilePath(currentTab.getText());

            // ANALIZAR
            parser.parse();

            // COMPARAR
            reports.compare();
            clearOutput(false);

            // ANALIZAR OTRA VEZ Y GRAFICAR
            FCAParser parser2 = new FCAParser(new FCAScanner(new StringReader(editor.getText())));
            parser2.setFilePath(currentTab.getText());
            parser2.parse();

            reports.generateGraphs();
        } catch (Exception ex) {
            System.out.println(ex);
            ex.printStackTrace();
        }
    }
}
