package com.backend.views;

import com.alibaba.fastjson.JSONObject;
import com.backend.models.User;
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

@WebServlet(urlPatterns = {"/bluelog/login"})
public class Login extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter writer = response.getWriter();

        String jsonData = transform(request.getInputStream());
        JSONObject jsonObject = JSONObject.parseObject(jsonData);

        String username = jsonObject.getString("username");
        String usertype = jsonObject.getString("usertype");
        String passhash = jsonObject.getString("passhash");

        Result<List<User>, Exception> queryResult = User.queryWithPasshash(username, usertype.equals("admin"), passhash);
        JSONObject result = new JSONObject();

        if(queryResult.isOk()) {
            HttpSession session = request.getSession();
            session.setAttribute("curuser", username);
            session.setAttribute("usertype", usertype);

            result.put("status", "login success");
            result.put("curuser", username);
            // STUB
            result.put("username", username);
            result.put("usertype", usertype);
        } else if(queryResult.isErr()){
            // TODO return 400
            response.setStatus(400);

            result.put("status", "login failed");
            result.put("error", queryResult.right.getMessage());
        }

        writer.write(result.toString());
    }
}
