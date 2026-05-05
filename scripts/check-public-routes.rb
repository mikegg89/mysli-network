#!/usr/bin/env ruby
# frozen_string_literal: true

require "net/http"
require "json"
require "pathname"
require "uri"

ROOT = Pathname.new(__dir__).join("..").expand_path
PUBLIC_DIR = ROOT.join("public")

Route = Struct.new(:path, :file, :markers, keyword_init: true)

ROUTES = [
  Route.new(
    path: "/",
    file: "index.html",
    markers: [
      "MySLI is in the pan",
      "let it cook",
      "human sign language interpreting",
      "state eligibility",
      "corporate ADA QR billing",
      "Current cook stage: cooking",
      "I need an interpreter",
      "I am an interpreter",
      "I represent an organization",
      "the Deaf person is not charged",
      "The John Claire Woolsey Foundation",
      "50% of net platform profits",
      "Grant amounts are driven by quarterly fund size",
      "No AI interpretation",
      "No call recordings",
      "No transcripts",
      "steak-stage-searing.jpg"
    ]
  ),
  Route.new(
    path: "/privacy/",
    file: "privacy/index.html",
    markers: [
      "Privacy Policy",
      "does not record video calls",
      "Stripe",
      "privacy@mysli.network"
    ]
  ),
  Route.new(
    path: "/early-access/",
    file: "early-access/index.html",
    markers: [
      "Request MySLI early access",
      "I need an interpreter",
      "I am an interpreter",
      "I represent an organization",
      "no sensitive details",
      "submitEarlyAccessLead"
    ]
  ),
  Route.new(
    path: "/terms/",
    file: "terms/index.html",
    markers: [
      "Terms of Service",
      "human sign language interpreting",
      "Interpreter eligibility",
      "No emergency services"
    ]
  ),
  Route.new(
    path: "/support/",
    file: "support/index.html",
    markers: [
      "Support",
      "support@mysli.network",
      "billing@mysli.network",
      "credentials@mysli.network",
      "Do not include medical diagnosis"
    ]
  ),
  Route.new(
    path: "/stripe-connect/return/",
    file: "stripe-connect/return/index.html",
    markers: [
      "Payout setup returned to MySLI",
      "Refresh Payout Status",
      "Open MySLI Staging",
      "mysli-staging://stripe-connect/return"
    ]
  ),
  Route.new(
    path: "/stripe-connect/refresh/",
    file: "stripe-connect/refresh/index.html",
    markers: [
      "Continue payout setup in MySLI",
      "Set Up Payouts",
      "Open MySLI Staging",
      "mysli-staging://stripe-connect/refresh"
    ]
  ),
  Route.new(
    path: "/identity-verification/",
    file: "identity-verification/index.html",
    markers: [
      "Identity verification returned to MySLI",
      "Open MySLI Staging",
      "mysli-staging://identity-verification",
      "support@mysli.network",
      "not raw driver's license images"
    ]
  ),
  Route.new(
    path: "/account-deletion/",
    file: "account-deletion/index.html",
    markers: [
      "Account deletion",
      "Delete MySLI Account",
      "privacy@mysli.network",
      "legal, safety, tax"
    ]
  ),
  Route.new(
    path: "/contact/",
    file: "contact/index.html",
    markers: [
      "Reach MySLI",
      "support@mysli.network",
      "safety@mysli.network",
      "accessibility@mysli.network"
    ]
  ),
  Route.new(
    path: "/accessibility/",
    file: "accessibility/index.html",
    markers: [
      "Accessibility commitment",
      "Deaf community first",
      "VoiceOver-friendly",
      "accessibility@mysli.network"
    ]
  )
].freeze

ASSET_ROUTES = [
  "/.well-known/apple-app-site-association",
  "/assets/steak-stage-seasoned.jpg",
  "/assets/steak-stage-searing.jpg",
  "/assets/steak-stage-resting.jpg",
  "/assets/steak-stage-medium-rare.jpg",
  "/early-access.js",
  "/favicon.ico",
  "/robots.txt",
  "/sitemap.xml"
].freeze

UNIVERSAL_LINK_MARKERS = [
  "SW9DHVDGY8.mysli.network.app",
  "SW9DHVDGY8.mysli.network.app.staging",
  "/qr*",
  "/corporate/*",
  "/payer/*",
  "/identity-verification*",
  "/interpreter/referral*",
  "/stripe-connect*"
].freeze

def body_for_url(base_url, path)
  uri = URI.join(base_url.end_with?("/") ? base_url : "#{base_url}/", path.delete_prefix("/"))
  response = Net::HTTP.get_response(uri)
  unless response.code.to_i.between?(200, 299)
    raise "#{uri} returned #{response.code}"
  end
  if namecheap_parking?(response.body)
    raise "#{uri} is still serving the Namecheap parking page. Update the domain DNS/Netlify custom-domain records, then rerun this check after propagation."
  end
  response.body
end

def namecheap_parking?(body)
  body.include?("Namecheap Parking Page") || body.include?("/nc_assets/")
end

def body_for_file(route)
  file_path = PUBLIC_DIR.join(route.file)
  raise "#{file_path} is missing" unless file_path.file?

  file_path.read
end

def assert_markers!(route, body)
  route.markers.each do |marker|
    raise "#{route.path} is missing required marker: #{marker.inspect}" unless body.include?(marker)
  end
end

def check_asset_files!
  ASSET_ROUTES.each do |path|
    asset = PUBLIC_DIR.join(path.delete_prefix("/"))
    raise "#{asset} is missing" unless asset.file?
    raise "#{asset} is empty" if asset.size.zero?
    puts "ok file #{path}"
  end
end

def check_universal_links!(body)
  JSON.parse(body)
  UNIVERSAL_LINK_MARKERS.each do |marker|
    raise "/.well-known/apple-app-site-association is missing required marker: #{marker.inspect}" unless body.include?(marker)
  end
end

base_url = ARGV.first

ROUTES.each do |route|
  body = base_url ? body_for_url(base_url, route.path) : body_for_file(route)
  assert_markers!(route, body)
  puts "ok #{base_url ? "url" : "file"} #{route.path}"
end

if base_url
  ASSET_ROUTES.each do |path|
    body = body_for_url(base_url, path)
    check_universal_links!(body) if path == "/.well-known/apple-app-site-association"
    puts "ok url #{path}"
  end
else
  check_asset_files!
  check_universal_links!(PUBLIC_DIR.join(".well-known/apple-app-site-association").read)
end

puts "mysli.network public route smoke check passed"
