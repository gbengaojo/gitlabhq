class Spinach::Features::ProjectFeature < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedProject
  include SharedPaths

  step 'change project settings' do
    fill_in 'project_name', with: 'NewName'
    uncheck 'project_issues_enabled'
  end

  step 'I save project' do
    click_button 'Save changes'
  end

  step 'I should see project with new settings' do
    find_field('project_name').value.should == 'NewName'
    find('#project_issues_enabled').should_not be_checked
    find('#project_merge_requests_enabled').should be_checked
  end

  step 'change project path settings' do
    fill_in "project_path", with: "new-path"
    click_button "Rename"
  end

  step 'I should see project with new path settings' do
    project.path.should == "new-path"
  end

  step 'I fill in merge request template' do
    fill_in 'project_merge_requests_template', with: "This merge request should contain the following."
  end

  step 'I should see project with merge request template saved' do
    find_field('project_merge_requests_template').value.should == 'This merge request should contain the following.'
  end

  step 'I should see project "Shop" README link' do
    within '.project-side' do
      page.should have_content "README.md"
    end
  end

  step 'I should see project "Shop" version' do
    within '.project-side' do
      page.should have_content "Version: 6.7.0.pre"
    end
  end

  step 'change project default branch' do
    select 'fix', from: 'project_default_branch'
    click_button 'Save changes'
  end

  step 'I should see project default branch changed' do
    find(:css, 'select#project_default_branch').value.should == 'fix'
  end

  step 'I select project "Forum" README tab' do
    click_link 'Readme'
  end

  step 'I should see project "Forum" README' do
    page.should have_link "README.md"
    page.should have_content "Sample repo for testing gitlab features"
  end

  step 'I should see project "Shop" README' do
    page.should have_link "README.md"
    page.should have_content "testme"
  end
end
