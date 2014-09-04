{:user
 {:dependencies [[clojure-complete "0.2.3"]
                 [org.clojure/tools.namespace "0.2.3"]]
  :injections [(require '(clojure.tools.namespace repl find))]
  :plugins [[lein-kibit "0.0.8"]
            [quickie "0.2.5"]
            [cider/cider-nrepl "0.7.0"]
            [lein-ancient "0.5.4"]
            [lein-try "0.4.1"]]}}
