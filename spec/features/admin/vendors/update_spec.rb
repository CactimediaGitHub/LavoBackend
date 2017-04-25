require "rails_helper"

feature 'Create new Vendor' do
  let!(:vendor) { create(:vendor, images: [uploaded_file('png.png'), uploaded_file('png1.png')]) }
  let!(:image1) { uploaded_file('avatar.jpg', "image/jpeg") }
  let!(:image2) { uploaded_file('laundry.jpg', "image/jpeg") }

  before(:each) do
    visit edit_admin_vendor_path(vendor)
  end

  scenario 'user can add more images to Vendor' do
    attach_file('images2', image1.path)
    attach_file('images3', image2.path)
    find('input[type="submit"]').click

    expect(page).to have_content('Vendor was successfully updated.')
    expect(vendor.reload.images.count) == 4
  end
end
