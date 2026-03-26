// service-worker.js
self.addEventListener('install', (event) => {
  console.log('Service Worker installed');
});

self.addEventListener('activate', (event) => {
  console.log('Service Worker activated');
});

// Intercept fetch requests and handle GPS data sync in the background
self.addEventListener('fetch', function(event) {
  if (event.request.url.includes('/gps_api/insert')) {
    event.respondWith(
      fetch(event.request).catch(() => {
        // If offline, store the request in cache
        return caches.match(event.request);
      })
    );
  }
});

// Listen for Push events (for syncing background data)
self.addEventListener('push', function(event) {
  console.log('Push message received', event.data.text());
  // Handle background sync
});
