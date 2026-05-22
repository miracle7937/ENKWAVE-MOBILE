package com.etop_pos_plugin.pay;


public class CreditCard {
    private CardReadMode cardReadMode = CardReadMode.MANUAL;
    private String cardNumber;
    private String expireDate;
    private String holderName;
    private String serviceCode;
    private String PIN;
    private String cardSequenceNumber;
    private MagData magData;
    private EmvData emvData;
    private String icdcData;

    public static class MagData {
        private String track1;
        private String track2;

        public MagData(String track1, String track2) {
            this.track1 = track1;
            this.track2 = track2;
        }

        public String getTrack1() {
            return track1;
        }

        public void setTrack1(String track1) {
            this.track1 = track1;
        }

        public String getTrack2() {
            return track2;
        }

        public void setTrack2(String track2) {
            this.track2 = track2;
        }

        @Override
        public String toString() {
            return "MagData{" +
                    "track1='" + track1 + '\'' +
                    ", track2='" + track2 + '\'' +
                    '}';
        }
    }
    public static class EmvData {
        private String track1;
        private String track2;
        private String iccData;
        public EmvData(String track1, String track2, String iccData) {
            this.track1 = track1;
            this.track2 = track2;
            this.iccData = iccData;
        }

        public String getTrack1() {
            return track1;
        }

        public void setTrack1(String track1) {
            this.track1 = track1;
        }

        public String getTrack2() {
            return track2;
        }

        public void setTrack2(String track2) {
            this.track2 = track2;
        }

        public void setIccData(String iccData) {
            this.iccData = iccData;
        }

        public String getIccData() {
            return iccData;
        }
    }

    public CardReadMode getCardReadMode() {
        return cardReadMode;
    }

    public String geticcIIData() {
        return icdcData;
    }

    public void seticcIIData(String iccData) {
        this.icdcData = iccData;
    }

    public void setCardReadMode(CardReadMode cardReadMode) {
        this.cardReadMode = cardReadMode;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getExpireDate() {
        return expireDate;
    }

    public void setExpireDate(String expireDate) {
        this.expireDate = expireDate;
    }

    public String getHolderName() {
        return holderName;
    }

    public void setHolderName(String holderName) {
        this.holderName = holderName;
    }

    public String getServiceCode() {
        return serviceCode;
    }

    public void setServiceCode(String serviceCode) {
        this.serviceCode = serviceCode;
    }

    public String getPIN() {
        return PIN;
    }

    public void setPIN(String PIN) {
        this.PIN = PIN;
    }

    public String getCardSequenceNumber() {
        return cardSequenceNumber;
    }

    public void setCardSequenceNumber(String cardSequenceNumber) {
        this.cardSequenceNumber = cardSequenceNumber;
    }

    public MagData getMagData() {
        return magData;
    }

    public void setMagData(MagData magData) {
        this.magData = magData;
    }

    public EmvData getEmvData() {
        return emvData;
    }

    public void setEmvData(EmvData emvData) {
        this.emvData = emvData;
    }
}
