package com.etop_pos_plugin.utils;

import java.util.LinkedList;
import java.util.List;
import java.util.Random;

public class GenerateReceiptNo {
    public static Long getTransactionReferenceNumber(String str) {

        StringBuilder result = new StringBuilder();

        for (int i = 0; i < str.length(); i++) {

            char ch = str.charAt(i);

            if (Character.isLetter(ch)) {
                char initialCharacter = Character.isUpperCase(ch) ? 'A' : 'a';
                result = new StringBuilder(result.toString().concat(String.valueOf((ch - initialCharacter + 1))));
            } else result.append(ch);
        }

        return Long.parseLong(result.toString());
    }
    public static String shuffle(String text) {
        List<Character> characters = new LinkedList<>();
        for(char c:text.toCharArray()){
            characters.add(c);
        }
        StringBuilder result = new StringBuilder();
        for (int index=0;index<text.length();index++){
            int randomPosition = new Random().nextInt(characters.size());
            result.append(characters.get(randomPosition));
            characters.remove(randomPosition);
        }
        return result.toString();
    }
}
