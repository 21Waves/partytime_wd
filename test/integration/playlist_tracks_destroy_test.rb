require 'test_helpers'

class PlaylistsTracksDeleteSpec < MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  let(:playlist) { FactoryGirl.create(:playlist_with_tracks) }
  let(:playlist2) { FactoryGirl.create(:playlist_with_tracks) }

  it "performs request" do
    TestApi.delete "/playlists/:playlist_id/tracks/:id", { playlist_id: playlist.id, id: playlist.tracks.last.id }
    assert_api_response
  end

  it "removes the track from the playlist" do
    track = playlist.tracks.last
    TestApi.delete "/playlists/:playlist_id/tracks/:id", { playlist_id: playlist.id, id: track.id }
    refute playlist.tracks.include?(track)
  end

  it "does not remove a track from a different playlist" do
    track = playlist2.tracks.last
    TestApi.delete "/playlists/:playlist_id/tracks/:id", { playlist_id: playlist.id, id: track.id }
    assert_equal 400, TestApi.json_response.status
  end
end
