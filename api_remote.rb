require 'xmlrpc/client'
require 'pp'
require 'md5'

class Test
   attr_accessor :session_id
   def initialize
      @s = Time.now
      XMLRPC::Config.module_eval {remove_const(:ENABLE_NIL_PARSER)}
      XMLRPC::Config.const_set(:ENABLE_NIL_PARSER, true)
      @server = XMLRPC::Client.new2("http://magento.tui8.com:88/index.php/api/xmlrpc/")
      if true
         @session_id = "5d6d06cf485c1c2656732a605ef60983"
      else
         @session_id = @server.call("login", 'admin', '135531')
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

pp Test.new.session_id

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

# ### checkout cart api ############################################
Test.new.go("checkout_cart.create",[567])
Test.new.go("checkout_cart.list",[])
# ##################################################################
Test.new.go("checkout.initCheckout",[])
Test.new.go("checkout.saveCheckoutMethod",['guest'])
Test.new.go("checkout.saveBilling",[billing_address, ''])
Test.new.go("checkout.saveShipping",[shipping_address, ''])
Test.new.go("checkout.saveShippingMethod",["freeshipping_freeshipping"])
Test.new.go("checkout.savePayment",[payment])
Test.new.go("checkout.saveOrder",[payment])

# Test.new.go("checkout_cart.clear",[])

