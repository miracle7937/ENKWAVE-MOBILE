package com.etop_pos_plugin.networking.miscellaneous;




import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;


import org.jpos.iso.ISOUtil;

public class ISO8583 {
    private static final String TAG = ISO8583.class.getSimpleName();
    public static boolean sec = false;
    public final static int ISO8583_MAX_LENGTH = 128; /*Max Filed Number*/
    public final static int MAXBUFFERLEN = 2048; /*Buffer*/
    public final static int MSGIDLEN = 4; /**/

    public final static byte FIX_LEN = 0; /*(LENgth fix )*/
    public final static byte LLVAR_LEN	= 1; /*(LENgth 00~99)*/
    public final static byte LLLVAR_LEN	= 2; /*(LENgth 00~999)*/
    public final static byte LLLLVAR_LEN	= 2; /*(LENgth 00~9999)*/

    public final static byte L_BCD = 0; /*Left Alignment BCD*/
    public final static byte L_ASC = 1; /*Left Alignment ASC*/
    public final static byte R_BCD = 2; /*Right  Alignment BCD */
    public final static byte R_ASC = 3; /*Right  Alignment ASC*/
    public final static byte D_BIN = 4; /*ֱBCD*/

    public ISO8583Domain[] mISO8583Domain;

    private int mOffset;
    private byte[] mDataBuffer;
    private byte[] mMessageId;

    private class ISO8583Domain { /*8583 Filed Define*/
        public int mMaxLength; /* data element max length */
        public byte mType; /* bit0,bit1 Retain，bit2: 0 Left Alignment ,1 Right Alignment，bit3:0 BCD,1 ASC，type:0,1,2,3三种*/
        public byte mFlag; /* length field length: 0--FIX_LEN型 1--LLVAR_LEN型 2--LLLVAR_LEN型*/
        public String mDomainName; /* 域名*/

        public int mBitf; /*field map if 1 true  0 false*/
        public int mLength; /*field length*/
        public int mStartAddr; /*field data's start address*/

        public void setDomainProperty(int length, byte type, byte flag, String domainName) {
            this.mMaxLength = length;
            this.mType = type;
            this.mFlag = flag;
            this.mDomainName = domainName;
        }
    }

    public ISO8583() {
        mISO8583Domain = new ISO8583Domain[ISO8583_MAX_LENGTH];
        for (int i = 0; i < ISO8583_MAX_LENGTH; i++) {
            mISO8583Domain[i] = new ISO8583Domain();
        }

        initCupISO8583Domain();

        mOffset = 0;
        mDataBuffer = new byte[MAXBUFFERLEN];
        mMessageId  = new byte[MSGIDLEN];
    }


    public int  setMit(String mit){

        if(mit.isEmpty() || mit.length()!=4){
            return  -1;
        }

        /*byte[] tmp = new byte[MAXBUFFERLEN];
        byte[] src = mit.getBytes();
        int le = src.length;
        int l = le;
        Arrays.fill(tmp, 0, le-l, (byte)' ');
        System.arraycopy(src, 0, tmp, le-l, l);
        System.arraycopy(tmp, 0, mMessageId, 0, 4);*/
        //Log.i(TAG, "MIT: " + mit);
        System.arraycopy(mit.getBytes(),0, mMessageId,0,4);

        return 0;
    }


