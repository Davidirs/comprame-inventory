'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "f02830a293d0f6914f9306dcd24bea61",
"assets/AssetManifest.bin.json": "02b3dfef106c247db68a20bb28945ac9",
"assets/AssetManifest.json": "94a67aac79a172aa8a983940d3bcdb73",
"assets/assets/fonts/Roboto-Bold.ttf": "e07df86cef2e721115583d61d1fb68a6",
"assets/assets/fonts/Roboto-Medium.ttf": "58aef543c97bbaf6a9896e8484456d98",
"assets/assets/fonts/Roboto-Regular.ttf": "11eabca2251325cfc5589c9c6fb57b46",
"assets/assets/fonts/WorkSans-Bold.ttf": "1fed2d8028f8f5356cbecedb03427405",
"assets/assets/fonts/WorkSans-Medium.ttf": "488b6f72b6183415e7a20aafa803a0c8",
"assets/assets/fonts/WorkSans-Regular.ttf": "30be604d29fd477c201fb1d6e668eaeb",
"assets/assets/fonts/WorkSans-SemiBold.ttf": "6f8da6d25c25d58ef3ec1c8b7c0e69c3",
"assets/assets/images/database.png": "59a142e78990dc27c41250d6b0be0e57",
"assets/assets/images/feedbackImage.jpg": "6ffd10385faa8a4bbc28dd660b11d074",
"assets/assets/images/feedbackImage.png": "5f8e9064f54cf51a70fee2da78a5b014",
"assets/assets/images/google.png": "8a8750564e7b137088af03f0452bb449",
"assets/assets/images/helpImage.jpg": "e658c75f2b4a941391cd7859105d90e1",
"assets/assets/images/helpImage.png": "2bff0fc93675d32f89db50f2d3e2a5b1",
"assets/assets/images/inviteImage.jpg": "704ed2b53bf8b51d3f0872e668420405",
"assets/assets/images/inviteImage.png": "4d337cf829c67258aa3aae385f5ec31c",
"assets/assets/images/login.jpg": "131cf2cc374b2470f57004545d1bcc37",
"assets/assets/images/shopme.png": "29a3b0b91269e5051e95a4fb6bdb5529",
"assets/assets/images/supportIcon.png": "2eb21b9823a538c996ec667e17388322",
"assets/assets/images/userImage.jpg": "aad8fffaa94d67db126ed8790c8644b8",
"assets/assets/images/userImage.png": "f2bb51f7c32f93c3433749ed79fc81cb",
"assets/assets/img/any.png": "4942771a4c00c3b943a2a3f45ae83e21",
"assets/assets/img/area1.png": "9cbfec64c29ec6821547f1c5093f38b7",
"assets/assets/img/area2.png": "2863c486c15808e8f105ccac2febfdbc",
"assets/assets/img/area3.png": "e85a8d2207edfb0325369d93982fba03",
"assets/assets/img/back.png": "af6b0e6121d6eb48289cce3a3b8d8963",
"assets/assets/img/bell.png": "929723572aa737a354244ca14fe5659b",
"assets/assets/img/bottle.png": "840d3c89291f9d3b0a859d7479c10d0c",
"assets/assets/img/breakfast.png": "1d2b0e6a7e46a44723131c663471f811",
"assets/assets/img/burned.png": "2ffad4b8dff525e57473142f0265b6bd",
"assets/assets/img/card.png": "c220ded1b8b6ca535e7df54ad9b39c00",
"assets/assets/img/cash.png": "9d1e013d6b2b62f7b3f8a294491abbd2",
"assets/assets/img/dinner.png": "d61779f47b560d09b0df15b346323ac4",
"assets/assets/img/eaten.png": "3f7d6f5aea8996d15d52c4c2268abd45",
"assets/assets/img/fitness_app.png": "bd55b7dc68210a0a5e6fa9341a47dbaf",
"assets/assets/img/glass.png": "266bca612c726abd6e481a4d890cef8e",
"assets/assets/img/great.jpg": "5e8fb90d7becec39648e581d954a4504",
"assets/assets/img/great.png": "8feadf4cd2794272ab4b27ffd66279e7",
"assets/assets/img/logo.png": "96810c93a06c80e52eb1d1f1cea1a05a",
"assets/assets/img/lunch.png": "6855159f38835c1f03289b102a2e8b52",
"assets/assets/img/movil.png": "1f417720a706a933af2d46e4b482c6e3",
"assets/assets/img/placeholder.png": "9f66f060031f801185eb35001cfbbd9d",
"assets/assets/img/placeholders.png": "93a4ecb5de3200d99d88f414be57a960",
"assets/assets/img/runner.png": "efb26bd46e91d305bda3b4b3c5a57c54",
"assets/assets/img/snack.png": "14a3e91c7a517b0a2f71dbcd86d2104d",
"assets/assets/img/tab_1.png": "b2a5f1ed83ceb8b194cd162bf1ae7b81",
"assets/assets/img/tab_1s.png": "7d14dae8755b3ba6465cc4100faf9130",
"assets/assets/img/tab_2.png": "5b7224852ee54c400e4ac3d8912c5209",
"assets/assets/img/tab_2s.png": "e17f599b36599217cef7af9a2ef7b27a",
"assets/assets/img/tab_3.png": "2939c0ab38fe43b6244304d593c2f1b4",
"assets/assets/img/tab_3s.png": "0e1e6b2987f99fc08355db419408363f",
"assets/assets/img/tab_4.png": "363050b7417636940303062a213ef26d",
"assets/assets/img/tab_4s.png": "03bf4ba0dc46a4cdeec41cdc30606067",
"assets/assets/introduction_animation/care_image.png": "ae631d1aa45674248e581ccd6f34067e",
"assets/assets/introduction_animation/introduction_animation.png": "309f80cbbe9ba84d2d643677c7853907",
"assets/assets/introduction_animation/introduction_image.png": "30421757bb57eab3439354f4dc4e31c2",
"assets/assets/introduction_animation/introduction_image1.png": "307c773d181ceeb899559add51c7acb4",
"assets/assets/introduction_animation/mood_dairy_image.png": "d6e7c7f4c210a5f2e0f468767e2b4344",
"assets/assets/introduction_animation/relax_image.png": "05d1133baf6082b8dd1edbd4495769cd",
"assets/assets/introduction_animation/welcome.png": "62ee1aa32560e9c63a2017424019528b",
"assets/FontManifest.json": "92d40a44a40733d060286a8973a3bd6c",
"assets/fonts/MaterialIcons-Regular.otf": "fc5d6be55e192e92790e59f5d6c67491",
"assets/NOTICES": "26f9d4c781a05a6c7cc1a541faf5b02a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "5ac99533bd9dc46227434b4853c3e532",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "093d2cde7075fcffb24ab215668d0da2",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "1e17b1ec3152f29bf783bd42db8b6023",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "15f5fa30677b2679ef8e00e634e7636f",
"/": "15f5fa30677b2679ef8e00e634e7636f",
"main.dart.js": "4fca951bd5fd8b301fad4543ca1dfe6b",
"manifest.json": "013168548553bd3af1f62bab13ca7358",
"splash/img/dark-1x.png": "20f9ba5456e294f018513037b9410742",
"splash/img/dark-2x.png": "e6c64b9457169d6346e2aa3ae7453443",
"splash/img/dark-3x.png": "24386166e5321b98b8a827a4b264d307",
"splash/img/dark-4x.png": "81a2dd6961df4217d9d646613041092a",
"splash/img/light-1x.png": "20f9ba5456e294f018513037b9410742",
"splash/img/light-2x.png": "e6c64b9457169d6346e2aa3ae7453443",
"splash/img/light-3x.png": "24386166e5321b98b8a827a4b264d307",
"splash/img/light-4x.png": "81a2dd6961df4217d9d646613041092a",
"version.json": "39e49fe9d60884959b2229addf1440ba"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
