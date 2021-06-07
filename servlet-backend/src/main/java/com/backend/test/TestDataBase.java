package com.backend.test;

import com.alibaba.fastjson.JSONObject;
import com.backend.models.Post;
import com.backend.utils.Result;
import org.junit.Test;

import java.util.List;

public class TestDataBase {
    @Test
    public void test() {
        Result<List<Post>, Exception> result = Post.queryWithAuthor("Steiner");
        JSONObject jsonObject = new JSONObject();
        if(result.isOk()) {
            jsonObject.put("posts", result.left);
            System.out.println(jsonObject);
        } else {
            System.out.println(result.right.getMessage());
        }
    }
}
