package com.example.backend.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PostRequest {
    @NotBlank(message = "title cannot be blank")
    @Length(min = 5, message = "title must greater than 5")
    String title;

    @NotBlank(message = "body cannot be blank")
    @Length(min = 8, message = "body must greater than 5")
    String body;

    @NotBlank(message = "category cannot be blank")
    String category;
}
