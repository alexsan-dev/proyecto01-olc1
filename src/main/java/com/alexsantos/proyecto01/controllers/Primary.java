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

    private int selectedEditor = 0;
    private char dotSymbol = '•';

    @FXML
    private JFXTabPane tabs;
    @FXML
    private TextFlow output;
    @FXML
    private StackPane mainPane;
    @FXML
    private VBox mainContainer;

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
            currentTab.setText(file.getName().replace(Character.toString(dotSymbol), ""));
            currentTab.setId(file.toString());

            saveFileOnPath(file.toString());
        }
    }

    @FXML
    private void saveFile() {
        String path = tabs.getTabs().get(selectedEditor).getId();
        if (path == null) {
            saveFileAs();
        } else {
            saveFileOnPath(path);
        }
    }

    @FXML
    private void saveFileOnPath(String path) {
        Tab currentTab = tabs.getTabs().get(selectedEditor);
        AnchorPane anchorPane = (AnchorPane) currentTab.getContent();
        TextArea textArea = (TextArea) anchorPane.getChildren().get(0);

        BufferedWriter writer = null;
        try {
            writer = new BufferedWriter(new FileWriter(path));
            writer.write(textArea.getText());
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

            String content = readFile(file);
            textArea.setText(content);
            currentTab.setId(file.toString());
            currentTab.setText(file.getName().replaceAll(Character.toString(dotSymbol), ""));
        }
    }

    @FXML
    private void closeEditorTab() {
        if (tabs.getTabs().size() > 1) {
            Tab currentTab = tabs.getTabs().get(selectedEditor);
            if (currentTab.getText().charAt(currentTab.getText().length() - 1) != dotSymbol) {
                tabs.getTabs().remove(selectedEditor);
            } else {
                ButtonType confirm = showDialog("Guardar archivo", "No se han guardado los cambios de esta pestaña,\nes posible que todos los cambios podrian perderse.");

                if (confirm == ButtonType.OK) {
                    saveFile();
                }

                tabs.getTabs().remove(selectedEditor);
            }
        }
    }

    public ButtonType showDialog(String title, String content) {
        // EFECTO
        BoxBlur blur = new BoxBlur(5, 5, 5);
        mainContainer.setEffect(blur);

        // Alert
        Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
        alert.setContentText(content);
        alert.setTitle(title);
        alert.showAndWait();
        mainContainer.setEffect(null);
        return alert.getResult();
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
        anchorPane.setStyle("-fx-background-color: #37474F;-fx-background-radius:0 10 10 10;");

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

        TextArea textArea = new TextArea();
        textArea.setMaxHeight(1.7976931348623157E308);
        textArea.setPrefHeight(245.0);
        textArea.setPrefWidth(565.0);
        textArea.setLayoutX(42);
        textArea.setPromptText("Escribe tu codigo aqui.");
        textArea.setStyle("-fx-text-fill: #fff;");
        textArea.setFont(Font.font("Fira Code SemiBold", 13));
        textArea.setId("");

        textArea.textProperty().addListener(new ChangeListener<String>() {
            @Override
            public void changed(ObservableValue<? extends String> observable,
                    String oldValue, String newValue) {

                int lines = newValue.split("\n").length;
                Double caretPosition = textArea.scrollTopProperty().get();
                String newLines = "";

                for (int i = 0; i < lines; i++) {
                    newLines += (i + 1) + "\n";
                }
                linesArea.setText(newLines);
                linesArea.scrollTopProperty().setValue(caretPosition);

                if (!newTab.getText().isEmpty()) {
                    if (newTab.getText().charAt(newTab.getText().length() - 1) != dotSymbol) {
                        newTab.setText(newTab.getText() + " " + dotSymbol);
                    }
                }
            }
        });

        textArea.scrollTopProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> ov, Number oldVal, Number newVal) {
                linesArea.scrollTopProperty().setValue(newVal.intValue());
            }
        });

        newTab.setOnSelectionChanged(e -> {
            selectedEditor = tabs.getSelectionModel().getSelectedIndex();
        });

        anchorPane.getChildren().add(textArea);
        anchorPane.getChildren().add(linesArea);
        newTab.setContent(anchorPane);
        tabs.getTabs().add(newTab);
        tabs.getSelectionModel().selectLast();
        selectedEditor = size;
        textArea.requestFocus();
    }

    @FXML
    private void clear() {
        clearOutput(true);
    }

    private void clearOutput(boolean isPlaceholder) {
        Text placeholder = new Text("Salida de consola y errores.");
        placeholder.setStyle("-fx-font-smoothing-type: lcd;-fx-fill: #fff;-fx-font-family: Fira Code;");
        output.getChildren().clear();

        if (isPlaceholder) {
            output.getChildren().add(placeholder);
        }
    }

    @FXML
    private void compile() {
        saveFile();

        Reports reports = Reports.getInstance();
        reports.cleanProps();

        Tab currentTab = tabs.getTabs().get(selectedEditor);
        AnchorPane anchorPane = (AnchorPane) currentTab.getContent();
        TextArea textArea = (TextArea) anchorPane.getChildren().get(0);
        clearOutput(false);

        try {
            FCAParser parser = new FCAParser(new FCAScanner(new StringReader(textArea.getText())));
            parser.parse();
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    public PrintStream getConsole(boolean isErr) {
        PrintStream out = new PrintStream(new OutputStream() {
            @Override
            public void write(int b) throws IOException {
                Text line = new Text("" + (char) (b & 0xFF));
                line.setStyle("-fx-font-smoothing-type: lcd;-fx-fill:" + (isErr ? "#F44336;-fx-font-weight:bold;" : "#fff;") + "-fx-font-family: Fira Code;");
                output.getChildren().add(line);
            }
        });
        return out;
    }

    public void initialize() {
        addEditorTab();
        clearOutput(true);
        System.setOut(getConsole(false));
        System.setErr(getConsole(true));
    }
}
