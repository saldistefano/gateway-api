<div class="px-4 py-6">
  <div class="mb-6">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">Envoy Gateway Configuration</h1>
    <p class="text-gray-600">View and learn about the Envoy Gateway configuration for this deployment</p>
  </div>

  <!-- Gateway Overview -->
  <div class="bg-white shadow rounded-lg p-6 mb-6">
    <h2 class="text-2xl font-semibold text-gray-900 mb-4">Gateway: eg</h2>
    <p class="text-gray-600 mb-4">
      The main gateway accepting HTTP traffic for this deployment
    </p>

    <div class="bg-gray-50 p-4 rounded-md">
      <p class="text-sm font-semibold text-gray-700 mb-2">View live configuration:</p>
      <code class="text-sm bg-gray-900 text-gray-100 p-3 rounded block overflow-x-auto">
        kubectl get gateway eg -n envoy-testing -o yaml
      </code>
    </div>

    <div class="mt-4 grid grid-cols-1 md:grid-cols-2 gap-4">
      <div class="border border-gray-200 rounded-md p-4">
        <h3 class="font-semibold text-gray-900 mb-2">Namespace</h3>
        <p class="text-gray-600">envoy-testing</p>
      </div>
      <div class="border border-gray-200 rounded-md p-4">
        <h3 class="font-semibold text-gray-900 mb-2">Gateway Class</h3>
        <p class="text-gray-600">eg</p>
      </div>
    </div>
  </div>

  <!-- HTTPRoutes -->
  <div class="bg-white shadow rounded-lg p-6 mb-6">
    <h2 class="text-2xl font-semibold text-gray-900 mb-4">HTTPRoutes</h2>

    <div class="space-y-4">
      <div class="border-l-4 border-green-500 bg-green-50 p-4">
        <h3 class="font-semibold text-gray-900">simple-api</h3>
        <p class="text-sm text-gray-600 mt-1">Routes traffic from <code class="bg-white px-2 py-1 rounded">api.local</code> to the simple-api service</p>
        <div class="mt-3 bg-gray-900 text-gray-100 p-3 rounded text-sm overflow-x-auto">
          <pre>kubectl get httproute simple-api -n simple-api -o yaml</pre>
        </div>
        <div class="mt-2">
          <p class="text-xs text-gray-500">Namespace: simple-api</p>
          <p class="text-xs text-gray-500">Backend Service: simple-api:80</p>
        </div>
      </div>

      <div class="border-l-4 border-blue-500 bg-blue-50 p-4">
        <h3 class="font-semibold text-gray-900">simple-web</h3>
        <p class="text-sm text-gray-600 mt-1">Routes traffic from <code class="bg-white px-2 py-1 rounded">web.local</code> to this web application</p>
        <div class="mt-3 bg-gray-900 text-gray-100 p-3 rounded text-sm overflow-x-auto">
          <pre>kubectl get httproute simple-web -n simple-web -o yaml</pre>
        </div>
        <div class="mt-2">
          <p class="text-xs text-gray-500">Namespace: simple-web</p>
          <p class="text-xs text-gray-500">Backend Service: simple-web:80</p>
        </div>
      </div>
    </div>
  </div>

  <!-- Configuration Files -->
  <div class="bg-white shadow rounded-lg p-6 mb-6">
    <h2 class="text-2xl font-semibold text-gray-900 mb-4">Configuration Files</h2>
    <p class="text-gray-600 mb-4">
      The Kubernetes manifests and Helm charts used to deploy these services
    </p>

    <div class="space-y-3">
      <div class="flex items-center justify-between p-3 bg-gray-50 rounded-md">
        <div>
          <p class="font-medium text-gray-900">simple-api Helm Chart</p>
          <p class="text-sm text-gray-600">apps/simple-api/k8s/helm/</p>
        </div>
        <a href="https://github.com" target="_blank" class="text-indigo-600 hover:text-indigo-700 text-sm">View →</a>
      </div>

      <div class="flex items-center justify-between p-3 bg-gray-50 rounded-md">
        <div>
          <p class="font-medium text-gray-900">simple-web Helm Chart</p>
          <p class="text-sm text-gray-600">apps/simple-web/k8s/helm/</p>
        </div>
        <a href="https://github.com" target="_blank" class="text-indigo-600 hover:text-indigo-700 text-sm">View →</a>
      </div>

      <div class="flex items-center justify-between p-3 bg-gray-50 rounded-md">
        <div>
          <p class="font-medium text-gray-900">HTTPRoute Manifests</p>
          <p class="text-sm text-gray-600">k8s/httproute.yaml</p>
        </div>
        <a href="https://github.com" target="_blank" class="text-indigo-600 hover:text-indigo-700 text-sm">View →</a>
      </div>
    </div>
  </div>

  <!-- Useful Commands -->
  <div class="bg-indigo-50 border border-indigo-200 rounded-lg p-6">
    <h2 class="text-2xl font-semibold text-indigo-900 mb-4">Useful Commands</h2>
    <div class="space-y-3">
      <div>
        <p class="text-sm font-semibold text-indigo-900 mb-1">List all gateways</p>
        <code class="block bg-gray-900 text-gray-100 p-2 rounded text-sm">kubectl get gateways --all-namespaces</code>
      </div>
      <div>
        <p class="text-sm font-semibold text-indigo-900 mb-1">List all HTTPRoutes</p>
        <code class="block bg-gray-900 text-gray-100 p-2 rounded text-sm">kubectl get httproutes --all-namespaces</code>
      </div>
      <div>
        <p class="text-sm font-semibold text-indigo-900 mb-1">Describe gateway</p>
        <code class="block bg-gray-900 text-gray-100 p-2 rounded text-sm">kubectl describe gateway eg -n envoy-testing</code>
      </div>
      <div>
        <p class="text-sm font-semibold text-indigo-900 mb-1">Get Envoy Gateway pods</p>
        <code class="block bg-gray-900 text-gray-100 p-2 rounded text-sm">kubectl get pods -n envoy-gateway-system</code>
      </div>
    </div>
  </div>
</div>

<style>
  code {
    font-family: 'Courier New', monospace;
  }

  pre {
    margin: 0;
    font-family: 'Courier New', monospace;
  }

  .border-green-500 {
    border-color: #22c55e;
  }

  .bg-green-50 {
    background-color: #f0fdf4;
  }

  .border-blue-500 {
    border-color: #3b82f6;
  }

  .bg-blue-50 {
    background-color: #eff6ff;
  }

  .bg-indigo-50 {
    background-color: #eef2ff;
  }

  .border-indigo-200 {
    border-color: #c7d2fe;
  }

  .text-indigo-900 {
    color: #312e81;
  }

  .bg-gray-900 {
    background-color: #111827;
  }

  .text-gray-100 {
    color: #f3f4f6;
  }

  .overflow-x-auto {
    overflow-x: auto;
  }

  .space-y-3 > * + * {
    margin-top: 0.75rem;
  }

  .space-y-4 > * + * {
    margin-top: 1rem;
  }

  .py-1 {
    padding-top: 0.25rem;
    padding-bottom: 0.25rem;
  }

  .px-2 {
    padding-left: 0.5rem;
    padding-right: 0.5rem;
  }

  .p-3 {
    padding: 0.75rem;
  }

  .mt-3 {
    margin-top: 0.75rem;
  }

  .mb-1 {
    margin-bottom: 0.25rem;
  }

  .text-xs {
    font-size: 0.75rem;
    line-height: 1rem;
  }

  .border-gray-200 {
    border-color: #e5e7eb;
  }
</style>
