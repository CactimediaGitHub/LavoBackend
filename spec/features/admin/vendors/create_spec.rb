require "rails_helper"

feature 'Create new Vendor' do
  let(:image1) { uploaded_file('avatar.jpg') }
  let(:image2) { uploaded_file('laundry.jpg') }

  before(:each) do
    visit new_admin_vendor_path
  end

  scenario 'user can create new Vendor' do
    fill_in 'vendor[email]', with: 'vendor@ex.com'
    fill_in 'vendor[name]', with: 'Vendor Name'
    fill_in 'vendor[phone]', with: '1234567890'
    fill_in 'vendor[address]', with: 'Vendor Adress'
    find(:css, '#vendor_activated').click
    fill_in 'vendor[password]', with: 'password11'
    fill_in 'vendor[password_confirmation]', with: 'password11'
    attach_file('images1', image1.path)
    attach_file('images2', image2.path)
    find('input[type="submit"]').click

    expect(page).to have_content('Vendor was successfully created.')
    expect(page).to have_content 'New vendor'
    expect(page).to have_content 'vendor@ex.com'
    expect(Vendor.last.images.map {|im| im.file.file }.uniq.count).to eq 2
  end
end
