require_relative 'spec_helper'

require_relative '../build'

FIXTURE_REPO_URL = 'https://github.com/gtklocker/latexbot-fixture.git'
FIXTURE_SUCCEEDING_COMMIT = '4c893fb6570e1958ed2535f680b6c65f330686ca'
FIXTURE_FAILING_COMMIT = '8342149fa696beecbca36ce7429633afabb60fb5'

describe "build" do
    it "builds a latex project" do
        pdf = build(FIXTURE_REPO_URL, FIXTURE_SUCCEEDING_COMMIT)
        expect(File).to exist(pdf)
    end

    it "fails on a malformed project" do
        expect {
            pdf = build(FIXTURE_REPO_URL, FIXTURE_FAILING_COMMIT)
        }.to raise_error
    end
end

describe "clone_url" do
    it "generates a valid github clone url" do
        expect(clone_url 'username', 'reponame', 'token').to eq "https://x-access-token:token@github.com/username/reponame.git"
    end
end