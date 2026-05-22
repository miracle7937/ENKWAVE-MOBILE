package com.etop_pos_plugin.utils;

import com.horizonpay.smartpossdk.aidl.emv.AidEntity;
import com.horizonpay.smartpossdk.aidl.emv.CapkEntity;

import java.util.ArrayList;
import java.util.List;

/***************************************************************************************************
 *                          Copyright (C),  Shenzhen Horizon Technology Limited                    *
 *                                   http://www.horizonpay.cn                                      *
 ***************************************************************************************************
 * usage           :
 * Version         : 1
 * Author          : Ashur Liu
 * Date            : 2017/12/18
 * Modify          : create file
 **************************************************************************************************/
public class AidsUtil {
    public static List<AidEntity> getAllAids(){
        return generateAids();
    }

    public static List<CapkEntity> getAllCapks(){
        List<CapkEntity> capkEntityList =new ArrayList<>();

        capkEntityList.addAll(generateAmexTestCapks());
        capkEntityList.addAll(generateAmexProductionCapks());

        capkEntityList.addAll(generateMasterTestCapks());
        capkEntityList.addAll(generateMasterProductionCapks());

        capkEntityList.addAll(generateVisaTestCapks());
        capkEntityList.addAll(generateVisaProductionCapks());

        capkEntityList.addAll(generateJcbTestCapks());
        capkEntityList.addAll(generateJcbLiveCapks());
        capkEntityList.addAll(generateCupTestCapks());
        return capkEntityList;
    }




    private static List<AidEntity> generateAids(){
        List<AidEntity> aidEntityList =new ArrayList<>();
//added by miracle for verve
        AidEntity appVerve= AidEntity.builder()
                .AID("A0000003710001")
                .selFlag(0)
                .appVersion("0001")
                .DDOL("9F3704")
                .tacDefault("DC4000A800")
                .tacOnline("DC4004F800")
                .tacDenial("0010000000")
                .rdCtlsFloorLimit(0)
                .rdCtlsCvmLimit(0)
                .rdCtlsTransLimit(10000)
                .rdVisaTransLimit(10000)
                .floorLimit(10000)
                .onlinePinCap(true)
                .maxTargetPer(80)
                .targetPer(80)
                .threshold(100)
                .build();
        aidEntityList.add(appVerve);

        AidEntity appAmex= AidEntity.builder()
                .AID("A00000002501")
                .selFlag(0)
                .appVersion("0001")
                .DDOL("9F3704")
                .tacDefault("DC50FC9800")
                .tacOnline("DE00FC9800")
                .tacDenial("0010000000")
                .rdCtlsFloorLimit(0)
                .rdCtlsCvmLimit(0)
                .rdCtlsTransLimit(10000)
                .rdVisaTransLimit(10000)
                .floorLimit(10000)
                .onlinePinCap(true)
                .maxTargetPer(80)
                .targetPer(80)
                .threshold(100)
                .build();
        aidEntityList.add(appAmex);

        AidEntity appMaster2= AidEntity.builder()
                .AID("A0000000041010")
                .selFlag(0)
                .appVersion("0001")
                .DDOL("9F3704")
                .tacDefault("CC00FC8000")
                .tacOnline("CC00FC8000")
                .tacDenial("0000000000")
                .rdCtlsFloorLimit(0)
                .rdCtlsCvmLimit(0)
                .rdCtlsTransLimit(10000)
                .rdVisaTransLimit(10000)
                .floorLimit(10000)
                .onlinePinCap(true)
                .maxTargetPer(80)
                .targetPer(80)
                .threshold(100)
                .build();
        aidEntityList.add(appMaster2);

        AidEntity appVisa= AidEntity.builder()
                .AID("A0000000031010")
                .selFlag(0)
                .appVersion("0001")
                .DDOL("9F3704")
                .tacDefault("DC4000A800")
                .tacOnline("DC4004F800")
                .tacDenial("0010000000")
                .rdCtlsFloorLimit(0)
                .rdCtlsCvmLimit(0)
                .rdCtlsTransLimit(10000)
                .rdVisaTransLimit(10000)
                .floorLimit(10000)
                .onlinePinCap(true)
                .maxTargetPer(80)
                .targetPer(80)
                .threshold(100)
                .build();
        aidEntityList.add(appVisa);

        AidEntity appVisa1= AidEntity.builder()
                .AID("A0000000032010")
                .selFlag(0)
                .appVersion("0001")
                .DDOL("9F3704")
                .tacDefault("DC4000A800")
                .tacOnline("DC4004F800")
                .tacDenial("0010000000")
                .rdCtlsFloorLimit(0)
                .rdCtlsCvmLimit(0)
                .rdCtlsTransLimit(10000)
                .rdVisaTransLimit(10000)
                .floorLimit(10000)
                .onlinePinCap(true)
                .maxTargetPer(80)
                .targetPer(80)
                .threshold(100)
                .build();
        aidEntityList.add(appVisa1);



        AidEntity appJcb= AidEntity.builder()
                .AID("A0000000651010")
                .selFlag(0)
                .appVersion("0001")
                .DDOL("9F3704")
                .tacDefault("FC6024A800")
                .tacOnline("FC60ACF800")
                .tacDenial("0010000000")
                .rdCtlsFloorLimit(0)
                .rdCtlsCvmLimit(0)
                .rdCtlsTransLimit(10000)
                .rdVisaTransLimit(10000)
                .floorLimit(10000)
                .onlinePinCap(true)
                .maxTargetPer(80)
                .build();
        aidEntityList.add(appJcb);



        AidEntity appCupDebit = new AidEntity.Builder()
                .AID("A000000333010101")
                .selFlag(0)
                .appVersion("0020")
                .DDOL("9F3704")
                .tacDefault("D84000A800")
                .tacOnline("D84004F800")
                .tacDenial("0010000000")
                .rdCtlsFloorLimit(0)
                .rdCtlsCvmLimit(0)
                .rdCtlsTransLimit(10000)
                .rdVisaTransLimit(10000)
                .floorLimit(0)
                .onlinePinCap(true)
                .maxTargetPer(99)
                .build();


        aidEntityList.add(appCupDebit);

        AidEntity appCupCredit = new AidEntity.Builder()
                .AID("A000000333010102")
                .selFlag(0)
                .appVersion("0020")
                .DDOL("9F3704")
                .tacDefault("D84000A800")
                .tacOnline("D84004F800")
                .tacDenial("0010000000")
                .rdCtlsFloorLimit(0)
                .rdCtlsCvmLimit(0)
                .rdCtlsTransLimit(10000)
                .rdVisaTransLimit(10000)
                .floorLimit(0)
                .onlinePinCap(true)
                .maxTargetPer(99)
                .build();
        aidEntityList.add(appCupCredit);

        AidEntity appCupQuasiCredit = new AidEntity.Builder()
                .AID("A000000333010103")
                .selFlag(0)
                .appVersion("0020")
                .DDOL("9F3704")
                .tacDefault("D84000A800")
                .tacOnline("D84004F800")
                .tacDenial("0010000000")
                .rdCtlsFloorLimit(0)
                .rdCtlsCvmLimit(0)
                .rdCtlsTransLimit(10000)
                .rdVisaTransLimit(10000)
                .floorLimit(0)
                .onlinePinCap(true)
                .maxTargetPer(99)
                .build();
        aidEntityList.add(appCupQuasiCredit);

        return aidEntityList;


    }

