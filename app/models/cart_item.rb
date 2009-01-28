class CartItem
  attr_writer :product, :quantity
  
  def initialize(product)
    @product = product
    @quantity = 1
  end
  
  def increment quantity
    @quantity += 1
  end
  
  def title
    @product.title
  end
  
  def price
    @product.price * @quantity
  end
end