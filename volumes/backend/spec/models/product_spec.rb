require "rails_helper"

RSpec.describe Product, type: :model do
  describe "associations" do
    it { is_expected.to have_one(:yahoo_auction_crawl_setting).dependent(:destroy) }
    it { is_expected.to have_one(:mercari_crawl_setting).dependent(:destroy) }
    it { is_expected.to have_one(:janpara_crawl_setting).dependent(:destroy) }
    it { is_expected.to have_one(:iosys_crawl_setting).dependent(:destroy) }
    it { is_expected.to have_one(:pc_koubou_crawl_setting).dependent(:destroy) }
    it { is_expected.to have_one(:used_sofmap_crawl_setting).dependent(:destroy) }
    it { is_expected.to have_one(:product_category_map).dependent(:destroy) }
    it { is_expected.to have_one(:category).through(:product_category_map) }

    it { is_expected.to have_many(:yahoo_auction_products).dependent(:destroy) }
    it { is_expected.to have_many(:yahoo_auction_daily_purchase_summaries).dependent(:destroy) }
    it { is_expected.to have_many(:yahoo_fleamarket_products).dependent(:destroy) }
    it { is_expected.to have_many(:yahoo_fleamarket_daily_purchase_summaries).dependent(:destroy) }
    it { is_expected.to have_many(:mercari_products).dependent(:destroy) }
    it { is_expected.to have_many(:mercari_daily_purchase_summaries).dependent(:destroy) }
    it { is_expected.to have_many(:janpara_products).dependent(:destroy) }
    it { is_expected.to have_many(:iosys_products).dependent(:destroy) }
    it { is_expected.to have_many(:pc_koubou_products).dependent(:destroy) }
    it { is_expected.to have_many(:used_sofmap_products).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
