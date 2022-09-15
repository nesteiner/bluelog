package com.example.backend.exception;

import lombok.AllArgsConstructor;
import lombok.Data;

@AllArgsConstructor
@Data
public class LoginException extends Exception {
    String message;
}
