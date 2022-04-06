require 'rails_helper'

RSpec.describe 'the admin application show page' do
  it 'allows admin to approve a specific pet for adoption' do
    shelter = Shelter.create!(name: 'Save The Animals', city: 'Denver', rank: 4, foster_program: true)
    pet1 = Pet.create!(name: 'Joey', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    application = Application.create!(name: 'Andrew',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'In Progress',
    )

    visit "/applications/#{application.id}"
    fill_in 'Pets', with: "Joey"
    click_button "Search"
    expect(page).to have_link("Joey")
    click_button 'Adopt Joey'

    visit "/admin/applications/#{application.id}"
    expect(page).to have_content(application.name)
    expect(page).to have_content(pet1.name)

    click_button "Approve #{pet1.name}"
    expect(page).to_not have_content("Approve #{pet1.name}")
    expect(page).to have_content(pet1.name)

  end

  it 'allows admin to reject a specific pet for adoption' do
    shelter = Shelter.create!(name: 'Save The Animals', city: 'Denver', rank: 4, foster_program: true)
    pet1 = Pet.create!(name: 'Joey', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    application = Application.create!(name: 'Andrew',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'In Progress',
    )

    visit "/applications/#{application.id}"
    fill_in 'Pets', with: "Joey"
    click_button "Search"
    expect(page).to have_link("Joey")
    click_button 'Adopt Joey'

    visit "/admin/applications/#{application.id}"
    expect(page).to have_content(application.name)
    expect(page).to have_content(pet1.name)

    click_button "Reject #{pet1.name}"
    expect(page).to_not have_content("Approve #{pet1.name}")
    expect(page).to_not have_content("Reject #{pet1.name}")
    expect(page).to have_content("rejected")

  end

  it 'allows admin to reject a specific pet for adoption' do
    shelter = Shelter.create!(name: 'Save The Animals', city: 'Denver', rank: 4, foster_program: true)
    pet1 = Pet.create!(name: 'Joey', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    application = Application.create!(name: 'Andrew',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'In Progress',
    )
    application2 = Application.create!(name: 'Antonio',
      street_address: '100 Happy Valley',
      city: 'Orinda',
      state: 'CA',
      zipcode: '94207',
      description: 'Person all day',
      status: 'In Progress',
    )
    app_pet_1 = ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)
    app_pet_2 = ApplicationPet.create!(application_id: application2.id, pet_id: pet1.id)

    visit "/admin/applications/#{application.id}"
    expect(page).to have_content(application.name)
    expect(page).to have_content(pet1.name)

    click_button "Reject #{pet1.name}"
    expect(page).to_not have_content("Approve #{pet1.name}")
    expect(page).to_not have_content("Reject #{pet1.name}")
    expect(page).to have_content("rejected")

    visit "/admin/applications/#{application2.id}"
    expect(page).to have_content(application2.name)
    expect(page).to have_content(pet1.name)

    click_button "Reject #{pet1.name}"
    expect(page).to_not have_content("Approve #{pet1.name}")
    expect(page).to_not have_content("Reject #{pet1.name}")
    expect(page).to have_content("rejected")

  end

  it 'allows admin to reject a specific pet for adoption' do
    shelter = Shelter.create!(name: 'Save The Animals', city: 'Denver', rank: 4, foster_program: true)
    pet1 = Pet.create!(name: 'Joey', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    pet2 = Pet.create!(name: 'Parker', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    pet3 = Pet.create!(name: 'Amanda', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    application = Application.create!(name: 'Andrew',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'In Progress',
    )

    app_pet_1 = ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)
    app_pet_2 = ApplicationPet.create!(application_id: application.id, pet_id: pet2.id)
    app_pet_3 = ApplicationPet.create!(application_id: application.id, pet_id: pet3.id)

    visit "/admin/applications/#{application.id}"
    click_button "Approve #{pet1.name}"
    click_button "Approve #{pet2.name}"
    click_button "Approve #{pet3.name}"

    expect(page).to have_content("#{pet1.name} approved")
    expect(page).to have_content("#{pet2.name} approved")
    expect(page).to have_content("#{pet3.name} approved")
    expect(page).to have_content("Status: Approved")
  end
 
  it 'shows application as rejected if one or more pets is rejected' do
    shelter = Shelter.create!(name: 'Save The Animals', city: 'Denver', rank: 4, foster_program: true)
    pet1 = Pet.create!(name: 'Joey', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    pet2 = Pet.create!(name: 'Parker', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    pet3 = Pet.create!(name: 'Amanda', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    application = Application.create!(name: 'Andrew',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'In Progress',
    )

    app_pet_1 = ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)
    app_pet_2 = ApplicationPet.create!(application_id: application.id, pet_id: pet2.id)
    app_pet_3 = ApplicationPet.create!(application_id: application.id, pet_id: pet3.id)

    visit "/admin/applications/#{application.id}"
    click_button "Reject #{pet2.name}"
    click_button "Approve #{pet1.name}"
    click_button "Approve #{pet3.name}"

    # expect(current_path).to eq("/admin/applications/#{application.id}")
    expect(page).to have_content("Status: Rejected")
  end
 
  it 'remove approval button' do
    shelter = Shelter.create!(name: 'Save The Animals', city: 'Denver', rank: 4, foster_program: true)
    pet1 = Pet.create!(name: 'Joey', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    pet2 = Pet.create!(name: 'Parker', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    pet3 = Pet.create!(name: 'Amanda', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter.id)
    application1 = Application.create!(name: 'Andrew',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'Pending',
    )
    application2 = Application.create!(name: 'Antonio',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'Approved',
    )

    app_pet_1 = ApplicationPet.create!(application_id: application1.id, pet_id: pet1.id)
    app_pet_2 = ApplicationPet.create!(application_id: application1.id, pet_id: pet2.id)
    app_pet_3 = ApplicationPet.create!(application_id: application2.id, pet_id: pet1.id)
    app_pet_4 = ApplicationPet.create!(application_id: application2.id, pet_id: pet3.id)

    visit "/admin/applications/#{application1.id}"

    expect(page).to_not have_button("Approve #{pet1.name}")
    expect(page).to have_button("Reject #{pet1.name}")
    expect(page).to have_content("#{pet1.name} has been approved for adoption")
  end
end
# As a visitor
# When a pet has an "Approved" application on them
# And when the pet has a "Pending" application on them
# And I visit the admin application show page for the pending application
# Then next to the pet I do not see a button to approve them
# And instead I see a message that this pet has been approved for adoption
# And I do see a button to reject them