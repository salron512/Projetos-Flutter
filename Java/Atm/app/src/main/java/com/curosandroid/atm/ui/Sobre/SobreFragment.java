package com.curosandroid.atm.ui.Sobre;

import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.curosandroid.atm.R;

import mehdi.sakout.aboutpage.AboutPage;
import mehdi.sakout.aboutpage.Element;

/**
 * A simple {@link Fragment} subclass.
 * Use the {@link SobreFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class SobreFragment extends Fragment {

    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    public SobreFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment SobreFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static SobreFragment newInstance(String param1, String param2) {
        SobreFragment fragment = new SobreFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        String descricao = "A Atm Consultoria tem como apoir organizações" +
                "que desejam alcançar o sucesso atráves da excelendia em gestão e da busca " +
                "pela qualidade ";
        Element versao = new Element();
        versao.setTitle("Vesão 1.0");

       return new AboutPage(getActivity())
               .setImage(R.drawable.logo)
               .setDescription(descricao)




               .addGroup("Entre em contato")
               .addEmail("atendimento@atmconsultoria.com.br", "Envie um e-mail")
               .addWebsite("https://www.google.com/", "Acese nosso site")

               .addGroup("Redes sociais")
               .addFacebook("andrericardovicensotti", "Facebook")
               .addInstagram("andrericardovicensotti", "Instagram")
               .addTwitter("andrericardovicensotti", "Twitter")
               .addYoutube("UCxDFRhF3Y1A_Gd0-cF8gbqQ", "Youtube")
               .addGitHub("andrericardovicensotti", "GitHub")
               .addPlayStore("com.facebook.katana", "Download App")
               .addItem(versao)

               .create();


        //return inflater.inflate(R.layout.fragment_sobre, container, false);
    }
}