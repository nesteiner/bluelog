package com.backend.models;
import com.alibaba.fastjson.annotation.JSONField;
import com.backend.utils.Result;

import java.sql.*;
import java.util.LinkedList;
import java.util.List;
import static com.backend.Config.*;

public class User {
    @JSONField(name = "userid")
    int userid;
    @JSONField(name = "name")
    String name;
    @JSONField(name = "isadmin")
    boolean isadmin;
    @JSONField(name = "passhash")
    String passhash;

    public static Result<List<User>, Exception> queryWithPasshash(String name, boolean isadmin, String passhash){
        Connection conn = null;
        Statement stmt = null;
        List<User> users = new LinkedList<>();
        Result<List<User>, Exception> result = new Result<>(null, null);

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, connInfo);
            // TODO 执行查询
            stmt = conn.createStatement();
            String querySQL = String.format("select * from %s where name = '%s' and passhash = '%s' and isadmin = %s", USER_TABLE, name, passhash, isadmin);
            ResultSet resultSet = stmt.executeQuery(querySQL);

            while (resultSet.next()) {
                int userid = resultSet.getInt("userid");
                String _name = resultSet.getString("name");
                String _passhash = resultSet.getString("passhash");
                boolean _isadmin  = resultSet.getBoolean("isadmin");
                users.add(new User(userid, _name, _isadmin, _passhash));
            }

            resultSet.close();
            stmt.close();
            conn.close();

            result.left = users;
        } catch (SQLException sqlException) {
            result.right = sqlException;
        } catch (Exception exception) {
            result.right = exception;
        } finally {
            return result;
        }

    }

    public static Result<List<User>, Exception> queryIfNotAdmin() {
        Connection conn = null;
        Statement stmt = null;
        List<User> users = new LinkedList<>();
        Result<List<User>, Exception> result = new Result<>(null, null);

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, connInfo);
            // TODO 执行查询
            stmt = conn.createStatement();
            String querySQL = String.format("select * from %s where isadmin = %s", USER_TABLE, false);
            ResultSet resultSet = stmt.executeQuery(querySQL);

            while (resultSet.next()) {
                int userid = resultSet.getInt("userid");
                String _name = resultSet.getString("name");
                boolean _isadmin  = resultSet.getBoolean("isadmin");
                String _passhash = resultSet.getString("passhash");
                users.add(new User(userid, _name, _isadmin, _passhash));
            }

            resultSet.close();
            stmt.close();
            conn.close();

            result.left = users;
        } catch (SQLException sqlException) {
            result.right = sqlException;
        } catch (Exception exception) {
            result.right = exception;
        } finally {
            return result;
        }

    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isIsadmin() {
        return isadmin;
    }

    public void setIsadmin(boolean isadmin) {
        this.isadmin = isadmin;
    }

    public String getPasshash() {
        return passhash;
    }

    public void setPasshash(String passhash) {
        this.passhash = passhash;
    }

    public User(int _userid, String _name, boolean _isadmin, String _passhash) {
        userid = _userid;
        name = _name;
        isadmin = _isadmin;
        passhash = _passhash;
    }
}
