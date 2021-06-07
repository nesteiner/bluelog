package com.backend.test;

import com.alibaba.fastjson.JSONObject;
import com.backend.models.Post;
import org.junit.Test;

import java.util.LinkedList;
import java.util.List;

public class TestJSON {
    @Test
    public void test() {
        List<Post> posts = new LinkedList<>();
        posts.add(new Post(1, "hello", "world", "fuck"));

        JSONObject result = new JSONObject();
        result.put("status", "get post success");
        result.put("posts", posts);

        System.out.println(result.toString());
    }
}
