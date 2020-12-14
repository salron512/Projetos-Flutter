package com.curosandroid.reciclerview.activity.activity;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.curosandroid.reciclerview.R;
import com.curosandroid.reciclerview.activity.RecyclerItemClickListener;
import com.curosandroid.reciclerview.activity.adapter.Adapter;
import com.curosandroid.reciclerview.activity.model.Filme;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {
    private RecyclerView recyclerView;
    private List<Filme> listaFilmes = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        recyclerView = findViewById(R.id.recyclerView);
        this.criarFilmes();

        Adapter adapter = new Adapter(listaFilmes);

        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(getApplicationContext());
        recyclerView.setLayoutManager(layoutManager);
        recyclerView.setHasFixedSize(true);
        recyclerView.addItemDecoration(new DividerItemDecoration(this, LinearLayout.VERTICAL));
        recyclerView.setAdapter(adapter);

        //evento click
        recyclerView.addOnItemTouchListener(
                new RecyclerItemClickListener(
                        getApplicationContext(),
                        recyclerView,
                        new RecyclerItemClickListener.OnItemClickListener() {
                            @Override
                            public void onItemClick(View view, int position) {
                                Filme filme = listaFilmes.get(position);
                                Toast.makeText(
                                        getApplicationContext(),
                                        "Item pressionado "+ filme.getTitulo(),
                                        Toast.LENGTH_SHORT
                                ).show();
                            }

                            @Override
                            public void onLongItemClick(View view, int position) {
                                Filme filme = listaFilmes.get(position);
                                Toast.makeText(
                                        getApplicationContext(),
                                        "Click longo "+ filme.getTitulo(),
                                        Toast.LENGTH_SHORT
                                ).show();

                            }

                            @Override
                            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

                            }
                        }
                )

        );


    }
    public  void criarFilmes(){
        Filme filme = new Filme("Liga da Justiça","Ficção","2017");
        this.listaFilmes.add(filme);
        filme = new Filme("Mulher Maravilha","Fantasia","2018");
        this.listaFilmes.add(filme);
        filme = new Filme("Capitão América - Guerra Civíl","Aventura","2018");
        this.listaFilmes.add(filme);
        filme = new Filme("Capitão América - Guerra Civíl","Aventura","2018");
        this.listaFilmes.add(filme);
        filme = new Filme("IT: a Coisa","Drama/Terror","2017");
        this.listaFilmes.add(filme);
        filme = new Filme("Homem Aranha - Devoltada ao lar","Aentura","2017");
        this.listaFilmes.add(filme);
        filme = new Filme("Pica-Pau: O Filme","Comédia/Animação","2017");
        this.listaFilmes.add(filme);
        filme = new Filme("A Múnia","Terror","2017");
        this.listaFilmes.add(filme);
        filme = new Filme("Meu Malvado Favorito","Comédia","2017");
        this.listaFilmes.add(filme);
        filme = new Filme("A Bela e a Fera","Romance","2017");
        this.listaFilmes.add(filme);

    }
}