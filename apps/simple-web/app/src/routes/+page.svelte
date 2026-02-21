<script>
  let apiStatus = 'checking...';

  async function checkAPI() {
    try {
      const response = await fetch('http://api.local/test');
      if (response.ok) {
        apiStatus = 'Connected ✓';
      } else {
        apiStatus = 'Error';
      }
    } catch (error) {
      apiStatus = 'Not accessible (expected in browser)';
    }
  }

  checkAPI();
</script>

<div class="px-4 py-8">
  <div class="mb-8">
    <h1 class="text-4xl font-bold text-gray-900 mb-2">Envoy Gateway Learning Platform</h1>
    <p class="text-lg text-gray-600">
      Learn application networking, Envoy Gateway, and Kubernetes security best practices
    </p>
  </div>

  <!-- API Status Banner -->
  <div class="bg-blue-50 border-l-4 border-blue-400 p-4 mb-8">
    <div class="flex">
      <div class="flex-shrink-0">
        <svg class="h-5 w-5 text-blue-400" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
        </svg>
      </div>
      <div class="ml-3">
        <p class="text-sm text-blue-700">
          API Status: <strong>{apiStatus}</strong> |
          Backend API accessible via Envoy Gateway at <code class="bg-blue-100 px-1 rounded">http://api.local</code>
        </p>
      </div>
    </div>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
    <!-- What is Envoy Gateway -->
    <div class="bg-white shadow rounded-lg p-6">
      <h2 class="text-2xl font-semibold text-gray-900 mb-4">What is Envoy Gateway?</h2>
      <p class="text-gray-600 mb-4">
        Envoy Gateway is an open-source project for managing Envoy Proxy as a standalone or Kubernetes-based API gateway.
        It provides a simple and consistent way to configure traffic routing, security, and observability.
      </p>
      <ul class="space-y-2 text-gray-600">
        <li class="flex items-start">
          <span class="text-indigo-600 mr-2">→</span>
          Built on Envoy Proxy - proven at scale
        </li>
        <li class="flex items-start">
          <span class="text-indigo-600 mr-2">→</span>
          Implements Kubernetes Gateway API
        </li>
        <li class="flex items-start">
          <span class="text-indigo-600 mr-2">→</span>
          Supports advanced traffic management
        </li>
        <li class="flex items-start">
          <span class="text-indigo-600 mr-2">→</span>
          Enterprise-grade security features
        </li>
      </ul>
    </div>

    <!-- This Deployment -->
    <div class="bg-white shadow rounded-lg p-6">
      <h2 class="text-2xl font-semibold text-gray-900 mb-4">This Deployment</h2>
      <p class="text-gray-600 mb-4">
        This demo showcases Envoy Gateway on a local Kind cluster with two applications:
      </p>
      <div class="space-y-3">
        <div class="border-l-4 border-green-400 pl-4">
          <h3 class="font-semibold text-gray-900">simple-api</h3>
          <p class="text-sm text-gray-600">DummyJSON REST API in hardened distroless container</p>
          <code class="text-xs text-gray-500">Hostname: api.local</code>
        </div>
        <div class="border-l-4 border-blue-400 pl-4">
          <h3 class="font-semibold text-gray-900">simple-web</h3>
          <p class="text-sm text-gray-600">SvelteKit frontend (this application)</p>
          <code class="text-xs text-gray-500">Hostname: web.local</code>
        </div>
      </div>
    </div>
  </div>

  <!-- Key Concepts -->
  <div class="bg-white shadow rounded-lg p-6 mb-8">
    <h2 class="text-2xl font-semibold text-gray-900 mb-4">Key Concepts</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div>
        <h3 class="font-semibold text-indigo-600 mb-2">Gateway</h3>
        <p class="text-sm text-gray-600">
          Defines a load balancer configuration for accepting traffic.
          Our gateway <code class="bg-gray-100 px-1 rounded">eg</code> listens for HTTP requests.
        </p>
      </div>
      <div>
        <h3 class="font-semibold text-indigo-600 mb-2">HTTPRoute</h3>
        <p class="text-sm text-gray-600">
          Routes HTTP requests to backend services based on hostname, path, headers, etc.
          Routes traffic from <code class="bg-gray-100 px-1 rounded">api.local</code> to simple-api service.
        </p>
      </div>
      <div>
        <h3 class="font-semibold text-indigo-600 mb-2">Policies</h3>
        <p class="text-sm text-gray-600">
          Configure cross-cutting concerns like rate limiting, authentication, CORS, etc.
          Applied to Gateways or HTTPRoutes.
        </p>
      </div>
    </div>
  </div>

  <!-- Quick Links -->
  <div class="bg-gradient-to-r from-indigo-500 to-purple-600 shadow rounded-lg p-6 text-white">
    <h2 class="text-2xl font-semibold mb-4">Explore</h2>
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <a href="/products" class="bg-white bg-opacity-20 hover:bg-opacity-30 rounded-lg p-4 text-center transition">
        <div class="text-2xl mb-2">📦</div>
        <div class="font-medium">Products</div>
      </a>
      <a href="/users" class="bg-white bg-opacity-20 hover:bg-opacity-30 rounded-lg p-4 text-center transition">
        <div class="text-2xl mb-2">👥</div>
        <div class="font-medium">Users</div>
      </a>
      <a href="/config" class="bg-white bg-opacity-20 hover:bg-opacity-30 rounded-lg p-4 text-center transition">
        <div class="text-2xl mb-2">⚙️</div>
        <div class="font-medium">Gateway Config</div>
      </a>
      <a href="/features" class="bg-white bg-opacity-20 hover:bg-opacity-30 rounded-lg p-4 text-center transition">
        <div class="text-2xl mb-2">🚀</div>
        <div class="font-medium">Test Features</div>
      </a>
    </div>
  </div>
