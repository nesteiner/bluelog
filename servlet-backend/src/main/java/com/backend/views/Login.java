package com.backend.views;

import com.alibaba.fastjson.JSONObject;
import com.backend.models.User;

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

@WebServlet(urlPatterns = "/bluelog/login")
public class Login extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=utf-8");
        PrintWriter writer = response.getWriter();

        String jsonData = transform(request.getInputStream());
        JSONObject jsonObject = JSONObject.parseObject(jsonData);

        String username = jsonObject.getString("username");
        String usertype = jsonObject.getString("usertype");
        String passhash = jsonObject.getString("passhash");

        List<User> matchedUser = User.queryWithPasshash(username, usertype.equals("admin"), passhash);
        if(!matchedUser.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("curuser", username);
            session.setAttribute("usertype", usertype);
            JSONObject result = new JSONObject();
            result.put("status", "login success");
            result.put("curuser", username);

            writer.write(result.toString());

        } else {
            // TODO return 400
            response.setStatus(400);
            JSONObject result = new JSONObject();
            result.put("status", "login failed");
            result.put("error", "no such user or password incorrect");

            writer.write(result.toString());

        }
    }
}