    private static List<CapkEntity> generateAmexTestCapks(){
        List<CapkEntity> capkEntityList =new ArrayList<>();
        //  Amex Test Capk
        CapkEntity capkAmex0xc8 = CapkEntity.builder()
                .RID("A000000025")
                .capkIndex(0xc8)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("BF0CFCED708FB6B048E3014336EA24AA007D7967B8AA4E613D26D015C4FE7805D9DB131CED0D2A8ED504C3B5CCD48C33199E5A5BF644DA043B54DBF60276F05B1750FAB39098C7511D04BABC649482DDCF7CC42C8C435BAB8DD0EB1A620C31111D1AAAF9AF6571EEBD4CF5A08496D57E7ABDBB5180E0A42DA869AB95FB620EFF2641C3702AF3BE0B0C138EAEF202E21D")
                .exponent("03")
                .checkSum("33BD7A059FAB094939B90A8F35845C9DC779BD50")
                .build();
        capkEntityList.add(capkAmex0xc8);

        CapkEntity capkAmex0xc9 = CapkEntity.builder()
                .RID("A000000025")
                .capkIndex(0xc9)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("B362DB5733C15B8797B8ECEE55CB1A371F760E0BEDD3715BB270424FD4EA26062C38C3F4AAA3732A83D36EA8E9602F6683EECC6BAFF63DD2D49014BDE4D6D603CD744206B05B4BAD0C64C63AB3976B5C8CAAF8539549F5921C0B700D5B0F83C4E7E946068BAAAB5463544DB18C63801118F2182EFCC8A1E85E53C2A7AE839A5C6A3CABE73762B70D170AB64AFC6CA482944902611FB0061E09A67ACB77E493D998A0CCF93D81A4F6C0DC6B7DF22E62DB")
                .exponent("03")
                .checkSum("8E8DFF443D78CD91DE88821D70C98F0638E51E49")
                .build();
        capkEntityList.add(capkAmex0xc9);

        CapkEntity capkAmex0xca = CapkEntity.builder()
                .RID("A000000025")
                .capkIndex(0xca)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("C23ECBD7119F479C2EE546C123A585D697A7D10B55C2D28BEF0D299C01DC65420A03FE5227ECDECB8025FBC86EEBC1935298C1753AB849936749719591758C315FA150400789BB14FADD6EAE2AD617DA38163199D1BAD5D3F8F6A7A20AEF420ADFE2404D30B219359C6A4952565CCCA6F11EC5BE564B49B0EA5BF5B3DC8C5C6401208D0029C3957A8C5922CBDE39D3A564C6DEBB6BD2AEF91FC27BB3D3892BEB9646DCE2E1EF8581EFFA712158AAEC541C0BBB4B3E279D7DA54E45A0ACC3570E712C9F7CDF985CFAFD382AE13A3B214A9E8E1E71AB1EA707895112ABC3A97D0FCB0AE2EE5C85492B6CFD54885CDD6337E895CC70FB3255E3")
                .exponent("03")
                .checkSum("6BDA32B1AA171444C7E8F88075A74FBFE845765F")
                .build();
        capkEntityList.add(capkAmex0xca);
        return capkEntityList;
    }

