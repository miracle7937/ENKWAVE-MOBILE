package com.etop_pos_plugin.networking.miscellaneous;


import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.security.Key;
import java.security.MessageDigest;

public class EncDec {
    private String TAG = EncDec.class.getSimpleName();

    public String decryptECB(String input, String ke) throws Exception
    {
        byte[] tmp = h2b(ke);
        byte[] key = new byte[24];
        System.arraycopy(tmp, 0, key, 0, 16);
        System.arraycopy(tmp, 0, key, 16, 8);
        Cipher cipher = Cipher.getInstance("DESede/ECB/NoPadding");
        cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(key, "DESede"));
        byte[] plaintext = cipher.doFinal(h2b(input));
        return b2h(plaintext);
    }

    private static byte[] h2b(String hex)
    {
        if ((hex.length() & 0x01) == 0x01)
            throw new IllegalArgumentException();
        byte[] bytes = new byte[hex.length() / 2];
        for (int idx = 0; idx < bytes.length; ++idx) {
            int hi = Character.digit((int) hex.charAt(idx * 2), 16);
            int lo = Character.digit((int) hex.charAt(idx * 2 + 1), 16);
            if ((hi < 0) || (lo < 0))
                throw new IllegalArgumentException();
            bytes[idx] = (byte) ((hi << 4) | lo);
        }
        return bytes;
    }

    private static String b2h(byte[] bytes)
    {
        char[] hex = new char[bytes.length * 2];
        for (int idx = 0; idx < bytes.length; ++idx) {
            int hi = (bytes[idx] & 0xF0) >>> 4;
            int lo = (bytes[idx] & 0x0F);
            hex[idx * 2] = (char) (hi < 10 ? '0' + hi : 'A' - 10 + hi);
            hex[idx * 2 + 1] = (char) (lo < 10 ? '0' + lo : 'A' - 10 + lo);
        }
        return new String(hex);
    }

    public String getClearKey(String transport, String nibss) throws Exception {
        return  decryptECB(nibss, transport);
    }

    public String getMacNibss(String seed, byte[] macDataBytes) throws Exception{
        byte [] keyBytes = h2b(seed);
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        digest.update(keyBytes, 0, keyBytes.length);
        digest.update(macDataBytes, 0, macDataBytes.length);
        byte[] hashedBytes = digest.digest();
        String hashText = b2h(hashedBytes);
        hashText = hashText.replace(" ", "");
        if (hashText.length() < 64) {
            int numberOfZeroes = 64 - hashText.length();
            String zeroes = "";
            String temp = hashText.toString();
            for (int i = 0; i < numberOfZeroes; i++)
                zeroes = zeroes + "0";
            temp = zeroes + temp;
            return temp;
        }
        return hashText;
    }

    private byte[] packData(byte[] data) {
        int len = data.length;
        byte buf[] = new byte[len + 2];
        buf[0] = (byte) (len >> 8 & 255);
        buf[1] = (byte) (len & 255);
        System.arraycopy(data, 0, buf, 2, len);
        return buf;
    }

    public void sendPacket(String ip, int port, byte[] msg) throws Exception
    {
        System.out.println(TAG+  "INSIDE SENDPACKET");
        Socket socket = null;
        ObjectOutputStream oos = null;
        ObjectInputStream ois = null;
        socket = new Socket(ip, port);
        byte[] bytes = packData(msg);
        oos = new ObjectOutputStream(socket.getOutputStream());
        oos.write(bytes, 0, bytes.length);
        oos.flush();
        //read the server response message
        ois = new ObjectInputStream(socket.getInputStream());
        String message = ois.readUTF();
        System.out.println(TAG+  "RESPONSE: " + message);
        System.out.println(TAG+ "RESPONSE LENGTH: " + message.length());
        //close resources
        ois.close();
        oos.close();
        socket.close();
    }

    public static byte[] des3EncodeECB(byte[] key, byte[] data) throws Exception {
        Key deskey = null;
        DESedeKeySpec spec = new DESedeKeySpec(key);
        SecretKeyFactory keyfactory = SecretKeyFactory.getInstance("desede");
        deskey = keyfactory.generateSecret(spec);
        Cipher cipher = Cipher.getInstance("desede" + "/ECB/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, deskey);
        byte[] bOut = cipher.doFinal(data);
        return bOut;
    }


    public static byte[] des3DecodeECB(byte[] key, byte[] data) throws Exception {
        Key deskey = null;
        DESedeKeySpec spec = new DESedeKeySpec(key);
        SecretKeyFactory keyfactory = SecretKeyFactory.getInstance("desede");
        deskey = keyfactory.generateSecret(spec);

        Cipher cipher = Cipher.getInstance("desede" + "/ECB/NoPadding");	//PKCS5Padding");

        cipher.init(Cipher.DECRYPT_MODE, deskey);

        byte[] bOut = cipher.doFinal(data);

        return bOut;
    }


    public static byte[] des3EncodeCBC(byte[] key, byte[] keyiv, byte[] data) throws Exception {
        Key deskey = null;
        DESedeKeySpec spec = new DESedeKeySpec(key);
        SecretKeyFactory keyfactory = SecretKeyFactory.getInstance("desede");
        deskey = keyfactory.generateSecret(spec);

        Cipher cipher = Cipher.getInstance("desede" + "/CBC/PKCS5Padding");
        IvParameterSpec ips = new IvParameterSpec(keyiv);
        cipher.init(Cipher.ENCRYPT_MODE, deskey, ips);
        byte[] bOut = cipher.doFinal(data);

        return bOut;
    }

    /**
     * CBC����
     * @param key ��Կ
     * @param keyiv IV
     * @param data Base64���������
     * @return ����
     * @throws Exception
     */
    public static byte[] des3DecodeCBC(byte[] key, byte[] keyiv, byte[] data) throws Exception {
        Key deskey = null;
        DESedeKeySpec spec = new DESedeKeySpec(key);
        SecretKeyFactory keyfactory = SecretKeyFactory.getInstance("desede");
        deskey = keyfactory.generateSecret(spec);

        Cipher cipher = Cipher.getInstance("desede" + "/CBC/PKCS5Padding");
        IvParameterSpec ips = new IvParameterSpec(keyiv);

        cipher.init(Cipher.DECRYPT_MODE, deskey, ips);

        byte[] bOut = cipher.doFinal(data);

        return bOut;
    }

    /**
     * ����������
     * @param src1
     * @param src2
     * @return
     */
/*    private static byte[] XOR(byte[] src1, byte[] src2, int srclen) {
    	byte[] bOut = new byte[srclen];
    	int i=0;

    	for (i=0; i<srclen; i++) {
    		bOut[i] = (byte) (src1[i] ^ src2[i]);
    	}

    	return bOut;
    }*/

//
//    public static String threeDesDecrypt(String keyComponent1, String keyComponent2, String encryptedToken) {
//        byte[] keyB1 = hexToByte(keyComponent1 + keyComponent1.substring(0, 16));
//        byte[] keyB2 = hexToByte(keyComponent2 + keyComponent2.substring(0, 16));
//
//        for(int i = 0; i < keyB2.length; ++i) {
//            keyB1[i] ^= keyB2[i];
//        }
//
//        SecretKey key = readKey(keyB1);
//        return Decrypt(key, encryptedToken);
//    }
//
//    public static String threeDesDecrypt(String encryptedToken, String key) {
//        byte[] mkB = hexToByte(key + key.substring(0, 16));
//        SecretKey keyse = readKey(mkB);
//        return Decrypt(keyse, encryptedToken);
//    }
}

