# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
QuestTillDone::Application.config.secret_key_base = '4b1f076bb6b35495d124fecaa745530b1d32f2a00802b67a58479ae144ea19a356c18c13f69dda901767d9919d6e2d99fcf0581ead09f39410fa5c17ab42f6aa'
Gritter.rails_flash_fallback = true
