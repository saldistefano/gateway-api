<div class="px-4 py-6">
  <div class="mb-6">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">Envoy Gateway Features</h1>
    <p class="text-gray-600">Test and learn about advanced Envoy Gateway capabilities</p>
  </div>

  <!-- Feature Status Banner -->
  <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-6">
    <div class="flex">
      <div class="flex-shrink-0">
        <svg class="h-5 w-5 text-yellow-400" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
        </svg>
      </div>
      <div class="ml-3">
        <p class="text-sm text-yellow-700">
          <strong>Development Mode:</strong> Advanced features are placeholders for future implementation. Use this section to plan and learn about Envoy Gateway capabilities.
        </p>
      </div>
    </div>
  </div>

  <!-- Features Grid -->
  <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

    <!-- Rate Limiting -->
    <div class="bg-white shadow rounded-lg p-6">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-xl font-semibold text-gray-900">Rate Limiting</h2>
        <span class="px-2 py-1 text-xs font-semibold bg-yellow-100 text-yellow-800 rounded">TODO</span>
      </div>
      <p class="text-gray-600 mb-4">
        Protect your services from excessive traffic with configurable rate limits per client, endpoint, or globally.
      </p>
      <div class="bg-gray-50 p-4 rounded-md mb-4">
        <p class="text-sm text-gray-700 mb-2">Example use cases:</p>
        <ul class="text-sm text-gray-600 space-y-1">
          <li>• Limit API requests to 100/minute per IP</li>
          <li>• Different limits for authenticated users</li>
          <li>• Burst handling for traffic spikes</li>
        </ul>
      </div>
      <button disabled class="w-full px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">
        Configure Rate Limiting (Coming Soon)
      </button>
    </div>

    <!-- Canary Deployments -->
    <div class="bg-white shadow rounded-lg p-6">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-xl font-semibold text-gray-900">Canary Deployments</h2>
        <span class="px-2 py-1 text-xs font-semibold bg-yellow-100 text-yellow-800 rounded">TODO</span>
      </div>
      <p class="text-gray-600 mb-4">
        Gradually roll out new versions by routing a percentage of traffic to canary deployments.
      </p>
      <div class="bg-gray-50 p-4 rounded-md mb-4">
        <p class="text-sm text-gray-700 mb-2">Example scenarios:</p>
        <ul class="text-sm text-gray-600 space-y-1">
          <li>• Send 10% of traffic to v2</li>
          <li>• A/B testing with header-based routing</li>
          <li>• Progressive rollout strategy</li>
        </ul>
      </div>
      <button disabled class="w-full px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">
        Setup Canary Deployment (Coming Soon)
      </button>
    </div>

    <!-- Authentication & Authorization -->
    <div class="bg-white shadow rounded-lg p-6">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-xl font-semibold text-gray-900">Authentication</h2>
        <span class="px-2 py-1 text-xs font-semibold bg-yellow-100 text-yellow-800 rounded">TODO</span>
      </div>
      <p class="text-gray-600 mb-4">
        Secure your services with JWT validation, OAuth2, or external authentication services.
      </p>
      <div class="bg-gray-50 p-4 rounded-md mb-4">
        <p class="text-sm text-gray-700 mb-2">Supported methods:</p>
        <ul class="text-sm text-gray-600 space-y-1">
          <li>• JWT token validation</li>
          <li>• OAuth2/OIDC integration</li>
          <li>• External auth server</li>
        </ul>
      </div>
      <button disabled class="w-full px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">
        Configure Authentication (Coming Soon)
      </button>
    </div>

    <!-- CORS Policies -->
    <div class="bg-white shadow rounded-lg p-6">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-xl font-semibold text-gray-900">CORS Policies</h2>
        <span class="px-2 py-1 text-xs font-semibold bg-yellow-100 text-yellow-800 rounded">TODO</span>
      </div>
      <p class="text-gray-600 mb-4">
        Control cross-origin resource sharing with flexible CORS policies.
      </p>
      <div class="bg-gray-50 p-4 rounded-md mb-4">
        <p class="text-sm text-gray-700 mb-2">Configuration options:</p>
        <ul class="text-sm text-gray-600 space-y-1">
          <li>• Allowed origins and methods</li>
          <li>• Credentials support</li>
          <li>• Custom headers</li>
        </ul>
      </div>
      <button disabled class="w-full px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">
        Configure CORS (Coming Soon)
      </button>
    </div>

    <!-- Request/Response Modification -->
    <div class="bg-white shadow rounded-lg p-6">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-xl font-semibold text-gray-900">Header Modification</h2>
        <span class="px-2 py-1 text-xs font-semibold bg-yellow-100 text-yellow-800 rounded">TODO</span>
      </div>
      <p class="text-gray-600 mb-4">
        Modify request and response headers for security, compatibility, or enrichment.
      </p>
      <div class="bg-gray-50 p-4 rounded-md mb-4">
        <p class="text-sm text-gray-700 mb-2">Common modifications:</p>
        <ul class="text-sm text-gray-600 space-y-1">
          <li>• Add security headers</li>
          <li>• Remove sensitive information</li>
          <li>• Set custom headers</li>
        </ul>
      </div>
      <button disabled class="w-full px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">
        Configure Headers (Coming Soon)
      </button>
    </div>

    <!-- Circuit Breaking -->
    <div class="bg-white shadow rounded-lg p-6">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-xl font-semibold text-gray-900">Circuit Breaking</h2>
        <span class="px-2 py-1 text-xs font-semibold bg-yellow-100 text-yellow-800 rounded">TODO</span>
      </div>
      <p class="text-gray-600 mb-4">
        Prevent cascading failures with automatic circuit breaking for unhealthy services.
      </p>
      <div class="bg-gray-50 p-4 rounded-md mb-4">
        <p class="text-sm text-gray-700 mb-2">Protection mechanisms:</p>
        <ul class="text-sm text-gray-600 space-y-1">
          <li>• Connection limits</li>
          <li>• Pending request limits</li>
          <li>• Retry budgets</li>
        </ul>
      </div>
      <button disabled class="w-full px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed">
        Configure Circuit Breaker (Coming Soon)
      </button>
    </div>
  </div>

  <!-- Learning Resources -->
  <div class="mt-8 bg-indigo-50 border border-indigo-200 rounded-lg p-6">
    <h2 class="text-2xl font-semibold text-indigo-900 mb-4">Learning Resources</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <a href="https://gateway.envoyproxy.io/docs/" target="_blank" class="flex items-center p-4 bg-white rounded-md hover:shadow-md transition">
        <svg class="h-5 w-5 text-indigo-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
        </svg>
        <div>
          <p class="font-medium text-gray-900">Official Documentation</p>
          <p class="text-sm text-gray-600">Envoy Gateway Docs</p>
        </div>
      </a>
      <a href="https://gateway-api.sigs.k8s.io/" target="_blank" class="flex items-center p-4 bg-white rounded-md hover:shadow-md transition">
        <svg class="h-5 w-5 text-indigo-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
        </svg>
        <div>
          <p class="font-medium text-gray-900">Gateway API</p>
          <p class="text-sm text-gray-600">Kubernetes Gateway API Spec</p>
        </div>
      </a>
    </div>
  </div>
</div>

<style>
  .text-xl {
    font-size: 1.25rem;
    line-height: 1.75rem;
  }

  .bg-yellow-50 {
    background-color: #fefce8;
  }

  .border-yellow-400 {
    border-color: #facc15;
  }

  .text-yellow-400 {
    color: #facc15;
  }

  .text-yellow-700 {
    color: #a16207;
  }

  .text-yellow-800 {
    color: #854d0e;
  }

  .bg-yellow-100 {
    background-color: #fef9c3;
  }

  .bg-gray-300 {
    background-color: #d1d5db;
  }

  .cursor-not-allowed {
    cursor: not-allowed;
  }

  .space-y-1 > * + * {
    margin-top: 0.25rem;
  }

  .w-full {
    width: 100%;
  }

  .mt-8 {
    margin-top: 2rem;
  }

  .mr-3 {
    margin-right: 0.75rem;
  }

  .hover\:shadow-md:hover {
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  }
</style>
