package com.etop_pos_plugin.utils;

public class NipsCode {
    public static String getResponseDetails(String res)
    {
        if(res == null){
            return "Please Attempt Again";
        }

        else if(res.equals("00"))
        {
            return "Approved..";
        }else if(res.equals("01"))
        {
            return "Refer to card issuer, special condition";
        }else if(res.equals("02"))
        {
            return "Refer to card issuer";
        }else if(res.equals("03"))
        {
            return "Invalid merchant";
        }else if(res.equals("04"))
        {
            return "Pick-up card";
        }else if(res.equals("05"))
        {
            return "Do not honor";
        }else if(res.equals("06"))
        {
            return "Error";
        }else if(res.equals("07"))
        {
            return "Pick-up card, special condition";
        }else if(res.equals("08"))
        {
            return "Honor with identification";
        }else if(res.equals("09"))
        {
            return "Request in progress";
        }else if(res.equals("10"))
        {
            return "Approved, partial";
        }else if(res.equals("11"))
        {
            return "Approved, VIP";
        }else if(res.equals("12"))
        {
            return "Invalid transaction";
        }else if(res.equals("13"))
        {
            return "Invalid amount";
        }else if(res.equals("14"))
        {
            return "Invalid card number";
        }else if(res.equals("15"))
        {
            return "No such issuer";
        }else if(res.equals("16"))
        {
            return "Approved, update track 3";
        }else if(res.equals("17"))
        {
            return "Customer cancellation";
        }else if(res.equals("18"))
        {
            return "Customer dispute";
        }else if(res.equals("19"))
        {
            return "Re-enter transaction";
        }else if(res.equals("20"))
        {
            return "Invalid response";
        }else if(res.equals("21"))
        {
            return "No action taken";
        }else if(res.equals("22"))
        {
            return "Suspected malfunction";
        }else if(res.equals("23"))
        {
            return "Unacceptable transaction fee";
        }else if(res.equals("24"))
        {
            return "File update not supported";
        }else if(res.equals("25"))
        {
            return "Unable to locate record";
        }else if(res.equals("26"))
        {
            return "Duplicate record";
        }else if(res.equals("27"))
        {
            return "File update field edit error";
        }else if(res.equals("28"))
        {
            return "File update file locked";
        }else if(res.equals("29"))
        {
            return "File update failed";
        }else if(res.equals("30"))
        {
            return "Format error";
        }else if(res.equals("31"))
        {
            return "Bank not supported";
        }else if(res.equals("32"))
        {
            return "Completed partially";
        }else if(res.equals("33"))
        {
            return "Expired card, pick-up";
        }else if(res.equals("34"))
        {
            return "Suspected fraud, pick-up";
        }else if(res.equals("35"))
        {
            return "Contact acquirer, pick-up";
        }else if(res.equals("36"))
        {
            return "Restricted card, pick-up";
        }else if(res.equals("37"))
        {
            return "Call acquirer security, pick-up";
        }else if(res.equals("38"))
        {
            return "PIN tries exceeded, pick-up";
        }else if(res.equals("39"))
        {
            return "No credit account";
        }else if(res.equals("40"))
        {
            return "Function not supported";
        }else if(res.equals("41"))
        {
            return "Lost card, pick-up";
        }else if(res.equals("42"))
        {
            return "No universal account";
        }else if(res.equals("43"))
        {
            return "Stolen card, pick-up";
        }else if(res.equals("44"))
        {
            return "No investment account";
        }else if(res.equals("45"))
        {
            return "Account closed";
        }else if(res.equals("46"))
        {
            return "Identification required";
        }else if(res.equals("47"))
        {
            return "Identification cross-check required";
        }else if(res.equals("48"))
        {
            return "Error";
        }else if(res.equals("49"))
        {
            return "Error";
        }else if(res.equals("50"))
        {
            return "Error";
        }else if(res.equals("51"))
        {
            return "Insufficient funds";
        }else if(res.equals("52"))
        {
            return "No check account";
        }else if(res.equals("53"))
        {
            return "No savings account";
        }else if(res.equals("54"))
        {
            return "Expired card";
        }else if(res.equals("55"))
        {
            return "Incorrect PIN";
        }else if(res.equals("56"))
        {
            return "No card record";
        }else if(res.equals("57"))
        {
            return "Transaction not permitted to cardholder";
        }else if(res.equals("58"))
        {
            return "Transaction not permitted on terminal";
        }else if(res.equals("59"))
        {
            return "Suspected fraud";
        }else if(res.equals("60"))
        {
            return "Contact acquirer";
        }else if(res.equals("61"))
        {
            return "Exceeds withdrawal limit";
        }else if(res.equals("62"))
        {
            return "Restricted card";
        }else if(res.equals("63"))
        {
            return "Security violation";
        }else if(res.equals("64"))
        {
            return "Original amount incorrect";
        }else if(res.equals("65"))
        {
            return "Exceeds withdrawal frequency";
        }else if(res.equals("66"))
        {
            return "Call acquirer security";
        }else if(res.equals("67"))
        {
            return "Hard capture";
        }else if(res.equals("68"))
        {
            return "Response received too late";
        }else if(res.equals("69"))
        {
            return "Advice received too late";
        }else if(res.equals("70"))
        {
            return "Error";
        }else if(res.equals("71"))
        {
            return "Error";
        }else if(res.equals("72"))
        {
            return "Error";
        }else if(res.equals("73"))
        {
            return "Error";
        }else if(res.equals("74"))
        {
            return "Error";
        }else if(res.equals("75"))
        {
            return "PIN tries exceeded";
        }else if(res.equals("76"))
        {
            return "Error";
        }else if(res.equals("77"))
        {
            return "Intervene, bank approval required";
        }else if(res.equals("78"))
        {
            return "Intervene, bank approval required for partial amount";
        }else if(res.equals("79"))
        {
            return "Error";
        }else if(res.equals("80"))
        {
            return "Error";
        }else if(res.equals("81"))
        {
            return "Error";
        }else if(res.equals("82"))
        {
            return "Error";
        }else if(res.equals("83"))
        {
            return "Error";
        }else if(res.equals("84"))
        {
            return "Error";
        }else if(res.equals("85"))
        {
            return "Error";
        }else if(res.equals("86"))
        {
            return "Error";
        }else if(res.equals("87"))
        {
            return "Error";
        }else if(res.equals("88"))
        {
            return "Error";
        }else if(res.equals("89"))
        {
            return "Error";
        }else if(res.equals("90"))
        {
            return "Cut-off in progress";
        }else if(res.equals("91"))
        {
            return "Issuer or switch inoperative";
        }else if(res.equals("92"))
        {
            return "Routing error";
        }else if(res.equals("93"))
        {
            return "Violation of law";
        }else if(res.equals("94"))
        {
            return "Duplicate transaction";
        }else if(res.equals("95"))
        {
            return "Reconcile error";
        }else if(res.equals("96"))
        {
            return "System malfunction";
        }else if(res.equals("97"))
        {
            return "Reserved for future Postilion use";
        }else if(res.equals("98"))
        {
            return "Exceeds cash limit";
        }else if(res.equals("99"))
        {
            return "Error";
        }else if(res.equals("100"))
        {
            return "Please Attempt Again";
        }else if(res.equals("101"))
        {
            return "Reversed";
        }else
        {
            return "Unknown";
        }
    }
}
