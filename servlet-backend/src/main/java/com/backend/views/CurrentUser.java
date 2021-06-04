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

@WebServlet(urlPatterns = "/bluelog/session/curuser")
public class CurrentUser extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=utf-8");
        PrintWriter writer = response.getWriter();

        HttpSession session = request.getSession();
        String username = (String)session.getAttribute("curuser");
        JSONObject result = new JSONObject();
        result.put("curuser", username);
        result.put("isadmin", session.getAttribute("usertype").equals("admin"));

        writer.write(result.toString());
    }
}
