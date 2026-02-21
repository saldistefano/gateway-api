<script>
  import { onMount } from 'svelte';
  import { api } from '$lib/api.js';

  let posts = [];
  let loading = true;
  let error = null;

  onMount(async () => {
    try {
      const data = await api.getPosts(30);
      posts = data.posts || [];
    } catch (err) {
      error = err.message;
    } finally {
      loading = false;
    }
  });
</script>

<div class="px-4 py-6">
  <h1 class="text-3xl font-bold text-gray-900 mb-6">Posts</h1>

  {#if loading}
    <div class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
    </div>
  {:else if error}
    <div class="bg-red-50 border-l-4 border-red-400 p-4">
      <p class="text-red-700">Error: {error}</p>
    </div>
  {:else}
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      {#each posts as post}
        <div class="bg-white shadow rounded-lg p-6">
          <h3 class="font-semibold text-gray-900 mb-2">{post.title}</h3>
          <p class="text-sm text-gray-600">{post.body}</p>
          <div class="mt-3 flex gap-2">
            {#each post.tags || [] as tag}
              <span class="px-2 py-1 bg-indigo-100 text-indigo-700 text-xs rounded">{tag}</span>
            {/each}
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>
