#!/usr/bin/env ruby
# frozen_string_literal: true

require "net/http"
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
  "/assets/steak-stage-seasoned.jpg",
  "/assets/steak-stage-searing.jpg",
  "/assets/steak-stage-resting.jpg",
  "/assets/steak-stage-medium-rare.jpg",
  "/favicon.ico",
  "/robots.txt",
  "/sitemap.xml"
].freeze

def body_for_url(base_url, path)
  uri = URI.join(base_url.end_with?("/") ? base_url : "#{base_url}/", path.delete_prefix("/"))
  response = Net::HTTP.get_response(uri)
  unless response.code.to_i.between?(200, 299)
    raise "#{uri} returned #{response.code}"
  end
  response.body
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

base_url = ARGV.first

ROUTES.each do |route|
  body = base_url ? body_for_url(base_url, route.path) : body_for_file(route)
  assert_markers!(route, body)
  puts "ok #{base_url ? "url" : "file"} #{route.path}"
end

if base_url
  ASSET_ROUTES.each do |path|
    body_for_url(base_url, path)
    puts "ok url #{path}"
  end
else
  check_asset_files!
end

puts "mysli.network public route smoke check passed"
