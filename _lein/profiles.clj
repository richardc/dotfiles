;; update with: lein ancient profiles

{:user
 {:dependencies [[clojure-complete "0.2.4"]
                 [org.clojure/tools.namespace "0.2.10"]]
  :injections [(require '(clojure.tools.namespace repl find))]
  :plugins [[lein-kibit "0.0.8"]
            [quickie "0.3.6"]
            [cider/cider-nrepl "0.9.0-SNAPSHOT"]
            [lein-ancient "0.6.5"]
            [lein-try "0.4.3"]]}}
