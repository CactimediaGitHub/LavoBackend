require "rails_helper"

feature 'Show Vendor' do
  let!(:vendor) { create(:vendor, images: [uploaded_file('png.png'), uploaded_file('png1.png'), uploaded_file('avatar.jpg')]) }

  before do
    visit admin_vendor_path(vendor)
  end

  scenario 'user can delete images one by one from Vendor' do
    click_link_or_button 'images_0'

    expect(page).to have_content('Image was successfully destroyed.')
    expect(vendor.reload.images.count) == 2
  end

  let!(:vendor2) { create(:vendor, images: [uploaded_file('png.png')]) }

  before do
    visit admin_vendor_path(vendor2)
  end

  scenario 'user can delete the last one image from Vendor' do
    click_link_or_button 'images_0'

    expect(page).to have_content('Image was successfully destroyed.')
    expect(vendor2.reload.images.empty?).to be_truthy
  end
end
