package com.backend.views;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.backend.models.Post;
import com.backend.utils.Result;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import static com.backend.utils.inputStream2String.transform;

@WebServlet(urlPatterns = {"/bluelog/posts"})
public class Posts extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        PrintWriter writer = response.getWriter();

        // PROBLEM username is from json
        String jsonData = transform(request.getInputStream());
        JSONObject jsonObject = JSONObject.parseObject(jsonData);
        String username = jsonObject.getString("username");
        // TODO query from table `Post`, which author == username, return it as posts: List<Post>
        Result<List<Post>, Exception> queryResult = Post.queryWithAuthor(username);

        JSONObject result = new JSONObject();
        if(queryResult.isOk()) {
            result.put("status", "get post success");
            result.put("posts", queryResult.left);
            result.put("username", username == null ? "null" : username);

        } else if(queryResult.isErr()) {
            response.setStatus(400);
            result.put("status", "error occusin");
            result.put("error", queryResult.right.getMessage());
        }

        writer.write(result.toString());

    }
}
