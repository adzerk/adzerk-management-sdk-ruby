#!/usr/bin/env ruby
# frozen_string_literal: true

# Create Release Script
#
# Usage:
#   ruby scripts/create-release.rb          (asks for the release type)
#   ruby scripts/create-release.rb TYPE     (TYPE is minor or major)
#
# This script:
# 1. Fetches origin/master and stops if the working tree has changes or HEAD is not
#    origin/master
# 2. Asks for the release type, if you do not give it
# 3. Shows the version change and asks for a confirmation
# 4. Writes the new version to lib/adzerk/version.rb and Gemfile.lock
# 5. Adds a CHANGELOG.md entry for the new version. The entry gets the notes from the
#    "## Unreleased" section and the pull requests and commits that merged to master after
#    the last tag.
#
# The script does not commit or tag. Review the changes and open a PR to master.
# When the PR merges, the Publish Gem workflow publishes the gem. See RELEASE.md.

require "date"
require "open3"

ROOT = File.expand_path("..", __dir__)
VERSION_FILE = File.join(ROOT, "lib/adzerk/version.rb")
LOCKFILE = File.join(ROOT, "Gemfile.lock")
CHANGELOG = File.join(ROOT, "CHANGELOG.md")

VERSION_PATTERN = /^(\s*VERSION\s*=\s*")([^"]+)(")/
LOCKFILE_PATTERN = /^(    adzerk \()([^)]+)(\))$/
RELEASE_TYPES = %w[minor major].freeze

def abort_with(message)
  warn "❌ #{message}"
  exit 1
end

# Returns the output of the git command, or nil if the command fails.
def git(*args)
  output, status = Open3.capture2("git", *args, chdir: ROOT, err: File::NULL)
  status.success? ? output.strip : nil
end

def ask(question)
  print question
  ($stdin.gets || "").strip
end

def ask_release_type
  puts "\n📦 Select the release type:\n\n"
  puts "  1. minor  - Bug fixes, dependency updates, new features (0.X)"
  puts "  2. major  - Breaking changes (X.0)"
  puts

  answer = ask("Enter your choice (1/2 or minor/major): ").downcase
  return "minor" if %w[1 minor].include?(answer)
  return "major" if %w[2 major].include?(answer)

  abort_with("Invalid choice. Run the script again.")
end

def current_version
  version = File.read(VERSION_FILE)[VERSION_PATTERN, 2]
  abort_with("Cannot find VERSION in lib/adzerk/version.rb.") unless version
  version
end

# Versions have two parts: 0.31 -> 0.32 (minor) or 1.0 (major).
def next_version(version, type)
  match = /\A(\d+)\.(\d+)\z/.match(version)
  abort_with("Version #{version} is not a valid X.Y version.") unless match

  major = match[1].to_i
  minor = match[2].to_i
  type == "major" ? "#{major + 1}.0" : "#{major}.#{minor + 1}"
end

def replace_version(path, pattern, version)
  content = File.read(path)
  abort_with("Cannot find the adzerk version in #{File.basename(path)}.") unless content.match?(pattern)

  File.write(path, content.sub(pattern) { "#{Regexp.last_match(1)}#{version}#{Regexp.last_match(3)}" })
end