    /*=================================================================
     * Function ID :  isotostr
     * Input       :  byte[] src
     * Output      :
     * Return	  :  success 0 fail -1
     * Description :  ISO583包解包成为一个数据BCD码串
     * Notice	  :  成功:返回该数据串,失败:返回null
     *=================================================================*/
    public byte[] isotostr(){
        int dataOffset = 0;
        int bitnum = 0;
        int n = 0;
        byte[] data = new byte[MAXBUFFERLEN];
        if(sec == true)
            bitnum = 16;
        else
            bitnum = 8;
        BCDASCII.fromASCIIToBCD(mMessageId, 0, MSGIDLEN, data, 0, false);
        dataOffset = MSGIDLEN/2 + bitnum; //指向消息类型和位图之后的数据域

        for (int i = 0; i < bitnum; i++) {
            byte bitmap = 0; //表示64位的位图中的一个字节中的8个位图域
            int bitmask = 0x80;
            for (int j = 0; j < 8; j++, bitmask>>=1) {
                n = (i<<3) + j;
                if (mISO8583Domain[n].mBitf == 0) {//该域没有值
                    continue;
                }
                bitmap |= bitmask;
                int len = mISO8583Domain[n].mLength;
                String srclen   = String.valueOf(len);
                //Log.i(TAG, "LENGTH: " + srclen);
                byte[] arraylen = null;

                //Log.i(TAG, "idx="+(n+1)+", "+mISO8583Domain[n].mDomainName+", len="+srclen );

                if (mISO8583Domain[n].mFlag == LLVAR_LEN)
                {
                    // error Temporary comment for F35 length
                    if (mISO8583Domain[n].mType == D_BIN) {
                        len = (len+1)/2;
                    }
                    String lenstr = String.format("%02d", len);

                    byte[] tmp = new byte[MAXBUFFERLEN];
                    byte[] src = lenstr.getBytes();
                    int le = src.length;
                    int l = le;
                    Arrays.fill(tmp, 0, le-l, (byte)' ');
                    System.arraycopy(src, 0, tmp, le-l, l);
                    System.arraycopy(tmp, 0, data, dataOffset, 2);
                    dataOffset += 2;
                } else if (mISO8583Domain[n].mFlag == LLLVAR_LEN) {
                    if (mISO8583Domain[n].mType == D_BIN) {
                        len = (len+1)/2;
                    }
                    String lenstr = String.format("%03d",len);

                    byte[] tmp = new byte[MAXBUFFERLEN];
                    byte[] src = lenstr.getBytes();
                    int le = src.length;
                    int l = le;
                    Arrays.fill(tmp, 0, le-l, (byte)' ');
                    System.arraycopy(src, 0, tmp, le-l, l);
                    System.arraycopy(tmp, 0, data, dataOffset, 3);
                    dataOffset += 3;
                }else if (mISO8583Domain[n].mFlag == LLLLVAR_LEN) {
                    if (mISO8583Domain[n].mType == D_BIN) {
                        len = (len+1)/2;
                    }
                    String lenstr = String.format("%04d",len);

                    byte[] tmp = new byte[MAXBUFFERLEN];
                    byte[] src = lenstr.getBytes();
                    int le = src.length;
                    int l = le;
                    Arrays.fill(tmp, 0, le-l, (byte)' ');
                    System.arraycopy(src, 0, tmp, le-l, l);
                    System.arraycopy(tmp, 0, data, dataOffset, 4);
                    dataOffset += 4;
                }
                if (mISO8583Domain[n].mType == L_BCD) {
                    len = (len+1)/2;
                } else if (mISO8583Domain[n].mType == L_ASC) {

                } else if (mISO8583Domain[n].mType == R_BCD) {
                    len = (len+1)/2;
                } else if (mISO8583Domain[n].mType == R_ASC) {

                }
                System.arraycopy(mDataBuffer, mISO8583Domain[n].mStartAddr, data, dataOffset, len);
                dataOffset += len;

            }
            data[i + 2] = bitmap;
        }

        if (mISO8583Domain[127].mBitf == 1 && bitnum == 16)
        {
            //Commented out by Wisdom
            /*data[2 + 7] |= 0x01; //将位图中的最后一位置为1，即将64域置为1
            System.arraycopy(mDataBuffer, mISO8583Domain[127].mStartAddr, data, dataOffset, 8);
            dataOffset += 8;*/
        }

        //Log.i(TAG, "A. JUST JUST FINAL: " + new String(data));

        if (bitnum == 16) {
            data[2] |= 0x80; //0x80 二进制为 1000 0000，将位图的首位置为1，表示使用128个域
            //Log.i(TAG, "JUST JUST FINAL: " + new String(data));
        }

        if (dataOffset != 0) {
            byte[] BCD = new byte[dataOffset];
            System.arraycopy(data, 0, BCD, 0, dataOffset);
            if(sec == true)
            {
                byte[] TMP = new byte[18];
                byte[] TMP2 = new byte[dataOffset];
                byte[] TMP3 = new byte[dataOffset + 18];
                System.arraycopy(data, 0, TMP, 0, 18);
                String t = ISOUtil.hexString(TMP);
                TMP2 = t.getBytes();
                System.arraycopy(TMP2, 0, TMP3, 0, 36);
                System.arraycopy(data, 18, TMP3, 36, dataOffset - 18);
                ISO8583 unpackISO8583  = new ISO8583();
                unpackISO8583.strtoiso(TMP3);
                ProfileParser.sending = new String[128];
                Utilities.logISOMsg(unpackISO8583, ProfileParser.sending);
                String cs = String.format("%04X", TMP3.length);
                System.out.println("ISO8583TMP"+new String(TMP3));
                byte[] bcdlen = BCDASCII.hexStringToBytes(cs);
                byte[] mPacketMsg = ISO8583Util.byteArrayAdd(bcdlen, TMP3);
                System.out.println("ISO8583TMP"+ BCDASCII.bytesToHexString(TMP3));

                sec = false;
                return mPacketMsg;
            }else
            {
                byte[] TMP = new byte[10];
                byte[] TMP2 = new byte[dataOffset];
                byte[] TMP3 = new byte[dataOffset + 10];
                System.arraycopy(data, 0, TMP, 0, 10);
                String t = ISOUtil.hexString(TMP);
                TMP2 = t.getBytes();
                System.arraycopy(TMP2, 0, TMP3, 0, 20);
                System.arraycopy(data, 10, TMP3, 20, dataOffset - 10);
                //Log.i(TAG, "TMP3: " + new String(TMP3));
                ISO8583 unpackISO8583  = new ISO8583();
                unpackISO8583.strtoiso(TMP3);
                ProfileParser.sending = new String[128];
                Utilities.logISOMsg(unpackISO8583, ProfileParser.sending);
                String cs = String.format("%04X", TMP3.length);
               System.out.println("ISO8583TMP"+ new String(TMP3));
                System.out.println("ISO8583TMP"+ BCDASCII.bytesToHexString(TMP3));


                byte[] bcdlen = BCDASCII.hexStringToBytes(cs);
                byte[] mPacketMsg = ISO8583Util.byteArrayAdd(bcdlen, TMP3);
                sec = false;
                return mPacketMsg;
            }
        }
        return null;
    }


