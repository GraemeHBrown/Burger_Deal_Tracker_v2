require('pry-byebug')
require("minitest/autorun")
require("minitest/reporters")
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative("../models/burger.rb")
require_relative("../models/eatery.rb")
require_relative("../models/deal.rb")

class TestDeals < MiniTest::Test

  def setup
    Deal.delete_all()
    Burger.delete_all()
    Eatery.delete_all()
    @bobs_burgers = Eatery.new({'name' => 'Bobs Burgers', 'location' => 'Edinburgh'})
    @bobs_burgers.save()
    @burgers_r_us = Eatery.new({'name' => 'Burgers R Us', 'location' => 'Edinburgh'})
    @burgers_r_us.save()
    @royale = Burger.new({'name' => 'Royale', 'price' => 17.50, 'eatery_id' => @bobs_burgers.id })
    @royale.save()
    @whopper = Burger.new({'name' => 'Whopper', 'price' => 3.50, 'eatery_id' => @bobs_burgers.id })
    @whopper.save()
    @two_for_one = Deal.new({'deal_name' => 'Two for one', 'day' => 'Tuesday', 'burger_id' => @royale.id })
    @two_for_one.save()
    @twenty_five_percent_off = Deal.new({'deal_name' => '25% off',
      'day' => 'Friday', 'burger_id' => @whopper.id })
  end


  def test_deal_has_deal_name()
    assert_equal('Two for one', @two_for_one.deal_name)
  end

  def test_deal_has_day()
    assert_equal('Tuesday', @two_for_one.day)
  end

  def test_deal_saved_to_db
    deal_name_pre_save = @twenty_five_percent_off.deal_name
    @twenty_five_percent_off.save()
    found_deal = Deal.find(@twenty_five_percent_off.id)
    assert_equal(deal_name_pre_save, found_deal.deal_name)
  end

  def test_updated_instance_shows_changes()
    new_deal_name = 'Two for one Tuesday!'
    @two_for_one.deal_name = new_deal_name
    @two_for_one.update()
    updated_deal = Deal.find(@two_for_one.id)
    assert_equal(new_deal_name, updated_deal.deal_name)
  end

  def test_deleting_an_instance()
    @two_for_one.delete()
    assert_raises (NoMethodError) {Deal.find(@two_for_one.id)}
  end

  #a db method so difficult to test well.  Calling find raises an error
  def test_delete_all_returns_error_on_find()
    @twenty_five_percent_off.save()
    Deal.delete_all()
    assert_raises (NoMethodError) {Deal.find(@two_for_one.id)}
    assert_raises (NoMethodError) {Deal.find(@twenty_five_percent_off.id)}
  end

  def test_all_deals_returns_deals_from_db()
    #saving twenty_five_percent_off to db before as its not saved in setup
    @twenty_five_percent_off.save()
    all_deals = Deal.all()
    assert_equal(2, all_deals.size())
  end

  def test_burger_return_burger_details_for_deal()
    assert_equal('Royale', @two_for_one.burger().name())
  end

end
