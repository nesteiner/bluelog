package com.backend.models;

import com.alibaba.fastjson.annotation.JSONField;

import java.util.LinkedList;
import java.util.List;
import java.sql.*;
import static com.backend.Config.*;

public class Post {
    @JSONField(name="postid")
    int postid;
    @JSONField(name="title")
    String title;
    @JSONField(name = "author")
    String author;
    @JSONField(name = "content")
    String content;

    public Post(int _postid, String _title, String _author, String _content) {
        postid = _postid;
        title = _title;
        author = _author;
        content = _content;
    }

    public int getPostid() {
        return postid;
    }

    public void setPostid(int postid) {
        this.postid = postid;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public static List<Post> queryWithAuthor(String author) {
        Connection conn = null;
        Statement stmt = null;
        List<Post> result = new LinkedList<>();

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASSWORD);
            // TODO 执行查询
            stmt = conn.createStatement();
            String querySQL = String.format("select * from %s where author = \'%s\'", POST_TABLE, author);
            ResultSet resultSet = stmt.executeQuery(querySQL);

            while (resultSet.next()) {
                int postid = resultSet.getInt("postid");
                String _title = resultSet.getString("title");
                String _author = resultSet.getString("author");
                String _content = resultSet.getString("content");
                result.add(new Post(postid, _title, _author, _content));
            }

            resultSet.close();
            stmt.close();
            conn.close();

        } catch (SQLException sqlException) {
            sqlException.printStackTrace();
        } catch (Exception exception) {
            exception.printStackTrace();
        } finally {

        }

        return result;
    }
}
