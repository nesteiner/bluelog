package com.example.backend.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PostShortcut {
    private static final int length = 255;
    Long postid;
    String title;
    User author;
    String shortcut;
    Category category;

    public static PostShortcut fromPost(Post post) {
        String shortcut = "";
        if(post.getBody().length() > length) {
            shortcut = post.getBody().substring(0, length);
        } else {
            shortcut = post.getBody();
        }
        return new PostShortcut(
                post.getId(),
                post.getTitle(),
                post.getAuthor(),
                shortcut,
                post.getCategory()
        );
    }
}