    public byte[] getMacIso(){
        int dataOffset = 0;
        int bitnum = 0;
        int n = 0;
        byte[] data = new byte[MAXBUFFERLEN];
        if(sec == true)
            bitnum = 16;
        else
            bitnum = 8;
        BCDASCII.fromASCIIToBCD(mMessageId, 0, MSGIDLEN, data, 0, false);
        dataOffset = MSGIDLEN/2 + bitnum; //指向消息类型和位图之后的数据域

        for (int i = 0; i < bitnum; i++) {
            byte bitmap = 0; //表示64位的位图中的一个字节中的8个位图域
            int bitmask = 0x80;
            for (int j = 0; j < 8; j++, bitmask>>=1) {
                n = (i<<3) + j;
                if (mISO8583Domain[n].mBitf == 0) {//该域没有值
                    continue;
                }
                bitmap |= bitmask;
                int len = mISO8583Domain[n].mLength;
                String srclen   = String.valueOf(len);
                //Log.i(TAG, "LENGTH: " + srclen);
                byte[] arraylen = null;

                //Log.i(TAG, "idx="+(n+1)+", "+mISO8583Domain[n].mDomainName+", len="+srclen );

                if (mISO8583Domain[n].mFlag == LLVAR_LEN)
                {
                    // error Temporary comment for F35 length
                    if (mISO8583Domain[n].mType == D_BIN) {
                        len = (len+1)/2;
                    }
                    String lenstr = String.format("%02d", len);

                    byte[] tmp = new byte[MAXBUFFERLEN];
                    byte[] src = lenstr.getBytes();
                    int le = src.length;
                    int l = le;
                    Arrays.fill(tmp, 0, le-l, (byte)' ');
                    System.arraycopy(src, 0, tmp, le-l, l);
                    System.arraycopy(tmp, 0, data, dataOffset, 2);
                    dataOffset += 2;
                } else if (mISO8583Domain[n].mFlag == LLLVAR_LEN) {
                    if (mISO8583Domain[n].mType == D_BIN) {
                        len = (len+1)/2;
                    }
                    String lenstr = String.format("%03d",len);

                    byte[] tmp = new byte[MAXBUFFERLEN];
                    byte[] src = lenstr.getBytes();
                    int le = src.length;
                    int l = le;
                    Arrays.fill(tmp, 0, le-l, (byte)' ');
                    System.arraycopy(src, 0, tmp, le-l, l);
                    System.arraycopy(tmp, 0, data, dataOffset, 3);
                    dataOffset += 3;
                }else if (mISO8583Domain[n].mFlag == LLLLVAR_LEN) {
                    if (mISO8583Domain[n].mType == D_BIN) {
                        len = (len+1)/2;
                    }
                    String lenstr = String.format("%04d",len);

                    byte[] tmp = new byte[MAXBUFFERLEN];
                    byte[] src = lenstr.getBytes();
                    int le = src.length;
                    int l = le;
                    Arrays.fill(tmp, 0, le-l, (byte)' ');
                    System.arraycopy(src, 0, tmp, le-l, l);
                    System.arraycopy(tmp, 0, data, dataOffset, 4);
                    dataOffset += 4;
                }
                if (mISO8583Domain[n].mType == L_BCD) {
                    len = (len+1)/2;
                } else if (mISO8583Domain[n].mType == L_ASC) {

                } else if (mISO8583Domain[n].mType == R_BCD) {
                    len = (len+1)/2;
                } else if (mISO8583Domain[n].mType == R_ASC) {

                }
                System.arraycopy(mDataBuffer, mISO8583Domain[n].mStartAddr, data, dataOffset, len);
                dataOffset += len;

            }
            data[i + 2] = bitmap;
        }

        if (mISO8583Domain[127].mBitf == 1 && bitnum == 16)
        {
            //Commented out by Wisdom
            /*data[2 + 7] |= 0x01; //将位图中的最后一位置为1，即将64域置为1
            System.arraycopy(mDataBuffer, mISO8583Domain[127].mStartAddr, data, dataOffset, 8);
            dataOffset += 8;*/
        }

        //Log.i(TAG, "A. JUST JUST FINAL: " + new String(data));

        if (bitnum == 16) {
            data[2] |= 0x80; //0x80 二进制为 1000 0000，将位图的首位置为1，表示使用128个域
            //Log.i(TAG, "JUST JUST FINAL: " + new String(data));
        }

        if (dataOffset != 0) {
            byte[] BCD = new byte[dataOffset];
            System.arraycopy(data, 0, BCD, 0, dataOffset);
            if(sec == true)
            {
                byte[] TMP = new byte[18];
                byte[] TMP2 = new byte[dataOffset];
                byte[] TMP3 = new byte[dataOffset + 18];
                System.arraycopy(data, 0, TMP, 0, 18);
                String t = ISOUtil.hexString(TMP);
                TMP2 = t.getBytes();
                System.arraycopy(TMP2, 0, TMP3, 0, 36);
                System.arraycopy(data, 18, TMP3, 36, dataOffset - 18);
                //Log.i(TAG, "FINAL: " + new String(TMP3));
                return TMP3;
            }else
            {
                byte[] TMP = new byte[10];
                byte[] TMP2 = new byte[dataOffset];
                byte[] TMP3 = new byte[dataOffset + 10];
                System.arraycopy(data, 0, TMP, 0, 10);
                String t = ISOUtil.hexString(TMP);
                TMP2 = t.getBytes();
                System.arraycopy(TMP2, 0, TMP3, 0, 20);
                System.arraycopy(data, 10, TMP3, 20, dataOffset - 10);
                //Log.i(TAG, "FINAL: " + new String(TMP3));
                return TMP3;
            }
        }
        return null;
    }

    /*=================================================================
     * Function ID :  strtoiso
     * Input       :  byte[] src
     * Output      :
     * Return	  :  success 0 fail -1
     * Description :  将按8583包格式的数据串装载到8583包中
     * Notice	  :
     *=================================================================*/
    public int strtoiso(byte[] src)
    {
        int bitnum = 0;
        int bitmask = 0x80;
        int srcLen = 0;
        byte[] srcData = null;

        if(sec == true)
        {
            bitnum = 16;
            bitmask = 0x80;
            clearBit();
            System.arraycopy(src, 0, mMessageId, 0, 4);
            srcLen = src.length;
            srcData = new byte[srcLen - (MSGIDLEN + 32)];
            System.arraycopy(src, MSGIDLEN + bitnum + 16, srcData, 0, srcData.length);
        }else
        {
            bitnum = 8;
            bitmask = 0x80;
            clearBit();
            System.arraycopy(src, 0, mMessageId, 0, 4);
            srcLen = src.length;
            srcData = new byte[srcLen - (MSGIDLEN + 16)];
            System.arraycopy(src, MSGIDLEN + bitnum + 8, srcData, 0, srcData.length);
        }

        int n = 0;
        int len = 0;
        int srcDataOffset = 0;
        int offset = 0;

        byte[] data1 = BCDASCII.hexStringToBytes(ISOUtil.hexString(src));
        byte[] packData = BCDASCII.hexStringToBytes(new String(data1));

        for (int i = 0; i < bitnum; i++) {
            bitmask = 0x80;
            for (int j = 0; j < 8; j++, bitmask>>=1) {
                if (i == 0 && bitmask == 0x80)
                {
                    continue;
                }
                if ((packData[i+2] & bitmask)==0)
                {
                    continue;
                }
                n = (i<<3) + j;
                byte[] temp;
                if (mISO8583Domain[n].mFlag == LLVAR_LEN) {
                    temp = new byte[2];
                    System.arraycopy(srcData, srcDataOffset, temp, 0, 2);
                    String lenSrc = new String(temp);
                    len = Integer.parseInt(lenSrc, 10); // .valueOf(lenSrc);
                    srcDataOffset += 2;
                } else if (mISO8583Domain[n].mFlag == LLLVAR_LEN) {
                    temp = new byte[3];
                    System.arraycopy(srcData, srcDataOffset, temp, 0, 3);
                    String lenSrc = new String(temp);
                    len = Integer.parseInt(lenSrc, 10); // .valueOf(lenSrc);
                    srcDataOffset += 3;
                } else if (mISO8583Domain[n].mFlag == LLLLVAR_LEN) {
                    temp = new byte[4];
                    System.arraycopy(srcData, srcDataOffset, temp, 0, 4);
                    String lenSrc = new String(temp);
                    len = Integer.parseInt(lenSrc, 10); // .valueOf(lenSrc);
                    srcDataOffset += 4;
                } else if (mISO8583Domain[n].mFlag == FIX_LEN) {
                    len = mISO8583Domain[n].mMaxLength;
                }
                mISO8583Domain[n].mLength = len;
                mISO8583Domain[n].mStartAddr = offset;
                if (len + offset >= MAXBUFFERLEN) {
                    return -1;
                }

                //int u = n + 1;
                //Log.i(TAG, "Field: " + u + ". Length: " + len);

                //byte[] buf = new byte[len + 1];
                byte[] buf = new byte[len];
                if (mISO8583Domain[n].mType == L_BCD) {
                    len = (len + 1)/2;
                    System.arraycopy(srcData, srcDataOffset, mDataBuffer, offset, len);
                    System.arraycopy(srcData, srcDataOffset, buf, 0, len);
                } else if (mISO8583Domain[n].mType == L_ASC || mISO8583Domain[n].mType == D_BIN) {
                    System.arraycopy(srcData, srcDataOffset, mDataBuffer, offset, len);
                    System.arraycopy(srcData, srcDataOffset, buf, 0, len);
                } else if (mISO8583Domain[n].mType == R_BCD) {
                    len = (len + 1) / 2;
                    System.arraycopy(srcData, srcDataOffset, mDataBuffer, offset, len);
                    System.arraycopy(srcData, srcDataOffset, buf, 0, len);
                } else if (mISO8583Domain[n].mType == R_ASC) {
                    try
                    {
                        System.arraycopy(srcData, srcDataOffset, mDataBuffer, offset, len);
                        System.arraycopy(srcData, srcDataOffset, buf, 0, len);
                    }catch(Exception e)
                    {
                        if(n == 52) {
                            buf = new byte[32];
                            System.arraycopy(srcData, srcDataOffset, mDataBuffer, offset, 32);
                            System.arraycopy(srcData, srcDataOffset, buf, 0, 32);
                        }
                    }
                    //Log.i(TAG, "A. Before: " + new String(buf));
                    //Log.i(TAG, "B. Before: " + new String(mDataBuffer));
                }
                mISO8583Domain[n].mBitf = 1;
                offset += len;
                srcDataOffset += len;
            }
        }
        mOffset = offset;
        return 0;
    }

