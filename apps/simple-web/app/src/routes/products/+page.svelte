<script>
  import { onMount } from 'svelte';
  import { api } from '$lib/api.js';

  let products = [];
  let loading = true;
  let error = null;
  let searchQuery = '';

  onMount(async () => {
    await loadProducts();
  });

  async function loadProducts() {
    try {
      loading = true;
      error = null;
      const data = await api.getProducts(20);
      products = data.products || [];
    } catch (err) {
      error = err.message;
    } finally {
      loading = false;
    }
  }

  async function searchProducts() {
    if (!searchQuery.trim()) {
      await loadProducts();
      return;
    }

    try {
      loading = true;
      error = null;
      const data = await api.searchProducts(searchQuery);
      products = data.products || [];
    } catch (err) {
      error = err.message;
    } finally {
      loading = false;
    }
  }
</script>

<div class="px-4 py-6">
  <div class="mb-6">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">Products</h1>
    <p class="text-gray-600">Browse products from the DummyJSON API via Envoy Gateway</p>
  </div>

  <!-- Search -->
  <div class="mb-6">
    <div class="flex gap-2">
      <input
        type="text"
        bind:value={searchQuery}
        on:keydown={(e) => e.key === 'Enter' && searchProducts()}
        placeholder="Search products..."
        class="flex-1 px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
      />
      <button
        on:click={searchProducts}
        class="px-6 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500"
      >
        Search
      </button>
    </div>
  </div>

  {#if loading}
    <div class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
      <p class="mt-2 text-gray-600">Loading products...</p>
    </div>
  {:else if error}
    <div class="bg-red-50 border-l-4 border-red-400 p-4">
      <p class="text-red-700">Error: {error}</p>
      <p class="text-sm text-red-600 mt-1">Make sure the API is accessible via the gateway</p>
    </div>
  {:else}
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {#each products as product}
        <div class="bg-white shadow rounded-lg overflow-hidden hover:shadow-lg transition">
          {#if product.thumbnail}
            <img src={product.thumbnail} alt={product.title} class="w-full h-48 object-cover" />
          {/if}
          <div class="p-4">
            <h3 class="font-semibold text-gray-900 mb-2">{product.title}</h3>
            <p class="text-sm text-gray-600 mb-3 line-clamp-2">{product.description}</p>
            <div class="flex justify-between items-center">
              <span class="text-2xl font-bold text-indigo-600">${product.price}</span>
              <span class="text-sm text-gray-500">{product.category}</span>
            </div>
            {#if product.rating}
              <div class="mt-2 flex items-center">
                <span class="text-yellow-400">★</span>
                <span class="ml-1 text-sm text-gray-600">{product.rating.toFixed(1)}</span>
              </div>
            {/if}
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
  .text-3xl {
    font-size: 1.875rem;
    line-height: 2.25rem;
  }

  .line-clamp-2 {
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }

  .animate-spin {
    animation: spin 1s linear infinite;
  }

  @keyframes spin {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }

  .h-8 {
    height: 2rem;
  }

  .w-8 {
    width: 2rem;
  }

  .border-b-2 {
    border-bottom-width: 2px;
  }

  .flex-1 {
    flex: 1 1 0%;
  }

  .gap-2 {
    gap: 0.5rem;
  }

  .border {
    border-width: 1px;
  }

  .border-gray-300 {
    border-color: #d1d5db;
  }

  .focus\:outline-none:focus {
    outline: 2px solid transparent;
    outline-offset: 2px;
  }

  .focus\:ring-2:focus {
    box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.5);
  }

  .px-6 {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }

  .bg-indigo-600 {
    background-color: #4f46e5;
  }

  .hover\:bg-indigo-700:hover {
    background-color: #4338ca;
  }

  .py-12 {
    padding-top: 3rem;
    padding-bottom: 3rem;
  }

  .bg-red-50 {
    background-color: #fef2f2;
  }

  .border-red-400 {
    border-color: #f87171;
  }

  .text-red-700 {
    color: #b91c1c;
  }

  .text-red-600 {
    color: #dc2626;
  }

  .mt-1 {
    margin-top: 0.25rem;
  }

  .mt-2 {
    margin-top: 0.5rem;
  }

  .overflow-hidden {
    overflow: hidden;
  }

  .hover\:shadow-lg:hover {
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  }

  .h-48 {
    height: 12rem;
  }

  .object-cover {
    object-fit: cover;
  }

  .justify-between {
    justify-content: space-between;
  }

  .text-yellow-400 {
    color: #facc15;
  }

  @media (min-width: 1024px) {
    .lg\:grid-cols-3 {
      grid-template-columns: repeat(3, minmax(0, 1fr));
    }
  }
</style>
