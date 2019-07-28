require 'pathname'
require 'digest'
require 'tmpdir'

def hash_params(username, reponame, commit)
    sha = Digest::SHA256.new
    sha << username
    sha << reponame
    sha << commit
    sha.hexdigest
end

class ArtifactStore
    def initialize(store_location)
        @store_location = Pathname.new(store_location || Dir.mktmpdir)
    end

    def location_of_hash(hash)
        @store_location.join "#{hash}.pdf"
    end

    def store(username, reponame, commit, old_location)
        hash = hash_params username, reponame, commit
        new_location = location_of_hash hash
        FileUtils.cp(old_location, new_location)
    end

    def fetch(username, reponame, commit)
        hash = hash_params username, reponame, commit
        location_of_hash hash
    end
end