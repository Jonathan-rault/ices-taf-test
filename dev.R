library(icesTAF)

## https://github.com/ices-taf/doc/wiki

icesTAF::taf.skeleton()

citation("CREDO.utils")

## source = jonathan-rault/CREDO.utils@<<HASH_DU_COMMIT>>

icesTAF::taf.boot(force = TRUE)

## pour ne pas effacer
icesTAF::source.all(clean = FALSE)

## pour effacer
icesTAF::source.all(clean = TRUE)