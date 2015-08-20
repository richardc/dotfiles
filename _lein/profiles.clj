;; update with: lein ancient profiles

{:user
 {:dependencies [[org.clojure/tools.nrepl "0.2.10" :exclusions [org.clojure/clojure]]]
  :plugins [[cider/cider-nrepl "0.9.1"]
            [lein-exec "0.3.5"]
            [lein-ancient "0.6.7"]
            [jonase/eastwood "0.2.1"]
            [lein-try "0.4.3"]]}}
