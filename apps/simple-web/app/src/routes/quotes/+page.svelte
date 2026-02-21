<script>
  import { onMount } from 'svelte';
  import { api } from '$lib/api.js';

  let quotes = [];
  let loading = true;
  let error = null;

  onMount(async () => {
    try {
      const data = await api.getQuotes(30);
      quotes = data.quotes || [];
    } catch (err) {
      error = err.message;
    } finally {
      loading = false;
    }
  });
</script>

<div class="px-4 py-6">
  <h1 class="text-3xl font-bold text-gray-900 mb-6">Quotes</h1>

  {#if loading}
    <div class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
    </div>
  {:else if error}
    <div class="bg-red-50 border-l-4 border-red-400 p-4">
      <p class="text-red-700">Error: {error}</p>
    </div>
  {:else}
    <div class="space-y-6">
      {#each quotes as quote}
        <div class="bg-white shadow rounded-lg p-6">
          <blockquote class="text-lg text-gray-900 italic mb-3">"{quote.quote}"</blockquote>
          <p class="text-sm text-gray-600">— {quote.author}</p>
        </div>
      {/each}
    </div>
  {/if}
</div>
