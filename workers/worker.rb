require './app'
require 'sidekiq'
require_relative 'reports_worker'
require_relative 'broadcast_worker'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://192.168.99.100:6379" }
end

def symbolize_keys_deep!(h)
  h.keys.each do |k|
    ks    = k.respond_to?(:to_sym) ? k.to_sym : k
    h[ks] = h.delete k # Preserve order even when k == ks
    symbolize_keys_deep! h[ks] if h[ks].kind_of? Hash
  end
end
