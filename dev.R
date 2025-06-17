library(icesTAF)

## https://github.com/ices-taf/doc/wiki

icesTAF::taf.skeleton()

citation("CREDO.utils")

icesTAF::draft.data()

## source = jonathan-rault/CREDO.utils@<<HASH_DU_COMMIT>>

icesTAF::taf.boot(force = TRUE)

## pour ne pas effacer
icesTAF::source.all(clean = FALSE)

## pour effacer
icesTAF::source.all(clean = TRUE)


## token test
icesConnect::set_username("jonathan.rault@ifremer.fr")
icesConnect:::token_set_from_keyring(my_token, "jonathan.rault@ifremer.fr") ### remark 3 ":" instead of 2
icesConnect::decode_token(formatted = FALSE)

# checks
icesConnect:::config_dir

# Define the API endpoint
url <- "https://api.example.com/protected-resource"

# Make the request with the Authorization header
response <- httr::GET(
  url,
  httr::add_headers(Authorization = paste("Bearer", my_token))
)

# Print response status and content
print(httr::status_code(response))
print(httr::content(response, as = "text", encoding = "UTF-8"))