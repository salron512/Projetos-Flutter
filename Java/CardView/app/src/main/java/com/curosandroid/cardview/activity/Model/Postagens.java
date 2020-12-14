package com.curosandroid.cardview.activity.Model;

public class Postagens {
    private String nome;
    private String postagens;
    private int imagem;

    public Postagens() {
    }

    public Postagens(String nome, String postagens, int imagem) {
        this.nome = nome;
        this.postagens = postagens;
        this.imagem = imagem;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getPostagens() {
        return postagens;
    }

    public void setPostagens(String postagens) {
        this.postagens = postagens;
    }

    public int getImagem() {
        return imagem;
    }

    public void setImagem(int imagem) {
        this.imagem = imagem;
    }
}
