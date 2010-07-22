require 'xmlrpc/client'
require 'pp'
require 'md5'



# string orderIncrementId - order increment id
# array itemsQty - items qty to ship as associative array (order_item_id ⇒ qty)
# string comment - shipment comment (optional)
# boolean email - send e-mail flag (optional)
# boolean includeComment - include comment in e-mail flag (optional)

# pp server.call("call", session_id, "sales_order.info", [100000003])
# server.call("call", session_id, "order_shipment.create", [100000003])

class Test
   attr_accessor :session_id
   def initialize
      @s = Time.now
      XMLRPC::Config.module_eval {remove_const(:ENABLE_NIL_PARSER)}
      XMLRPC::Config.const_set(:ENABLE_NIL_PARSER, true)
      @server = XMLRPC::Client.new2("http://localhost/magento/index.php/api/xmlrpc/")
      # @server = XMLRPC::Client.new2("http://magento.tui8.com:88/index.php/api/xmlrpc/")
      if true
         @session_id = "bd7c0b8f55a13dd3ce11161784a05716"
      else
         @session_id = @server.call("login", 'admin', '123321')
      end
      # server.call("endSession", session_id)
   end

   def go(*args)
      begin
         result = @server.call("call", @session_id, args[0], args[1])
         puts "#{args[0]}:\t\t\t" + (Time.now - @s).to_s
         result
      rescue Exception => e
         puts e.message
      end
   end
end

# pp Test.new.session_id

billing_address = {
   "firstname" => 'michael',
   "lastname" => 'he',
   "company" => 'theplant',
   "email" => 'michael@theplant.jp',
   "street" => ["hangzhou EAC F1402 zhejiang china", "zhejiang, china"],
   "city" => 'hangzhou',
   "region_id" => 43,
   "region" => '',
   "postcode" => '310000',
   "country_id" => 'US',
   "telephone" => '81234567',
   "fax" => '',
   "save_in_address_book" => 1,
   "use_for_shipping" => 0
}
shipping_address = {
   "firstname" => 'michael',
   "lastname" => 'he',
   "company" => 'theplant',
   "street" => ["hangzhou EAC F1402 zhejiang china", "zhejiang, china"],
   "city" => 'hangzhou',
   "region_id" => 43,
   "region" => '',
   "postcode" => '310000',
   "country_id" => 'US',
   "telephone" => '81234567',
   "fax" => '',
   "save_in_address_book" => 1,
   "same_as_billing" => 1
}
payment = {
   "method" => 'ccsave',
   "cc_owner" => 'My master card',
   "cc_type" => 'MC',
   "cc_number" => "5555555555554444",
   "cc_exp_month" => 12,
   "cc_exp_year" => 2009,
   "cc_cid" => '123'
}


##############################
# pp Test.new.go('product_stock.update', 
# [
#    1332, 
#    {'qty'=> 9999, 'is_in_stock'=>1}
# ]);

  
# pp Test.new.go("product_stock.list", [1332])
# pp Test.new.go("product.info", [1331])

# pp Test.new.go("product.create", 
#    ["simple", 4, "hlxwell-test-product-0002", 
#       {
#          :name => "hlxwell-test-product2", 
#          :description => "hlxwell-test-product description", 
#          :short_description => "hlxwell-test-product", 
#          :price => 108, 
#          :weight => 128,
#          :status => 1,
#          :is_in_stock => "1",
#          :tax_class_id => "0",
#          :websites => ["1"]
#       }
#    ]
# )
# pp Test.new.go('product_stock.update',
# [
#    "hlxwell-test-product-0002", 
#    {'qty'=> 9999, 'is_in_stock'=>1}
# ]);
# ### checkout cart api ############################################
Test.new.go("checkout_cart.create",[567])
# Test.new.go("checkout_cart.create",[2])
# Test.new.go("checkout_cart.create",[3])
Test.new.go("checkout_cart.total_price",[])
Test.new.go("checkout_cart.list",[])
# Test.new.go("checkout_cart.clear",[])
# Test.new.go("checkout_cart.delete", [1])
# Test.new.go("checkout_cart.update", [{ '4'=>{ 'qty' => 3 } }])
# Test.new.go("checkout_cart.info", ["590169_0900"])
# ##################################################################
Test.new.go("checkout.initCheckout",[])
Test.new.go("checkout.saveCheckoutMethod",['guest'])
Test.new.go("checkout.saveBilling",[billing_address, ''])
Test.new.go("checkout.saveShipping",[shipping_address, ''])
Test.new.go("checkout.saveShippingMethod",["freeshipping_freeshipping"])
Test.new.go("checkout.savePayment",[payment])
Test.new.go("checkout.saveOrder",[payment])
# 
# pp Test.new.go("checkout_cart.clear",[])

