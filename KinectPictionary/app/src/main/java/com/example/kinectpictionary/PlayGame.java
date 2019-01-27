package com.example.kinectpictionary;

import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.opencsv.CSVReader;

import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class PlayGame extends AppCompatActivity {

    private TextView mTextMessage;
    private TextView nextToPlay;
    private String[] players;
    private List categories;

    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()) {
                case R.id.navigation_home:
                    mTextMessage.setText(R.string.title_home);
                    return true;
                case R.id.navigation_dashboard:
                    mTextMessage.setText(R.string.title_dashboard);
                    return true;
                case R.id.navigation_notifications:
                    mTextMessage.setText(R.string.title_notifications);
                    return true;
            }
            return false;
        }
    };
    private int numPlayers;
    private int[] score;

    public void getWord(View view) {
        Random rand = new Random();
        int value = rand.nextInt(categories.size());

        TextView word = findViewById(R.id.textView2);
        word.setText(categories.get(value).toString());

    }

    public void accepted(View view) {
        TextView name = findViewById(R.id.editText);
        String nameString = name.getText().toString();
        for (int i = 0; i < numPlayers; i++) {
            if (nameString.matches(players[i])) {
                score[i]++;
            }

        }
        newPlayer();
    }

    public void endGame(View view) {
        if (score != null){
            Intent intent = new Intent(PlayGame.this, Scoreboard.class);
            Log.d("Playgame", Arrays.toString(players));
            intent.putExtra("players", players);
            intent.putExtra("scores", score);
            startActivity(intent);
        } else {

            Toast.makeText(this, "The specified file was not found", Toast.LENGTH_SHORT).show();
        }

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_play_game);
               Bundle bundle = getIntent().getExtras();
        players = bundle.getStringArray("players");
        numPlayers = bundle.getInt("numplayers");

        score = new int[numPlayers];
        for (int i = 0; i < numPlayers; i++) {
            score[i] = 0;
        }

        newPlayer();

        mTextMessage = (TextView) findViewById(R.id.message);
        BottomNavigationView navigation = (BottomNavigationView) findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);

        loadWords();
    }

    private void newPlayer() {
        nextToPlay = findViewById(R.id.textView5);
        Random rand = new Random();
        int value = rand.nextInt(numPlayers);
        nextToPlay.setText(players[value]);
    }
    private void loadWords() {
        try {
            InputStream inputStream = getResources().openRawResource(R.raw.categories);
            CSVFile csvFile = new CSVFile(inputStream);
            categories = csvFile.read();
        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(this, "The specified file was not found", Toast.LENGTH_SHORT).show();
        }
    }

}
