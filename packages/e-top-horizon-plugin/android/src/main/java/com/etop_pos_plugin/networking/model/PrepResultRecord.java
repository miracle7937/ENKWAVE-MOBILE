package com.etop_pos_plugin.networking.model;

import com.etop_pos_plugin.networking.prep.GetMasterKey;
import com.etop_pos_plugin.networking.prep.GetParameter;
import com.etop_pos_plugin.networking.prep.GetPinKey;
import com.etop_pos_plugin.networking.prep.GetSessionKey;

public class PrepResultRecord {
    MasterKeyModel masterKeyModel ;
    SessionKeyModel sessionKeyModel ;
    PinKeyModel pinKeyModel;
     ParameterModel parameterModel ;

    @Override
    public String toString() {
        return "PrepResultRecord{" +
                "masterKeyModel=" + masterKeyModel +
                ", sessionKeyModel=" + sessionKeyModel +
                ", pinKeyModel=" + pinKeyModel +
                ", parameterModel=" + parameterModel +
                '}';
    }

    public MasterKeyModel getMasterKeyModel() {
        return masterKeyModel;
    }

    public void setMasterKeyModel(MasterKeyModel masterKeyModel) {
        this.masterKeyModel = masterKeyModel;
    }

    public SessionKeyModel getSessionKeyModel() {
        return sessionKeyModel;
    }

    public void setSessionKeyModel(SessionKeyModel sessionKeyModel) {
        this.sessionKeyModel = sessionKeyModel;
    }

    public PinKeyModel getPinKeyModel() {
        return pinKeyModel;
    }

    public void setPinKeyModel(PinKeyModel pinKeyModel) {
        this.pinKeyModel = pinKeyModel;
    }

    public ParameterModel getParameterModel() {
        return parameterModel;
    }

    public void setParameterModel(ParameterModel parameterModel) {
        this.parameterModel = parameterModel;
    }
}
