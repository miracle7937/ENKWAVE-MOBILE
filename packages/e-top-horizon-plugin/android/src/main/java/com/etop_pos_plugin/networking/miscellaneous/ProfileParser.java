package com.etop_pos_plugin.networking.miscellaneous;

import org.json.JSONException;
import org.json.JSONObject;

import java.nio.charset.StandardCharsets;

public class ProfileParser {
    public static String BASEURL = "https://baxitms.com";
    public static String BRAND = "UROVO";
    public static String MODEL = "t1";
    public static String APPVERSION = "1.0.1";
    public static String sourceParameter;
    public static String profileId;

    //Populate on key download
    //Host 1 details
    public static String host1ctmk;
    public static String host1encmsk;
    public static String host1encsk;
    public static String host1encpk;
    public static String host1clrmsk;
    public static String host1clrsk;
    public static String host1clrpk;

    //Host 2 details
    public static String host2ctmk;
    public static String host2encmsk;
    public static String host2encsk;
    public static String host2encpk;
    public static String host2clrmsk;
    public static String host2clrsk;
    public static String host2clrpk;

    public static String hostToUse;

    public static String rfield7;
    public static String rfield14;
    public static String totalAmount;
    public static String Amount;
    public static long receiptNum;
    public static String cardAid;
    public static String cardType;
    public static String cardName;
    public static int cusCopy;
    public static int merCopy;
    public static int totalCopy;
    public static String txnNumber;
    public static String txnName;
    public static String field0;
    public static String field2;
    public static String field3;
    public static String field4;
    public static String field7;
    public static String field11;
    public static String field12;
    public static String field13;
    public static String field14;
    public static String field18;
    public static String field22;
    public static String field23;
    public static String field25;
    public static String field26;
    public static String field28;
    public static String field32;
    public static String field35;
    public static String field37;
    public static String field38;
    public static String field40;
    public static String field41;
    public static String field42;
    public static String field43;
    public static String field49;
    public static String field52;
    public static String field55;
    public static String field56;
    public static String field59;
    public static String field60;
    public static String field62;
    public static String field123;
    public static String fhostip;
    public static String fhostport;
    public static String fhostssl;
    public static String fhostfriendlyname;
    public static String fhostctmk;
    public static String fhostencmsk;
    public static String fhostencsk;
    public static String fhostencpk;
    public static String fhostclrmsk;
    public static String fhostclrsk;
    public static String fhostclrpk;
    public static String fhostmid;
    public static String fhostcurrcode;
    public static String fhostmnl;
    public static String fhostmcc;
    public static String orrn;
    public static String tmsusername;
    public static String tmstid;
    public static String phoneNumber;
    public static byte[] response;

    public static byte[] mskhost1;
    public static byte[] skkhost1;
    public static byte[] pkkhost1;
    public static byte[] parahost1;
    public static byte[] mskhost2;
    public static byte[] skkhost2;
    public static byte[] pkkhost2;
    public static byte[] parahost2;
    public static String[] sending;
    public static String[] receiving;
    public static String[] notification;

