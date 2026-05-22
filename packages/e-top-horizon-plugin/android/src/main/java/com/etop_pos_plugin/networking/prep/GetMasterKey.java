package com.etop_pos_plugin.networking.prep;

import static com.etop_pos_plugin.networking.miscellaneous.Decrypter.*;


import org.jpos.iso.ISOUtil;

import com.etop_pos_plugin.networking.miscellaneous.BCDASCII;
import com.etop_pos_plugin.networking.miscellaneous.CommSocket;
import com.etop_pos_plugin.networking.miscellaneous.EncDec;
import com.etop_pos_plugin.networking.miscellaneous.ISO8583;
import com.etop_pos_plugin.networking.miscellaneous.ProfileParser;
import com.etop_pos_plugin.networking.miscellaneous.SSLTLS;
import com.etop_pos_plugin.networking.miscellaneous.Utilities;
import com.etop_pos_plugin.networking.model.MasterKeyModel;
import com.etop_pos_plugin.networking.model.NetworkVariables;
import com.etop_pos_plugin.utils.Debug;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.crypto.SecretKey;

public class GetMasterKey {
    private static final String TAG = GetMasterKey.class.getSimpleName();
    public MasterKeyModel doWork(String terminalID) {


        NetworkVariables networkVariables = NetworkVariables.getInstance();

        MasterKeyModel  masterKeyModel =  new MasterKeyModel();
         Debug.print(TAG+  "  MASTER KEY HOST: " +networkVariables.getPort());
        ISO8583 packISO8583 = new ISO8583();
        packISO8583.setMit("0800");
        packISO8583.clearBit();
        byte[] field3 = "9A0000".getBytes();
        packISO8583.setBit(3, field3, field3.length);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MMddhhmmss");
        String datetime = simpleDateFormat.format(new Date());

        byte[] field7 = datetime.getBytes();
        packISO8583.setBit(7, field7, field7.length);

        simpleDateFormat = new SimpleDateFormat("hhmmss");
        String stan = simpleDateFormat.format(new Date());
        byte[] field11 = stan.getBytes();
        packISO8583.setBit(11, field11, field11.length);
        byte[] field12 = stan.getBytes();
        packISO8583.setBit(12, field12, field12.length);
        simpleDateFormat = new SimpleDateFormat("MMdd");
        String date = simpleDateFormat.format(new Date());
        byte[] field13 = date.getBytes();
        packISO8583.setBit(13, field13, field13.length);
        byte[] field41 = terminalID.getBytes();
        packISO8583.setBit(41, field41, field41.length);
        ISO8583.sec = false;
        byte[] packData = packISO8583.isotostr();
        Debug.print(TAG+  "MSK. ISO TO HOST: " + new String(packData).trim());
        Debug.print(TAG+ "2. ISO TO HOST: " + ISOUtil.hexString(packData));

        byte[] recvarr = null;
        ISO8583 unpackISO8583 = new ISO8583();
        //Check if it is ssl here
        if(networkVariables.getSsl().equals("true"))
        {
            try {
                recvarr = SSLTLS.doSSL(networkVariables.getIp(), networkVariables.getPort(), packData);
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (recvarr != null && recvarr.length > 65)
            {
                byte[] msk = new byte[recvarr.length - 4];
                System.arraycopy(recvarr, 4, msk, 0, recvarr.length - 4);
                unpackISO8583.strtoiso(msk);
            }
        }else
        {
           try {
               CommSocket send = new CommSocket();
               if (send.open(networkVariables.getIp(), networkVariables.getPort()) ) {
                   Debug.print(TAG+  "OPEN SUCCESS");
                   int count = send.send(packData);
                   Debug.print(TAG+  "SENT: " + count);
                   recvarr = send.recv();
                   send.close();
               }else {
                   Debug.print(TAG+  "MASTERKEY DOWNLAOD FAILED");

                   return null;
               }

           }catch (Exception e){
               e.printStackTrace();
            }
            if (recvarr != null && recvarr.length > 65)
            {
                byte[] msk = new byte[recvarr.length - 2];
                System.arraycopy(recvarr, 2, msk, 0, recvarr.length - 2);
                unpackISO8583.strtoiso(msk);
                Debug.print("EveryResponse"+ new String(msk));
            }
        }

        if (recvarr == null || recvarr.length < 10)
        {
            Debug.print(TAG+  "MASTERKEY DOWNLAOD FAILED");

            return null;
        }

        Debug.print(TAG+  "1. RECV: " + new String(recvarr));

        String[] receiving = new String[128];
        Utilities.logISOMsg(unpackISO8583, receiving);
        if(receiving[53] != null && receiving[39].equals("00")) {
            String key = receiving[53];
            String eKey = key.substring(0, 32);
            String eKcv = "";
            EncDec enc = new EncDec();
            String gotten = null;
            try {

                System.out.println("Returning Master: "+eKey);
                String newDecryptedMaster = threeDesDecryptA(networkVariables.getCompKey1(),networkVariables.getCompKey2(),eKey);
                gotten = enc.getClearKey(ProfileParser.swkcomp1, eKey);
                Debug.print(TAG+ " NEW DECRYPTED MASTER KEY: " + newDecryptedMaster);

                masterKeyModel.setMasterKey(eKey);
                masterKeyModel.setClearMasterKey(newDecryptedMaster);
                Debug.print(TAG+  "ENCRYPTED MASTER KEY: " + eKey);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }else
        {

            return masterKeyModel ;
        }

        return masterKeyModel;
    }


    public static String threeDesDecryptA(String keyComponent1, String keyComponent2, String encryptedToken) {
        System.out.println("KEY1 >>>>>>>>>>> "+ keyComponent1);
        System.out.println("KEY2 >>>>>>>>>>> "+ keyComponent2);
        byte[] keyB1 = hexToByte(keyComponent1 + keyComponent1.substring(0, 16));
        byte[] keyB2 = hexToByte(keyComponent2 + keyComponent2.substring(0, 16));

        for(int i = 0; i < keyB2.length; ++i) {
            keyB1[i] ^= keyB2[i];
        }

        Debug.print("-----XORED COMPONENT "+ BCDASCII.bytesToHexString(keyB1));


        SecretKey key = readKey(keyB1);

        Debug.print("----------READ KEY I " + key.toString());
        Debug.print("-FORMAT KEY "+ key.getFormat());
        Debug.print("----------ALGO KEY II "+ key.getAlgorithm());
        return Decrypt(key, encryptedToken);
    }
}


