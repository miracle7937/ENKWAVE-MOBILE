package com.etop_pos_plugin.activity;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;

import com.etop_pos_plugin.etop_pos_plugin.R;
import com.etop_pos_plugin.utils.ETopPayProcessor;
import com.etop_pos_plugin.utils.CustomerData;

import java.util.HashMap;
import java.util.Objects;

public class InsertCardActivity extends AppCompatActivity {
    private static final int REQUEST_CODE_SECOND_ACTIVITY = 1;
    private static final int RESULT_CODE_REMOVED = 2;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_insert_card);

        HashMap<String, String> transactionData =  (HashMap<String, String>) getIntent().getSerializableExtra("transaction_data");

//          new ETopPayProcessor(this).payNow( transactionData, false);


    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == REQUEST_CODE_SECOND_ACTIVITY) {
            if (resultCode == RESULT_CODE_REMOVED) {
              finish();
            }
        }
    }
}