package com.example.backend.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity(name = "Post")
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Column(length = 60, nullable = false)
    String title;

    @Lob
    @Column(columnDefinition = "text", nullable = false)
    String body;

    @Column(columnDefinition = "timestamp default current_timestamp", insertable = false, updatable = false)
    @Generated(GenerationTime.INSERT)
    Timestamp timestamp;

    @OneToOne
    @JoinColumn(name = "authorfk")
    User author;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "categoryfk")
    Category category;


    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinTable(
            name = "Post_Comment",
            joinColumns = @JoinColumn(name = "postid", referencedColumnName = "id"),
            inverseJoinColumns = @JoinColumn(name = "commentid", referencedColumnName = "id")
    )
    List<Comment> comments;
    // comments
}
