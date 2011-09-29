# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_layout_ex_session',
  :secret      => '114b28a8abc47dc002ef1d553d73c99cefa124c9342bb60bcac4c3d9b5533d8242dfdfbff2032208d018f0664afd39b3276769ec2b278ee1fca5fd7b4f66a689'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
