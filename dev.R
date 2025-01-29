library(icesTAF)

## https://github.com/ices-taf/doc/wiki

icesTAF::taf.skeleton()

citation("CREDO.utils")

## source = jonathan-rault/CREDO.utils@<<HASH_DU_COMMIT>>

icesTAF::taf.boot(force = TRUE)

## va effacer les autres stocks :(
icesTAF::source.all(clean = FALSE)