    public static String appname;
    public static String country;
    public static String countrycode;
    public static String terminalmanufacturer;
    public static String blocked;
    public static String blockedpin;
    public static String ownerusername;
    public static String superagent;
    public static String dialogheading;
    public static String simserial;
    public static String simnumber;
    public static String simname;
    public static String timestamp = "";
//    public static String configtid = "201115FH";
     public static String configtid = "2101KI58";
    public static String configmid = "";
    public static String configadminpin = "";
    public static String configchangepin = "";
    public static Object configserialnumber = "";
    public static Object configterminalmanufacturer = "";
    public static Object configterminalmodel = "";
    public static Object configinitapplicationversion = "";
    public static String configmerchantname = "";
    public static String configmerchantaddress = "";
    public static String configremarks = "";
    public static String accountname = "";
    public static String accountcode = "";
    public static String accountnumber = "";
    public static String accountbank = "";
    public static String configcontactname = "";
    public static String configcontactphone = "";
    public static String configemail = "";
    public static String configmcc = "";
    public static String configlga = "";
    public static String configphysicaladdress = "";
    public static String configmerchantcatcode = "";
    public static String configstatecode = "";
    public static String configptsp = "";
    public static String configmechantaccountname = "";
    public static String configbankcode = "";
    public static String configslipfoot = "";
    public static String configterminalownercode = "";
    public static String merchantpin = "";
    public static String configbankid = "";
    public static String configecrid = "";
    public static String configcommsid = "";
    public static String bankname = "";
    public static String bankcode = "";
    public static String bankremarks = "";
    public static String profilename = "";
    public static String profileprotectlist = "";
    public static String profilecardschemekeytypes = "";
    public static String profiletransactiontypesarray = "";
    public static String profilemastercard = "";
    public static String profilevisa = "";
    public static String profilepayattitude = "";
    public static String profileverve = "";
    public static String profilecup = "";
    public static String profileamex = "";
    public static String profilefreedomcard = "";
    public static String profileothersscheme = "";
    public static Object profileotherimportant = "";
    public static String profilehostarray = "";
    public static String chname = "";
    public static String chremotedlt = "";
    public static Integer chinterval;
    public static String chremarks = "";
    public static String rptname = "";
    public static String rptfootertext = "";
    public static String rptcustomercopylabel = "";
    public static String rptmerchantcopylabel = "";
    public static String rptfootnotelabel = "";
    public static Boolean rptshowlogo;
    public static Integer rptnormalfontsize;
    public static Integer rptheaderfontsize;
    public static Integer rptamountfontsize;
    public static Boolean rptshowbarcode;
    public static Integer rptprintmerchantcopynumber;
    public static Integer rptprintclientcopynumber;
    public static Boolean rptsaveforreceipt;
    public static String rptheadervalue = "";
    public static String rptaddedby = "";
    public static String hostname = "";
    public static String hostip = "";
    public static Integer hostport;
    public static Boolean hostssl;
    public static String hostfriendlyname = "";
    public static String hostremarks = "";
    public static String hostmestype = "";
    public static String hostaddedby = "";
    public static String host2name = "";
    public static String host2ip = "";
    public static Integer host2port;
    public static Boolean host2ssl;
    public static String host2friendlyname = "";
    public static String host2remarks = "";
    public static String host2mestype = "";
    public static String host2addedby = "";
    public static String appversion = "";
    public static String appbrand = "";
    public static String appdescription = "";
    public static String appmodel = "";
    public static String appfix = "";
    public static String appterminals = "";
    public static String appupdated = "";
    public static String appremarks = "";
    public static String swkname = "";
    public static String swkupdated = "";
    public static String swkcomp1 = "AD9160FC7946955E7BC4E27A8D10C0DA";
    public static String swkcomp2 = "BC986FA24F0A4BAFEE42C81910D8EF52";
    public static String swkswitchkey = "";
    public static String swkremarks = "";
    public static String swkfname = "";
    public static String swkfupdated = "";
    public static String swkfcomp1 = "";
    public static String swkfcomp2 = "";
    public static String swkfswitchkey = "";
    public static String swkfremarks = "";
    public static String curname = "";
    public static String curabbr = "";
    public static Integer curcode;
    public static String curminorunit = "";
    public static String curremarks = "";
    public static String curaddedby = "";
    public static String logoversion = "";
    public static String logofilename = "";
    public static String logodescription = "";
    public static String logobankcode = "";
    public static String logobankname = "";
    public static String logoremarks = "";
    public static String logobversion = "";
    public static String logobfilename = "";
    public static String logobdescription = "";
    public static String logobbankcode = "";
    public static String logobbankname = "";
    public static String logobremarks = "";
    public static String paymentdetails = "";
    public static String paymentvendorid = "";
    public static String paymentconveniencefee = "";
    public static String paymentaddedby = "";
    public static Object paymentremarks = "";
    public static String transactions = "";
    public static String hostarray = "";
    public static String profilevas = "";
    public static Object protectlist = "";
    public static Integer status;
    public static String message = "";
    public static String logodownload = "";
    public static String logoreceipt = "";
    public static String logobdownload = "";
    public static String logobreceipt = "";

