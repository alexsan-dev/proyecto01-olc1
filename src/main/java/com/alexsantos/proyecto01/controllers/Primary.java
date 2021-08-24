package com.alexsantos.proyecto01.controllers;

import com.alexsantos.proyecto01.analyzer.fca.FCAParser;
import com.alexsantos.proyecto01.analyzer.fca.FCAScanner;
import com.jfoenix.controls.JFXTabPane;
import java.io.*;
import javafx.fxml.FXML;
import javafx.scene.control.Tab;
import javafx.scene.control.TextArea;
import javafx.scene.layout.AnchorPane;
import javafx.scene.text.Font;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

public class Primary {

    private int selectedEditor = 0;

    @FXML
    private JFXTabPane tabs;
    @FXML
    private TextArea output;

    private String readFile(File file) {
        // BUFFER
        StringBuilder stringBuffer = new StringBuilder();
        BufferedReader bufferedReader = null;

        try {
            // leer
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

    @FXML
    private void saveFileAs() {
        FileChooser fileChooser = new FileChooser();
        FileChooser.ExtensionFilter extFilter = new FileChooser.ExtensionFilter("Archivos FCA (*.fca)", "*.fca");
        fileChooser.getExtensionFilters().add(extFilter);
        File file = fileChooser.showSaveDialog(new Stage());

        if (file != null) {
            Tab currentTab = tabs.getTabs().get(selectedEditor);
            saveFileOnPath(file.toString());
            currentTab.setText(file.getName());
            currentTab.setId(file.toString());
        }
    }

    @FXML
    private void saveFile() {
        String path = tabs.getTabs().get(selectedEditor).getId();
        saveFileOnPath(path);
    }

    @FXML
    private void saveFileOnPath(String path) {
        AnchorPane anchorPane = (AnchorPane) tabs.getTabs().get(selectedEditor).getContent();
        TextArea textArea = (TextArea) anchorPane.getChildren().get(0);
        String content = textArea.getText();

        BufferedWriter writer = null;
        try {
            writer = new BufferedWriter(new FileWriter(path));
            writer.write(content);
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

    @FXML
    private void openFile() {
        // ABRIR
        FileChooser chooser = new FileChooser();
        chooser.setTitle("Abrir FCA");

        // GUARDAR
        File file = chooser.showOpenDialog(new Stage());

        // ASIGNAR A EDITOR ACTUAL
        if (file != null) {
            Tab currentTab = tabs.getTabs().get(selectedEditor);
            AnchorPane anchorPane = (AnchorPane) currentTab.getContent();
            TextArea textArea = (TextArea) anchorPane.getChildren().get(0);
            textArea.setText(readFile(file));
            currentTab.setId(file.toString());
            currentTab.setText(file.getName());
        }
    }

    @FXML
    private void closeEditorTab() {
        if (tabs.getTabs().size() > 1) {
            tabs.getTabs().remove(selectedEditor);
        }
    }

    @FXML
    private void addEditorTab() {
        Tab newTab = new Tab();
        int size = tabs.getTabs().size();
        newTab.setText("Editor");

        AnchorPane anchorPane = new AnchorPane();
        anchorPane.setMinHeight(0);
        anchorPane.setMinWidth(0);
        anchorPane.setPrefHeight(219.0);
        anchorPane.setPrefWidth(650.0);

        TextArea textArea = new TextArea();
        textArea.setMaxHeight(1.7976931348623157E308);
        textArea.setPrefHeight(245.0);
        textArea.setPrefWidth(610.0);
        textArea.setPromptText("Escribe tu codigo aqui.");
        textArea.setStyle("-fx-text-fill: #fff;");
        textArea.setFont(Font.font("Fira Code SemiBold", 13));
        textArea.setWrapText(true);
        textArea.setId("");

        newTab.setOnSelectionChanged(e -> {
            selectedEditor = tabs.getSelectionModel().getSelectedIndex();
        });

        anchorPane.getChildren().add(textArea);
        newTab.setContent(anchorPane);
        tabs.getTabs().add(newTab);
        tabs.getSelectionModel().selectLast();
        selectedEditor = size;
    }

    @FXML
    private void clear() {
        output.setText("");
    }

    @FXML
    private void compile() {
        Tab currentTab = tabs.getTabs().get(selectedEditor);
        AnchorPane anchorPane = (AnchorPane) currentTab.getContent();
        TextArea textArea = (TextArea) anchorPane.getChildren().get(0);
        output.setText("");

        try {
            FCAParser parser = new FCAParser(new FCAScanner(new StringReader(textArea.getText())));
            parser.parse();
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    public void initialize() {
        addEditorTab();

        PrintStream out = new PrintStream(new OutputStream() {
            @Override
            public void write(int b) throws IOException {
                output.appendText("" + (char) (b & 0xFF));
            }
        });

        System.setOut(out);
    }
}
