package com.etop_pos_plugin.networking.miscellaneous;


import com.etop_pos_plugin.utils.Debug;

import org.bouncycastle.jcajce.io.CipherOutputStream;

import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.Arrays;

public class Decrypter {
    public static SecretKey readKey(byte[] rawkey) {
        try {
            DESedeKeySpec keyspec = new DESedeKeySpec(rawkey);
            SecretKeyFactory keyfactory = SecretKeyFactory.getInstance("DESede");
            SecretKey key = keyfactory.generateSecret(keyspec);
            key = keyfactory.translateKey(key);
            return key;
        } catch (InvalidKeySpecException var4) {
            return null;
        } catch (NoSuchAlgorithmException var5) {
            return null;
        } catch (InvalidKeyException var6) {
            return null;

        }
    }

    public static String threeDesDecrypt(String encryptedToken, String key) {
        byte[] mkB = hexToByte(key + key.substring(0, 16));
        SecretKey keyse = readKey(mkB);
        return Decrypt(keyse, encryptedToken);
    }


    public static byte[] hexToByte(String hexString) {
        String str = new String("0123456789ABCDEF");
        byte[] bytes = new byte[hexString.length() / 2];
        int i = 0;

        for(int var4 = 0; i < hexString.length(); ++i) {
            byte firstQuad = (byte)(str.indexOf(hexString.charAt(i)) << 4);
            ++i;
            byte secondQuad = (byte)str.indexOf(hexString.charAt(i));
            bytes[var4++] = (byte)(firstQuad | secondQuad);
        }

        return bytes;
    }
    public static String Decrypt(Key key, String cipherComp) {
        try {
            Cipher cipher = Cipher.getInstance("DESede/ECB/NoPadding");
            cipher.init(2, key);
            ByteArrayOutputStream bytes = new ByteArrayOutputStream();
            byte[] ciphertext = hexToByte(cipherComp);
            CipherOutputStream out = new CipherOutputStream(bytes, cipher);
            out.write(ciphertext);
            out.flush();
            out.close();
            byte[] deciphertext = bytes.toByteArray();
            bytes.flush();
            bytes.close();
            String decrypted = ToHexString(deciphertext);
            Arrays.fill(ciphertext, (byte) 0);
            Arrays.fill(deciphertext, (byte) 0);
            return decrypted;
        } catch (IOException var8) {
            return null;
        } catch (NoSuchPaddingException var9) {
            return null;
        } catch (NoSuchAlgorithmException var10) {
            return null;
        } catch (InvalidKeyException var11) {
            return null;
        }
    }
    public static String ToHexString(byte[] toAsciiData) {
        String hexString = "";
        byte[] var2 = toAsciiData;
        int var3 = toAsciiData.length;

        for (int var4 = 0; var4 < var3; ++var4) {
            byte b = var2[var4];
            hexString = hexString + String.format("%02X", b);
        }

        return hexString;
    }
    public static String threeDesDecryptA(String keyComponent1, String keyComponent2, String encryptedToken) {
        byte[] keyB1 = hexToByte(keyComponent1 + keyComponent1.substring(0, 16));
        byte[] keyB2 = hexToByte(keyComponent2 + keyComponent2.substring(0, 16));

        for(int i = 0; i < keyB2.length; ++i) {
            keyB1[i] ^= keyB2[i];
        }



        SecretKey key = readKey(keyB1);


        Debug.print("----------ALGO KEY II"+ key.getAlgorithm());

        return Decrypt(key, encryptedToken);
    }

    }