    private static List<CapkEntity> generateAmexProductionCapks(){
        List<CapkEntity> capkEntityList =new ArrayList<>();
        // Amex Production Capk
        CapkEntity capkAmex0x0e = CapkEntity.builder()
                .RID("A000000025")
                .capkIndex(0x0e)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("AA94A8C6DAD24F9BA56A27C09B01020819568B81A026BE9FD0A3416CA9A71166ED5084ED91CED47DD457DB7E6CBCD53E560BC5DF48ABC380993B6D549F5196CFA77DFB20A0296188E969A2772E8C4141665F8BB2516BA2C7B5FC91F8DA04E8D512EB0F6411516FB86FC021CE7E969DA94D33937909A53A57F907C40C22009DA7532CB3BE509AE173B39AD6A01BA5BB85")
                .exponent("03")
                .checkSum("A7266ABAE64B42A3668851191D49856E17F8FBCD")
                .build();
        capkEntityList.add(capkAmex0x0e);

        CapkEntity capkAmex0x0f = CapkEntity.builder()
                .RID("A000000025")
                .capkIndex(0x0e)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("C8D5AC27A5E1FB89978C7C6479AF993AB3800EB243996FBB2AE26B67B23AC482C4B746005A51AFA7D2D83E894F591A2357B30F85B85627FF15DA12290F70F05766552BA11AD34B7109FA49DE29DCB0109670875A17EA95549E92347B948AA1F045756DE56B707E3863E59A6CBE99C1272EF65FB66CBB4CFF070F36029DD76218B21242645B51CA752AF37E70BE1A84FF31079DC0048E928883EC4FADD497A719385C2BBBEBC5A66AA5E5655D18034EC5")
                .exponent("03")
                .checkSum("5A0454618287E944E25FB862B1C5D4A10D4CD5E0")
                .build();
        capkEntityList.add(capkAmex0x0f);

        CapkEntity capkAmex0x10 = CapkEntity.builder()
                .RID("A000000025")
                .capkIndex(0x10)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("CF98DFEDB3D3727965EE7797723355E0751C81D2D3DF4D18EBAB9FB9D49F38C8C4A826B99DC9DEA3F01043D4BF22AC3550E2962A59639B1332156422F788B9C16D40135EFD1BA94147750575E636B6EBC618734C91C1D1BF3EDC2A46A43901668E0FFC136774080E888044F6A1E65DC9AAA8928DACBEB0DB55EA3514686C6A732CEF55EE27CF877F110652694A0E3484C855D882AE191674E25C296205BBB599455176FDD7BBC549F27BA5FE35336F7E29E68D783973199436633C67EE5A680F05160ED12D1665EC83D1997F10FD05BBDBF9433E8F797AEE3E9F02A34228ACE927ABE62B8B9281AD08D3DF5C7379685045D7BA5FCDE58637")
                .exponent("03")
                .checkSum("C729CF2FD262394ABC4CC173506502446AA9B9FD")
                .build();
        capkEntityList.add(capkAmex0x10);

        return capkEntityList;


    }
    private static List<CapkEntity> generateMasterTestCapks(){
        List<CapkEntity> capkEntityList =new ArrayList<>();
        // MasterCard Test Capk
        CapkEntity capkMaster0xfe = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0xfe)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("A90FCD55AA2D5D9963E35ED0F440177699832F49C6BAB15CDAE5794BE93F934D4462D5D12762E48C38BA83D8445DEAA74195A301A102B2F114EADA0D180EE5E7A5C73E0C4E11F67A43DDAB5D55683B1474CC0627F44B8D3088A492FFAADAD4F42422D0E7013536C3C49AD3D0FAE96459B0F6B1B6056538A3D6D44640F94467B108867DEC40FAAECD740C00E2B7A8852D")
                .exponent("03")
                .checkSum("95D0A75BB4A9789F1297942D7DF929B1994E9550")
                .build();
        capkEntityList.add(capkMaster0xfe);

