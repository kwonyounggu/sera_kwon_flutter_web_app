# drkwon

A new Flutter project.

add a package in the project directory
>flutter pub add flutter_riverpod

######## how to build #######
#https://www.perplexity.ai/search/how-to-put-cache-control-no-ca-Chx_tfqkTsO28d2gS90B1g
#If you are using Flutter's default service worker (flutter_service_worker.js), it may cache assets #aggressively. You can disable it by building the app with the --pwa-strategy=none flag
>flutter clean
>flutter pub get
>flutter build web --pwa-strategy=none --release --base-href "/"