package com.backend.utils;

public class Result <Ok, Err> {
    public Ok left;
    public Err right;

    public Result(Ok left, Err right) {
        this.left = left;
        this.right = right;
    }

    public boolean isOk() {
        return left != null && right == null;
    }

    public boolean isErr() {
        return left == null && right != null;
    }
}