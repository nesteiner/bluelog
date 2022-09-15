package com.example.backend;

import com.example.backend.model.Category;
import com.example.backend.model.Comment;
import com.example.backend.model.Post;
import com.example.backend.model.User;
import com.example.backend.repository.CategoryRepository;
import com.example.backend.repository.CommentRepository;
import com.example.backend.repository.PostRepository;
import com.example.backend.repository.UserRepository;
import com.example.backend.service.UserService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.List;

@SpringBootTest
class BackendApplicationTests {
    @Autowired
    PostRepository postRepository;
    @Autowired
    CategoryRepository categoryRepository;
    @Autowired
    CommentRepository commentRepository;
    @Autowired
    UserRepository userRepository;
    @Test
    void contextLoads() {
    }

    @Test
    void fakeData() {
        User user = new User(null, "steiner", "steiner3044@163.com", "$2a$10$8QbGr61GouH29DIwoN6DUuzcHEODSqqh6TqJXqe5L26KcEMuoH3eS");
        user = userRepository.save(user);
        Category defaultCategory = new Category(null, "default", user.getId());
        Category category1 = new Category(null, "category1", user.getId());
        Category category2 = new Category(null, "category2", user.getId());

        categoryRepository.save(defaultCategory);
        categoryRepository.save(category1);
        categoryRepository.save(category2);

        List<Comment> comments1 = List.of(
          new Comment(null, user, "comment1", null),
          new Comment(null, user, "comment2", null),
          new Comment(null, user, "comment3", null)
        );

        List<Comment> comments2 = List.of(
                new Comment(null, user, "comment4", null),
                new Comment(null, user, "comment5", null),
                new Comment(null, user, "comment6", null)
        );


        Post post1 = new Post(null, "post1", new String("<h1> Hello World </h1>").repeat(40), null, user, category1, comments1);
        Post post2 = new Post(null, "post2", new String("<h1> Fuck You </h1>").repeat(40), null, user, category2, comments2);
        postRepository.save(post1);
        postRepository.save(post2);
    }
}
