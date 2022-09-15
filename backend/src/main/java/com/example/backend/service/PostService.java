package com.example.backend.service;

import com.example.backend.model.*;
import com.example.backend.repository.CategoryRepository;
import com.example.backend.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class PostService {
    @Autowired
    PostRepository postRepository;
    @Autowired
    CategoryRepository categoryRepository;

    public Post insertOne(Post post) {
        return postRepository.save(post);
    }

    public void deleteOne(Long id) {
        postRepository.deleteById(id);
    }

    public Post updateOne(Post post) {
        Category category = post.getCategory();
        String categoryName = category.getName();
        Optional<Category> optionalCategory = categoryRepository.findByName(categoryName);
        return optionalCategory.map(_category -> {
            post.setCategory(_category);
            return postRepository.save(post);
        }).orElse(post);
    }

    public Optional<Post> findOne(Long id) {
        return postRepository.findById(id);
    }

    public PagePostshortcut findAll(User author, Pageable pageable) {
        Page<Post> posts = postRepository.findAllByAuthor(author, pageable);
        PagePostshortcut postshortcut = new PagePostshortcut(
                posts.getTotalPages(),
                posts.getContent().stream().map(PostShortcut::fromPost).collect(Collectors.toList())
        );

        return postshortcut;
    }

    public PagePostshortcut findAll(User author, Category category, Pageable pageable) {
        Page<Post> posts = postRepository.findAllByAuthorAndCategory(author, category, pageable);
        PagePostshortcut pagePostshortcut = new PagePostshortcut(
                posts.getTotalPages(),
                posts.getContent().stream().map(PostShortcut::fromPost).collect(Collectors.toList())
        );

        return pagePostshortcut;
    }

    // add comment
    public Comment insertComment(Long id, Comment comment) {
        Optional<Post> optionalPost = postRepository.findById(id);
        return optionalPost.map(post -> {
            post.getComments().add(0, comment);
            Post _post = postRepository.save(post);
            return _post.getComments().get(0);
        }).orElse(null);
    }
}
