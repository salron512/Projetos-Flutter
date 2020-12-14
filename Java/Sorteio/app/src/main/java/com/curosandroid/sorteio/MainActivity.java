package com.curosandroid.sorteio;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import java.util.Random;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }
    public void Resultado(View view){
        TextView texto = findViewById(R.id.textoResultado);

        int x = new Random().nextInt(11);
        texto.setText("Numero " + x);
    }
}