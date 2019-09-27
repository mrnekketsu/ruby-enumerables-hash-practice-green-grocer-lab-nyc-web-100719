require "pry"
def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item_hash|
    item_hash.each do |item, value|
      if new_cart[item]
          new_cart[item][:count] += 1
      else
          new_cart[item] = value
          new_cart[item][:count] = 1
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  # code here
  hash = cart
  coupons.each do |coupon_hash|
    # add coupon to cart
    item = coupon_hash[:item]

    if !hash[item].nil? && hash[item][:count] >= coupon_hash[:num]
      temp = {"#{item} W/COUPON" => {
        :price => coupon_hash[:cost]/coupon_hash[:num],
        :clearance => hash[item][:clearance],
        :count => coupon_hash[:num]
        }
      }
      
      if hash["#{item} W/COUPON"].nil?
        hash.merge!(temp)
      else
        hash["#{item} W/COUPON"][:count] += coupon_hash[:num]
      end
      
      hash[item][:count] -= coupon_hash[:num]
    end
  end
  hash
  
end

def apply_clearance(cart)
  cart.each do |item, attribute_hash|
    if attribute_hash[:clearance] == true
      attribute_hash[:price] = (attribute_hash[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart1 = apply_coupons(cart, coupons)
  cart2 = apply_clearance(cart1)
  
  total = 0
  
  cart2.each do |name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  end
  
  total > 100 ? total * 0.9 : total
end
