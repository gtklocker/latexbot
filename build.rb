require 'digest/bubblebabble'
require 'tmpdir'
require 'pathname'
require 'dotenv/load'
require 'git'

def hash_url(url)
    Digest::SHA256.hexdigest url
end

def clone_location
    Pathname.new(ENV['CLONE_LOCATION'] || Dir.mktmpdir)
end

def build_pdf(base)
    successful_build = system("latexmk", "-pdf", "#{base}")
    if successful_build
        artifact = Pathname.new "#{base}.pdf"
        if artifact.exist?
            artifact
        else
            raise "Build succeeded but artifact #{artifact} not found."
        end
    else
        raise "Artifact #{artifact} build failed with status code #{successful_build}."
    end
end

def checkout_commit_clean(repo, commit)
    git = Git.open repo
    git.fetch
    git.checkout commit
    git.clean x: true, d: true, force: true
    git
end

def save_pdf(url, commit, path)
end

def build(url, commit)
    base = "burn"
    hash = hash_url url
    local_repo = clone_location.join hash
    if !local_repo.exist?
        raise 'unimplemented'
    end
    checkout_commit_clean local_repo, commit
    Dir.chdir local_repo do
        artifact = build_pdf base
        artifact.expand_path
    end
end

puts build "https://github.com/gtklocker/burn-paper", "5d95b8604b2ff7c0e3e94ed8aa8b36e055a598e6"