    /*=================================================================
     * Function ID :  setbit
     * Input       :  int n,byte[] str,int len
     * Return	  :  success 0 fail -1
     * Description :  将第n域加载到8583包(mDataBuffer)中.
     * Notice	  :  n->第几个域 str->需要打包的字符串 len->字符串的长度
     *=================================================================*/
    public int  setBit(int n, byte[] src, int len) {
        int  i=0, l=0;
        byte[] pt  = null;//new byte[MAXBUFFERLEN];
        byte[] tmp = new byte[MAXBUFFERLEN];

        //Log.i(TAG, "comein "+"setBit, n: " + n + ",len: " + len + ",src: " + BCDASCII.bytesToHexString(src) + ", ascii(" + new String(src) + ")");

        if (len == 0 || len > MAXBUFFERLEN) {
            return 0; //str为空或超长,不需要打包
        }
        if (n == 0) {
            System.arraycopy(src, 0, mMessageId, 0, MSGIDLEN);
            return 0;
        }
        if (n <= 1 || n > ISO8583_MAX_LENGTH) {//第1域为位图域,不能用
            return -1;
        }
        n--;//域从1开始，数组从0开始

        //Log.i(TAG, "setBit, mMaxLength: " + mISO8583Domain[n].mMaxLength+" n= "+n);
        if( len > mISO8583Domain[n].mMaxLength ) {//最大长度不能超过8583包规定的长度
            len = mISO8583Domain[n].mMaxLength;
        }

        l = len;
        if( mISO8583Domain[n].mFlag == FIX_LEN ) {//该域为固定长度
            len = mISO8583Domain[n].mMaxLength;
        }
        //如果固定长度为8，实际传入只有6，那么需要补2位，len >= l.

        //Log.i(TAG, "setBit, l: " + l + ",len: " + len);
        mISO8583Domain[n].mBitf = 1;            /*置该域为有数据 */
        mISO8583Domain[n].mLength = len;        /*保存该域的长度*/
        mISO8583Domain[n].mStartAddr = mOffset;  /*该域值在mDataBuffer中的起始位置*/
        if ((mOffset + len) >=  MAXBUFFERLEN) {//mDataBuffer空间已满
            return -1;
        }
        if (mISO8583Domain[n].mType == L_BCD) {
            System.arraycopy(src, 0, tmp, 0, l);
            Arrays.fill(tmp, l, len, (byte)' ');
            pt = BCDASCII.fromASCIIToBCD(tmp, 0, len, false);
            System.arraycopy(pt, 0, mDataBuffer, mOffset, (len+1)/2);
            mOffset += (len+1)/2;
        } else if (mISO8583Domain[n].mType == L_ASC) {
            System.arraycopy(src, 0, tmp, 0, l);
            Arrays.fill(tmp, l, len, (byte)' ');
            System.arraycopy(tmp, 0, mDataBuffer, mOffset, len);
            mOffset += len;
        } else if (mISO8583Domain[n].mType == R_BCD) {
            Arrays.fill(tmp, 0, len-l, (byte)'0');
            System.arraycopy(src, 0, tmp, len-l, l);
            pt = BCDASCII.fromASCIIToBCD(tmp, 0, len, true);
            System.arraycopy(pt, 0, mDataBuffer, mOffset, (len+1)/2);
            mOffset += (len+1)/2;
        } else if (mISO8583Domain[n].mType == R_ASC) {
            Arrays.fill(tmp, 0, len-l, (byte)' ');
            //Log.i(TAG, "R_ASC 1: " + new String(tmp));
            System.arraycopy(src, 0, tmp, len-l, l);
            //Log.i(TAG, "R_ASC 2: " + new String(src));
            System.arraycopy(tmp, 0, mDataBuffer, mOffset, len);
            //Log.i(TAG, "R_ASC 3: " + new String(tmp));
            mOffset += len;
        } else if (mISO8583Domain[n].mType == D_BIN) {
           System.out.println(TAG+ "  l = " + l);
            System.arraycopy(src, 0, tmp, 0, l);
            Arrays.fill(tmp, l, len, (byte) ' ');
            pt = BCDASCII.fromASCIIToBCD(tmp, 0, len, false);
            System.arraycopy(pt, 0, mDataBuffer, mOffset, (len + 1) / 2);
            mOffset += (len + 1) / 2;
        }
        return 0;
    }

