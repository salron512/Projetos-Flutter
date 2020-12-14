package com.curosandroid.compomentesbasicos;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.google.android.material.textfield.TextInputEditText;

import org.w3c.dom.Text;

public class MainActivity extends AppCompatActivity {
   private EditText campoNome;
   private TextInputEditText campoEmail;
   private  TextView resultado;

   private CheckBox checkVerde;
   private CheckBox checkBranco;
   private CheckBox checkVermelho;

   private RadioButton sexoMasculino, sexoFeminino;
   private RadioGroup opcaoSexo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        campoNome  = findViewById(R.id.editNome);
        campoEmail = findViewById(R.id.editEmail);
        resultado = findViewById(R.id.textResultado);

        checkVerde = findViewById(R.id.checkVerde);
        checkBranco = findViewById(R.id.checkBranco);
        checkVermelho = findViewById(R.id.checkVermelho);

        sexoFeminino = findViewById(R.id.radioButtonF);
        sexoMasculino = findViewById(R.id.radioButtonM);
        opcaoSexo = findViewById(R.id.radioGrupSexo);
        radioButton();

    }

    public void  radioButton(){

        opcaoSexo.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup radioGroup, int i) {
                if(i == R.id.radioButtonM){
                    resultado.setText("Masculino");
                } else if(i == R.id.radioButtonF){
                    resultado.setText("Feminino");
                }
            }
        });

      /*  if(sexoMasculino.isChecked()){
            resultado.setText("Masculino");

        }else if (sexoFeminino.isChecked()){
             resultado.setText("Masculino");

        }*/

    }

    public void enviar(View view){
        //checkBox();
        //radioButton();

/*
        String nome = campoNome.getText().toString();
        String email = campoEmail.getText().toString();
        resultado.setText("Nome: "+ nome +" e-mail: " + email);
        */


    }


    public void checkBox(){

        String texto = "";

        if(checkVerde.isChecked() ) {
            //texto = "verde selecionado ";

        }
        if(checkBranco.isChecked() ) {
            texto = texto + "branco selecionado ";

        }
        if(checkVermelho.isChecked() ) {
            texto = texto + "vermelho selecionado ";

        }
        resultado.setText(texto);

    }

    public void limpar(View view){
        campoNome.setText("");
        campoEmail.setText("");
        resultado.setText("Resultado");


    }
}