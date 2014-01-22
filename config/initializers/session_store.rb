# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_storyteller_session',
  :secret      => 'a9a641d56d98ce186bd4318ddca48cbf8acee2f4329fbd5d2acaa052ff48e2eb24b3aa24817fac61f49f2a3194c8f0683d67829acb4f5f3bacae2a4a96b3f83f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
