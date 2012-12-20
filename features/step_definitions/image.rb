Given /^there exists an image$/ do
  stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
  @image = FactoryGirl.create(:image)
end

Given /^I am on the edit page for the image$/ do
  port = Capybara.current_session.driver.app_server.port
  visit edit_admin_image_url(@image, subdomain: :admin, host: 'lvh.me', port: port)
end

Given /^there exist (\d+) images$/ do |n|
  stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
  @images = FactoryGirl.create_list(:image, n.to_i)
end

Given /^I am on the (\w+) (\w+) page$/ do |action, collection|
  visit url_for(action: action,
                controller: "admin/#{collection.pluralize}",
                subdomain: :admin,
                port: Capybara.current_session.driver.app_server.port,
                host: 'lvh.me')
end

When /^I attach an image file$/ do
  begin
    attach_file 'image_original', File.join('lib', 'sample-images', 'pikachu.png')
  rescue Capybara::Poltergeist::ObsoleteNode
    # https://github.com/jonleighton/poltergeist/issues/115
    nil
  end
end

When /^I start the upload$/ do
  @stub = stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
  click_button "Start"
  wait_until(60) { find('.template-download .name') rescue nil }
end

Then /^it should contain the file$/ do
  Image.where(original_file_name: 'pikachu.png').should have(1).model
end

Then /^the image file should be uploaded to S3$/ do
  @stub.should have_been_requested.times(6)
end

Then /^it should not show an upload error$/ do
  expect { find('.template-download .error') }.to raise_error(Capybara::ElementNotFound)
end

Then /^I should see a listing of images sorted by creation date$/ do
  Image.order("created_at DESC").each_with_index do |image, i|
    page.find("tr:nth-child(#{i + 1})").text
      .should include(image.original_file_name)
  end
end

Then /^they should have the thumbnail versions$/ do
  @images.each do |image|
    expect {page.find("tr img[src=#{image.original.url(:thumb_rect)}]")}
      .not_to raise_error(Capybara::ElementNotFound)
  end
end

Then /^they should have links to image edit pages$/ do
  @images.each do |image|
    row = page.find("tr#image_#{image.id}")
    row.should have_link(image.original_file_name,
                         href: edit_admin_image_path(image))
  end
end

Then /^they should have links to delete images$/ do
  @images.each do |image|
    row = page.find("tr#image_#{image.id}")
    row.should have_link('Delete', href: admin_image_path(image))
  end
end

Then /^I should see the fields with image information$/ do
  find_field('Caption').value.should == @image.caption
  find_field('Location').value.should == @image.location
  find_field('image_created_at_1i').value.should == @image.created_at.year.to_s
  find_field('image_created_at_2i').value.should == @image.created_at.month.to_s
  find_field('image_created_at_3i').value.should == @image.created_at.day.to_s
end

When /^I make valid changes to the image$/ do
  @image.caption = "Ash goes into hiding in Johto."
  @image.location = "Mt. Silver"

  fill_in 'Caption', with: @image.caption
  fill_in 'Location', with: @image.location
end

Then /^the image should have the correct properties$/ do
  image = Image.find(@image.id)
  image.caption.should == @image.caption
  image.location.should == @image.location
  image.created_at.should == @image.created_at
end
