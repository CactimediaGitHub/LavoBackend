# TODO: create tons of orders, customers, etc..

# Set start id to avoid payfort 'Duplicate order number'
Order.connection.execute("select setval('orders_id_seq', extract(epoch from now())::integer)")


avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/avatar.jpg'), 'image/jpg')
image  = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/laundry.jpg'), 'image/jpg')

coord10 = Geocoder.coordinates("Al Sa'ada Street - Dubai - United Arab Emirates")
v1 = Vendor.create!(name: 'Diva Laundry', activated: true, lat: coord10[0], lon: coord10[1], email: 'vendor-01@divalaundry.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '445349441', address: 'R02A, ICON Tower Tecom : New Media City Extension - Dubai', emirate: 'Dubai')

coord20 = Geocoder.coordinates('Tecom, Dubai')
v1 = Vendor.create!(name: 'Baraa Laundry', activated: true, lat: coord20[0], lon: coord20[1], email: 'vendor-02@baraa-laundry.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '445349441', address: 'G25, Ground Floor, I-Rise Tower, Tecom, Dubai', emirate: 'Dubai')

coord30 = Geocoder.coordinates('Jebel Ali Race Course Rd - Dubai')
v1 = Vendor.create!(name: 'Emco Express Laundry', activated: true, lat: coord30[0], lon: coord30[1], email: 'vendor-03@example.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '445349441', address: 'Jebel Ali Race Course Rd - Dubai', emirate: 'Dubai')

coord40 = Geocoder.coordinates('TECOM - Dubai')
v1 = Vendor.create!(name: 'Pressto Laundry & Dry Cleaners', activated: true, lat: coord40[0], lon: coord40[1], email: 'vendor-04@presstouae.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '445349441', address: 'Two Towers, Inside Geant Easy Supermarket, TECOM - Dubai', emirate: 'Dubai')

coord60 = Geocoder.coordinates('Sheikh Zayed Road - Dubai')
v1 = Vendor.create!(name: 'Eastern Rose Laundry', activated: true, lat: coord60[0], lon: coord60[1], email: 'vendor-06@easternroselaundry.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '445349441', address: 'Sheikh Zayed Road - Dubai', emirate: 'Dubai')

coord70 = Geocoder.coordinates('Jebel Ali Race Course Rd - Dubai - United Arab Emirates')
v1 = Vendor.create!(name: 'The laundry Basket', activated: true, lat: coord70[0], lon: coord70[1], email: 'vendor-07@thelaundrybasket.ae', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '445349441', address: 'SHOP No. 1,ALSHAIBA GATE BLD,TECOM AREA - Dubai', emirate: 'Dubai')

coord80 = Geocoder.coordinates('Street 7 - Dubai')
v1 = Vendor.create!(name: 'Champion Cleaners', activated: true, lat: coord80[0], lon: coord80[1], email: 'vendor-08@example.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '445349441', address: 'Street 7 - Dubai', emirate: 'Dubai')


c1 = Customer.create!(phone: '1234567', prefix_phone: '052', name: 'John', surname: 'Doe', email: 'customer-1@example.com', password: '123456', password_confirmation: '123456', activated: true)
c2 = Customer.create!(phone: '1234567', prefix_phone: '052', name: 'Syber', surname: 'Junkie', email: 'customer-2@example.com', password: '123456', password_confirmation: '123456', activated: true)
c3 = Customer.create!(phone: '1234567', prefix_phone: '052', name: 'Pjotr', surname: 'Ferdyschenko', email: 'customer-3@example.com', password: '123456', password_confirmation: '123456', activated: true)
c4 = Customer.create!(phone: '1234567', prefix_phone: '052', name: 'Eugene', surname: 'Potapenko', email: 'eugene.potapenko@lavohost.com', password: '123456', password_confirmation: '123456', activated: true)
c5 = Customer.create!(phone: '1234567', prefix_phone: '052', name: 'Nadiia', surname: 'Antonova', email: 'na@na.com', password: '1111', password_confirmation: '1111', activated: true)

customer1_address1 = Address.create!(customer: c1, address1: 'Al Hamriya 7', address2: 'Near Dubai Hospital 4', city: 'Dubai', country: 'AE', human_name: 'My home address 1', nearest_landmark: '123456')
customer2_address1 = Address.create!(customer: c2, address1: 'Al Hamriya 8', address2: 'Near Dubai Hospital 4', city: 'Dubai', country: 'AE', human_name: 'My home address 1', nearest_landmark: '123456')
customer3_address1 = Address.create!(customer: c3, address1: 'Al Hamriya 3', address2: 'Near Dubai Hospital 4', city: 'Dubai', country: 'AE', human_name: 'My home address 1', nearest_landmark: '123456')
customer3_address2 = Address.create!(customer: c3, address1: 'Al Hamriya 4', address2: 'Near Dubai Hospital 5', city: 'Dubai', country: 'AE', human_name: 'My home address 2', nearest_landmark: '123456')
customer4_address1 = Address.create!(customer: c4, address1: 'Al Hamriya 5', address2: 'Near Dubai Hospital 5', city: 'Dubai', country: 'AE', human_name: 'My home address 1', nearest_landmark: '123456')
customer5_address1 = Address.create!(customer: c5, address1: 'Al Hamriya 6', address2: 'Near Dubai Hospital 5', city: 'Dubai', country: 'AE', human_name: 'My home address 1', nearest_landmark: '123456')
Card.create!(customer: c3, name: 'Steve Smith', number: '455701******8902', token: '3F36728453274738E053321E320A846A', card_bin: '455701', expiry_date: '1705', nick: 'My lovely card 1')
Card.create!(customer: c3, name: 'Steve Smith', number: '512345******2346', token: '3F36728453274738E053321E320A846B', card_bin: '512345', expiry_date: '1705', nick: 'My lovely card 2')

coord1 = Geocoder.coordinates('Dubai Investment Park 2 - Dubai')
coord2 = Geocoder.coordinates('Dubai Investments Park 2, Dubai')
coord3 = Geocoder.coordinates('Al Hamriya, Near Dubai Hospital, Dubai')
coord4 = Geocoder.coordinates('Plot No. 597-226, Dubai')
coord5 = Geocoder.coordinates('10 Ibn Battuta St, Dubai')


v1 = Vendor.create!(name: 'Green Residences',                  activated: true, lat: coord1.fetch(0, 24.9745179), lon: coord1.fetch(1, 55.1983055), email: 's1@dubai.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '555922781', address: 'WH-5, Plot-597/226, Dubai Investment Park 2 - Dubai', emirate: 'Dubai')
v2 = Vendor.create!(name: 'Dubai Investments Park 2',          activated: true, lat: coord2.fetch(0, 24.9745179), lon: coord2.fetch(1, 55.1983055), email: 's2@dubai.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '555922782', address: 'Dubai Investments Park 2, Dubai', emirate: 'Dubai')
v3 = Vendor.create!(name: 'Al Hamriya, Near Dubai Hospital',   activated: true, lat: coord3.fetch(0, 25.269735), lon: coord3.fetch(1, 55.3116909), email: 's3@dubai.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '555922783', address: 'Al Hamriya, Near Dubai Hospital, Dubai', emirate: 'Dubai')
v4 = Vendor.create!(name: 'Warehouse No. 9, Plot No. 597-226', activated: true, lat: coord4.fetch(0, 25.2048493), lon: coord4.fetch(1, 55.2707828), email: 's4@dubai.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '555922784', address: 'Warehouse No. 9, Plot No. 597-226, Dubai', emirate: 'Dubai')
v5 = Vendor.create!(name: '10 Ibn Battuta St',                 activated: true, lat: coord5.fetch(0, 25.0478705), lon: coord5.fetch(1, 55.1301715), email: 's5@dubai.com', avatar: avatar, images: [image], password: '123456', password_confirmation: '123456', phone: '555922785', address: '10 Ibn Battuta St, Dubai', emirate: 'Dubai')

s1 = Service.create!(name: "Laundry")
s2 = Service.create!(name: "Drycleaning")
s3 = Service.create!(name: "Iron")

i1 = Item.create!(name: "T-Shirt")
i2 = Item.create!(name: "Pants")
i3 = Item.create!(name: "Dress")

item_type1 = ItemType.create!(name: "Male")
item_type2 = ItemType.create!(name: "Female")
item_type3 = ItemType.create!(name: "Kids")

ShippingMethodName.create!(name: 'normal')
ShippingMethodName.create!(name: 'express')

vendor1_ii1 =InventoryItem.create!(service: s1, item: i1, item_type: item_type3, vendor: v1, price: 1000)
ii2 = InventoryItem.create!(service: s1, item: i2, item_type: item_type1, vendor: v1, price: 10000)
ii3 = InventoryItem.create!(service: s1, item: i3, item_type: item_type2, vendor: v1, price: 1000)

ii4 = InventoryItem.create!(service: s2, item: i1, item_type: item_type1, vendor: v1, price: 1000)
ii5 = InventoryItem.create!(service: s2, item: i2, item_type: item_type2, vendor: v1, price: 1000)
ii6 = InventoryItem.create!(service: s2, item: i3, item_type: item_type3, vendor: v1, price: 1000)

ii7 = InventoryItem.create!(service: s3, item: i1, item_type: item_type2, vendor: v1, price: 1000)

vendor2_ii8 = InventoryItem.create!(service: s1, item: i1, item_type: item_type1, vendor: v2, price: 3000)
InventoryItem.create!(service: s1, item: i2, item_type: item_type2, vendor: v2, price: 2000)
InventoryItem.create!(service: s1, item: i3, item_type: item_type3, vendor: v2, price: 3000)

InventoryItem.create!(service: s2, item: i1, item_type: item_type1, vendor: v2, price: 3000)
InventoryItem.create!(service: s2, item: i2, item_type: item_type2, vendor: v2, price: 3000)

InventoryItem.create!(service: s3, item: i1, item_type: item_type3, vendor: v2, price: 3000)

InventoryItem.create!(service: s1, item: i1, item_type: item_type3, vendor: v3, price: 3000)

vendor1_shipping_method1 = ShippingMethod.create!(vendor: v1, delivery_period: 16, shipping_method_name: ShippingMethodName.first, shipping_charge: 1000)
shipping_method2 = ShippingMethod.create!(vendor: v1, delivery_period: 8, shipping_method_name: ShippingMethodName.last, shipping_charge: 2000)

vendor2_shipping_method3 = ShippingMethod.create!(vendor: v2, delivery_period: 16, shipping_method_name: ShippingMethodName.first, shipping_charge: 1100)
shipping_method4 = ShippingMethod.create!(vendor: v2, delivery_period: 8, shipping_method_name: ShippingMethodName.last, shipping_charge: 2000)

ShippingMethod.create!(vendor: v3, delivery_period: 16, shipping_method_name: ShippingMethodName.first, shipping_charge: 1000)
ShippingMethod.create!(vendor: v3, delivery_period: 8, shipping_method_name: ShippingMethodName.last, shipping_charge: 2000)

ShippingMethod.create!(vendor: v4, delivery_period: 16, shipping_method_name: ShippingMethodName.first, shipping_charge: 1000)
ShippingMethod.create!(vendor: v4, delivery_period: 8, shipping_method_name: ShippingMethodName.last, shipping_charge: 2000)

ShippingMethod.create!(vendor: v5, delivery_period: 16, shipping_method_name: ShippingMethodName.first, shipping_charge: 1000)
ShippingMethod.create!(vendor: v5, delivery_period: 8, shipping_method_name: ShippingMethodName.last, shipping_charge: 2000)

customer1_address1 = Address.create!(customer: c5, address1: 'Al Hamriya', address2: 'Near Dubai Hospital', city: 'Dubai', country: 'AE', human_name: 'My home address', nearest_landmark: '123456')
customer1_shipping_address1 = ShippingAddress.create!(address1: 'Al Hamriya', address2: 'Near Dubai Hospital', city: 'Dubai', country: 'AE', human_name: 'My home address', nearest_landmark: '123456')
vendor1_shipping1 = Shipping.new(shipping_method: vendor1_shipping_method1, address: customer1_shipping_address1, pick_up: "[#{Time.now}, #{Time.now + 2.hours}]", drop_off: "[#{Time.now + 8.hours}, #{Time.now + 8.hours + 2.hours}]")
vendor1_order_item1 = OrderItem.new(inventory_item: vendor1_ii1, quantity: 2)
total1 = API::Order::CartCalculator.new(
  order_items: [ { inventory_item_id: vendor1_ii1.id, quantity: 2 }],
  shipping: { shipping_method_id: vendor1_shipping_method1.id }
).total
order1 = Order.new(vendor: v1, customer: c5, order_items: [vendor1_order_item1], shipping: vendor1_shipping1, total: total1)
order1.save!

customer2_address2 = Address.create!(customer: c2, address1: 'WH-5, Plot-597/226', address2: 'Dubai Investment Park 2', city: 'Dubai', country: 'AE', human_name: 'My home address', nearest_landmark: '123456')
customer2_shipping_address2 = ShippingAddress.create!(address1: 'WH-5, Plot-597/226', address2: 'Dubai Investment Park 2', city: 'Dubai', country: 'AE', human_name: 'My home address', nearest_landmark: '123456')
vendor2_shipping2 = Shipping.new(shipping_method: vendor2_shipping_method3, address: customer2_shipping_address2, pick_up: "[#{Time.now}, #{Time.now + 2.hours}]", drop_off: "[#{Time.now + 8.hours}, #{Time.now + 8.hours + 2.hours}]")

vendor2_order_item2 = OrderItem.new(inventory_item: vendor2_ii8, quantity: 4)
total2 = API::Order::CartCalculator.new(
  order_items: [ { inventory_item_id: vendor2_ii8, quantity: 4 }],
  shipping: { shipping_method_id: vendor2_shipping_method3.id }
).total
order2 = Order.new(vendor: v2, customer: c2, order_items: [vendor2_order_item2], shipping: vendor2_shipping2, total: total2)
order2.save

vendor1_shipping3 = Shipping.new(shipping_method: vendor1_shipping_method1, address: customer1_shipping_address1, pick_up: "[#{Time.now}, #{Time.now + 2.hours}]", drop_off: "[#{Time.now + 8.hours}, #{Time.now + 8.hours + 2.hours}]")
order3 = Order.new(vendor: v1, customer: c5, order_items: [vendor1_order_item1], shipping: vendor1_shipping3, total: total1)
order3.save

vendor1_shipping4 = Shipping.new(shipping_method: vendor1_shipping_method1, address: customer1_shipping_address1, pick_up: "[#{Time.now}, #{Time.now + 2.hours}]", drop_off: "[#{Time.now + 8.hours}, #{Time.now + 8.hours + 2.hours}]")
order4 = Order.new(vendor: v1, customer: c5, order_items: [vendor1_order_item1], shipping: vendor1_shipping4, total: total1)
order4.save

# Order.find(order3).state_machine.transition_to(:processing)
# Order.find(order3).state_machine.transition_to(:completed)
# Order.find(order4).state_machine.transition_to(:processing)
# Order.find(order4).state_machine.transition_to(:completed)
#
# Order.connection.execute("update orders set created_at='#{2.month.ago.to_s(:db)}' where(id = #{order3.id})")
# Order.connection.execute("update orders set created_at='#{5.month.ago.to_s(:db)}' where(id = #{order4.id})")

v1.review!(by: c5, rating: 4, title: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod', body: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
review = Review.first
comment1 = Review.create!(reviewer: c5, reviewable: review, body: 'Comment 1, Review 1. Customer 1. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
Review.connection.execute("update reviews set created_at='#{2.month.ago.to_s(:db)}' where(id = #{comment1.id})")
comment2 = Review.create!(reviewer: c2, reviewable: review, body: 'Comment 2, Review 1. Customer 2. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
Review.connection.execute("update reviews set created_at='#{1.month.ago.to_s(:db)}' where(id = #{comment2.id})")
comment3 = Review.create!(reviewer: c3, reviewable: review, body: 'Comment 3, Review 1. Customer 3. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
like1 =    Review.create!(reviewer: c5, reviewable: review, rating: 1)

v1.review!(by: c2, title: 'Review title 1, Customer 2', body: 'Review body 1', rating: 4)
v1.review!(by: c3, title: 'Review title 1, Customer 3', body: 'Review body 2', rating: 1)

v2.review!(by: c5, title: 'Review title 21', body: 'Review body', rating: 3)
v2.review!(by: c2, title: 'Review title 22', body: 'Review body', rating: 4)
v2.review!(by: c3, title: 'Review title 2, Customer 3', body: 'Review body', rating: 3)

v3.review!(by: c5, title: 'Review title 31', body: 'Review body', rating: 3)
v3.review!(by: c2, title: 'Review title 32', body: 'Review body', rating: 3)
v3.review!(by: c3, title: 'Review title 3, Customer 3', body: 'Review body', rating: 2)

v4.review!(by: c5, title: 'Review title 41', body: 'Review body', rating: 1)
v4.review!(by: c2, title: 'Review title 42', body: 'Review body', rating: 1)
v4.review!(by: c3, title: 'Review title 4, Customer 3', body: 'Review body', rating: 1)

v5.review!(by: c5, title: 'Review title 51', body: 'Review body', rating: 3)
v5.review!(by: c2, title: 'Review title 52', body: 'Review body', rating: 4)
v5.review!(by: c3, title: 'Review title 5, Customer 3', body: 'Review body', rating: 3)

sh1 = Schedule.create!(weekday: Date::DAYNAMES[1], vendor: Vendor.find(v1.id))
sh1 = Schedule.create!(weekday: Date::DAYNAMES[2], vendor: Vendor.find(v1.id))
sh1 = Schedule.create!(weekday: Date::DAYNAMES[3], vendor: Vendor.find(v1.id))
sh1 = Schedule.create!(weekday: Date::DAYNAMES[4], vendor: Vendor.find(v1.id))
sh1 = Schedule.create!(weekday: Date::DAYNAMES[5], vendor: Vendor.find(v1.id))
sh1 = Schedule.create!(weekday: Date::DAYNAMES[6], vendor: Vendor.find(v1.id))
sh1 = Schedule.create!(weekday: Date::DAYNAMES[0], vendor: Vendor.find(v1.id))

sh2 = Schedule.create!(weekday: Date::DAYNAMES[1], vendor: Vendor.find(v2))
sh2 = Schedule.create!(weekday: Date::DAYNAMES[2], vendor: Vendor.find(v2))
sh2 = Schedule.create!(weekday: Date::DAYNAMES[3], vendor: Vendor.find(v2))
sh2 = Schedule.create!(weekday: Date::DAYNAMES[4], vendor: Vendor.find(v2))
sh2 = Schedule.create!(weekday: Date::DAYNAMES[5], vendor: Vendor.find(v2))
sh2 = Schedule.create!(weekday: Date::DAYNAMES[6], vendor: Vendor.find(v2))
sh2 = Schedule.create!(weekday: Date::DAYNAMES[0], vendor: Vendor.find(v2))

sh3 = Schedule.create!(weekday: Date::DAYNAMES[1], vendor: Vendor.find(v3))
sh3 = Schedule.create!(weekday: Date::DAYNAMES[2], vendor: Vendor.find(v3))
sh3 = Schedule.create!(weekday: Date::DAYNAMES[3], vendor: Vendor.find(v3))
sh3 = Schedule.create!(weekday: Date::DAYNAMES[4], vendor: Vendor.find(v3))
sh3 = Schedule.create!(weekday: Date::DAYNAMES[5], vendor: Vendor.find(v3))
sh3 = Schedule.create!(weekday: Date::DAYNAMES[6], vendor: Vendor.find(v3))
sh3 = Schedule.create!(weekday: Date::DAYNAMES[0], vendor: Vendor.find(v3))

sh4 = Schedule.create!(weekday: Date::DAYNAMES[1], vendor: Vendor.find(v4))
sh4 = Schedule.create!(weekday: Date::DAYNAMES[2], vendor: Vendor.find(v4))
sh4 = Schedule.create!(weekday: Date::DAYNAMES[3], vendor: Vendor.find(v4))
sh4 = Schedule.create!(weekday: Date::DAYNAMES[4], vendor: Vendor.find(v4))
sh4 = Schedule.create!(weekday: Date::DAYNAMES[5], vendor: Vendor.find(v4))
sh4 = Schedule.create!(weekday: Date::DAYNAMES[6], vendor: Vendor.find(v4))
sh4 = Schedule.create!(weekday: Date::DAYNAMES[0], vendor: Vendor.find(v4))

sh5 = Schedule.create!(weekday: Date::DAYNAMES[1], vendor: Vendor.find(v5))
sh5 = Schedule.create!(weekday: Date::DAYNAMES[2], vendor: Vendor.find(v5))
sh5 = Schedule.create!(weekday: Date::DAYNAMES[3], vendor: Vendor.find(v5))
sh5 = Schedule.create!(weekday: Date::DAYNAMES[4], vendor: Vendor.find(v5))
sh5 = Schedule.create!(weekday: Date::DAYNAMES[5], vendor: Vendor.find(v5))
sh5 = Schedule.create!(weekday: Date::DAYNAMES[6], vendor: Vendor.find(v5))
sh5 = Schedule.create!(weekday: Date::DAYNAMES[0], vendor: Vendor.find(v5))

CreditTransaction.create!(amount: 1111, transaction_type: :purchased, customer: Customer.find(c5))
CreditTransaction.create!(amount: 1110, transaction_type: :paid, customer: Customer.find(c5))
CreditTransaction.create!(amount: 2, transaction_type: :manual_addition, note: 'For luck!', customer: Customer.find(c5))
CreditTransaction.create!(amount: 1, transaction_type: :manual_withdrawal, customer: Customer.find(c5))
CreditTransaction.create!(amount: 1, transaction_type: :refunded, customer: Customer.find(c5))

Page.create!(nick: 'about', title: 'About us', body: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' )
Page.create!(nick: 'terms', title: 'Terms and Conditions', body: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' )
Page.create!(nick: 'privacy_policy', title: 'Privacy Policy', body: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' )
Page.create!(nick: 'return_policy', title: 'Return policy', body: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' )
Page.create!(nick: 'what_are_credits', title: 'What are credits?', body: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' )

order1 = Order.find(order1)
order2 = Order.find(order2)
order3 = Order.find(order3)
Payment.create!(paid_amount: order1.total, order_total: order1.total, order: order1, vendor: order1.vendor, customer: order1.customer, payment_method: 'cash')
card1 = Card.create!(customer: order2.customer, name: 'Steve Smith', number: '455701******8902', token: '3F36728453274738E053321E320A846C', card_bin: '455701', expiry_date: '1705', nick: 'My lovely card')
Payment.create!(paid_amount: order2.total - 100, order_total: order2.total, credits_amount: 100, order: order2, vendor: order2.vendor, customer: order2.customer, status: '14', response_code: "1400", response_message: 'Success', fort_id: '123456789', card: card1, payment_method: 'card_credits')
Payment.create!(paid_amount: order3.total, order_total: order3.total, order: order2, vendor: order3.vendor, customer: order3.customer, status: '14', response_code: "1400", response_message: 'Success', fort_id: '123456789', card: card1, payment_method: 'card')
Payment.create!(paid_amount: 100, credits_amount: 100, payment_method: 'credits', status: '14', response_code: "1400", response_message: 'Success', fort_id: '123456789', card: card1, customer: order1.customer)

promotion1 = Promotion.create!(
  name: 'Flat rate discount on order total',
  description: '400.00 AED < Order total < 700.00 AED, discount: 15.00 AED.',
  vendors: [v1],
  icon: image,
  starts_at:  (Time.now - 1.day).to_s(:db),
  expires_at: (Time.now + 10.year).to_s(:db)
)
Promotion::Rules::OrderTotal.create!(
  promotion: promotion1,
  type: Promotion::Rules::OrderTotal,
  preferences: {
    :operator_min => 'gt',
    :operator_max => 'lt',
    :amount_min => 40000,
    :amount_max => 70000
  }
)
Promotion::Actions::CreateAdjustment.create!(
  promotion: promotion1,
  type: Promotion::Actions::CreateAdjustment,
  calculator_amount: 1500,
  calculator_type: 'Promotion::Calculators::FlatRate'
)

promotion2 = Promotion.create!(
  name: 'Flat percent discount on order total',
  description: '700.00 AED < Order total < 900.00 AED, discount: 50%.',
  vendors: [v2],
  icon: image,
  starts_at:  (Time.now - 1.day).to_s(:db),
  expires_at: (Time.now + 10.year).to_s(:db)
)
Promotion::Rules::OrderTotal.create!(
  promotion: promotion2,
  type: Promotion::Rules::OrderTotal,
  preferences: {
    :operator_min => 'gt',
    :operator_max => 'lt',
    :amount_min => 70000,
    :amount_max => 90000
  }
)
Promotion::Actions::CreateAdjustment.create!(
  promotion: promotion2,
  type: Promotion::Actions::CreateAdjustment,
  calculator_amount: 50,
  calculator_type: 'Promotion::Calculators::FlatPercent'
)

# promotion3 = Promotion.create!(
#   name: 'Flat rate order total discount on order item presence',
#   description: "If #{[v1.inventory_items.last.name, v1.inventory_items.last.name, v1.inventory_items.last.name]} present give discount: 1500. All amounts in cents",
#   vendors: [v1],
#   icon: image,
#   starts_at:  (Time.now - 1.day).to_s(:db),
#   expires_at: (Time.now + 10.year).to_s(:db)
# )
# Promotion::Rules::OrderItemDiscount.create!(
#   promotion: promotion3,
#   type: Promotion::Rules::OrderItemDiscount,
#   preferences: {
#       service_id: v1.inventory_items.last.service_id,
#          item_id: v1.inventory_items.last.item_id,
#     item_type_id: v1.inventory_items.last.item_type_id,
#   }
# )
# Promotion::Actions::CreateAdjustment.create!(
#   promotion: promotion3,
#   type: Promotion::Actions::CreateAdjustment,
#   calculator_amount: 1500,
#   calculator_type: 'Promotion::Calculators::FlatRate'
# )
promotion4 = Promotion.create!(
  name: 'Item quantity flat rate discount on order total',
  description: "If 5 items present in the order give flat rate discount: 15.00 AED.",
  vendors: [v3],
  icon: image,
  starts_at:  (Time.now - 1.day).to_s(:db),
  expires_at: (Time.now + 10.year).to_s(:db)
)
Promotion::Rules::OrderItemQuantity.create!(
  promotion: promotion4,
  type: Promotion::Rules::OrderItemQuantity,
  preferences: {
    :order_item_quantity => 5
  }
)
Promotion::Actions::CreateAdjustment.create!(
  promotion: promotion4,
  type: Promotion::Actions::CreateAdjustment,
  calculator_amount: 1500,
  calculator_type: 'Promotion::Calculators::FlatRate'
)

connection = ActiveRecord::Base.connection()
connection.execute(
  %(
    insert into vendors (name, email, lat, lon, address, phone, created_at, updated_at) (
      select 'Dubai Laundry Services ' || i as name, 'vendor-' || i || '@example.com' as email, 24 + x.lat as lat, 55 + x.lon as lon, 'Dubai Investments Park 2, ' || i || ', Dubai' as address, '555922781' as phone, now() as created_at, now() as updated_at
      from (select i, random() * 10 as lat, random() * 10 as lon from generate_series(1,10000) as i)
    as x );
  )
)