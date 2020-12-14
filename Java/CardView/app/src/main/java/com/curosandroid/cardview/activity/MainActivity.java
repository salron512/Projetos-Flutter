package com.curosandroid.cardview.activity;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;
import android.widget.LinearLayout;

import com.curosandroid.cardview.R;

import com.curosandroid.cardview.activity.Model.Postagens;
import com.curosandroid.cardview.activity.adapter.PostagemAdapter;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {
    private RecyclerView recyclerPostagem;
    private List<Postagens> postagens = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        recyclerPostagem = findViewById(R.id.recyclerView);

        //Define layout
       LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayout.VERTICAL);

        recyclerPostagem.setLayoutManager(layoutManager);
        prepaparaPostagens();

        PostagemAdapter postagemAdapter = new PostagemAdapter(postagens);
        recyclerPostagem.setAdapter(postagemAdapter);
    }
    public void prepaparaPostagens(){
        Postagens p = new Postagens("André Ricardo Vicensotti", "#tbt Viagem legal", R.drawable.imagem1);
        this.postagens.add(p);
        p = new Postagens("Hotel JM", "Viaje e aproveite", R.drawable.imagem2);
        this.postagens.add(p);
        p = new Postagens("Maria Luiza", "#Paris!!!", R.drawable.imagem3);
        this.postagens.add(p);
        p = new Postagens("Marcos Paulo", "Que foto linda", R.drawable.imagem4);
        this.postagens.add(p);
    }
}