package com.etop_pos_plugin.networking.transaction;

import android.os.RemoteException;

import com.etop_pos_plugin.networking.miscellaneous.CommSocket;
import com.etop_pos_plugin.networking.miscellaneous.EncDec;
import com.etop_pos_plugin.networking.miscellaneous.ISO8583;
import com.etop_pos_plugin.networking.miscellaneous.ProfileParser;
import com.etop_pos_plugin.networking.miscellaneous.SSLTLS;
import com.etop_pos_plugin.networking.miscellaneous.Utilities;
import com.etop_pos_plugin.networking.model.NetworkVariables;
import com.etop_pos_plugin.networking.model.ParameterModel;
import com.etop_pos_plugin.networking.model.TransactionRequest;
import com.etop_pos_plugin.networking.model.TransactionResponseModel;
import com.etop_pos_plugin.networking.model.TransactionType;
import com.etop_pos_plugin.utils.Debug;
import com.etop_pos_plugin.utils.DeviceHelper;
import com.etop_pos_plugin.utils.GenerateReceiptNo;
import com.etop_pos_plugin.utils.HexUtil;
import com.etop_pos_plugin.utils.NipsCode;

import org.jpos.iso.ISOUtil;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TransactionBalanceInquiry {
    String TAG = TransactionBalanceInquiry.class.getSimpleName();



    public TransactionResponseModel doWork(String generatedRRN, TransactionRequest tranReqObj, ParameterModel parameterModel ) throws RemoteException {
        NetworkVariables networkVariables = NetworkVariables.getInstance();

        ISO8583 packISO8583 = new ISO8583();
        packISO8583.setMit("0100");
        packISO8583.clearBit();


        byte[] field2 = tranReqObj.getCardPan().getBytes(); //check
        packISO8583.setBit(2, field2, field2.length);


        String processingCode = "31" + tranReqObj.getProcessingCode() + "00";
        byte[] field3 = processingCode.getBytes(); //check
//        byte[] field3 = "310000".getBytes(); //check
        packISO8583.setBit(3, field3, field3.length);

        byte[] field4 = Utilities.getField4("0").getBytes(); //transaction amount
        packISO8583.setBit(4, field4, field4.length);

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


        byte[] field14 = tranReqObj.getExpiryDate().getBytes();
        packISO8583.setBit(14, field14, field14.length);


        byte[] field18;// check too Merchant’s type
        field18 = parameterModel.getMcc().getBytes();
        packISO8583.setBit(18, field18, field18.length);

        byte[] field22 = "051".getBytes(); // check too POS entry mode
        packISO8583.setBit(22, field22, field22.length);


        if (!tranReqObj.getCSN().isEmpty()) {
            byte[] field23 = tranReqObj.getCSN().getBytes(); // check too Card sequence number eg master card number, visa number
            packISO8583.setBit(23, field23, field23.length);
        }


        byte[] field25 = "00".getBytes(); // check too POS condition code Good
        packISO8583.setBit(25, field25, field25.length);

        byte[] field26 = "06".getBytes(); // check too POS PIN capture code length pin
        packISO8583.setBit(26, field26, field26.length);


        byte[] field28 = "D00000000".getBytes(); // check too Amount, transaction fee Good
        packISO8583.setBit(28, field28, field28.length);

        byte[] field32 = tranReqObj.getTrack2data().substring(0, 6).getBytes(); //track2Data.substring(0, 6); that the answer  // check too Acquiring institution id code
        packISO8583.setBit(32, field32, field32.length);

        byte[] field35 = tranReqObj.getTrack2data().replace("F", "").replace("f", "").getBytes(); // check too Track 2 data
        packISO8583.setBit(35, field35, field35.length);


        // check Retrieval reference number
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        String pre = dateFormat.format(new Date());
        String rrn = pre.substring(2);
        byte[] field37 = rrn.getBytes();
        packISO8583.setBit(37, field37, field37.length);

        // Service Restriction Code
        byte[] field40 = Utilities.getServiceCode(tranReqObj.getTrack2data()).getBytes();
        packISO8583.setBit(40, field40, field40.length);


        byte[] field41 = tranReqObj.getTerminalID().getBytes(); //device ID
        packISO8583.setBit(41, field41, field41.length);

        byte[] field42;
        if (!parameterModel.getMid().isEmpty()) {
            field42 = parameterModel.getMid().getBytes();
        } else {
            field42 = "000000000000000".getBytes();
        }
        packISO8583.setBit(42, field42, field42.length);

        if (!parameterModel.getMnl().isEmpty()) {
            byte[] field43 = parameterModel.getMnl().getBytes();
            packISO8583.setBit(43, field43, field43.length);
        } else {
            byte[] field43 = "0000000000000000000000000000000000000000".getBytes();
            packISO8583.setBit(43, field43, field43.length);
        }


        // currency code (parameter download)
        // currency code (parameter download)
        byte[] field49;// currency code
        if (!parameterModel.getCountryCode().isEmpty()) {
            field49 = parameterModel.getCountryCode().getBytes();
        } else {
            field49 = "0566".getBytes();
        }
        packISO8583.setBit(49, field49, field49.length);

        if (tranReqObj.getPinBlock() != null) {
            byte[] field52 = tranReqObj.getPinBlock().toUpperCase().getBytes();
            packISO8583.setBit(52, field52, field52.length);
        }


        byte[] field55 = tranReqObj.getICCData().toUpperCase().getBytes(); // ICCData
        packISO8583.setBit(55, field55, field55.length);


        byte[] field123 = "510101511344101".getBytes(); // Good
        packISO8583.setBit(123, field123, field123.length);

        byte use = 0x0;
        char ch = (char) use;
        byte[] field128 = Character.toString(ch).getBytes();
        packISO8583.setBit(128, field128, field128.length);

        ISO8583.sec = true;
        byte[] preUnmac = packISO8583.getMacIso();
        System.out.println(TAG + "PRE ISO BEFORE MAC: " + new String(preUnmac));
        byte[] unMac = new byte[preUnmac.length - 64];
        System.arraycopy(preUnmac, 0, unMac, 0, preUnmac.length - 64);

        //byte[] unMac =  packISO8583.getMacIso();
        System.out.println(TAG + "ISO BEFORE MAC: " + new String(unMac));
        EncDec enc = new EncDec();
        String gotten = null;
        try {
            Debug.print(TAG + "CLEAR SESSION KEY USED: " + tranReqObj.getSessionkey());
            gotten = enc.getMacNibss(tranReqObj.getSessionkey(), unMac);
            Debug.print(TAG + "MAC: " + gotten);
        } catch (Exception e) {
            e.printStackTrace();
        }

        field128 = gotten.getBytes();
        packISO8583.setBit(128, field128, field128.length);
        ISO8583.sec = true;
        byte[] packData = packISO8583.isotostr();
        Debug.print(TAG + "ISO TO HOST: " + ISOUtil.hexString(packData));

        System.out.println(TAG + "ISO TO HOST: " + ISOUtil.hexString(packData));
        byte[] getSending = new byte[packData.length - 2];
        System.arraycopy(packData, 2, getSending, 0, packData.length - 2);
        ISO8583.sec = true;
        ISO8583 unpackISO8583 = new ISO8583();
        unpackISO8583.strtoiso(getSending);
        String[] sending = new String[128];
        Utilities.logISOMsgMute(unpackISO8583, sending);
        final String ssl = networkVariables.getSsl();
        TransactionResponseModel model = new TransactionResponseModel();

        byte[] recvarr = null;

        if (ssl.equals("true")) {
            try {
                recvarr = SSLTLS.doSSL(networkVariables.getIp(), networkVariables.getPort(), packData);

            } catch (Exception e) {
                e.printStackTrace();
            }

        } else {
            CommSocket send = new CommSocket();
            if (send.open(networkVariables.getIp(), networkVariables.getPort())) {
                System.out.println(TAG + " OPEN SUCCESS");
                int count = send.send(packData);
                System.out.println(TAG + "SENT: " + count);
                recvarr = send.recv();
                send.close();
            } else {

                Debug.print(TAG + " Could Not Open: " + networkVariables.getIp() + ":" + networkVariables.getPort());
            }

        }

        if (recvarr == null) {
            System.out.println("Receiver is null please refresh");
            //set data here to tell user it fail
            return null;
        } else if (recvarr.length == 36 || recvarr.length < 36) {


            //TRIGGER KEY EXCHANGE HERE
            //Call Key Exchange here based on key


            return null;
        } else {
            String resp = new String(recvarr);
            byte[] response;
            if (resp.charAt(0) == '0' &&
                    resp.charAt(1) == '1' &&
                    resp.charAt(2) == '1' &&
                    resp.charAt(3) == '0') {
                Debug.print(TAG + "  FIRST STEP");
                response = new byte[recvarr.length];
                System.arraycopy(recvarr, 0, response, 0, recvarr.length);
            } else {
                int l = resp.indexOf("0110");
                String des = resp.substring(l);
                response = des.getBytes();
                Debug.print(TAG + "  SECOND STEP: " + l);
            }


            Debug.print(TAG + "  PARSED RESPONSE FROM HOST: " + new String(response));
            Debug.print(TAG + "  PARSED RESPONSE FROM HOST LENGTH: " + new String(response).length());
            ISO8583.sec = true;
            unpackISO8583.strtoiso(response);
            String[] receiving = new String[128];
            Utilities.logISOMsg(unpackISO8583, receiving);
            Debug.print("Data " + resp);

            //where the response begins
            String responseCode = receiving[39];
            String RRN = receiving[37];
            String STAN = receiving[11];
            String cardPan = receiving[2];
            model.setRespCode(responseCode);
            model.setStatus(responseCode.equals("00"));
            String responseMessage = NipsCode.getResponseDetails(responseCode);
            model.setResponseMessage(responseMessage);
            String receivedData = receiving[54];
            Debug.print("receivedData " + receivedData);
            Debug.print("responseCode " + responseCode);
            Debug.print("Status Code " + NipsCode.getResponseDetails(responseCode));


            if (receivedData != null) {
                String accountType = receivedData.substring(0, 2);
                String amountType = receivedData.substring(2, 4);
                String currencyCode = receivedData.substring(4, 7);
                String amountSign = receivedData.substring(7, 8);
                String amount = receivedData.substring(9, 20);
                Debug.print("amountType " + amountType);
                Debug.print("currencyCode " + currencyCode);
                Debug.print("amountSign " + amountSign);
                Debug.print("amount " + amount);
                Debug.print("Status Code " + NipsCode.getResponseDetails(responseCode));
                model.setAccountType(Utilities.parseIntAccountTypeToString(Integer.parseInt(accountType)));
                model.setAccountBalance(Utilities.parseLongIntoNairaKoboString(Long.parseLong(amount)));
                model.setCurrencyCode(currencyCode);
                model.setRRN(RRN);
                model.setSTAN(STAN);
                model.setTransactionType(TransactionType.BALANCE_INQUIRY);
                model.setPan(HexUtil.mask(cardPan));


            }

            return model;


        }
    }
}
