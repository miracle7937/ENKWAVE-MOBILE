package com.etop_pos_plugin.networking.transaction;

import com.etop_pos_plugin.networking.miscellaneous.CommSocket;
import com.etop_pos_plugin.networking.miscellaneous.EncDec;
import com.etop_pos_plugin.networking.miscellaneous.ISO8583;
import com.etop_pos_plugin.networking.miscellaneous.ProfileParser;
import com.etop_pos_plugin.networking.miscellaneous.SSLTLS;
import com.etop_pos_plugin.networking.miscellaneous.Utilities;
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
import static com.etop_pos_plugin.networking.miscellaneous.Decrypter.*;

import android.os.RemoteException;

import com.etop_pos_plugin.networking.model.NetworkVariables;
import com.etop_pos_plugin.utils.StringUtil;

public class TransactionPurchase {

    String TAG = TransactionPurchase.class.getSimpleName();

    public TransactionResponseModel doWork(String generatedRRN, TransactionRequest tranReqObj, ParameterModel parameterModel  ) throws RemoteException {
        NetworkVariables networkVariables = NetworkVariables.getInstance();

        Debug.print(TAG + "Transaction Session Key "+ tranReqObj.getSessionkey());
        ISO8583 packISO8583 = new ISO8583();
        packISO8583.setMit("0200");
        packISO8583.clearBit();

        byte[] field2 =  tranReqObj.getCardPan().getBytes();
        packISO8583.setBit(2, field2, field2.length);

        String processingCode =    "00" + tranReqObj.getProcessingCode() + "00";
        byte[] field3 = processingCode.getBytes(); //check
        packISO8583.setBit(3, field3, field3.length);

      byte[] field4 = StringUtil.convertAmountToField4(tranReqObj.getAmount()).getBytes(); //check also
//        byte[] field4 = tranReqObj.getAmount().getBytes(); //check also
        packISO8583.setBit(4, field4, field4.length);


        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MMddhhmmss");
        String datetime = simpleDateFormat.format(new Date());
        byte[] field7 = datetime.getBytes();
        packISO8583.setBit(7, field7, field7.length);


        simpleDateFormat = new SimpleDateFormat("hhmmss");
        String stan = simpleDateFormat.format(new Date());

        byte[] field11 = stan.getBytes();
        packISO8583.setBit(11, field11, field11.length);   // check Systems trace audit number


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


        if(!tranReqObj.getCSN().isEmpty()){
            byte[] field23 = tranReqObj.getCSN().getBytes(); // check too Card sequence number eg master card number, visa number
            packISO8583.setBit(23, field23, field23.length);
        }




        byte[] field25 = "00".getBytes(); // check too POS condition code Good
        packISO8583.setBit(25, field25, field25.length);




        byte[] field26 = "06".getBytes(); // check too POS PIN capture code length pin
        packISO8583.setBit(26, field26, field26.length);

        byte[] field28 = "C00000000".getBytes(); // check too Amount, transaction fee Good
        packISO8583.setBit(28, field28, field28.length);




        byte[] field32  = tranReqObj.getTrack2data().substring(0, 6).getBytes(); //track2Data.substring(0, 6); that the answer  // check too Acquiring institution id code
        packISO8583.setBit(32, field32, field32.length);






        byte[] field35   = tranReqObj.getTrack2data().replace("F", "").replace("f", "").getBytes(); // check too Track 2 data
        packISO8583.setBit(35, field35, field35.length);





        // check Retrieval reference number

        String rrn = generatedRRN;
        byte[] field37 = rrn.getBytes();
        packISO8583.setBit(37, field37, field37.length);

        // Service Restriction Code
        byte[] field40 = Utilities.getServiceCode(tranReqObj.getTrack2data()).getBytes();
        packISO8583.setBit(40, field40, field40.length);



        byte[] field41 = tranReqObj.getTerminalID().getBytes(); //device ID
        packISO8583.setBit(41, field41, field41.length);

        byte[] field42;
        if(!parameterModel.getMid().isEmpty()){
            field42 = parameterModel.getMid().getBytes();
        }else {
            field42 = "000000000000000".getBytes();
        }
        packISO8583.setBit(42, field42, field42.length);


        // check Card acceptor name/location from parameter download(mnl)

        if(!parameterModel.getMnl().isEmpty()){
            byte[]   field43 = parameterModel.getMnl().getBytes();
            packISO8583.setBit(43, field43, field43.length);
        }else{
            byte[]     field43 = "0000000000000000000000000000000000000000".getBytes();
            packISO8583.setBit(43, field43, field43.length);
        }



        // currency code (parameter download)
        byte[] field49;// currency code
        if(!parameterModel.getCountryCode().isEmpty()){
            field49 = parameterModel.getCountryCode().getBytes();
        }else{
            field49 = "0566".getBytes();
        }
        packISO8583.setBit(49, field49, field49.length);


        if(tranReqObj.getPinBlock() != null){
            byte[] field52   = tranReqObj.getPinBlock().toUpperCase().getBytes();
            packISO8583.setBit(52, field52, field52.length);
        }




        byte[] field55   = tranReqObj.getICCData().toUpperCase().getBytes(); // ICCData
        packISO8583.setBit(55, field55, field55.length);




        if(ProfileParser.field59 != null)
        {
            if(Integer.parseInt(ProfileParser.txnNumber) == 2)
            {
                int i = ProfileParser.field59.indexOf("Meter Number=12^") + 16;
                Debug.print(TAG+ " INTEGER: " + i);
                if(i <= 15)
                {
                    byte[] field59 = ProfileParser.field59.getBytes();
                    packISO8583.setBit(59, field59, field59.length);
                }else
                {
                    String fin = ProfileParser.field59.substring(0, i) + ProfileParser.field62 + "^" + ProfileParser.field59.substring(i);
                    ProfileParser.field59 = fin;
                    byte[] field59 = ProfileParser.field59.getBytes();
                    packISO8583.setBit(59, field59, field59.length);
                }
            }else
            {
                byte[] field59 = " ".getBytes();
                packISO8583.setBit(59, field59, field59.length);
            }
        }






        byte[] field123   = "510101511344101".getBytes(); // Good
        packISO8583.setBit(123, field123 , field123.length);


        byte use = 0x0;
        char ch = (char)use;
        byte[] field128 = Character.toString(ch).getBytes();
        packISO8583.setBit(128, field128, field128.length);
        ISO8583.sec = true;
        byte[] preUnmac = packISO8583.getMacIso();

        Debug.print(TAG+ "PRE ISO BEFORE MAC: " + new String(preUnmac));

        byte[] unMac = new byte[preUnmac.length - 64];
        System.arraycopy(preUnmac, 0, unMac, 0, preUnmac.length - 64);

        //byte[] unMac =  packISO8583.getMacIso();
        Debug.print(TAG+ "ISO BEFORE MAC: " + new String(unMac));
        EncDec enc = new EncDec();
        String gotten = null;
        try {
            Debug.print(TAG+ "CLEAR SESSION KEY USED: " + tranReqObj.getSessionkey());
            gotten = enc.getMacNibss(tranReqObj.getSessionkey(), unMac);
            Debug.print(TAG+ "MAC: " + gotten);
        } catch (Exception e) {
            e.printStackTrace();
        }
        field128 = gotten.getBytes();
        packISO8583.setBit(128, field128, field128.length);
        ISO8583.sec = true;
        byte[] packData =  packISO8583.isotostr();


        Debug.print(TAG+ "ISO TO HOST: " + ISOUtil.hexString(packData));

        Debug.print(TAG+ "IP: " + networkVariables.getIp());
        Debug.print(TAG+ "PORT: " + networkVariables.getPort());
        Debug.print(TAG+ "SSL: " + networkVariables.getSsl());

        Debug.print(TAG+ "Storing for database sake");
        byte[] getSending = new byte[packData.length - 2];
        System.arraycopy(packData, 2, getSending, 0, packData.length - 2);
        ISO8583.sec = true;
        ISO8583 unpackISO8583  = new ISO8583();
        unpackISO8583.strtoiso(getSending);
        String[] sending = new String[128];
        Utilities.logISOMsgMute(unpackISO8583, sending);


        final String ssl =  networkVariables.getSsl();
        TransactionResponseModel paymentResponseModel = new TransactionResponseModel();
        byte[] recvarr = null;

        if(ssl.equals("true"))
        {
            try {
                recvarr = SSLTLS.doSSL(networkVariables.getIp(), networkVariables.getPort(), packData);

            } catch (Exception e) {
                e.printStackTrace();
            }

        }else {
            try {

            CommSocket send = new CommSocket();
            if (send.open(networkVariables.getIp(), networkVariables.getPort())) {
                Debug.print(TAG+ " OPEN SUCCESS");
                int count = send.send(packData);
                Debug.print(TAG+ "SENT: " + count);
                recvarr = send.recv();
                send.close();
            } else {
                Debug.print(TAG+ " Could Not Open: " + networkVariables.getIp() + ":" + networkVariables.getPort());
            }
            } catch (Exception e) {
                e.printStackTrace();

            }

        }
        if (recvarr == null) {
            Debug.print("Receiver is null please refresh" );
            //set data here to tell user it fail
            return null;
        }else if (recvarr.length == 36 || recvarr.length < 36) {


            return null;
        }else
        {
            String resp = new String(recvarr);
            byte[] response;
            Debug.print(TAG+ " RESPONSE FROM HOST: " + resp);
            Debug.print(TAG+ " RESPONSE FROM HOST LENGTH: " + resp.length());
            if(resp.charAt(0) == '0' &&
                    resp.charAt(1) == '2' &&
                    resp.charAt(2) == '1' &&
                    resp.charAt(3) == '0')
            {
                Debug.print(TAG+ "  FIRST STEP");
                response = new byte[recvarr.length];
                System.arraycopy(recvarr, 0, response, 0, recvarr.length);
            }else {
                int l = resp.indexOf("0210");
                String des = resp.substring(l);
                response = new byte[des.length()];
                response = des.getBytes();
                Debug.print(TAG+ "  SECOND STEP: " + l);
            }

            Debug.print(TAG+ "  PARSED RESPONSE FROM HOST: " + new String(response));
            Debug.print(TAG+ "  PARSED RESPONSE FROM HOST LENGTH: " + new String(response).length());
            ISO8583.sec = true;
            unpackISO8583.strtoiso(response);
            String[] receiving = new String[128];
            Utilities.logISOMsg(unpackISO8583, receiving);
            String successResponse = "RESPONSE RECEIVED";
            Long receiptNumber = GenerateReceiptNo.getTransactionReferenceNumber(GenerateReceiptNo.shuffle(Utilities.bytes2HexString(recvarr).substring(0,12)));
            String authcode = receiving[38];
            String respcode = receiving[39];
            String systemTraceNo = receiving[11];
            String transmissionDate = receiving[13]; //this is set from the processCardPayment
            String transmissionTime = receiving[12];
            String transmissionDateTime = receiving[7];
            Debug.print(TAG+ "  transmissionDateTime: " + transmissionDateTime);

            String acquiringInstitutionIdCode = receiving[32];
            String forwardingInstCode = receiving[33];
            String cardPan = receiving[2];
            String accountType   = tranReqObj.getAccountType();
            String cardExpire = receiving[14];
            String cardCardSequenceNum = receiving[23];
            String track2Data = receiving[34];
            String RRN = receiving[37];
            String terminalId = receiving[4];
            String STAN = receiving[11];

            Debug.print(TAG+ "  SECOND STEP: " + authcode);
            paymentResponseModel.setSuccessResponse(successResponse);
            paymentResponseModel.setStatus(respcode.equals("00"));
            paymentResponseModel.setReceiptNumber(receiptNumber.toString());
            paymentResponseModel.setAuthCode(authcode);
            paymentResponseModel.setRespCode(respcode);
            paymentResponseModel.setTransactionDate(transmissionDate);
            paymentResponseModel.setTransactionTime(transmissionTime);
            paymentResponseModel.setTransactionDateTime(transmissionDateTime);
            paymentResponseModel.setResponseMessage(NipsCode.getResponseDetails(respcode));
            paymentResponseModel.setSystemTraceAuditNo(systemTraceNo);
            paymentResponseModel.setForwardingInstCode(forwardingInstCode);
            paymentResponseModel.setAcquiringInstitutionIdCode(acquiringInstitutionIdCode);
            paymentResponseModel.setPan(HexUtil.mask(cardPan));
            paymentResponseModel.setAccountType(accountType);
            paymentResponseModel.setCardExpireData(cardExpire);
            paymentResponseModel.setCardCardSequenceNum(cardCardSequenceNum);
            paymentResponseModel.setPinBlock(tranReqObj.getPinBlock());
            paymentResponseModel.setRRN(RRN);
            paymentResponseModel.setTrack2Data(track2Data);
            paymentResponseModel.setSTAN(STAN);
            paymentResponseModel.setAmount(tranReqObj.getAmount());
            paymentResponseModel.setSerialNO(DeviceHelper.getSysHandle().getSn());
            paymentResponseModel.setTransactionType(TransactionType.PURCHASE);
            Debug.print(TAG+ " RESPONSE CODE: " + receiving[39]);
            Debug.print(TAG+ " RESPONSE MESSAGE: " + NipsCode.getResponseDetails(respcode));
            return paymentResponseModel;
        }


    }
}