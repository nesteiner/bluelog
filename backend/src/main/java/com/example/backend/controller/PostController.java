package com.example.backend.controller;

import com.example.backend.model.*;
import com.example.backend.service.CategoryService;
import com.example.backend.service.PostService;
import com.example.backend.service.UserService;
import com.example.backend.utils.JwtTokenUtil;
import com.example.backend.utils.Result;
import com.example.backend.utils.Status;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/post")
@Validated
public class PostController {
    @Autowired
    PostService postService;
    @Autowired
    UserService userService;
    @Autowired
    CategoryService categoryService;
    @Autowired
    JwtTokenUtil jwtTokenUtil;
    @Value("${pagesize}")
    Integer pagesize;

    @PostMapping
    public Result<Post> insertOne(@RequestBody @Valid PostRequest post, BindingResult result, HttpServletRequest request) {
        String username = jwtTokenUtil.getUsernameFromRequest(request);
        Optional<User> optionalUser = userService.findOne(username);

        Optional<Category> optionalCategory = categoryService.findOne(post.getCategory());
        if(optionalCategory.isPresent() && optionalUser.isPresent()) {
            User user = optionalUser.get();
            Category category = optionalCategory.get();
            Post newpost = new Post(null, post.getTitle(), post.getBody(), null, user, category, new ArrayList<>());
            return Result.Ok("insert ok", postService.insertOne(newpost));
        } else if(optionalUser.isEmpty()) {
            return Result.Err("no such user");
        } else { // optional category is empty
            return Result.Err("no such category");
        }

    }

    @DeleteMapping("/{id}")
    public Result<Status> deleteOne(@PathVariable Long id) {
        postService.deleteOne(id);
        return Result.Ok("delete ok", Status.Ok);
    }

    @PutMapping
    public Result<Post> updateOne(@RequestBody Post post) {
        return Result.Ok("update ok", postService.updateOne(post));
    }

    @GetMapping("/{id}")
    public Result<Post> findOne(@PathVariable Long id) {
        return postService.findOne(id)
                .map(post -> Result.Ok("post", post))
                .orElse(Result.Err("no such post"));
    }

    @GetMapping
    public Result<PagePostshortcut> findAll(@RequestParam("pageindex") Integer pageindex, @RequestParam(value = "category", required = false) String categoryName, HttpServletRequest request) {
        Pageable pageable = PageRequest.of(pageindex, pagesize);
        String username = jwtTokenUtil.getUsernameFromRequest(request);
        Optional<User> optionalUser = userService.findOne(username);

        if(categoryName == null) {
            return optionalUser.map(user -> {
                PagePostshortcut pagePostshortcut = postService.findAll(user, pageable);
                return Result.Ok("posts", pagePostshortcut);
            }).orElse(Result.Err("no such user"));
        } else {
            Optional<Category> optionalCategory = categoryService.findOne(categoryName);
            return optionalUser.map(user -> {
                return optionalCategory.map(category -> {
                    PagePostshortcut pagePostshortcut = postService.findAll(user, category, pageable);
                    return Result.Ok("posts", pagePostshortcut);
                }).orElse(Result.Err("no such category"));
            }).orElse(Result.Err("no such user"));
        }
    }


}