    /*=================================================================
     * Function ID :  getbit
     * Input       :  int n,第几个域
     * Return	  :  成功返回这个域的字符串，失败返回空。
     * Description :  从8583包(mDataBuffer)中取出第n域的值。
     * Notice	  :  n->第几个域
     *=================================================================*/
    public byte[] getBit(int n)
    {
        byte[] domainValue = null;
        if (n == 0)
        {
            domainValue = new byte[MSGIDLEN];
            System.arraycopy(mMessageId, 0, domainValue, 0, MSGIDLEN);
            //Log.i(TAG, "getBit, n=0," + new String(domainValue));
            return domainValue;
        }

        if (n <= 1 || n > ISO8583_MAX_LENGTH)
        {
            //Log.i(TAG, "getBit, n is not normal.");
            return null;
        }

        n--;
        if (mISO8583Domain[n].mBitf == 0) {
            //Log.i(TAG, "getBit, n domainValue is null.");
            return null;
        }

        int len = mISO8583Domain[n].mLength;
        int startAddr = mISO8583Domain[n].mStartAddr;
        byte[] data   = null;

        if (mISO8583Domain[n].mType == L_BCD)
        {
            data = new byte[(len+1)/2];
            System.arraycopy(mDataBuffer, startAddr, data, 0, (len+1)/2);
            domainValue = BCDASCII.fromBCDToASCII(data, 0, len, false);
        } else if (mISO8583Domain[n].mType == L_ASC || mISO8583Domain[n].mType == D_BIN)
        {
            data = new byte[len];
            System.arraycopy(mDataBuffer, startAddr, data, 0, len);
            domainValue = data;
        } else if (mISO8583Domain[n].mType == R_BCD)
        {
            data = new byte[(len+1)/2];
            System.arraycopy(mDataBuffer, startAddr, data, 0, (len+1)/2);
            domainValue = BCDASCII.fromBCDToASCII(data, 0, len, true);
        } else if (mISO8583Domain[n].mType == R_ASC) {
            data = new byte[len];
            System.arraycopy(mDataBuffer, startAddr, data, 0, len);
            domainValue = data;
        }
        return domainValue;
    }

    public String getSHA(String input)
    {
        try {
            // Static getInstance method is called with hashing SHA
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            // digest() method called
            // to calculate message digest of an input
            // and return array of byte
            byte[] messageDigest = md.digest(input.getBytes());
            // Convert byte array into signum representation
            BigInteger no = new BigInteger(1, messageDigest);

            // Convert message digest into hex value
            String hashtext = no.toString(16);

            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        }catch (NoSuchAlgorithmException e) {
            System.out.println(TAG+ "Exception thrown" + " for incorrect algorithm: " + e);
            return null;
        }
    }

    public void clearBit() {
        for (int i = 0; i < ISO8583_MAX_LENGTH; i++) {
            mISO8583Domain[i].mBitf = 0;
            mISO8583Domain[i].mLength = 0;
            mISO8583Domain[i].mStartAddr = 0;
        }
        mOffset = 0;
        Arrays.fill(mDataBuffer, (byte)0);
    }


