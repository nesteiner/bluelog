package com.example.backend.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;

import javax.persistence.*;
import java.sql.Timestamp;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity(name = "Comment")
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @OneToOne
    @JoinColumn(name = "userfk")
    User user;

    @Column(length = 255, nullable = false)
    String body;

    @Column(columnDefinition = "timestamp default current_timestamp", insertable = false, updatable = false)
    @Generated(GenerationTime.INSERT)
    Timestamp timestamp;
}