# Lists the commits on the master line after the tag. A merge commit is shown as its PR. A
# squash merge ("Title (#123)") or a rebased or pushed commit is shown by its subject.
def merged_pull_requests(tag)
  range = tag ? ["#{tag}..HEAD"] : []
  output = git("log", *range, "--first-parent", "--pretty=format:%h%x1f%s%x1f%b%x1e")
  return [] if output.nil? || output.empty?

  output.split("\x1e").map(&:strip).reject(&:empty?).map do |commit|
    hash, subject, body = commit.split("\x1f", 3).map { |part| part.to_s.strip }
    match = %r{\AMerge pull request #(\d+) from [^/]+/(.+)\z}i.match(subject)
    unless match
      squash = /\A(.+?)\s*\(#(\d+)\)\z/.match(subject)
      next squash ? "#{squash[1]} (##{squash[2]}, #{hash})" : "#{subject} (#{hash})"
    end

    number = match[1]
    branch = match[2]

    # The PR title is the first line of the merge commit body. If there is no body, make a
    # title from the branch name: "mgmt-123-fix-the-thing" -> "Fix The Thing".
    title = body.lines.map(&:strip).find { |line| !line.empty? }
    title ||= branch.sub(/\A[a-z]+-\d+-/i, "").tr("-_", "  ").split.map(&:capitalize).join(" ")
    title.empty? ? "##{number} (#{hash})" : "#{title} (##{number}, #{hash})"
  end
end

# Returns true if the new entry has no notes.
def update_changelog(version)
  tag = git("describe", "--tags", "--abbrev=0")
  puts(tag ? "Last tag: #{tag}" : "No tag found. The script uses all of the history.")

  pull_requests = merged_pull_requests(tag)
  puts "Found #{pull_requests.length} merged pull request(s)."

  content = File.exist?(CHANGELOG) ? File.read(CHANGELOG) : "# CHANGELOG\n"
  header, *sections = content.split(/^(?=## )/)
  if header.start_with?("## ")
    sections.unshift(header)
    header = "# CHANGELOG\n"
  end

  # Move the notes from "## Unreleased" into the new entry.
  unreleased = sections.first&.match(/\A## Unreleased[^\n]*\n(.*)\z/mi)
  notes = unreleased ? unreleased[1].strip : ""
  sections.shift if unreleased

  # The subheading keeps the list apart from notes that end in a list of their own.
  pull_request_list = ""
  unless pull_requests.empty?
    pull_request_list = "### Pull requests\n\n#{pull_requests.map { |pull_request| "- #{pull_request}" }.join("\n")}"
  end
  body = [notes, pull_request_list].reject(&:empty?).join("\n\n")

  entry = "## [#{version}] - #{Date.today.iso8601}\n\n"
  entry += "#{body}\n\n" unless body.empty?

  File.write(CHANGELOG, "#{header.rstrip}\n\n#{entry}#{sections.join}".rstrip + "\n")
  body.empty?
end

# The changelog lists the PRs on HEAD, so HEAD must be the latest master.
def ensure_up_to_date_master
  puts "🔄 Fetching origin/master..."
  abort_with("Cannot fetch origin/master.") unless git("fetch", "origin", "master")

  status = git("status", "--porcelain")
  abort_with("Cannot read the git status.") if status.nil?
  abort_with("The working tree has changes. Commit or stash them first.") unless status.empty?

  head = git("rev-parse", "HEAD")
  master = git("rev-parse", "origin/master")
  return if head && head == master

  abort_with("HEAD is not origin/master. Run the script on an up-to-date master: " \
             "git switch master && git pull")
end

def main
  type = ARGV[0]
  if type && !RELEASE_TYPES.include?(type)
    abort_with(%(Invalid release type "#{type}". Use one of: #{RELEASE_TYPES.join(", ")}.))
  end

  ensure_up_to_date_master
  type ||= ask_release_type

  old_version = current_version
  new_version = next_version(old_version, type)

  puts
  puts "📦 Release type:    #{type.upcase}"
  puts "📊 Current version: #{old_version}"
  puts "📈 New version:     #{new_version}"
  puts

  answer = ask("Do you want to continue with this #{type} release? (y/N): ").downcase
  unless %w[y yes].include?(answer)
    puts "\n❌ Release cancelled.\n"
    exit 0
  end

  replace_version(VERSION_FILE, VERSION_PATTERN, new_version)
  replace_version(LOCKFILE, LOCKFILE_PATTERN, new_version)
  puts "\n✅ Version updated: #{new_version}"

  puts "\n📝 Updating CHANGELOG.md..."
  empty_entry = update_changelog(new_version)
  if empty_entry
    puts "⚠️  The CHANGELOG.md entry for #{new_version} is empty. Add the release notes before you open the PR."
  end

  puts "\nFiles updated:"
  puts "  - lib/adzerk/version.rb (#{old_version} → #{new_version})"
  puts "  - Gemfile.lock (#{old_version} → #{new_version})"
  puts "  - CHANGELOG.md"
  puts "\n📋 Next steps:"
  puts "  1. Review the changes: git diff"
  puts "  2. Edit the CHANGELOG.md entry for #{new_version}, if necessary"
  puts "  3. Make a branch: git switch -c release-#{new_version}"
  puts %(  4. Commit the changes: git commit -am "Release #{new_version}")
  puts "  5. Push the branch and open a PR to master"
  puts "  6. When the PR merges, the Publish Gem workflow tags #{new_version} and publishes the gem\n\n"
end

main
