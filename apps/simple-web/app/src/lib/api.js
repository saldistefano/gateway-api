// API client for calling simple-api via Envoy Gateway
// Calls api.local through the gateway to demonstrate Envoy routing

const API_BASE_URL = 'http://api.local';

async function fetchAPI(endpoint, options = {}) {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
    if (!response.ok) {
      throw new Error(`API error: ${response.status} ${response.statusText}`);
    }
    return await response.json();
  } catch (error) {
    console.error(`Failed to fetch ${endpoint}:`, error);
    throw error;
  }
}

export const api = {
  // Health check
  async health() {
    return fetchAPI('/test');
  },

  // Products
  async getProducts(limit = 10, skip = 0) {
    return fetchAPI(`/products?limit=${limit}&skip=${skip}`);
  },

  async getProduct(id) {
    return fetchAPI(`/products/${id}`);
  },

  async searchProducts(query) {
    return fetchAPI(`/products/search?q=${encodeURIComponent(query)}`);
  },

  async getProductsByCategory(category) {
    return fetchAPI(`/products/category/${category}`);
  },

  async getProductCategories() {
    return fetchAPI('/products/categories');
  },

  // Users
  async getUsers(limit = 10, skip = 0) {
    return fetchAPI(`/users?limit=${limit}&skip=${skip}`);
  },

  async getUser(id) {
    return fetchAPI(`/users/${id}`);
  },

  async searchUsers(query) {
    return fetchAPI(`/users/search?q=${encodeURIComponent(query)}`);
  },

  // Posts
  async getPosts(limit = 10, skip = 0) {
    return fetchAPI(`/posts?limit=${limit}&skip=${skip}`);
  },

  async getPost(id) {
    return fetchAPI(`/posts/${id}`);
  },

  async getPostsByUser(userId) {
    return fetchAPI(`/posts/user/${userId}`);
  },

  // Quotes
  async getQuotes(limit = 10, skip = 0) {
    return fetchAPI(`/quotes?limit=${limit}&skip=${skip}`);
  },

  async getRandomQuote() {
    return fetchAPI('/quotes/random');
  },

  // Recipes
  async getRecipes(limit = 10, skip = 0) {
    return fetchAPI(`/recipes?limit=${limit}&skip=${skip}`);
  },

  async getRecipe(id) {
    return fetchAPI(`/recipes/${id}`);
  },

  // Todos
  async getTodos(limit = 10, skip = 0) {
    return fetchAPI(`/todos?limit=${limit}&skip=${skip}`);
  },

  async getTodosByUser(userId) {
    return fetchAPI(`/todos/user/${userId}`);
  }
};
