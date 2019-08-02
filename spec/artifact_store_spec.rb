require_relative 'spec_helper'

require 'digest'
require_relative '../artifact_store'

def create_dummy_file
    Dir.mktmpdir { |dir|
        filename = "#{dir}/dummy.pdf"
        File.open(filename, "w") { |file|
            file.puts "dummy"
        }
        yield filename
    }
end

def file_hash(file)
    Digest::SHA256.file(file)
end

describe ArtifactStore do
    it 'can be store and retrieve a file' do
        as = ArtifactStore.new(nil)
        expected_hash = nil
        create_dummy_file { |original_file|
            expected_hash = file_hash original_file
            as.store('username', 'reponame', 'commit', original_file)
        }
        fetched_file = as.fetch('username', 'reponame', 'commit')
        actual_hash = file_hash fetched_file
        expect(actual_hash).to eq expected_hash
    end
end