        CapkEntity capkMaster0xf1 = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0xf1)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("A0DCF4BDE19C3546B4B6F0414D174DDE294AABBB828C5A834D73AAE27C99B0B053A90278007239B6459FF0BBCD7B4B9C6C50AC02CE91368DA1BD21AAEADBC65347337D89B68F5C99A09D05BE02DD1F8C5BA20E2F13FB2A27C41D3F85CAD5CF6668E75851EC66EDBF98851FD4E42C44C1D59F5984703B27D5B9F21B8FA0D93279FBBF69E090642909C9EA27F898959541AA6757F5F624104F6E1D3A9532F2A6E51515AEAD1B43B3D7835088A2FAFA7BE7")
                .exponent("03")
                .checkSum("D8E68DA167AB5A85D8C3D55ECB9B0517A1A5B4BB")
                .build();
        capkEntityList.add(capkMaster0xf1);

        CapkEntity capkMaster0xef = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0xef)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("A191CB87473F29349B5D60A88B3EAEE0973AA6F1A082F358D849FDDFF9C091F899EDA9792CAF09EF28F5D22404B88A2293EEBBC1949C43BEA4D60CFD879A1539544E09E0F09F60F065B2BF2A13ECC705F3D468B9D33AE77AD9D3F19CA40F23DCF5EB7C04DC8F69EBA565B1EBCB4686CD274785530FF6F6E9EE43AA43FDB02CE00DAEC15C7B8FD6A9B394BABA419D3F6DC85E16569BE8E76989688EFEA2DF22FF7D35C043338DEAA982A02B866DE5328519EBBCD6F03CDD686673847F84DB651AB86C28CF1462562C577B853564A290C8556D818531268D25CC98A4CC6A0BDFFFDA2DCCA3A94C998559E307FDDF915006D9A987B07DDAEB3B")
                .exponent("03")
                .checkSum("21766EBB0EE122AFB65D7845B73DB46BAB65427A")
                .build();
        capkEntityList.add(capkMaster0xef);

        CapkEntity capkMaster0xf8 = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0xf8)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("A1F5E1C9BD8650BD43AB6EE56B891EF7459C0A24FA84F9127D1A6C79D4930F6DB1852E2510F18B61CD354DB83A356BD190B88AB8DF04284D02A4204A7B6CB7C5551977A9B36379CA3DE1A08E69F301C95CC1C20506959275F41723DD5D2925290579E5A95B0DF6323FC8E9273D6F849198C4996209166D9BFC973C361CC826E1")
                .exponent("03")
                .checkSum("F06ECC6D2AAEBF259B7E755A38D9A9B24E2FF3DD")
                .build();
        capkEntityList.add(capkMaster0xf8);

        return capkEntityList;
    }

    private static List<CapkEntity> generateMasterProductionCapks() {
        List<CapkEntity> capkEntityList =new ArrayList<>();
        // MasterCard Production Capk
        CapkEntity capkMaster0x00 = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0x00)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("9E15214212F6308ACA78B80BD986AC287516846C8D548A9ED0A42E7D997C902C3E122D1B9DC30995F4E25C75DD7EE0A0CE293B8CC02B977278EF256D761194924764942FE714FA02E4D57F282BA3B2B62C9E38EF6517823F2CA831BDDF6D363D")
                .exponent("03")
                .checkSum("8BB99ADDF7B560110955014505FB6B5F8308CE27")
                .build();
        capkEntityList.add(capkMaster0x00);

        CapkEntity capkMaster0x01 = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0x01)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("D2010716C9FB5264D8C91A14F4F32F8981EE954F20087ED77CDC5868431728D3637C632CCF2718A4F5D92EA8AB166AB992D2DE24E9FBDC7CAB9729401E91C502D72B39F6866F5C098B1243B132AFEE65F5036E168323116338F8040834B98725")
                .exponent("03")
                .checkSum("EA950DD4234FEB7C900C0BE817F64DE66EEEF7C4")
                .build();
        capkEntityList.add(capkMaster0x01);

        CapkEntity capkMaster0x02 = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0x02)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("CF4264E1702D34CA897D1F9B66C5D63691EACC612C8F147116BB22D0C463495BD5BA70FB153848895220B8ADEEC3E7BAB31EA22C1DC9972FA027D54265BEBF0AE3A23A8A09187F21C856607B98BDA6FC908116816C502B3E58A145254EEFEE2A3335110224028B67809DCB8058E24895")
                .exponent("03")
                .checkSum("AF1CC1FD1C1BC9BCA07E78DA6CBA2163F169CBB7")
                .build();
        capkEntityList.add(capkMaster0x02);

        CapkEntity capkMaster0x03 = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0x03)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("C2490747FE17EB0584C88D47B1602704150ADC88C5B998BD59CE043EDEBF0FFEE3093AC7956AD3B6AD4554C6DE19A178D6DA295BE15D5220645E3C8131666FA4BE5B84FE131EA44B039307638B9E74A8C42564F892A64DF1CB15712B736E3374F1BBB6819371602D8970E97B900793C7C2A89A4A1649A59BE680574DD0B60145")
                .exponent("03")
                .checkSum("5ADDF21D09278661141179CBEFF272EA384B13BB")
                .build();
        capkEntityList.add(capkMaster0x03);

        CapkEntity capkMaster0x04 = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0x04)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("A6DA428387A502D7DDFB7A74D3F412BE762627197B25435B7A81716A700157DDD06F7CC99D6CA28C2470527E2C03616B9C59217357C2674F583B3BA5C7DCF2838692D023E3562420B4615C439CA97C44DC9A249CFCE7B3BFB22F68228C3AF13329AA4A613CF8DD853502373D62E49AB256D2BC17120E54AEDCED6D96A4287ACC5C04677D4A5A320DB8BEE2F775E5FEC5")
                .exponent("03")
                .checkSum("381A035DA58B482EE2AF75F4C3F2CA469BA4AA6C")
                .build();
        capkEntityList.add(capkMaster0x04);

        CapkEntity capkMaster0x05 = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0x05)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("B8048ABC30C90D976336543E3FD7091C8FE4800DF820ED55E7E94813ED00555B573FECA3D84AF6131A651D66CFF4284FB13B635EDD0EE40176D8BF04B7FD1C7BACF9AC7327DFAA8AA72D10DB3B8E70B2DDD811CB4196525EA386ACC33C0D9D4575916469C4E4F53E8E1C912CC618CB22DDE7C3568E90022E6BBA770202E4522A2DD623D180E215BD1D1507FE3DC90CA310D27B3EFCCD8F83DE3052CAD1E48938C68D095AAC91B5F37E28BB49EC7ED597")
                .exponent("03")
                .checkSum("EBFA0D5D06D8CE702DA3EAE890701D45E274C845")
                .build();
        capkEntityList.add(capkMaster0x05);


        CapkEntity capkMaster0x06 = CapkEntity.builder()
                .RID("A000000004")
                .capkIndex(0x06)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("CB26FC830B43785B2BCE37C81ED334622F9622F4C89AAE641046B2353433883F307FB7C974162DA72F7A4EC75D9D657336865B8D3023D3D645667625C9A07A6B7A137CF0C64198AE38FC238006FB2603F41F4F3BB9DA1347270F2F5D8C606E420958C5F7D50A71DE30142F70DE468889B5E3A08695B938A50FC980393A9CBCE44AD2D64F630BB33AD3F5F5FD495D31F37818C1D94071342E07F1BEC2194F6035BA5DED3936500EB82DFDA6E8AFB655B1EF3D0D7EBF86B66DD9F29F6B1D324FE8B26CE38AB2013DD13F611E7A594D675C4432350EA244CC34F3873CBA06592987A1D7E852ADC22EF5A2EE28132031E48F74037E3B34AB747F")
                .exponent("03")
                .checkSum("F910A1504D5FFB793D94F3B500765E1ABCAD72D9")
                .build();
        capkEntityList.add(capkMaster0x06);

        return capkEntityList;
    }
    private static List<CapkEntity> generateVisaTestCapks(){
        List<CapkEntity> capkEntityList =new ArrayList<>();
        // Visa Test Capk

        CapkEntity capkVisa0x95 = CapkEntity.builder()
                .RID("A000000003")
                .capkIndex(0x95)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("BE9E1FA5E9A803852999C4AB432DB28600DCD9DAB76DFAAA47355A0FE37B1508AC6BF38860D3C6C2E5B12A3CAAF2A7005A7241EBAA7771112C74CF9A0634652FBCA0E5980C54A64761EA101A114E0F0B5572ADD57D010B7C9C887E104CA4EE1272DA66D997B9A90B5A6D624AB6C57E73C8F919000EB5F684898EF8C3DBEFB330C62660BED88EA78E909AFF05F6DA627B")
                .exponent("03")
                .checkSum("EE1511CEC71020A9B90443B37B1D5F6E703030F6")
                .build();
        capkEntityList.add(capkVisa0x95);

        CapkEntity capkVisa0x92 = CapkEntity.builder()
                .RID("A000000003")
                .capkIndex(0x92)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("996AF56F569187D09293C14810450ED8EE3357397B18A2458EFAA92DA3B6DF6514EC060195318FD43BE9B8F0CC669E3F844057CBDDF8BDA191BB64473BC8DC9A730DB8F6B4EDE3924186FFD9B8C7735789C23A36BA0B8AF65372EB57EA5D89E7D14E9C7B6B557460F10885DA16AC923F15AF3758F0F03EBD3C5C2C949CBA306DB44E6A2C076C5F67E281D7EF56785DC4D75945E491F01918800A9E2DC66F60080566CE0DAF8D17EAD46AD8E30A247C9F")
                .exponent("03")
                .checkSum("429C954A3859CEF91295F663C963E582ED6EB253")
                .build();
        capkEntityList.add(capkVisa0x92);

        CapkEntity capkVisa0x94 = CapkEntity.builder()
                .RID("A000000003")
                .capkIndex(0x94)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("ACD2B12302EE644F3F835ABD1FC7A6F62CCE48FFEC622AA8EF062BEF6FB8BA8BC68BBF6AB5870EED579BC3973E121303D34841A796D6DCBC41DBF9E52C4609795C0CCF7EE86FA1D5CB041071ED2C51D2202F63F1156C58A92D38BC60BDF424E1776E2BC9648078A03B36FB554375FC53D57C73F5160EA59F3AFC5398EC7B67758D65C9BFF7828B6B82D4BE124A416AB7301914311EA462C19F771F31B3B57336000DFF732D3B83DE07052D730354D297BEC72871DCCF0E193F171ABA27EE464C6A97690943D59BDABB2A27EB71CEEBDAFA1176046478FD62FEC452D5CA393296530AA3F41927ADFE434A2DF2AE3054F8840657A26E0FC617")
                .exponent("03")
                .checkSum("C4A3C43CCF87327D136B804160E47D43B60E6E0F")
                .build();
        capkEntityList.add(capkVisa0x94);

        return capkEntityList;


    }
    private static List<CapkEntity> generateVisaProductionCapks() {
        List<CapkEntity> capkEntityList =new ArrayList<>();
        // Visa Production Capk
        CapkEntity capkVisa0x01 = CapkEntity.builder()
                .RID("A000000003")
                .capkIndex(0x01)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("C696034213D7D8546984579D1D0F0EA519CFF8DEFFC429354CF3A871A6F7183F1228DA5C7470C055387100CB935A712C4E2864DF5D64BA93FE7E63E71F25B1E5F5298575EBE1C63AA617706917911DC2A75AC28B251C7EF40F2365912490B939BCA2124A30A28F54402C34AECA331AB67E1E79B285DD5771B5D9FF79EA630B75")
                .exponent("03")
                .checkSum("D34A6A776011C7E7CE3AEC5F03AD2F8CFC5503CC")
                .build();
        capkEntityList.add(capkVisa0x01);

        CapkEntity capkVisa0x07 = CapkEntity.builder()
                .RID("A000000003")
                .capkIndex(0x07)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("A89F25A56FA6DA258C8CA8B40427D927B4A1EB4D7EA326BBB12F97DED70AE5E4480FC9C5E8A972177110A1CC318D06D2F8F5C4844AC5FA79A4DC470BB11ED635699C17081B90F1B984F12E92C1C529276D8AF8EC7F28492097D8CD5BECEA16FE4088F6CFAB4A1B42328A1B996F9278B0B7E3311CA5EF856C2F888474B83612A82E4E00D0CD4069A6783140433D50725F")
                .exponent("03")
                .checkSum("B4BC56CC4E88324932CBC643D6898F6FE593B172")
                .build();
        capkEntityList.add(capkVisa0x07);

        CapkEntity capkVisa0x08 = CapkEntity.builder()
                .RID("A000000003")
                .capkIndex(0x08)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("D9FD6ED75D51D0E30664BD157023EAA1FFA871E4DA65672B863D255E81E137A51DE4F72BCC9E44ACE12127F87E263D3AF9DD9CF35CA4A7B01E907000BA85D24954C2FCA3074825DDD4C0C8F186CB020F683E02F2DEAD3969133F06F7845166ACEB57CA0FC2603445469811D293BFEFBAFAB57631B3DD91E796BF850A25012F1AE38F05AA5C4D6D03B1DC2E568612785938BBC9B3CD3A910C1DA55A5A9218ACE0F7A21287752682F15832A678D6E1ED0B")
                .exponent("03")
                .checkSum("20D213126955DE205ADC2FD2822BD22DE21CF9A8")
                .build();
        capkEntityList.add(capkVisa0x08);

        CapkEntity capkVisa0x09 = CapkEntity.builder()
                .RID("A000000003")
                .capkIndex(0x09)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("9D912248DE0A4E39C1A7DDE3F6D2588992C1A4095AFBD1824D1BA74847F2BC4926D2EFD904B4B54954CD189A54C5D1179654F8F9B0D2AB5F0357EB642FEDA95D3912C6576945FAB897E7062CAA44A4AA06B8FE6E3DBA18AF6AE3738E30429EE9BE03427C9D64F695FA8CAB4BFE376853EA34AD1D76BFCAD15908C077FFE6DC5521ECEF5D278A96E26F57359FFAEDA19434B937F1AD999DC5C41EB11935B44C18100E857F431A4A5A6BB65114F174C2D7B59FDF237D6BB1DD0916E644D709DED56481477C75D95CDD68254615F7740EC07F330AC5D67BCD75BF23D28A140826C026DBDE971A37CD3EF9B8DF644AC385010501EFC6509D7A41")
                .exponent("03")
                .checkSum("1FF80A40173F52D7D27E0F26A146A1C8CCB29046")
                .build();
        capkEntityList.add(capkVisa0x09);

        return capkEntityList;
    }

    private static List<CapkEntity> generateJcbTestCapks(){
        List<CapkEntity> capkEntityList =new ArrayList<>();

        CapkEntity capkJcb0x0f = CapkEntity.builder()
                .RID("A000000065")
                .capkIndex(0x0f)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("9EFBADDE4071D4EF98C969EB32AF854864602E515D6501FDE576B310964A4F7C2CE842ABEFAFC5DC9E26A619BCF2614FE07375B9249BEFA09CFEE70232E75FFD647571280C76FFCA87511AD255B98A6B577591AF01D003BD6BF7E1FCE4DFD20D0D0297ED5ECA25DE261F37EFE9E175FB5F12D2503D8CFB060A63138511FE0E125CF3A643AFD7D66DCF9682BD246DDEA1")
                .exponent("03")
                .checkSum("2A1B82DE00F5F0C401760ADF528228D3EDE0F403")
                .build();
        capkEntityList.add(capkJcb0x0f);

        CapkEntity capkJcb0x11 = CapkEntity.builder()
                .RID("A000000065")
                .capkIndex(0x11)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("A2583AA40746E3A63C22478F576D1EFC5FB046135A6FC739E82B55035F71B09BEB566EDB9968DD649B94B6DEDC033899884E908C27BE1CD291E5436F762553297763DAA3B890D778C0F01E3344CECDFB3BA70D7E055B8C760D0179A403D6B55F2B3B083912B183ADB7927441BED3395A199EEFE0DEBD1F5FC3264033DA856F4A8B93916885BD42F9C1F456AAB8CFA83AC574833EB5E87BB9D4C006A4B5346BD9E17E139AB6552D9C58BC041195336485")
                .exponent("03")
                .checkSum("D9FD62C9DD4E6DE7741E9A17FB1FF2C5DB948BCB")
                .build();
        capkEntityList.add(capkJcb0x11);

        CapkEntity capkJcb0x13 = CapkEntity.builder()
                .RID("A000000065")
                .capkIndex(0x13)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("A3270868367E6E29349FC2743EE545AC53BD3029782488997650108524FD051E3B6EACA6A9A6C1441D28889A5F46413C8F62F3645AAEB30A1521EEF41FD4F3445BFA1AB29F9AC1A74D9A16B93293296CB09162B149BAC22F88AD8F322D684D6B49A12413FC1B6AC70EDEDB18EC1585519A89B50B3D03E14063C2CA58B7C2BA7FB22799A33BCDE6AFCBEB4A7D64911D08D18C47F9BD14A9FAD8805A15DE5A38945A97919B7AB88EFA11A88C0CD92C6EE7DC352AB0746ABF13585913C8A4E04464B77909C6BD94341A8976C4769EA6C0D30A60F4EE8FA19E767B170DF4FA80312DBA61DB645D5D1560873E2674E1F620083F30180BD96CA589")
                .exponent("03")
                .checkSum("54CFAE617150DFA09D3F901C9123524523EBEDF3")
                .build();
        capkEntityList.add(capkJcb0x13);

        return capkEntityList;

    }

    private static List<CapkEntity> generateJcbLiveCapks(){
        List<CapkEntity> capkEntityList =new ArrayList<>();

        CapkEntity capkJcb0x10 = CapkEntity.builder()
                .RID("A000000065")
                .capkIndex(0x10)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("99B63464EE0B4957E4FD23BF923D12B61469B8FFF8814346B2ED6A780F8988EA9CF0433BC1E655F05EFA66D0C98098F25B659D7A25B8478A36E489760D071F54CDF7416948ED733D816349DA2AADDA227EE45936203CBF628CD033AABA5E5A6E4AE37FBACB4611B4113ED427529C636F6C3304F8ABDD6D9AD660516AE87F7F2DDF1D2FA44C164727E56BBC9BA23C0285")
                .exponent("03")
                .checkSum("C75E5210CBE6E8F0594A0F1911B07418CADB5BAB")
                .build();
        capkEntityList.add(capkJcb0x10);

        CapkEntity capkJcb0x12 = CapkEntity.builder()
                .RID("A000000065")
                .capkIndex(0x12)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("ADF05CD4C5B490B087C3467B0F3043750438848461288BFEFD6198DD576DC3AD7A7CFA07DBA128C247A8EAB30DC3A30B02FCD7F1C8167965463626FEFF8AB1AA61A4B9AEF09EE12B009842A1ABA01ADB4A2B170668781EC92B60F605FD12B2B2A6F1FE734BE510F60DC5D189E401451B62B4E06851EC20EBFF4522AACC2E9CDC89BC5D8CDE5D633CFD77220FF6BBD4A9B441473CC3C6FEFC8D13E57C3DE97E1269FA19F655215B23563ED1D1860D8681")
                .exponent("03")
                .checkSum("874B379B7F607DC1CAF87A19E400B6A9E25163E8")
                .build();
        capkEntityList.add(capkJcb0x12);

        CapkEntity capkJcb0x14 = CapkEntity.builder()
                .RID("A000000065")
                .capkIndex(0x14)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("AEED55B9EE00E1ECEB045F61D2DA9A66AB637B43FB5CDBDB22A2FBB25BE061E937E38244EE5132F530144A3F268907D8FD648863F5A96FED7E42089E93457ADC0E1BC89C58A0DB72675FBC47FEE9FF33C16ADE6D341936B06B6A6F5EF6F66A4EDD981DF75DA8399C3053F430ECA342437C23AF423A211AC9F58EAF09B0F837DE9D86C7109DB1646561AA5AF0289AF5514AC64BC2D9D36A179BB8A7971E2BFA03A9E4B847FD3D63524D43A0E8003547B94A8A75E519DF3177D0A60BC0B4BAB1EA59A2CBB4D2D62354E926E9C7D3BE4181E81BA60F8285A896D17DA8C3242481B6C405769A39D547C74ED9FF95A70A796046B5EFF36682DC29")
                .exponent("03")
                .checkSum("C0D15F6CD957E491DB56DCDD1CA87A03EBE06B7B")
                .build();
        capkEntityList.add(capkJcb0x14);

        return capkEntityList;

    }

    private static List<CapkEntity> generateCupTestCapks(){
        List<CapkEntity> capkEntityList =new ArrayList<>();

        CapkEntity capkCup0x0A = CapkEntity.builder()
                .RID("A000000333")
                .capkIndex(0x0A)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("B2AB1B6E9AC55A75ADFD5BBC34490E53C4C3381F34E60E7FAC21CC2B26DD34462B64A6FAE2495ED1DD383B8138BEA100FF9B7A111817E7B9869A9742B19E5C9DAC56F8B8827F11B05A08ECCF9E8D5E85B0F7CFA644EFF3E9B796688F38E006DEB21E101C01028903A06023AC5AAB8635F8E307A53AC742BDCE6A283F585F48EF")
                .exponent("03")
                .checkSum("C88BE6B2417C4F941C9371EA35A377158767E4E3")
                .build();
        capkEntityList.add(capkCup0x0A);

        CapkEntity capkCup0x08 = CapkEntity.builder()
                .RID("A000000333")
                .capkIndex(0x08)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("B61645EDFD5498FB246444037A0FA18C0F101EBD8EFA54573CE6E6A7FBF63ED21D66340852B0211CF5EEF6A1CD989F66AF21A8EB19DBD8DBC3706D135363A0D683D046304F5A836BC1BC632821AFE7A2F75DA3C50AC74C545A754562204137169663CFCC0B06E67E2109EBA41BC67FF20CC8AC80D7B6EE1A95465B3B2657533EA56D92D539E5064360EA4850FED2D1BF")
                .exponent("03")
                .checkSum("EE23B616C95C02652AD18860E48787C079E8E85A")
                .build();
        capkEntityList.add(capkCup0x08);


        CapkEntity capkCup0x09 = CapkEntity.builder()
                .RID("A000000333")
                .capkIndex(0x09)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("EB374DFC5A96B71D2863875EDA2EAFB96B1B439D3ECE0B1826A2672EEEFA7990286776F8BD989A15141A75C384DFC14FEF9243AAB32707659BE9E4797A247C2F0B6D99372F384AF62FE23BC54BCDC57A9ACD1D5585C303F201EF4E8B806AFB809DB1A3DB1CD112AC884F164A67B99C7D6E5A8A6DF1D3CAE6D7ED3D5BE725B2DE4ADE23FA679BF4EB15A93D8A6E29C7FFA1A70DE2E54F593D908A3BF9EBBD760BBFDC8DB8B54497E6C5BE0E4A4DAC29E5")
                .exponent("03")
                .checkSum("A075306EAB0045BAF72CDD33B3B678779DE1F527")
                .build();
        capkEntityList.add(capkCup0x09);

        CapkEntity capkCup0x0B = CapkEntity.builder()
                .RID("A000000333")
                .capkIndex(0x0B)
                .arithInd(0x01)
                .hashInd(0x01)
                .expDate("211231")
                .modul("CF9FDF46B356378E9AF311B0F981B21A1F22F250FB11F55C958709E3C7241918293483289EAE688A094C02C344E2999F315A72841F489E24B1BA0056CFAB3B479D0E826452375DCDBB67E97EC2AA66F4601D774FEAEF775ACCC621BFEB65FB0053FC5F392AA5E1D4C41A4DE9FFDFDF1327C4BB874F1F63A599EE3902FE95E729FD78D4234DC7E6CF1ABABAA3F6DB29B7F05D1D901D2E76A606A8CBFFFFECBD918FA2D278BDB43B0434F5D45134BE1C2781D157D501FF43E5F1C470967CD57CE53B64D82974C8275937C5D8502A1252A8A5D6088A259B694F98648D9AF2CB0EFD9D943C69F896D49FA39702162ACB5AF29B90BADE005BC157")
                .exponent("03")
                .checkSum("BD331F9996A490B33C13441066A09AD3FEB5F66C")
                .build();
        capkEntityList.add(capkCup0x0B);

        return capkEntityList;
    }


}