</div>

<style>
  code {
    font-family: 'Courier New', monospace;
    font-size: 0.875em;
  }

  .text-4xl {
    font-size: 2.25rem;
    line-height: 2.5rem;
  }

  .text-2xl {
    font-size: 1.5rem;
    line-height: 2rem;
  }

  .text-lg {
    font-size: 1.125rem;
    line-height: 1.75rem;
  }

  .mb-2 {
    margin-bottom: 0.5rem;
  }

  .mb-4 {
    margin-bottom: 1rem;
  }

  .mb-8 {
    margin-bottom: 2rem;
  }

  .bg-blue-50 {
    background-color: #eff6ff;
  }

  .border-l-4 {
    border-left-width: 4px;
  }

  .border-blue-400 {
    border-color: #60a5fa;
  }

  .border-green-400 {
    border-color: #4ade80;
  }

  .p-4 {
    padding: 1rem;
  }

  .p-6 {
    padding: 1.5rem;
  }

  .h-5 {
    height: 1.25rem;
  }

  .w-5 {
    width: 1.25rem;
  }

  .text-blue-400 {
    color: #60a5fa;
  }

  .text-blue-700 {
    color: #1d4ed8;
  }

  .bg-blue-100 {
    background-color: #dbeafe;
  }

  .grid {
    display: grid;
  }

  .grid-cols-1 {
    grid-template-columns: repeat(1, minmax(0, 1fr));
  }

  .grid-cols-2 {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .gap-4 {
    gap: 1rem;
  }

  .gap-6 {
    gap: 1.5rem;
  }

  .shadow {
    box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  }

  .rounded-lg {
    border-radius: 0.5rem;
  }

  .space-y-2 > * + * {
    margin-top: 0.5rem;
  }

  .space-y-3 > * + * {
    margin-top: 0.75rem;
  }

  .ml-3 {
    margin-left: 0.75rem;
  }

  .mr-2 {
    margin-right: 0.5rem;
  }

  .pl-4 {
    padding-left: 1rem;
  }

  .px-1 {
    padding-left: 0.25rem;
    padding-right: 0.25rem;
  }

  .rounded {
    border-radius: 0.25rem;
  }

  .bg-gray-100 {
    background-color: #f3f4f6;
  }

  .bg-gradient-to-r {
    background-image: linear-gradient(to right, var(--tw-gradient-stops));
  }

  .from-indigo-500 {
    --tw-gradient-from: #6366f1;
    --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to, rgba(99, 102, 241, 0));
  }

  .to-purple-600 {
    --tw-gradient-to: #9333ea;
  }

  .bg-opacity-20 {
    --tw-bg-opacity: 0.2;
  }

  .bg-opacity-30 {
    --tw-bg-opacity: 0.3;
  }

  .hover\:bg-opacity-30:hover {
    --tw-bg-opacity: 0.3;
  }

  .transition {
    transition-property: background-color, border-color, color, fill, stroke, opacity, box-shadow, transform;
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
    transition-duration: 150ms;
  }

  @media (min-width: 768px) {
    .md\:grid-cols-2 {
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .md\:grid-cols-3 {
      grid-template-columns: repeat(3, minmax(0, 1fr));
    }

    .md\:grid-cols-4 {
      grid-template-columns: repeat(4, minmax(0, 1fr));
    }
  }
</style>