    public static void parseNewProfile(String response) throws JSONException {
        System.out.println("CHECKING"+ "JSON: " + response);
        JSONObject in = new JSONObject(response);
        timestamp = in.getString("timestamp");
        configtid = in.getString("tid");
        configmid = in.getString("mid");
        configadminpin = in.getString("adminpin");
        configchangepin = in.getString("changepin");
        configserialnumber = in.getString("serialnumber");
        configterminalmodel = in.getString("terminalmodel");
        configinitapplicationversion = in.getString("initapplicationversion");
        configmerchantname = in.getString("merchantname");
        configmerchantaddress = in.getString("merchantaddress");
        configcontactname = in.getString("contactname");
        configcontactphone = in.getString("contactphone");
        configemail = in.getString("email");
        configmcc = in.getString("mcc");
        configlga = in.getString("lga");
        appname = in.getString("appname");
        country = in.getString("country");
        countrycode = in.getString("countrycode");
        profilename = in.getString("profilename");
        terminalmanufacturer = in.getString("terminalmanufacturer");
        blocked = in.getString("blocked");
        blockedpin = in.getString("blockedpin");
        ownerusername = in.getString("ownerusername");
        superagent = in.getString("superagent");
        dialogheading = in.getString("dialogheading");
        simserial = in.getString("simserial");
        simnumber = in.getString("simnumber");
        simname = in.getString("simname");
        accountname = in.getString("accountname");
        accountcode = in.getString("accountcode");
        accountnumber = in.getString("accountnumber");
        accountbank = in.getString("accountbank");
        appversion = in.getString("appversion");
        appbrand = in.getString("appbrand");
        appdescription = in.getString("appdescription");
        appmodel = in.getString("appmodel");
        appfix = in.getString("appfix");
        appterminals = in.getString("appterminals");
        appupdated = in.getString("appupdated");
        appremarks = in.getString("appremarks");
        profileprotectlist = in.getString("profileprotectlist");
        profilecardschemekeytypes = in.getString("profilecardschemekeytypes");
        profiletransactiontypesarray = in.getString("profiletransactiontypesarray");
        profilevas = in.getString("profilevas");
        profilehostarray = in.getString("profilehostarray");
        chname = in.getString("chname");
        chremotedlt = in.getString("chremotedownloadtime");
        chinterval = in.getInt("chinterval");
        chremarks = in.getString("chcount");
        rptname = in.getString("rptname");
        rptfootertext = in.getString("rptfootertext");
        rptcustomercopylabel = in.getString("rptcustomercopylabel");
        rptmerchantcopylabel = in.getString("rptmerchantcopylabel");
        rptfootnotelabel = in.getString("rptfootnotelabel");
        rptshowlogo = in.getBoolean("rptshowlogo");
        rptnormalfontsize = in.getInt("rptnormalfontsize");
        rptheaderfontsize = in.getInt("rptheaderfontsize");
        rptamountfontsize = in.getInt("rptamountfontsize");
        rptshowbarcode = in.getBoolean("rptshowbarcode");
        rptprintmerchantcopynumber = in.getInt("rptprintmerchantcopynumber");
        rptprintclientcopynumber = in.getInt("rptprintclientcopynumber");
        rptsaveforreceipt = in.getBoolean("rptsaveforreceipt");
        //rptheadervalue = in.getString("rptheadervalue");
        hostname = in.getString("hostidname");
        hostip = in.getString("hostip");
        hostport = in.getInt("hostport");
        hostssl = in.getBoolean("hostssl");
        hostfriendlyname = in.getString("hostfriendlyname");
        //hostremarks = in.getString("hostremarks");
        hostmestype = in.getString("hostmestype");
        configphysicaladdress = in.getString("merchantaddress");
        configmerchantcatcode = in.getString("mcc");
        bankname = in.getString("bnkname");
        bankcode = in.getString("bnkcode");
        profilename = in.getString("profilename");
        swkname = in.getString("swkname");
        swkcomp1 = in.getString("swkcomponent1");
        swkcomp2 = in.getString("swkcomponent2");
        curname = in.getString("curname");
        curabbr = in.getString("curabbreviation");
        curcode = in.getInt("curcode");
        curminorunit = in.getString("curminorunit");
        curremarks = in.getString("curremarks");
        transactions = in.getString("transactions");
        hostarray = in.getString("hostarray");
        protectlist = in.getString("protectlist");
        host2name = in.getString("hostid2name");
        host2ip = in.getString("host2ip");
        host2port = in.getInt("host2port");
        host2ssl = in.getBoolean("host2ssl");
        host2friendlyname = in.getString("host2friendlyname");
        //host2remarks = in.getString("host2remarks");
        host2mestype = in.getString("host2mestype");
        swkfname = in.getString("swk2name");
        swkfcomp1 = in.getString("swk2component1");
        swkfcomp2 = in.getString("swk2component2");
        if(in.getString("logorisreceipt") != null) {
            logoversion = in.getString("logorversion");
            logofilename = in.getString("logorfilename");
            logodescription = in.getString("logordescription");
            logobankcode = in.getString("logorbankcode");
            logobankname = in.getString("logorbankname");
            logodownload = in.getString("logordownload");
            logoreceipt = in.getString("logorisreceipt");
        }
        /*if(in.getString("logobisreceipt") != null) {
            logobversion = in.getString("logobversion");
            logobfilename = in.getString("logobfilename");
            logobdescription = in.getString("logobdescription");
            logobbankcode = in.getString("logobbankcode");
            logobbankname = in.getString("logobbankname");
            logobremarks = in.getString("logobremarks");
            logobdownload = in.getString("logobdownload");
            logobreceipt = in.getString("logobisreceipt");
        }*/
        status = in.getInt("status");
        message = in.getString("message");
    }

