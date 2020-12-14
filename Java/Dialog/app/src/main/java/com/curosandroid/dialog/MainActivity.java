package com.curosandroid.dialog;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }
    public void abrirDialog(View view){
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);
        dialog.setTitle("Título da dialog");
        dialog.setMessage("Mensagen da Dialog");
        dialog.setCancelable(false);
        dialog.setIcon(android.R.drawable.ic_btn_speak_now);

        dialog.setPositiveButton("sim", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                Toast.makeText(
                        getApplicationContext(),
                        "Executar ação ao clicar sim",
                        Toast.LENGTH_SHORT
                ).show();
            }
        });
        dialog.setNegativeButton("Não", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                Toast.makeText(getApplicationContext(),
                        "Executar ação ao clicar não",
                        Toast.LENGTH_SHORT
                ).show();
            }
        });
        dialog.create();
        dialog.show();
    }
}