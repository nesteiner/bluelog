package com.backend.views;

import com.alibaba.fastjson.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(urlPatterns = {"/bluelog/session/curuser"})
public class CurrentUser extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter writer = response.getWriter();

        HttpSession session = request.getSession();
        String username = (String)session.getAttribute("curuser");
        String usertype = (String)session.getAttribute("usertype");

        JSONObject result = new JSONObject();
        result.put("curuser", username);
        result.put("isadmin", "admin".equals(usertype));
        result.put("usertype", usertype == null ? "null" : usertype);
        writer.write(result.toString());
    }
}
