package com.etop_pos_plugin.networking.prep;

import com.etop_pos_plugin.networking.model.MasterKeyModel;
import com.etop_pos_plugin.networking.model.ParameterModel;
import com.etop_pos_plugin.networking.model.PinKeyModel;
import com.etop_pos_plugin.networking.model.PrepResultRecord;
import com.etop_pos_plugin.networking.model.SessionKeyModel;

import java.util.Objects;


public final class SynchronizePrep {
    private final String terminalID;

    public SynchronizePrep(String terminalID) {
        this.terminalID = terminalID;
    }

    public String terminalID() {
        return terminalID;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        SynchronizePrep that = (SynchronizePrep) obj;
        return Objects.equals(this.terminalID, that.terminalID);
    }

    @Override
    public int hashCode() {
        return Objects.hash(terminalID);
    }

    @Override
    public String toString() {
        return "SynchronizePrep[" +
                "terminalID=" + terminalID + ']';
    }

    public PrepResultRecord Init() {
        MasterKeyModel masterKeyModel =          new GetMasterKey().doWork(terminalID);
        SessionKeyModel sessionKeyModel =         new GetSessionKey().doWork(terminalID, masterKeyModel.getClearMasterKey());
        PinKeyModel pinKeyModel =                   new GetPinKey().doWork(terminalID, masterKeyModel.getClearMasterKey());
        ParameterModel parameterModel =             new GetParameter().doWork(terminalID, sessionKeyModel.getClearSessionKey());

        PrepResultRecord resultRecord = new PrepResultRecord();
        resultRecord.setMasterKeyModel(masterKeyModel);
        resultRecord.setSessionKeyModel(sessionKeyModel);
        resultRecord.setPinKeyModel(pinKeyModel);
        resultRecord.setParameterModel(parameterModel);
        return resultRecord;

    }
}
