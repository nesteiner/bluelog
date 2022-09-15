package com.example.backend.controller;

import com.example.backend.model.Category;
import com.example.backend.model.User;
import com.example.backend.service.CategoryService;
import com.example.backend.service.UserService;
import com.example.backend.utils.JwtTokenUtil;
import com.example.backend.utils.Result;
import com.example.backend.utils.Status;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/category")
@Validated
public class CategoryController {
    @Autowired
    CategoryService categoryService;
    @Autowired
    JwtTokenUtil jwtTokenUtil;
    @Autowired
    UserService userService;

    @GetMapping("/{id}")
    public Result<Category> findOne(@PathVariable Long id) {
        return categoryService.findOne(id)
                .map(category -> Result.Ok("category", category))
                .orElse(Result.Err("no such category"));
    }

    @GetMapping
    public Result<List<Category>> findAll(HttpServletRequest request) {
        String username = jwtTokenUtil.getUsernameFromRequest(request);
        Optional<User> optionalUser = userService.findOne(username);
        return optionalUser.map(user -> {
            return Result.Ok("all category", categoryService.findAll(user.getId()));
        }).orElse(Result.Err("no such user"));
    }

    @PostMapping
    public Result<Category> insertOne(@RequestBody @Valid Category category, BindingResult result, HttpServletRequest request) {
        String username = jwtTokenUtil.getUsernameFromRequest(request);
        Optional<User> optionalUser = userService.findOne(username);
        return optionalUser.map(user -> {
            category.setUserid(user.getId());
            return Result.Ok("insert ok", categoryService.insertOne(category));
        }).orElse(Result.Err("no such user"));

    }

    @DeleteMapping("/{id}")
    public Result<Status> deleteOne(@PathVariable Long id, HttpServletRequest request) {
        String username = jwtTokenUtil.getUsernameFromRequest(request);
        Optional<User> optionalUser = userService.findOne(username);
        return optionalUser.map(user -> {
            categoryService.deleteOne(id, user.getId());
            return Result.Ok("delete ok", Status.Ok);
        }).orElse(Result.Err("no such user"));
    }

    @PutMapping
    public Result<Category> updateOne(@RequestBody @Valid Category category, BindingResult result, HttpServletRequest request) {
        String username = jwtTokenUtil.getUsernameFromRequest(request);
        Optional<User> optionalUser = userService.findOne(username);
        return optionalUser.map(user -> {
            category.setUserid(user.getId());
            return Result.Ok("insert ok", categoryService.updateOne(category));
        }).orElse(Result.Err("no such user"));
    }
}
