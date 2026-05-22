package com.etop_pos_plugin.utils;

import android.os.Handler;
import android.os.Looper;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;


public class PosEventStreamHandler
        implements EventChannel.StreamHandler {
    public EventChannel.EventSink events;

    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.events = events;
    }

    @Override
    public void onCancel(Object arguments) {
    }

    public void sendEvent(final String name, Object data) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("event", name);
        map.put("data", data);
        Runnable runnable = () -> events.success(map);
        mainHandler.post(runnable);
    }
}