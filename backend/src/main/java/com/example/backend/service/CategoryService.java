package com.example.backend.service;

import com.example.backend.model.Category;
import com.example.backend.model.Post;
import com.example.backend.repository.CategoryRepository;
import com.example.backend.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryService {
    @Autowired
    CategoryRepository categoryRepository;
    @Autowired
    PostRepository postRepository;

    public Category insertOne(Category category) {
        return categoryRepository.save(category);
    }

    public void deleteOne(Long id, Long userid) {
        Optional<Category> optionalCategory = categoryRepository.findById(id);
        optionalCategory.ifPresent(category -> {
            categoryRepository.deleteById(id);
            List<Post> posts = postRepository.findAllByCategory(category);
            Optional<Category> defaultCategory = categoryRepository.findByNameAndUserid("default", userid);
            defaultCategory.ifPresent(_default -> {
                posts.forEach(post -> {
                    post.setCategory(_default);
                });

                postRepository.saveAll(posts);
            });

        });

    }

    public Category updateOne(Category category) {
        return categoryRepository.save(category);
    }

    public Optional<Category> findOne(Long id) {
        return categoryRepository.findById(id);
    }

    public Optional<Category> findOne(String name) { return categoryRepository.findByName(name); }
    public List<Category> findAll(Long userid) {
        return categoryRepository.findAllByUserid(userid);
    }
}
