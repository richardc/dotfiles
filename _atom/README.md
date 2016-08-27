packages.list managed by hand.

To populate:

    apm list --packages --bare --installed > packages.list

To load:

    apm install --packages-file packages.list
