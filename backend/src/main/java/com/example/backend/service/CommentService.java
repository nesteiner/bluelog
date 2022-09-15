package com.example.backend.service;

import com.example.backend.model.Comment;
import com.example.backend.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommentService {
    @Autowired
    CommentRepository commentRepository;

    public Comment insertOne(Comment comment) {
        return commentRepository.save(comment);
    }

    public void deleteOne(Long id) {
        commentRepository.deleteById(id);
    }

    public Comment updateOne(Comment comment) {
        return commentRepository.save(comment);
    }

}
