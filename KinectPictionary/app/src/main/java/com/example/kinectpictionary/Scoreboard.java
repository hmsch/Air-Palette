package com.example.kinectpictionary;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

public class Scoreboard extends AppCompatActivity {

    private String[] players;
    private int[] score;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.d("Scoreboard", "I'm here");
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scoreboard);
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        Bundle bundle = getIntent().getExtras();
        players = bundle.getStringArray("players");
        score = bundle.getIntArray("scores");

        TextView nextToPlay = findViewById(R.id.textView3);
        String text = "";
        for (int i = 0; i < score.length; i ++) {
            text = text + players[i] +": " + score[i] + "\n";
        }

        nextToPlay.setText(text);
    }

    public void returnToStart(View view) {
        Intent intent = new Intent(Scoreboard.this, MainActivity.class);
        startActivity(intent);
    }

}
