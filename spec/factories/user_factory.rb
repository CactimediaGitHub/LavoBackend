FactoryGirl.define do
  factory :customer do
    name "John"
    surname  "Doe"
    sequence :email do |n|
      "#{[name, surname].join('-').gsub(/\s+/, '-')}-#{n}@example.com"
    end
    password '123456'
    password_confirmation '123456'
    activated true
    phone '555922781'
    factory :inactive_customer do
      activated false
    end

    # after(:create) do |r|
    #   r.notification_registrations =
    #     [ create(:notification_registration,
    #         token: 'bad-dmWymonqXps:APA91bFo9yv0B5HCHZwP-H9Y4RfEbYD3tiof9WazR4QNFZlaxhZqoj0H6CYNf5H_ylHMKpG3C1OrkyA10jH7sqJ4azQ3PKSSmOOUOe_EN20QCcJ0_BD3Z_UMCRxglviapUheiDmCpfl0',
    #         notifiable: r) ]
    # end

    factory :signed_in_customer do
      http_token { create(:http_token) }
    end
  end

  factory :vendor do
    address 'Warehouse No. 9, Plot No. 597-226, Dubai'
    name { address }
    phone '123456789'
    sequence :email do |n|
      "laundry-#{n}@example.com"
    end
    password '123456'
    password_confirmation '123456'

    # after(:create) do |r|
    #   r.notification_registrations =
    #     [ create(:notification_registration,
    #         token: 'fv6BNsXkW4M:APA91bEJGOUzOgGlS_OyU90Av6lDI68AMMIW3rOiCIweYXdwePRcFSYmTQ70R23fCpl7WXTGpH9fsAWTgAMUUu7vSf1anYtlTf5NkldeIn5-ftsCh8nwHItZtXXLhSLtgsyeu-6XTiLD',
    #         notifiable: r) ]
    # end

    factory :signed_in_vendor do
      http_token { create(:http_token) }
    end

    factory :activated_vendor do
      activated true
    end

    factory :active_vendor do
      after(:create) do |vendor, _|
        create(:inventory_item_full, price: 10,     vendor: vendor)
        create(:inventory_item_full, price: 200000, vendor: vendor)
        create(:inventory_item_full, price: 5000,   vendor: vendor)
        create(:shipping_method_express, vendor: vendor)
        create(:shipping_method_normal, vendor: vendor)
      end
    end
  end
end