require "test_helper"

describe Notifications do
  describe "#tournament_invitation" do
    it "must contain tournament details" do
      @tournament = create(:tournament)
      @invite = create(:invite, :tournament => @tournament)
      mail = Notifications.tournament_invitation @invite
      mail.subject.must_equal I18n.t('notifications.tournament_invitation.subject')
      mail.to.must_equal [@invite.email]
      mail.body.encoded.must_match I18n.t('notifications.tournament_invitation.invited', :tournament => @tournament.name)
      mail.body.encoded.must_match @invite.code
    end
  end

  describe "#game_confirmation" do
    before do
      @game = create(:game)
      @user1 = create(:user)
      @user2 = create(:user)
      @game_rank1 = create(:game_rank, :game => @game, :user => @user1, :position => 1)
      @game_rank2 = create(:game_rank, :game => @game, :user => @user2, :position => 2)
    end

    it "must contain game details" do
      mail = Notifications.game_confirmation @user1, @game
      mail.subject.must_equal I18n.t('notifications.game_confirmation.subject')
      mail.to.must_equal [@user1.email]
      mail.body.encoded.must_match @game.tournament.name
      mail.body.encoded.must_match @game.versus
    end
  end

  describe "#game_confirmed" do
    before do
      @game = create(:game)
      @user1 = create(:user)
      @user2 = create(:user)
      @game_rank1 = create(:game_rank, :game => @game, :user => @user1, :position => 1)
      @game_rank2 = create(:game_rank, :game => @game, :user => @user2, :position => 2)
    end

    it "must contain game details" do
      mail = Notifications.game_confirmed @user1, @game
      mail.subject.must_equal I18n.t('notifications.game_confirmed.subject')
      mail.to.must_equal [@user1.email]
      mail.body.encoded.must_match @game.tournament.name
      mail.body.encoded.must_match @game.versus
    end
  end

  describe "#challenged" do
    it "must contain challenge details" do
      challenge = create(:challenge)
      mail = Notifications.challenged(challenge)
      mail.subject.must_equal I18n.t('notifications.challenged.subject')
      mail.to.must_equal [challenge.defender.email]
      mail.body.encoded.must_match challenge.tournament.name
      mail.body.encoded.must_match challenge.challenger.name
      mail.body.encoded.must_match challenge.defender.name
    end
  end
end
