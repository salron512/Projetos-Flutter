package com.curosandroid.cardview.activity.model.adapter.activity;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;

import com.curosandroid.cardview.R;

import com.curosandroid.cardview.activity.model.adapter.adapter.PostagemAdapter;

public class MainActivity extends AppCompatActivity {
    private RecyclerView recyclerPostagem;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        recyclerPostagem = findViewById(R.id.recyclerView);

        //Define layout
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(this);
        recyclerPostagem.setLayoutManager(layoutManager);
        PostagemAdapter postagemAdapter = new PostagemAdapter();
        recyclerPostagem.setAdapter(postagemAdapter);
    }
}