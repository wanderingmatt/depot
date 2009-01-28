class Product < ActiveRecord::Base  
  before_save :price_in_dollars
  
  def price_in_dollars
    self.price / 100.0 unless self.price == nil
  end
  
  def price_in_dollars=(amount)
    self.price = (amount.to_f * 100).to_i
  end
  
  def self.find_products_for_sale 
    find(:all, :order => 'title') 
  end
  
  # validation stuff...
  validates_presence_of :title, :description, :image_url, :price
  validates_uniqueness_of :title
  validates_format_of :image_url,
                      :with    => %r{\.(gif|jpg|png)$}i,
                      :message => 'must be a URL for a GIF, JPG or PNG image.'
  validates_numericality_of :price
  validate :price_must_be_at_least_a_cent


  protected


  def price_must_be_at_least_a_cent
    errors.add(:price, 'should be at least 0.01') if price.nil? || price < 0.01
  end
end