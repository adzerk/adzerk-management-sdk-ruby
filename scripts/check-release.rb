#!/usr/bin/env ruby
# frozen_string_literal: true

# Check Release Script
#
# Usage:
#   ruby scripts/check-release.rb BASE_REF    (for example: ruby scripts/check-release.rb origin/master)
#
# This script compares the version in lib/adzerk/version.rb with the version on BASE_REF.
# If the version changed, it makes sure that the change has everything that
# scripts/create-release.rb adds:
# 1. The new version is a valid X.Y version, and it is higher than the base version
# 2. Gemfile.lock has the new version
# 3. CHANGELOG.md starts with a non-empty entry for the new version
#
# The Release Check workflow runs this script on each PR to master. When the version change
# passes the checks, the script writes release_version and base_version to $GITHUB_OUTPUT.
# The workflow uses these values to comment on the PR.

require "open3"

$stdout.sync = true

ROOT = File.expand_path("..", __dir__)
VERSION_PATH = "lib/adzerk/version.rb"
VERSION_PATTERN = /^\s*VERSION\s*=\s*"([^"]+)"/
LOCKFILE_PATTERN = /^    adzerk \(([^)]+)\)$/
FIX_HINT = "Run `ruby scripts/create-release.rb` and follow RELEASE.md → Deployment."

def git(*args)
  output, error, status = Open3.capture3("git", *args, chdir: ROOT)
  raise error.strip unless status.success?

  output.strip
end

def read(path)
  File.read(File.join(ROOT, path))
end

# Compare with the merge base, not with the tip of the ref. A local branch that is behind
# master must not fail because master got a release. In CI, HEAD is the PR merge commit,
# so the merge base is the tip of the base branch.
def read_base_version(ref)
  merge_base = git("merge-base", "HEAD", ref)
  git("show", "#{merge_base}:#{VERSION_PATH}")[VERSION_PATTERN, 1]
rescue RuntimeError => e
  warn "❌ Cannot read #{VERSION_PATH} on #{ref}. Make sure that the ref exists (git fetch)."
  warn e.message
  exit 1
end

def valid_version?(version)
  /\A\d+\.\d+\z/.match?(version.to_s)
end

def check_version(version, base_version, base_ref)
  return [%(#{VERSION_PATH} version "#{version}" is not a valid X.Y version.)] unless valid_version?(version)
  return [] unless valid_version?(base_version)
  return [] if Gem::Version.new(version) > Gem::Version.new(base_version)

  ["#{VERSION_PATH} version #{version} is not higher than #{base_version} on #{base_ref}."]
end

def check_lockfile(version)
  locked_version = read("Gemfile.lock")[LOCKFILE_PATTERN, 1]
  return [] if locked_version == version

  ["Gemfile.lock has adzerk (#{locked_version || "no version"}), but #{VERSION_PATH} has #{version}."]
end

def check_changelog(version)
  sections = read("CHANGELOG.md").split(/^(?=## )/).select { |section| section.start_with?("## ") }
  heading = "## [#{version}]"

  return [%(CHANGELOG.md does not start with a "#{heading}" entry.)] unless sections.first&.start_with?(heading)

  errors = []
  if sections.first.lines.drop(1).join.strip.empty?
    errors << %(The "#{heading}" entry in CHANGELOG.md is empty.)
  end
  duplicates = sections.count { |section| section.start_with?(heading) }
  errors << %(CHANGELOG.md has #{duplicates} "#{heading}" entries. Keep only one.) if duplicates > 1
  errors
end

def write_github_output(outputs)
  return unless ENV["GITHUB_OUTPUT"]

  File.open(ENV["GITHUB_OUTPUT"], "a") do |file|
    outputs.each { |key, value| file.puts("#{key}=#{value}") }
  end
end

def main
  base_ref = ARGV[0]
  unless base_ref
    warn "❌ Missing base ref. Usage: ruby scripts/check-release.rb BASE_REF (for example: origin/master)"
    exit 1
  end

  version = read(VERSION_PATH)[VERSION_PATTERN, 1]
  base_version = read_base_version(base_ref)

  if version == base_version
    puts "✅ Version unchanged (#{version}), no release checks needed."
    return
  end

  puts "📈 Version changed: #{base_version} (#{base_ref}) → #{version}\n\n"

  errors = check_version(version, base_version, base_ref) + check_lockfile(version) + check_changelog(version)
  unless errors.empty?
    errors.each { |error| warn "❌ #{error}" }
    warn "\n#{FIX_HINT}"
    exit 1
  end

  puts "✅ #{VERSION_PATH}, Gemfile.lock and CHANGELOG.md are ready for release."
  write_github_output(release_version: version, base_version: base_version)
end

main
