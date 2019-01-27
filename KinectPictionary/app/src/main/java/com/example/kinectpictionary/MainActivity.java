package com.example.kinectpictionary;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import static android.provider.AlarmClock.EXTRA_MESSAGE;

public class MainActivity extends AppCompatActivity {

    private String[] players = new String[100];
    private TextView mTextMessage;
    public static final String PLAYER_NAME = "com.example.kinectpictionary.MESSAGE";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        mTextMessage = (TextView) findViewById(R.id.message);
        BottomNavigationView navigation = (BottomNavigationView) findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);
    }

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
    private int endOfList = 0;
    private TextView playersTextView;


    /** Called when the user taps the Send button */
        public void addPlayer(View view) {

            EditText editText = (EditText) findViewById(R.id.editText5);
            String player = editText.getText().toString();
            playersTextView = findViewById(R.id.textView4);
            players[endOfList] = player;
            endOfList++;
            String newPlayersString = playersTextView.getText().toString() + "\n " + player;
            playersTextView.setText(newPlayersString);


        }

        public void startGame(View view) {
            Intent intent = new Intent(MainActivity.this, PlayGame.class);
            intent.putExtra("players", players);
            intent.putExtra("numplayers", endOfList);
            startActivity(intent);
        }




}
