package com.backend.utils;

import java.io.IOException;
import java.io.InputStream;

public class inputStream2String {
    public static String transform(InputStream inputStream) throws IOException {
        StringBuffer buffer = new StringBuffer();
        byte [] bytes = new byte[4096];
        int result = inputStream.read(bytes);
        while(result != -1) {
            buffer.append(new String(bytes, 0, result));
            result = inputStream.read(bytes);
        }

        return buffer.toString();
    }
}
