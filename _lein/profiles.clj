;; update with: lein ancient profiles

{:user
 {:dependencies [[clojure-complete "0.2.4"]
                 [org.clojure/tools.namespace "0.2.10"]
                 [spyscope "0.1.5"]]
  :injections [(require '(clojure.tools.namespace repl find))
               (require 'spyscope.core)]
  :plugins [[lein-exec "0.3.4"]
            [cider/cider-nrepl "0.9.0-SNAPSHOT"]
            [lein-ancient "0.6.5"]
            [lein-try "0.4.3"]]}}
