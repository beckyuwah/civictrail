const CACHE_NAME = "civictrail-v1";
const STATIC_ASSETS = [
  "/",
  "/static/manifest.webmanifest",
  "/static/icons/web-app-manifest-192x192.png",
  "/static/icons/web-app-manifest-512x512.png",
  // Add other static assets you want to cache
  "/static/css/styles.css",
  "/static/js/main.js",
  // Add more assets as needed  
  "/offline/",
];

// Install
self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(STATIC_ASSETS))
  );
});

// Fetch (NETWORK FIRST for auth)
self.addEventListener("fetch", event => {
  const url = new URL(event.request.url);

  // Never cache auth or admin
  if (
    url.pathname.startsWith("/login") ||
    url.pathname.startsWith("/logout") ||
    url.pathname.startsWith("/admin")
  ) {
    return;
  }

  event.respondWith(
    fetch(event.request)
      .then(response => {
        const copy = response.clone();
        caches.open(CACHE_NAME).then(cache => cache.put(event.request, copy));
        return response;
      })
      .catch(() => caches.match(event.request))
  );
});
/* const CACHE_NAME = "civictrail-v1";
const URLS_TO_CACHE = [
  "/",
  "/login/",
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(URLS_TO_CACHE);
    })
  );
});

self.addEventListener("fetch", event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      return response || fetch(event.request);
    })
  );
});
self.addEventListener("activate", event => {
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (!cacheWhitelist.includes(cacheName)) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
}); */