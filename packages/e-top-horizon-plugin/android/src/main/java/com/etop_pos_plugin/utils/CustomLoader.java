package com.etop_pos_plugin.utils;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.TextView;

import com.etop_pos_plugin.etop_pos_plugin.R;

public class CustomLoader {

    private View loaderView;
    private Activity activity;
    private TextView loaderDescription;

    public CustomLoader(Activity activity) {
        this.activity = activity;
    }

    public void showLoader(String description) {
        if (loaderView == null) {
            loaderView = LayoutInflater.from(activity).inflate(R.layout.loader_layout, null);
            ViewGroup rootView = activity.findViewById(android.R.id.content);
            rootView.addView(loaderView);

            loaderDescription = loaderView.findViewById(R.id.loaderDescription);
            startRotationAnimation();
        } else {
            loaderView.setVisibility(View.VISIBLE);
            startRotationAnimation();
        }

        if (loaderDescription != null) {
            loaderDescription.setText(description);
        }
    }

    public void updateText(String description) {

        if (loaderDescription != null) {
            loaderDescription.setText(description);
        }
    }



    public void hideLoader() {
        if (loaderView != null) {
            loaderView.setVisibility(View.GONE);
        }
    }

    private void startRotationAnimation() {
//        Animation rotation = AnimationUtils.loadAnimation(activity, R.anim.rotation_animation);
//        loaderView.findViewById(R.id.loaderProgressBar).startAnimation(rotation);
    }
}
