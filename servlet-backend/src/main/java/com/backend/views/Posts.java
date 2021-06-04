package com.backend.views;

import com.alibaba.fastjson.JSON;
import com.backend.models.Post;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(urlPatterns = "/bluelog/posts")
public class Posts extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=utf-8");
        PrintWriter writer = response.getWriter();

        HttpSession session = request.getSession();
        String username = (String)session.getAttribute("curuser");
        // TODO query from table `Post`, which author == username, return it as posts: List<Post>
        List<Post> posts = Post.queryWithAuthor(username);
        writer.write(JSON.toJSONString(posts));
    }
}
