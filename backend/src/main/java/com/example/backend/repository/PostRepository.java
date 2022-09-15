package com.example.backend.repository;

import com.example.backend.model.Category;
import com.example.backend.model.Post;
import com.example.backend.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    Page<Post> findAll(Pageable pageable);
    Page<Post> findAllByAuthor(User author, Pageable pageable);
    Page<Post> findAllByAuthorAndCategory(User author, Category category, Pageable pageable);
    List<Post> findAllByCategory(Category category);
}
