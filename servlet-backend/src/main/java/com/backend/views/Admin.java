package com.backend.views;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.backend.models.User;
import com.backend.utils.Result;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(urlPatterns = {"/bluelog/admin"})
public class Admin extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=utf-8");
        PrintWriter writer = response.getWriter();

        Result<List<User>, Exception> queryResult = User.queryIfNotAdmin();
        JSONObject result = new JSONObject();

        if(queryResult.isOk()) {
            result.put("status", "get users success");
            result.put("users", queryResult.left);
        } else if(queryResult.isErr()) {
            response.setStatus(400);
            result.put("status", "get users failed");
            result.put("error", queryResult.right.getMessage());
        }

        writer.write(result.toString());
    }
}