    private void initISO8583Domain() {
        if (mISO8583Domain == null) {
            return;
        }

        mISO8583Domain[0 ].setDomainProperty(  8, L_ASC, FIX_LEN,       		"位图");			//1
        mISO8583Domain[1 ].setDomainProperty( 32, D_BIN, LLVAR_LEN,     		"主帐号");		//2 + L_ASC->L_BCD
        mISO8583Domain[2 ].setDomainProperty(  6, L_BCD, FIX_LEN,       		"交易处理码");		//3 +
        mISO8583Domain[3 ].setDomainProperty( 12, R_BCD, FIX_LEN,       		"交易金额");	    //4 + Henry 4->12
        mISO8583Domain[4 ].setDomainProperty(  8, L_BCD, FIX_LEN,       		"未使用");	    //5
        mISO8583Domain[5 ].setDomainProperty(  8, L_BCD, FIX_LEN,       		"未使用");	    //6
        mISO8583Domain[6 ].setDomainProperty( 99, R_BCD, LLVAR_LEN,     		"未使用");      	//7
        mISO8583Domain[7 ].setDomainProperty(  8, R_BCD, FIX_LEN,       		"未使用");	    //8
        mISO8583Domain[8 ].setDomainProperty(  8, R_BCD, FIX_LEN,       		"未使用");      	//9
        mISO8583Domain[9 ].setDomainProperty(  8, R_BCD, FIX_LEN,       		"未使用");      	//10
        mISO8583Domain[10].setDomainProperty(  6, R_BCD, FIX_LEN,       		"系统跟踪号");	    //11 +
        mISO8583Domain[11].setDomainProperty(  6, R_BCD, FIX_LEN,       		"本地交易时间");	//12 +
        mISO8583Domain[12].setDomainProperty(  4, R_BCD, FIX_LEN,       		"本地交易日期");	//13 + Henry 8->4 ->hw: 8
        mISO8583Domain[13].setDomainProperty(  4, R_BCD, FIX_LEN,       		"卡有效期");		//14 + Henry 8->4
        mISO8583Domain[14].setDomainProperty(  4, R_BCD, FIX_LEN,       		"结算日期");	    //15 +
        mISO8583Domain[15].setDomainProperty(  4, R_BCD, FIX_LEN,       		"未使用");	    //16
        mISO8583Domain[16].setDomainProperty(  4, R_BCD, FIX_LEN,       		"未使用");	    //17
        mISO8583Domain[17].setDomainProperty(  4, R_BCD, FIX_LEN,       		"未使用");	    //18
        mISO8583Domain[18].setDomainProperty(  4, R_BCD, FIX_LEN,       		"未使用");	    //19
        mISO8583Domain[19].setDomainProperty(  4, R_BCD, FIX_LEN,       		"未使用");	    //20
        mISO8583Domain[20].setDomainProperty(  4, R_BCD, FIX_LEN,       		"未使用");	    //21
        mISO8583Domain[21].setDomainProperty(  3, L_BCD, FIX_LEN,       		"服务点输入方式"); 	//22 + Henry 4->3 R_BCD->L_BCD
        mISO8583Domain[22].setDomainProperty(  3, R_BCD, FIX_LEN,       		"卡序列号");	    //23 + Henry 4->3
        mISO8583Domain[23].setDomainProperty(  4, R_BCD, FIX_LEN,       		"未使用");	    //24
        mISO8583Domain[24].setDomainProperty(  2, R_BCD, FIX_LEN,       		"服务点条件代码");	//25 +
        mISO8583Domain[25].setDomainProperty(  2, R_BCD, FIX_LEN,       		"服务点PIN获取码");	//26 +
        mISO8583Domain[26].setDomainProperty(  99, L_BCD, LLVAR_LEN,			"未使用");	    //27
        mISO8583Domain[27].setDomainProperty(  99, L_BCD, LLVAR_LEN,			"未使用");	    //28
        mISO8583Domain[28].setDomainProperty(  99, L_BCD, LLVAR_LEN,			"未使用");	    //29
        mISO8583Domain[29].setDomainProperty(  99, L_BCD, LLVAR_LEN,			"未使用");	    //30
        mISO8583Domain[30].setDomainProperty(  99, L_BCD, LLVAR_LEN,			"未使用");	    //31
        mISO8583Domain[31].setDomainProperty(  99, L_BCD, LLVAR_LEN,    		"受理方标识码");	//32 +
        mISO8583Domain[32].setDomainProperty(  99, L_BCD, LLVAR_LEN,	   		"未使用");	    //33
        mISO8583Domain[33].setDomainProperty( 999, L_BCD, LLLVAR_LEN,   		"未使用");	    //34
        mISO8583Domain[34].setDomainProperty( 48, D_BIN, LLVAR_LEN,    		"二磁道数据");	    //35 +
        mISO8583Domain[35].setDomainProperty(112,  D_BIN, LLLVAR_LEN,   		"三磁道数据");	    //36 +
        mISO8583Domain[36].setDomainProperty( 12,  L_ASC, FIX_LEN,      		"检索参考号");		//37 +  Henry 16->12
        mISO8583Domain[37].setDomainProperty(  6,  L_ASC, FIX_LEN,      		"授权码");		//38 +
        mISO8583Domain[38].setDomainProperty(  2,  L_ASC, FIX_LEN,      		"应答码");		//39 +  Henry 4->2
        mISO8583Domain[39].setDomainProperty( 16,  L_ASC, FIX_LEN,			"终端序列号");	    //40 +  Hw:
        mISO8583Domain[40].setDomainProperty(  8,  R_ASC, FIX_LEN,      		"受卡方终端标识码");	//41 +
        mISO8583Domain[41].setDomainProperty( 15,  R_ASC, FIX_LEN,      		"受卡方标识码");	//42 +
        mISO8583Domain[42].setDomainProperty( 99,  L_BCD, LLVAR_LEN,			"未使用");		//43
        mISO8583Domain[43].setDomainProperty( 25,  L_ASC, LLVAR_LEN,    		"附加返回数据");	//44 +
        mISO8583Domain[44].setDomainProperty( 99,  L_BCD, LLVAR_LEN,			"未使用");	    //45
        mISO8583Domain[45].setDomainProperty(999, R_ASC, LLLVAR_LEN,			"未使用");	    //46
        mISO8583Domain[46].setDomainProperty(999, D_BIN, LLLVAR_LEN,			"未使用");	    //47
        mISO8583Domain[47].setDomainProperty(322, R_BCD, LLLVAR_LEN,    		"附加数据-私用");	//48 +
        mISO8583Domain[48].setDomainProperty(  3, R_ASC, FIX_LEN,       		"交易货币代码");	//49 +
        mISO8583Domain[49].setDomainProperty(  3, R_BCD, FIX_LEN,			"未使用");		//50
        mISO8583Domain[50].setDomainProperty(  3, R_BCD, FIX_LEN,           	"未使用");		//51
        mISO8583Domain[51].setDomainProperty(  8, L_ASC, FIX_LEN,       		"个人标识码数据(PIN)");	//52 +
        mISO8583Domain[52].setDomainProperty( 16, L_BCD, FIX_LEN,       		"密码相关控制信息");		//53 +
        mISO8583Domain[53].setDomainProperty( 20, R_ASC, LLLVAR_LEN,    		"附加金额");	    //54 +
        mISO8583Domain[54].setDomainProperty(255, R_ASC, LLLVAR_LEN,    		"IC卡数据域");	    //55
        mISO8583Domain[55].setDomainProperty(999, R_BCD, LLLVAR_LEN,       	"未使用");	    //56
        mISO8583Domain[56].setDomainProperty(999, R_BCD, LLLVAR_LEN,       	"未使用");	    //57
        mISO8583Domain[57].setDomainProperty(100, R_BCD, LLLVAR_LEN,    		"PBOC电子钱包标准交易信息");	    //58
        mISO8583Domain[58].setDomainProperty(999, R_BCD, LLLVAR_LEN,       	"未使用");	    //59
        mISO8583Domain[59].setDomainProperty(999, L_BCD, LLLVAR_LEN,    		"自定义域");	    //60 +  Henry R_ASC->R_BCD
        mISO8583Domain[60].setDomainProperty(999, L_BCD, LLLVAR_LEN,    		"自定义域");	    //61 +  Henry L_ASC->R_BCD LLVAR_LEN->LLLVAR_LEN; Hw
        mISO8583Domain[61].setDomainProperty(512, L_ASC, LLLVAR_LEN,    		"自定义域");	    //62 +  Henry R_BCD->L_ASC
        mISO8583Domain[62].setDomainProperty(999, L_ASC, LLLVAR_LEN,    		"自定义域");	    //63 +	Hw
        mISO8583Domain[63].setDomainProperty(  8, L_ASC, FIX_LEN,       		"报文鉴别码(MAC)");	//64 +
        mISO8583Domain[64].setDomainProperty(  8, L_BCD, FIX_LEN,           	"未使用");      	//65
        mISO8583Domain[65].setDomainProperty(  1, R_ASC, FIX_LEN,           	"未使用");      	//66
        mISO8583Domain[66].setDomainProperty(  2, R_ASC, FIX_LEN,           	"未使用");      	//67
        mISO8583Domain[67].setDomainProperty(  3, R_ASC, FIX_LEN,           	"未使用");      	//68
        mISO8583Domain[68].setDomainProperty(  3, R_ASC, FIX_LEN,           	"未使用");      	//69
        mISO8583Domain[69].setDomainProperty(  3, R_ASC, FIX_LEN,       		"管理信息码");      //70
        mISO8583Domain[70].setDomainProperty(  4, R_ASC, FIX_LEN,           	"未使用");      	//71
        mISO8583Domain[71].setDomainProperty(  4, R_ASC, FIX_LEN,           	"未使用");      	//72
        mISO8583Domain[72].setDomainProperty(  6, R_ASC, FIX_LEN,           	"未使用");      	//73
        mISO8583Domain[73].setDomainProperty( 10, R_ASC, FIX_LEN,       		"贷记交易笔数");    //74
        mISO8583Domain[74].setDomainProperty( 10, R_ASC, FIX_LEN,       		"贷记自动冲正交易笔数");      //75
        mISO8583Domain[75].setDomainProperty( 10, R_ASC, FIX_LEN,       		"借记交易笔数");    		//76
        mISO8583Domain[76].setDomainProperty( 10, R_ASC, FIX_LEN,       		"借记自动冲正交易笔数");      //77
        mISO8583Domain[77].setDomainProperty( 10, R_ASC, FIX_LEN,       		"转帐交易笔数");    		//78
        mISO8583Domain[78].setDomainProperty( 10, R_ASC, FIX_LEN,       		"转帐自动冲正交易笔数");      //79
        mISO8583Domain[79].setDomainProperty( 10, R_ASC, FIX_LEN,       		"查询交易笔数");    //80
        mISO8583Domain[80].setDomainProperty( 10, R_ASC, FIX_LEN,       		"授权交易笔数");    //81
        mISO8583Domain[81].setDomainProperty( 12, R_ASC, FIX_LEN,           	"未使用");      	//82
        mISO8583Domain[82].setDomainProperty( 12, R_ASC, FIX_LEN,       		"贷记交易费金额");  	//83
        mISO8583Domain[83].setDomainProperty( 12, R_ASC, FIX_LEN,           	"未使用");     	//84
        mISO8583Domain[84].setDomainProperty( 12, R_ASC, FIX_LEN,       		"借记交易费金额");  	//85
        mISO8583Domain[85].setDomainProperty( 16, R_ASC, FIX_LEN,       		"贷记交易金额");    //86
        mISO8583Domain[86].setDomainProperty( 16, R_ASC, FIX_LEN,       		"贷记自动冲正金额");	//87
        mISO8583Domain[87].setDomainProperty( 16, R_ASC, FIX_LEN,       		"借记交易金额");    //88
        mISO8583Domain[88].setDomainProperty( 16, R_ASC, FIX_LEN,       		"借记自动冲正交易金额");      	//89
        mISO8583Domain[89].setDomainProperty( 42, R_ASC, FIX_LEN,       		"原交易的数据元素");			//90
        mISO8583Domain[90 ].setDomainProperty(  1, R_BCD, FIX_LEN,       	"文件修改编码");    //91
        mISO8583Domain[91 ].setDomainProperty(  2, R_BCD, FIX_LEN,           "未使用");      	//92
        mISO8583Domain[92 ].setDomainProperty(  5, R_BCD, FIX_LEN,           "未使用");      	//93
        mISO8583Domain[93 ].setDomainProperty(  7, R_BCD, FIX_LEN,       	"服务指示码");     //94
        mISO8583Domain[94 ].setDomainProperty( 42, R_BCD, FIX_LEN,       	"代替金额");		//95
        mISO8583Domain[95 ].setDomainProperty(  8, R_BCD, FIX_LEN,           "未使用");      	//96
        mISO8583Domain[96 ].setDomainProperty( 16, R_BCD, FIX_LEN,       	"净结算金额");     //97
        mISO8583Domain[97 ].setDomainProperty( 25, R_BCD, FIX_LEN,           "未使用"); 		//98
        mISO8583Domain[98 ].setDomainProperty( 11, R_ASC, LLVAR_LEN,     	"结算机构码");		//99
        mISO8583Domain[99 ].setDomainProperty( 11, R_ASC, LLVAR_LEN,     	"接收机构码");		//100
        mISO8583Domain[100].setDomainProperty( 17, R_BCD, LLVAR_LEN,     	"文件名"); 		//101
        mISO8583Domain[101].setDomainProperty( 28, R_BCD, LLVAR_LEN,     	"帐号1");  		//102
        mISO8583Domain[102].setDomainProperty( 28, R_BCD, LLVAR_LEN,     	"帐号2");   		//103
        mISO8583Domain[103].setDomainProperty(10,  R_BCD, LLLVAR_LEN,		"");       	//104
        mISO8583Domain[104].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//105
        mISO8583Domain[105].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//106
        mISO8583Domain[106].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//107
        mISO8583Domain[107].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//108
        mISO8583Domain[108].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//109
        mISO8583Domain[109].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//110
        mISO8583Domain[110].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//111
        mISO8583Domain[111].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//112
        mISO8583Domain[112].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//113
        mISO8583Domain[113].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//114
        mISO8583Domain[114].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//115
        mISO8583Domain[115].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//116
        mISO8583Domain[116].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//117
        mISO8583Domain[117].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//118
        mISO8583Domain[118].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//119
        mISO8583Domain[119].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//120
        mISO8583Domain[120].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//121
        mISO8583Domain[121].setDomainProperty(999, R_BCD, LLLVAR_LEN,		"");       	//122
        mISO8583Domain[122].setDomainProperty(999, R_BCD, LLLVAR_LEN,    	"新密码数据");     //123
        mISO8583Domain[123].setDomainProperty(999, R_BCD, LLLVAR_LEN,       	"未使用");       	//124
        mISO8583Domain[124].setDomainProperty(999, R_BCD, LLLVAR_LEN,       	"未使用");       	//125
        mISO8583Domain[125].setDomainProperty(999, R_BCD, LLLVAR_LEN,       	"未使用");       	//126
        mISO8583Domain[126].setDomainProperty(999, R_BCD, LLLVAR_LEN,       	"未使用");       	//127
        mISO8583Domain[127].setDomainProperty(  8, R_BCD, FIX_LEN,       	"信息确认码");		//128
    }

