package com.example.backend.service;

import com.example.backend.model.Category;
import com.example.backend.model.User;
import com.example.backend.repository.CategoryRepository;
import com.example.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Optional;

@Service
public class UserService implements UserDetailsService {
    @Autowired
    UserRepository userRepository;
    @Autowired
    CategoryRepository categoryRepository;

    public User insertOne(User user) {
        User newuser = userRepository.save(user);
        Category defaultCategory = new Category(null, "default", newuser.getId());
        categoryRepository.save(defaultCategory);
        return newuser;
    }

    public void deleteOne(Long id) {
        userRepository.deleteById(id);
    }

    public User updateOne(User user) {
        return userRepository.save(user);
    }

    public Optional<User> findOne(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> findOne(String name) {
        return userRepository.findByName(name);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Optional<User> optionalUser = userRepository.findByName(username);
        return optionalUser.map(user -> {
                    return new org.springframework.security.core.userdetails.User(user.getName(), user.getPasswordHash(), new ArrayList<>());
                })
                .orElseThrow(() -> new UsernameNotFoundException("no such user"));
    }
}
