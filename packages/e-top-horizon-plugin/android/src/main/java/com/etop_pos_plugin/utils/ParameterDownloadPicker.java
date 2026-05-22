package com.etop_pos_plugin.utils;

import com.etop_pos_plugin.networking.model.ParameterModel;

public class ParameterDownloadPicker {

    public ParameterModel parseField62(String field62String) {
        ParameterModel parameterModel = new ParameterModel();
        String[] responseDataCodes = {
            TAG_LEN_CALL_HOME_TIME,
              TAG_LEN_CARD_ACCEPTOR_ID_CODE,
               TAG_LEN_COUNTRY_CODE,
              TAG_LEN_EPMS_DATE_TIME,
               TAG_LEN_CURRENCY_CODE,
               TAG_LEN_MERCHANT_CATEGORY_CODE,
               TAG_LEN_MERCHANT_NAME_LOCATION,
               TAG_LEN_TIMEOUT
        };

        for (String dataCode : responseDataCodes) {
            String data = getDownloadParameterManagementData(dataCode, field62String);
            switch (dataCode) {
                case TAG_LEN_CALL_HOME_TIME:
                    parameterModel.setCallHome(data);
                    break;
                case TAG_LEN_CARD_ACCEPTOR_ID_CODE:
                    parameterModel.setMid(data);
                    break;
                case TAG_LEN_COUNTRY_CODE:
                    parameterModel.setCountryCode(data);

                    break;
                case TAG_LEN_EPMS_DATE_TIME:
                    parameterModel.setCtMkDatetime(data);

                    break;
                case TAG_LEN_CURRENCY_CODE:
                    parameterModel.setCurrencyCode(data);
                    break;
                case TAG_LEN_MERCHANT_CATEGORY_CODE:
                    parameterModel.setMcc(data);
                    break;
                case TAG_LEN_MERCHANT_NAME_LOCATION:
                    parameterModel.setMnl(data);

                    break;
                case TAG_LEN_TIMEOUT:
                    parameterModel.setTimeout(data);

                    break;
            }
        }

        return parameterModel;
    }


    private String getDownloadParameterManagementData(String mgtCode, String mainString) {
        int lengthOfTag = 2;

        int indexOfMgtCodeInMainString = mainString.indexOf(mgtCode);

        if (indexOfMgtCodeInMainString < 0) {
            // throw new IllegalArgumentException("Could not locate data");
            return "";
        }

        String dataLenString = mgtCode.substring(lengthOfTag);

        int dataLength = Integer.parseInt(dataLenString);

        int indexOfMgtData = indexOfMgtCodeInMainString + mgtCode.length();

        return mainString.substring(indexOfMgtData, indexOfMgtData + dataLength);
    }


    private final String TAG_LEN_EPMS_DATE_TIME = "02014";
    private final String TAG_LEN_CARD_ACCEPTOR_ID_CODE = "03015";
    private final String TAG_LEN_TIMEOUT = "04002";
    private final String TAG_LEN_CURRENCY_CODE = "05003";
    private final String TAG_LEN_COUNTRY_CODE = "06003";
    private final String TAG_LEN_CALL_HOME_TIME = "07002";
    private final String TAG_LEN_MERCHANT_NAME_LOCATION = "52040";
    private final String TAG_LEN_MERCHANT_CATEGORY_CODE = "08004";
}
