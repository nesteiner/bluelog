declare interface User {
    id: number,
    name: string,
    email: string,
}

declare interface Category {
    id: number,
    name: string,
}

declare interface Comment {
    id: number,
    user: User,
    body: string,
    timestamp: string
}

declare interface PostRequest {
    title: string,
    body: string,
    category: string
}

declare interface Post {
    id: number,
    title: string,
    body: string,
    timestamp: string,
    author: User,
    category: Category,
    comments: Comment[]
}

declare interface PostShortcut {
    postid: number,
    title: string,
    author: User,
    shortcut: string,
    category: Category
}

declare interface PagePostShortcut {
    totalPage: number,
    shortcuts: PostShortcut[]
}