package com.backend;

import java.util.Map;
import java.util.Properties;

public class Config {
//    public static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    public static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    public static final String POST_TABLE = "Post";
    public static final String USER_TABLE = "User";
    public static final String USER = "steiner";
    public static final String PASSWORD = "whoamisteiner3044";
    public static final String PROXY_HOST = "127.0.0.1";
    public static final String PROXY_PORT = "7890";
    public static final String DB_URL = "jdbc:mysql://localhost:3306/Bluelog?autoReconnect=true&failOverReadOnly=false&maxReconnects=10";

    public static final Properties connInfo = new Properties() {{
        put("proxy_host", PROXY_HOST);
        put("proxy_port", PROXY_PORT);
        put("user", USER);
        put("password", PASSWORD);
    }};
}
