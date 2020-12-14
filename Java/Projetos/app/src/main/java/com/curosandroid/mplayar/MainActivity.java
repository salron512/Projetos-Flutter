package com.curosandroid.mplayar;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.media.AudioManager;
import android.media.MediaParser;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.SeekBar;

public class MainActivity extends AppCompatActivity {
    private MediaPlayer mediaPlayer;
    private SeekBar seekVolume;
    private AudioManager audioManager;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mediaPlayer = MediaPlayer.create(getApplicationContext(),R.raw.teste);
        incializarSeekBar();
    }
    public void incializarSeekBar(){
        seekVolume = findViewById(R.id.seekVolume);

        audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        int volumeMaximo = audioManager.getStreamMaxVolume(audioManager.STREAM_MUSIC);
        int volumeAtual = audioManager.getStreamVolume(audioManager.STREAM_MUSIC);

        seekVolume.setMax(volumeMaximo);
        seekVolume.setProgress(volumeAtual);
        seekVolume.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {
                audioManager.setStreamVolume(audioManager.STREAM_MUSIC, i,0);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

    }

    public void executarSom(View view){
        if(mediaPlayer != null){
            mediaPlayer.start();
        }

    }
    public void pausaSom(View view){
      if(mediaPlayer.isPlaying()){
          mediaPlayer.pause();
      }
    }
    public void paraSom(View view) {
        if (mediaPlayer.isPlaying()) {
            mediaPlayer.stop();
            mediaPlayer = MediaPlayer.create(getApplicationContext(),R.raw.teste);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(mediaPlayer != null && mediaPlayer.isPlaying()){
            mediaPlayer.stop();
            mediaPlayer.release();
            mediaPlayer = null;
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if(mediaPlayer.isPlaying()){
            mediaPlayer.pause();
        }
    }
}