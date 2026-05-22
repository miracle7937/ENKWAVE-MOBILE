package com.etop_pos_plugin.networking.prep;

import com.etop_pos_plugin.networking.miscellaneous.CommSocket;
import com.etop_pos_plugin.networking.miscellaneous.Decrypter;
import com.etop_pos_plugin.networking.miscellaneous.ISO8583;
import com.etop_pos_plugin.networking.miscellaneous.ProfileParser;
import com.etop_pos_plugin.networking.miscellaneous.SSLTLS;
import com.etop_pos_plugin.networking.miscellaneous.Utilities;
import com.etop_pos_plugin.networking.model.NetworkVariables;
import com.etop_pos_plugin.networking.model.SessionKeyModel;
import com.etop_pos_plugin.utils.Debug;

import org.jpos.iso.ISOUtil;

import java.text.SimpleDateFormat;
import java.util.Date;

public class GetSessionKey {

    private static final String TAG = GetSessionKey.class.getSimpleName();
    public SessionKeyModel doWork(String terminalID, String masterKey) {
        NetworkVariables networkVariables = NetworkVariables.getInstance();

        SessionKeyModel sessionKeyModel = new SessionKeyModel();


        ISO8583 packISO8583 = new ISO8583();
        packISO8583.setMit("0800");
        packISO8583.clearBit();
        byte[] field3 = "9B0000".getBytes();
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
        Debug.print(TAG+  "SSK. ISO TO HOST: " + new String(packData));
        Debug.print(TAG+  "2. ISO TO HOST: " + ISOUtil.hexString(packData));
        Debug.print(TAG+  "IP: " + networkVariables.getIp());
        Debug.print(TAG+ "PORT: " + networkVariables.getPort());
        Debug.print(TAG+  "SSL: " + networkVariables.getSsl());
        byte[] recvarr = null;
        String gotten = null; // clear session key
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
                ProfileParser.skkhost1 = new byte[recvarr.length - 4];
                System.arraycopy(recvarr, 4, ProfileParser.skkhost1, 0, recvarr.length - 4);
                unpackISO8583.strtoiso(ProfileParser.skkhost1);
            }
        }else
        {
            try {
            CommSocket send = new CommSocket();
            if (send.open(networkVariables.getIp(), networkVariables.getPort())) {
                Debug.print(TAG+ "OPEN SUCCESS");
                int count = send.send(packData);
                Debug.print(TAG+ "SENT: " + count);
                recvarr = send.recv();
                send.close();
            } else {
                Debug.print(TAG+ "SESSION KEY DOWNLOAD FAILED");
                Debug.print(TAG+ "Could Not Open: " + ProfileParser.hostip + ":" + ProfileParser.hostport);
//                return  null;
            }
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (recvarr != null && recvarr.length > 65)
            {
                ProfileParser.skkhost1 = new byte[recvarr.length - 2];
                System.arraycopy(recvarr, 2, ProfileParser.skkhost1, 0, recvarr.length - 2);
                unpackISO8583.strtoiso(ProfileParser.skkhost1);
            }
        }

        Debug.print(TAG+ "1. RECV: " + new String(recvarr));
        ProfileParser.receiving = new String[128];
        Utilities.logISOMsg(unpackISO8583, ProfileParser.receiving);

        if (recvarr == null || recvarr.length < 65) {
            Debug.print(TAG+ "SESSIONKEY DOWNLAOD FAILED");
        }
        Debug.print(TAG+" RECV: " + new String(recvarr));
        Debug.print(TAG+ " DONE WITH CONNECTION");

        ProfileParser.receiving = new String[128];
        Utilities.logISOMsg(unpackISO8583, ProfileParser.receiving);
        String key = ProfileParser.receiving[53];
        if(ProfileParser.receiving[53] != null && ProfileParser.receiving[39].equals("00")) {
            String eKey = key.substring(0, 32);

            String eKcv = "";
            Decrypter decrypter = new Decrypter();
            try {
                ProfileParser.host1encsk = eKey;
                gotten = decrypter.threeDesDecrypt(eKey,  masterKey);
                Debug.print(TAG+" ENCRYPTED SESSION KEY: " + eKey);
                Debug.print(TAG+ " CLEAR SESSION KEY: " + gotten);
                sessionKeyModel.setSessionKey(eKey);
                sessionKeyModel.setClearSessionKey(gotten);

                ProfileParser.host1clrsk = gotten;
                return  sessionKeyModel;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }else
        {
            Debug.print(TAG+ "SESSIONKEY DOWNLAOD FAILED");
            return  null;

        }

        return null;
    }


}
