package com.example.backend.controller;

import com.example.backend.model.Comment;
import com.example.backend.model.User;
import com.example.backend.service.CommentService;
import com.example.backend.service.PostService;
import com.example.backend.service.UserService;
import com.example.backend.utils.JwtTokenUtil;
import com.example.backend.utils.Result;
import com.example.backend.utils.Status;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

@RestController
@RequestMapping("/comment")
public class CommentController {
    @Autowired
    CommentService commentService;
    @Autowired
    PostService postService;
    @Autowired
    JwtTokenUtil jwtTokenUtil;
    @Autowired
    UserService userService;

    @PostMapping
    public Result<Comment> insertOne(@RequestParam("postid") Long postid, @RequestBody Comment comment, HttpServletRequest request) {
        String username = jwtTokenUtil.getUsernameFromRequest(request);
        Optional<User> optionalUser = userService.findOne(username);
        return optionalUser.map(user -> {
            comment.setUser(user);
            return Result.Ok("add comment ok", postService.insertComment(postid, comment));
        }).orElse(Result.Err("add comment error"));
    }

    @DeleteMapping("/{id}")
    public Result<Status> deleteOne(@PathVariable Long id) {
        postService.deleteOne(id);
        return Result.Ok("delete ok", Status.Ok);
    }

    @PutMapping
    public Result<Comment> updateOne(@RequestBody Comment comment) {
        return Result.Ok("update ok", commentService.updateOne(comment));
    }

}
