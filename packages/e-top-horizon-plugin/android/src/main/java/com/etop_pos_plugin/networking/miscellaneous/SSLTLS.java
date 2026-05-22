package com.etop_pos_plugin.networking.miscellaneous;


import com.etop_pos_plugin.utils.Debug;

import org.bouncycastle.crypto.tls.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;

public class SSLTLS {
    private static final String TAG = SSLTLS.class.getSimpleName();

    public static byte[] doSSL(String host, String port, byte[] send) throws Exception {
        Socket socket = null;
        try {
            java.security.SecureRandom secureRandom = new java.security.SecureRandom();
            socket = new Socket(java.net.InetAddress.getByName(host), Integer.parseInt(port));
            //socket.setSoTimeout(10*1000);//Set timeout
            Debug.print(TAG+ "DONE WITH SSL SOCKET");
            TlsClientProtocol protocol = new TlsClientProtocol(socket.getInputStream(), socket.getOutputStream(), secureRandom);
            DefaultTlsClient client = new DefaultTlsClient() {
                public TlsAuthentication getAuthentication() throws IOException {
                    TlsAuthentication auth = new TlsAuthentication() {
                        // Capture the server certificate information!
                        public void notifyServerCertificate(Certificate serverCertificate) throws IOException {
                        }

                        public TlsCredentials getClientCredentials(CertificateRequest certificateRequest) throws IOException {
                            return null;
                        }
                    };
                    return auth;
                }
            };
            protocol.connect(client);
            Debug.print(TAG+"PROCEED AFTER SSL SOCKET GET");
            java.io.OutputStream output = protocol.getOutputStream();
            output.write(send);
            output.flush();

            Debug.print(TAG+ "PROCEED AFTER SENDING BYTES");
            java.io.InputStream input = protocol.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(input));
            String line;
            byte[] ret = null;
            long mEndtTime = System.currentTimeMillis() + 60000;
            while ((line = reader.readLine()) != null
                    && (System.currentTimeMillis() <= mEndtTime)) {
                if(System.currentTimeMillis() > mEndtTime){
                    Debug.print(TAG+ "TIME OUT WHILE RECEIVING BYTES");
                    socket.close();
                    return null;
                }
                Debug.print(line);
                ret = line.getBytes();
            }
            Debug.print(TAG+ "CLOSE AFTER RECEIVING BYTES");
            socket.close();
            return ret;
        }catch(Exception e)
        {
            if(socket != null)
                socket.close();
            return null;
        }
    }
}

