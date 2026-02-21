<script>
  import { page } from '$app/stores';

  let mobileMenuOpen = false;

  const navigation = [
    { name: 'Home', href: '/' },
    { name: 'Products', href: '/products' },
    { name: 'Users', href: '/users' },
    { name: 'Posts', href: '/posts' },
    { name: 'Quotes', href: '/quotes' },
    { name: 'Gateway Config', href: '/config' },
    { name: 'Features', href: '/features' }
  ];
</script>

<svelte:head>
  <title>Simple Web - Envoy Gateway Learning</title>
</svelte:head>

<div class="min-h-screen bg-gray-50">
  <!-- Navigation -->
  <nav class="bg-white shadow-sm">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between h-16">
        <div class="flex">
          <div class="flex-shrink-0 flex items-center">
            <h1 class="text-xl font-bold text-indigo-600">Envoy Gateway Learning</h1>
          </div>
          <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
            {#each navigation as item}
              <a
                href={item.href}
                class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium {$page.url.pathname === item.href ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'}"
              >
                {item.name}
              </a>
            {/each}
          </div>
        </div>
        <div class="flex items-center sm:hidden">
          <button
            on:click={() => mobileMenuOpen = !mobileMenuOpen}
            class="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100"
          >
            <span class="sr-only">Open main menu</span>
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              {#if mobileMenuOpen}
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              {:else}
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              {/if}
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- Mobile menu -->
    {#if mobileMenuOpen}
      <div class="sm:hidden">
        <div class="pt-2 pb-3 space-y-1">
          {#each navigation as item}
            <a
              href={item.href}
              class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium {$page.url.pathname === item.href ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700'}"
              on:click={() => mobileMenuOpen = false}
            >
              {item.name}
            </a>
          {/each}
        </div>
      </div>
    {/if}
  </nav>

  <!-- Page content -->
  <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
    <slot />
  </main>

  <!-- Footer -->
  <footer class="bg-white border-t border-gray-200 mt-auto">
    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
      <p class="text-center text-sm text-gray-500">
        Simple Web - Learning Envoy Gateway on Kubernetes | Data from <a href="https://dummyjson.com" target="_blank" class="text-indigo-600 hover:text-indigo-500">DummyJSON</a>
      </p>
    </div>
  </footer>
</div>

<style>
  :global(body) {
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  :global(*) {
    box-sizing: border-box;
  }

  /* Tailwind-inspired utility classes */
  :global(.min-h-screen) {
    min-height: 100vh;
  }

  :global(.bg-gray-50) {
    background-color: #f9fafb;
  }

  :global(.bg-white) {
    background-color: #ffffff;
  }

  :global(.shadow-sm) {
    box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  }

  :global(.max-w-7xl) {
    max-width: 80rem;
  }

  :global(.mx-auto) {
    margin-left: auto;
    margin-right: auto;
  }

  :global(.px-4) {
    padding-left: 1rem;
    padding-right: 1rem;
  }

  :global(.py-6) {
    padding-top: 1.5rem;
    padding-bottom: 1.5rem;
  }

  :global(.text-indigo-600) {
    color: #4f46e5;
  }

  :global(.text-indigo-500) {
    color: #6366f1;
  }

  :global(.text-gray-900) {
    color: #111827;
  }

  :global(.text-gray-500) {
    color: #6b7280;
  }

  :global(.text-sm) {
    font-size: 0.875rem;
    line-height: 1.25rem;
  }

  :global(.font-bold) {
    font-weight: 700;
  }

  :global(.font-medium) {
    font-weight: 500;
  }

  :global(.border-b-2) {
    border-bottom-width: 2px;
  }

  :global(.border-indigo-500) {
    border-color: #6366f1;
  }

  :global(.border-transparent) {
    border-color: transparent;
  }

  :global(.hover\:border-gray-300:hover) {
    border-color: #d1d5db;
  }

  :global(.hover\:text-gray-700:hover) {
    color: #374151;
  }

  :global(.hover\:text-indigo-500:hover) {
    color: #6366f1;
  }

  :global(.flex) {
    display: flex;
  }

  :global(.items-center) {
    align-items: center;
  }

  :global(.justify-between) {
    justify-content: space-between;
  }

  :global(.space-x-8 > * + *) {
    margin-left: 2rem;
  }

  :global(.h-16) {
    height: 4rem;
  }

  :global(.text-xl) {
    font-size: 1.25rem;
    line-height: 1.75rem;
  }

  :global(.inline-flex) {
    display: inline-flex;
  }

  :global(.pt-1) {
    padding-top: 0.25rem;
  }

  :global(.px-1) {
    padding-left: 0.25rem;
    padding-right: 0.25rem;
  }

  :global(.border-t) {
    border-top-width: 1px;
  }

  :global(.border-gray-200) {
    border-color: #e5e7eb;
  }

  :global(.text-center) {
    text-align: center;
  }

  :global(.mt-auto) {
    margin-top: auto;
  }

  @media (min-width: 640px) {
    :global(.sm\:px-6) {
      padding-left: 1.5rem;
      padding-right: 1.5rem;
    }

    :global(.sm\:ml-6) {
      margin-left: 1.5rem;
    }

    :global(.sm\:flex) {
      display: flex;
    }

    :global(.sm\:hidden) {
      display: none;
    }
  }

  @media (min-width: 1024px) {
    :global(.lg\:px-8) {
      padding-left: 2rem;
      padding-right: 2rem;
    }
  }

  :global(.hidden) {
    display: none;
  }

  :global(.block) {
    display: block;
  }

  :global(.rounded-md) {
    border-radius: 0.375rem;
  }

  :global(.p-2) {
    padding: 0.5rem;
  }

  :global(.h-6) {
    height: 1.5rem;
  }

  :global(.w-6) {
    width: 1.5rem;
  }

  :global(.sr-only) {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border-width: 0;
  }

  :global(.text-gray-400) {
    color: #9ca3af;
  }

  :global(.hover\:text-gray-500:hover) {
    color: #6b7280;
  }

  :global(.hover\:bg-gray-100:hover) {
    background-color: #f3f4f6;
  }

  :global(.pt-2) {
    padding-top: 0.5rem;
  }

  :global(.pb-3) {
    padding-bottom: 0.75rem;
  }

  :global(.space-y-1 > * + *) {
    margin-top: 0.25rem;
  }

  :global(.pl-3) {
    padding-left: 0.75rem;
  }

  :global(.pr-4) {
    padding-right: 1rem;
  }

  :global(.py-2) {
    padding-top: 0.5rem;
    padding-bottom: 0.5rem;
  }

  :global(.border-l-4) {
    border-left-width: 4px;
  }

  :global(.text-base) {
    font-size: 1rem;
    line-height: 1.5rem;
  }

  :global(.bg-indigo-50) {
    background-color: #eef2ff;
  }

  :global(.text-indigo-700) {
    color: #4338ca;
  }

  :global(.hover\:bg-gray-50:hover) {
    background-color: #f9fafb;
  }
</style>
