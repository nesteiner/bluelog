import Axios from "axios";

const instance = Axios.create({
    baseURL: "http://localhost/api"
})

const LOCAL_TOKEN_KEY = "token";

async function login(username: string, password: string) {
    let jwttoken = await instance.post("/authenticate", {
        username,
        password
    })
        .then(response => response.data.jwttoken)
        .catch(error => {
            let errorMessage = error.response.data.message;
            throw errorMessage;
        });

    let authorization = `Bearer ${jwttoken}`;
    localStorage.setItem(LOCAL_TOKEN_KEY, authorization);

}

function logout() {
    localStorage.removeItem(LOCAL_TOKEN_KEY);
}

async function findPost(id: number) {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    let post = await instance.get(`/post/${id}`, {
        headers: {
            "Authorization": jwttoken
        }
    }).then(response => response.data["data"])
        .catch(error => {
            throw error.response
        });

    return post;
}

async function findPostShortcuts(pageindex: number) {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    let pagePostShortcut = await instance.get("/post", {
        params: {
            pageindex
        },

        headers: {
            "Authorization": jwttoken
        }
    }).then(response => response.data["data"])
        .catch(error => {
            throw error.response
        })

    return pagePostShortcut;
}

async function findPostShortcutsByCategory(pageindex: number, category: string) {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    let pagePostShortcut = await instance.get("/post", {
        params: {
            pageindex,
            category
        },

        headers: {
            "Authorization": jwttoken
        }
    }).then(response => response.data["data"])
        .catch(error => {
            throw error.response
        })

    return pagePostShortcut;
}

async function findCategories() {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    let categories = await instance.get("/category", {
        headers: {
            "Authorization": jwttoken
        }
    }).then(response => response.data["data"])
        .catch(error => {
            throw error.response
        })

    return categories;
}

async function deletePost(id: number) {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    await instance.delete(`/post/${id}`, {
        headers: {
            "Authorization": jwttoken
        }
    }).catch(error => {
        throw error.response
    })
}

async function insertPost(request: PostRequest) {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    let post = await instance.post("/post", request, {
        headers: {
            "Authorization": jwttoken
        }
    }).then(response => response.data["data"])
        .catch(error => {
            throw error.response
        })

    return post;
}

async function updatePost(post: Post) {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    let newpost = await instance.put("/post", post, {
        headers: {
            "Authorization": jwttoken
        }
    }).then(response => response.data["data"])
        .catch(error => {
            throw error.response
        })
    return newpost;
}

async function insertCategory(category: {name: string}) {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    let newcategory = await instance.post("/category", category, {
        headers: {
            "Authorization": jwttoken
        }
    }).then(response => response.data["data"])
        .catch(error => {
            throw error.response
        });

    return newcategory;
}

async function updateCategory(category: Category) {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    let newcategory = await instance.put("/category", category, {
        headers: {
            "Authorization": jwttoken
        }
    }).then(response => response.data["data"])
        .catch(error => {
            throw error.response
        });

    return newcategory;
}

async function deleteCategory(id: number) {
    let jwttoken = localStorage.getItem(LOCAL_TOKEN_KEY) || "no token";
    let newcategory = await instance.delete(`/category/${id}`, {
        headers: {
            "Authorization": jwttoken
        }
    }).catch(error => {
        throw error.response
    });

}
export {
    login,
    logout,
    findPost,
    findPostShortcuts,
    findPostShortcutsByCategory,
    findCategories,
    deletePost,
    insertPost,
    updatePost,
    insertCategory,
    updateCategory,
    deleteCategory
}