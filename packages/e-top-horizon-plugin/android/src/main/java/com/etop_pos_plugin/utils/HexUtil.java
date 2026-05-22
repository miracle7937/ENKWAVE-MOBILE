package com.etop_pos_plugin.utils;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.text.DecimalFormat;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.CipherOutputStream;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;


public class HexUtil {
    private static final char[] DIGITS = new char[]{'0', '1', '2', '3', '4',
            '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

    public static String byteToHex(byte b) {
        return ("" + "0123456789ABCDEF".charAt(0xf & b >> 4) + "0123456789ABCDEF".charAt(b & 0xf));
    }

    public static byte[] hexStringToByte(String hex) {
        if(hex == null || hex.length() == 0){
            return null;
        }
        hex = hex.toUpperCase();
        int len = (hex.length() / 2);
        byte[] result = new byte[len];
        char[] achar = hex.toCharArray();
        for (int i = 0; i < len; i++) {
            int pos = i * 2;
            result[i] = (byte) (toByte(achar[pos]) << 4 | toByte(achar[pos + 1]));
        }
        return result;
    }

    public static byte asc_to_bcd(byte asc) {
        byte bcd;

        if ((asc >= '0') && (asc <= '9'))
            bcd = (byte) (asc - '0');
        else if ((asc >= 'A') && (asc <= 'F'))
            bcd = (byte) (asc - 'A' + 10);
        else if ((asc >= 'a') && (asc <= 'f'))
            bcd = (byte) (asc - 'a' + 10);
        else
            bcd = (byte) (asc - 48);
        return bcd;
    }

    public static byte[] ASCII_To_BCD(byte[] ascii, int asc_len) {
        byte[] bcd = new byte[asc_len / 2];
        int j = 0;
        for (int i = 0; i < (asc_len + 1) / 2; i++) {
            bcd[i] = asc_to_bcd(ascii[j++]);
            bcd[i] = (byte) (((j >= asc_len) ? 0x00 : asc_to_bcd(ascii[j++])) + (bcd[i] << 4));
        }
        return bcd;
    }


    public static String bcd2Str(byte[] bytes) {
        StringBuffer temp = new StringBuffer(bytes.length * 2);
        for (int i = 0; i < bytes.length; i++) {
            temp.append((byte) ((bytes[i] & 0xf0) >>> 4));
            temp.append((byte) (bytes[i] & 0x0f));
        }
        return temp.toString().substring(0, 1).equalsIgnoreCase("0") ? temp.toString().substring(1) : temp.toString();
    }

    public static String bcd2str(byte[] bcds) {
        if (null == bcds) {
            return null;
        }
        char[] ascii = "0123456789abcdef".toCharArray();
        byte[] temp = new byte[bcds.length * 2];
        for (int i = 0; i < bcds.length; i++) {
            temp[i * 2] = (byte) ((bcds[i] >> 4) & 0x0f);
            temp[i * 2 + 1] = (byte) (bcds[i] & 0x0f);
        }
        StringBuffer res = new StringBuffer();

        for (int i = 0; i < temp.length; i++) {
            res.append(ascii[temp[i]]);
        }
        return res.toString().toUpperCase();
    }

    public static String mask(String input) {

        int length = input.length() - input.length()/4;
        String s = input.substring(0, length);
        String res = s.replaceAll("[A-Za-z0-9]", "X") + input.substring(length);


        return res;
    }

    public static String amountFormatter(double amount){
        DecimalFormat formatter = new DecimalFormat("#,###.00");
        return formatter.format(amount);

    }


    public static byte hex2Byte(String hex) {
        char[] achar = hex.toUpperCase().toCharArray();
        byte b = (byte) (toByte(achar[0]) << 4 | toByte(achar[1]));
        return b;
    }

    private static byte toByte(char c) {
        byte b = (byte) "0123456789ABCDEF".indexOf(c);
        return b;
    }

    public static String padLeft(String data, int length, char padChar) {
        int remaining = length - data.length();
        String newData = data;

        for(int i = 0; i < remaining; ++i) {
            newData = padChar + newData;
        }

        return newData;
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
            Arrays.fill(ciphertext, (byte)0);
            Arrays.fill(deciphertext, (byte)0);
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

    public static String threeDesDecrypt(String encryptedToken, String key) {
        byte[] mkB = hexToByte(key + key.substring(0, 16));
        SecretKey keyse = readKey(mkB);
        return Decrypt(keyse, encryptedToken);
    }

    public static byte[] int2bytes(int num) {
        byte[] b = new byte[4];
        int mask = 0xff;
        for (int i = 0; i < 4; i++) {
            b[i] = (byte) (num >>> (24 - i * 8));
        }
        return b;
    }

    public static int int2bytes(int d, byte[] outdata, int offset) {
        outdata[offset + 3] = (byte) ((d >> 24) & 0xff);
        outdata[offset + 2] = (byte) ((d >> 16) & 0xff);
        outdata[offset + 1] = (byte) ((d >> 8) & 0xff);
        outdata[offset + 0] = (byte) ((d >> 0) & 0xff);
        return offset + 4;
    }
    public static int bytes2int(byte[] b) {

        int mask = 0xff;
        int temp = 0;
        int res = 0;
        for (int i = 0; i < 4; i++) {
            res <<= 8;
            temp = b[i] & mask;
            res |= temp;
        }
        return res;
    }


    public static int bytes2short(byte[] b) {

        int mask = 0xff;
        int temp = 0;
        int res = 0;
        for (int i = 0; i < 2; i++) {
            res <<= 8;
            temp = b[i] & mask;
            res |= temp;
        }
        return res;
    }

    public static String getBinaryStrFromByteArr(byte[] bArr) {
        String result = "";
        for (byte b : bArr) {
            result += getBinaryStrFromByte(b);
        }
        return result;
    }


    public static String getBinaryStrFromByte(byte b) {
        String result = "";
        byte a = b;
        ;
        for (int i = 0; i < 8; i++) {
            byte c = a;
            a = (byte) (a >> 1);
            a = (byte) (a << 1);
            if (a == c) {
                result = "0" + result;
            } else {
                result = "1" + result;
            }
            a = (byte) (a >> 1);
        }
        return result;
    }

    public static String getBinaryStrFromByte2(byte b) {
        String result = "";
        byte a = b;
        ;
        for (int i = 0; i < 8; i++) {
            result = (a % 2) + result;
            a = (byte) (a >> 1);
        }
        return result;
    }

    public static String getBinaryStrFromByte3(byte b) {
        String result = "";
        byte a = b;
        ;
        for (int i = 0; i < 8; i++) {
            result = (a % 2) + result;
            a = (byte) (a / 2);
        }
        return result;
    }


    public static byte[] toByteArray(int iSource, int iArrayLen) {
        byte[] bLocalArr = new byte[iArrayLen];
        for (int i = 0; (i < 4) && (i < iArrayLen); i++) {
            bLocalArr[i] = (byte) (iSource >> 8 * i & 0xFF);

        }
        return bLocalArr;
    }

    public static byte[] xor(byte[] op1, byte[] op2) {
        if (op1.length != op2.length) {
            throw new IllegalArgumentException("Parameter error, parameter length is different");
        }
        byte[] result = new byte[op1.length];
        for (int i = 0; i < op1.length; i++) {
            result[i] = (byte) (op1[i] ^ op2[i]);
        }
        return result;
    }

    public static byte xorBytes(byte[] op, int start, int end) {
        byte xorResult = 0x00;
        String xorResultStr = "";
        if ((start >= 0) && (start < end) && (end > 1)) {
            for (int i = start; i < end; i++) {
                xorResult = (byte) (xorResult ^ op[i]);
                xorResultStr = xorResultStr + String.format("%02x ", xorResult);
            }
        }
        return xorResult;
    }

    public static final String bytesToHexString(byte[] bArray) {
        if(bArray == null || bArray.length == 0){
            return null;
        }
        StringBuffer sb = new StringBuffer(bArray.length);

        String sTemp;
        int j = 0;
        for (int i = 0; i < bArray.length; i++) {
            sTemp = Integer.toHexString(0xFF & bArray[i]);
            if (sTemp.length() < 2)
                sb.append(0);

            sb.append(sTemp.toUpperCase());
            j++;

        }
        return sb.toString();
    }

    public static String str2HexStr(String str) {
        if(str == null || str.length() == 0){
            return null;
        }
        char[] chars = "0123456789ABCDEF".toCharArray();
        StringBuilder sb = new StringBuilder("");
        byte[] bs = str.getBytes();
        int bit;

        for (int i = 0; i < bs.length; i++) {
            bit = (bs[i] & 0x0f0) >> 4;
            sb.append(chars[bit]);
            bit = bs[i] & 0x0f;
            sb.append(chars[bit]);
        }
        return sb.toString().trim();
    }

    public static byte[] subBytes(byte[] src, int begin, int count) {
        byte[] bs = new byte[count];
        System.arraycopy(src, begin, bs, 0, count);
        return bs;
    }

    public static byte[] mergeBytes(byte[] bytesA, byte[] bytesB) {
        if (bytesA != null && bytesA.length != 0) {
            if (bytesB != null && bytesB.length != 0) {
                byte[] bytes = new byte[bytesA.length + bytesB.length];
                System.arraycopy(bytesA, 0, bytes, 0, bytesA.length);
                System.arraycopy(bytesB, 0, bytes, bytesA.length, bytesB.length);
                return bytes;
            } else {
                return bytesA;
            }
        } else {
            return bytesB;
        }
    }

    public static byte[] merge(byte[]... data) {
        if (data == null) {
            return null;
        } else {
            byte[] bytes = null;

            for(int i = 0; i < data.length; ++i) {
                bytes = mergeBytes(bytes, data[i]);
            }

            return bytes;
        }
    }

    public static byte[] subByte(byte[] srcBytes, int offset, int len) {
        if (srcBytes == null) {
            return null;
        } else if (len <= srcBytes.length && offset + len <= srcBytes.length && offset < srcBytes.length) {
            byte[] bytes;
            if (len == -1) {
                bytes = new byte[srcBytes.length - offset];
                System.arraycopy(srcBytes, offset, bytes, 0, srcBytes.length - offset);
            } else {
                bytes = new byte[len];
                System.arraycopy(srcBytes, offset, bytes, 0, len);
            }

            return bytes;
        } else {
            return null;
        }
    }
    public static String encode(int i) {
        char[] cbuf = new char[8];
        int charPos = cbuf.length - 1;
        do {
            cbuf[charPos--] = DIGITS[i & 0xF];
            i >>>= 4;
            cbuf[charPos--] = DIGITS[i & 0xF];
            i >>>= 4;
        } while (i != 0);
        return new String(cbuf, charPos + 1, cbuf.length - charPos - 1);
    }
    public static String encode(final byte b) {
        return encode(new byte[]{b});
    }

    public static String encode(final byte[] b) {
        final StringBuilder hex = new StringBuilder(b.length * 2);
        for (int i = 0; i < b.length; i++) {
            int hiNibble = b[i] >> 4 & 0xF;
            int loNibble = b[i] & 0xF;
            hex.append(DIGITS[hiNibble]).append(DIGITS[loNibble]);
        }
        return hex.toString();
    }

    public static byte[] decode(String hex) {
        int len = hex.length();
        if (len > 0) {
            hex = hex.toUpperCase();
        }
        byte[] r = new byte[len / 2];
        for (int i = 0; i < r.length; i++) {
            int digit1 = hex.charAt(i * 2), digit2 = hex.charAt(i * 2 + 1);
            if (digit1 >= '0' && digit1 <= '9')
                digit1 -= '0';
            else if (digit1 >= 'A' && digit1 <= 'F')
                digit1 -= 'A' - 10;
            if (digit2 >= '0' && digit2 <= '9')
                digit2 -= '0';
            else if (digit2 >= 'A' && digit2 <= 'F')
                digit2 -= 'A' - 10;

            r[i] = (byte) ((digit1 << 4) + digit2);
        }
        return r;
    }
    /**
     * Move first 2 bytes to the last
     * e.g.
     * before:1122334455667788
     * after:2233445566778811
     *
     * @param rbuf
     * @return
     */
    public static byte[] insertFirst2Last(byte[] rbuf) {
        byte temp;
        byte tmp[] = new byte[8];

        for (int i = 0; i < 8; i++) {
            temp = rbuf[0];
            for (int j = 0; j < 7; j++) {
                tmp[j] = rbuf[j + 1];
            }
            tmp[7] = temp;
        }
        return tmp;

    }

    /**
     * Move last 2 bytes to the first.
     * e.g.
     * before:1122334455667788
     * after:8811223344556677
     *
     * @param rbuf
     * @return
     */
    public static byte[] insertLast2First(byte[] rbuf) {
        char temp;
        byte tmp[] = new byte[8];
        tmp[0] = rbuf[7];
        for (int j = 1; j < 8; j++) {
            tmp[j] = rbuf[j - 1];
        }
        return tmp;
    }

    public static String encryptKey(String cipherText, String encryptingKey) {
        byte[] mkB = hexToByte(encryptingKey + encryptingKey.substring(0, 16));
        SecretKey keyse = readKey(mkB);
        return Encrypt(keyse, cipherText);
    }


    public static String Encrypt(Key key, String clearComp) {
        try {
            Cipher cipher = Cipher.getInstance("DESede/ECB/NoPadding");
            cipher.init(1, key);
            ByteArrayOutputStream bytes = new ByteArrayOutputStream();
            byte[] clearText = hexToByte(clearComp);
            CipherOutputStream out = new CipherOutputStream(bytes, cipher);
            out.write(clearText);
            out.flush();
            out.close();
            byte[] ciphertext = bytes.toByteArray();
            bytes.flush();
            bytes.close();
            String encrypted = ToHexString(ciphertext);
            Arrays.fill(clearText, (byte)0);
            Arrays.fill(ciphertext, (byte)0);
            return encrypted;
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

        for(int var4 = 0; var4 < var3; ++var4) {
            byte b = var2[var4];
            hexString = hexString + String.format("%02X", b);
        }

        return hexString;
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

}