    private void initCupISO8583Domain() {
        if (mISO8583Domain == null) {
            return;
        }

        mISO8583Domain[0 ].setDomainProperty(  8, L_ASC, FIX_LEN,       		"BITMAP");	//1
        mISO8583Domain[1 ].setDomainProperty( 19, R_ASC, LLVAR_LEN,     		"PAN");		//2
        mISO8583Domain[2 ].setDomainProperty(  6, R_ASC, FIX_LEN,       		"TRANS PROC CODE");	//3
        mISO8583Domain[3 ].setDomainProperty( 12, R_ASC, FIX_LEN,       		"AMOUNT");//4
        mISO8583Domain[6 ].setDomainProperty( 10, R_ASC, FIX_LEN,     		"TRANS DATE TIME"); //7
        mISO8583Domain[10].setDomainProperty(  6, R_ASC, FIX_LEN,       		"STAN");	    //11
        mISO8583Domain[11].setDomainProperty(  6, R_ASC, FIX_LEN,       		"TIME");	//12
        mISO8583Domain[12].setDomainProperty(  4, R_ASC, FIX_LEN,       		"DATE");	//13
        mISO8583Domain[13].setDomainProperty(  4, R_ASC, FIX_LEN,       		"EXPIRY DATE");	//14
        mISO8583Domain[14].setDomainProperty(  4, R_ASC, FIX_LEN,       		"DATE SETTLEMENT");//15
        mISO8583Domain[17].setDomainProperty(  4, R_ASC, FIX_LEN,       		"MCC");	    //18
        mISO8583Domain[21].setDomainProperty(  3, R_ASC, FIX_LEN,       		"POS ENTRY CODE"); //22
        mISO8583Domain[22].setDomainProperty(  3, R_ASC, FIX_LEN,       		"CARD SEQ NUM");//23
        mISO8583Domain[24].setDomainProperty(  2, R_ASC, FIX_LEN,       		"POS CON CODE");//25
        mISO8583Domain[25].setDomainProperty(  2, R_ASC, FIX_LEN,       		"POS PIN CAPTURE CODE");//26
        mISO8583Domain[27].setDomainProperty(  9, R_ASC, FIX_LEN,			"AMOUNT TRANSACTION FEE");//28
        //mISO8583Domain[29].setDomainProperty(  9, R_ASC, LLVAR_LEN,			"AMOUNT TRANSACTION PROCESSING FEE");//30
        mISO8583Domain[29].setDomainProperty(  9, R_ASC, FIX_LEN,			"AMOUNT TRANSACTION PROCESSING FEE");//30
        mISO8583Domain[31].setDomainProperty(  9, R_ASC, LLVAR_LEN,    		"ACQ INSTI CODE");	//32
        mISO8583Domain[32].setDomainProperty(  9, R_ASC, LLVAR_LEN,	   		"FORWARDING INSTI CODE"); //33
        mISO8583Domain[34].setDomainProperty( 37, R_ASC, LLVAR_LEN,    		"TRACK 2 DATA");	    //35
        mISO8583Domain[36].setDomainProperty( 12,  R_ASC, FIX_LEN,      		"RRN");		//37
        mISO8583Domain[37].setDomainProperty(  6,  R_ASC, FIX_LEN,      		"AUTH CODE");//38 +
        mISO8583Domain[38].setDomainProperty(  2,  R_ASC, FIX_LEN,      		"RESPONSE CODE");//39
        mISO8583Domain[39].setDomainProperty( 3,  R_ASC, FIX_LEN,			"SERVICE RES CODE");//40
        mISO8583Domain[40].setDomainProperty(  8,  R_ASC, FIX_LEN,      		"TID");	//41
        mISO8583Domain[41].setDomainProperty( 15,  R_ASC, FIX_LEN,      		"MID");	//42
        mISO8583Domain[42].setDomainProperty( 40,  R_ASC, FIX_LEN,			"MNL");		//43
        mISO8583Domain[47].setDomainProperty(999, R_ASC, LLLVAR_LEN,    		"ADDITIONAL DATA");	//48
        mISO8583Domain[48].setDomainProperty(  3, R_ASC, FIX_LEN,       		"CURRENCY CODE");//49
        mISO8583Domain[51].setDomainProperty(  16, R_ASC, FIX_LEN,       		"PINBLOCK");	//52
        mISO8583Domain[52].setDomainProperty( 96, R_ASC, FIX_LEN,       		"SECURITY RELATED INFO");//53//96
        mISO8583Domain[53].setDomainProperty( 120, R_ASC, LLLVAR_LEN,    		"ADDITIONAL AMOUNTS");//54
        mISO8583Domain[54].setDomainProperty(510, R_ASC, LLLVAR_LEN,    		"ICC");	    //55
        mISO8583Domain[55].setDomainProperty(4, R_ASC, LLLVAR_LEN,       	"MESSAGE REASON CODE");	//56
        mISO8583Domain[58].setDomainProperty(255, R_ASC, LLLVAR_LEN,       	"ECHO DATA");//59
        mISO8583Domain[59].setDomainProperty(999, R_ASC, LLLVAR_LEN,    		"PAYMENT INFO"); //60
        mISO8583Domain[61].setDomainProperty(999, R_ASC, LLLVAR_LEN,    		"MANAGEMENT INFO 1");//62
        mISO8583Domain[62].setDomainProperty(9999, R_ASC, LLLLVAR_LEN,    		"MANAGEMENT INFO 2"); //63
        mISO8583Domain[63].setDomainProperty(  64, R_ASC, FIX_LEN,       		"(MAC)");//64
        mISO8583Domain[89].setDomainProperty( 42, R_ASC, FIX_LEN,       		"ORIGINAL DATA ELEMENTS");//90
        mISO8583Domain[94 ].setDomainProperty( 42, R_ASC, FIX_LEN,       	"REPLACEMENT AMOUNT");//95
        mISO8583Domain[101].setDomainProperty( 28, R_ASC, LLVAR_LEN,     	"ACCOUNT IDENT 1");  //102
        mISO8583Domain[102].setDomainProperty( 28, R_ASC, LLVAR_LEN,     	"ACCOUNT IDENT 2"); //103
        mISO8583Domain[122].setDomainProperty(999, R_ASC, LLLVAR_LEN,    	"POS DATA CODE");     //123
        //mISO8583Domain[122].setDomainProperty(18, R_ASC, FIX_LEN,    	"POS DATA CODE");     //123
        mISO8583Domain[123].setDomainProperty(9999, R_ASC, LLLLVAR_LEN,       	"NEAR FIELD COMM");  //124
        mISO8583Domain[127].setDomainProperty(  64, R_ASC, FIX_LEN,       	"SECONDARY MAC");		//128
    }
}