    public static void resetFields()
    {
        ProfileParser.hostToUse = "";
        ProfileParser.Amount = "";
        ProfileParser.totalAmount = "";
        ProfileParser.cardAid = "";
        ProfileParser.cardType = "";
        ProfileParser.cardName = "";
        ProfileParser.cusCopy = 0;
        ProfileParser.merCopy = 0;
        ProfileParser.totalCopy = 0;
        ProfileParser.txnName = "";
        ProfileParser.txnNumber = "";
        ProfileParser.field0 = "";
        ProfileParser.field2 = "";
        ProfileParser.field3 = "";
        ProfileParser.field4 = "";
        ProfileParser.field7 = "";
        ProfileParser.field11 = "";
        ProfileParser.field12 = "";
        ProfileParser.field13 = "";
        ProfileParser.field14 = "";
        ProfileParser.field18 = "";
        ProfileParser.field22 = "";
        ProfileParser.field23 = "";
        ProfileParser.field25 = "";
        ProfileParser.field26 = "";
        ProfileParser.field28 = "";
        ProfileParser.field32 = "";
        ProfileParser.field35 = "";
        ProfileParser.field37 = "";
        ProfileParser.field38 = "";
        ProfileParser.field40 = "";
        ProfileParser.field41 = "";
        ProfileParser.field42 = "";
        ProfileParser.field43 = "";
        ProfileParser.field49 = "";
        ProfileParser.field52 = "";
        ProfileParser.field55 = "";
        ProfileParser.field56 = "";
        ProfileParser.field59 = "";
        ProfileParser.field60 = "";
        ProfileParser.field62 = "";
        ProfileParser.field123 = "";
        ProfileParser.fhostip = "";
        ProfileParser.fhostport = "";
        ProfileParser.fhostssl = "";
        ProfileParser.fhostfriendlyname = "";
        ProfileParser.fhostctmk = "";
        ProfileParser.fhostencmsk = "";
        ProfileParser.fhostencsk = "";
        ProfileParser.fhostencpk = "";
        ProfileParser.fhostclrmsk = "";
        ProfileParser.fhostclrsk = "";
        ProfileParser.fhostclrpk = "";
        ProfileParser.fhostmid = "";
        ProfileParser.fhostcurrcode = "";
        ProfileParser.fhostmnl = "";
        ProfileParser.fhostmcc = "";
        ProfileParser.orrn = "";
        ProfileParser.tmsusername = "";
        ProfileParser.tmstid = "";
        ProfileParser.phoneNumber = "";
        ProfileParser.response = null;
        ProfileParser.receiving = null;
        ProfileParser.sending = null;
        ProfileParser.notification = null;
        ProfileParser.sourceParameter = null;
        ProfileParser.profileId = null;
    }

    public static String getResponseDetails(String res)
    {
        if(res == null)
            return "Please Attempt Again";
        if(res.equals("00"))
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

    public static String hexStringToByteArray(String hex) {
        try {
            int l = hex.length();
            byte[] data = new byte[l / 2];
            for (int i = 0; i < l; i += 2) {
                data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                        + Character.digit(hex.charAt(i + 1), 16));
            }
            String st = new String(data, StandardCharsets.UTF_8);
            return st;
        }catch(Exception e)
        {
            return "-/";
        }
    }
}
