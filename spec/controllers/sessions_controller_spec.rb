require 'spec_helper'

describe SessionsController do
  render_views
  
  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
  end
  
  describe "POST 'create'" do
    describe "failed sign-in form submission" do

      before(:each) do
        @attr = {:email => "", :password => ""}
      end

      it "should render the new page" do
         post :create, :session => @attr
         response.should render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Sign in")
      end
      
      it "should have an error message" do
        post :create, :session =>@attr
        flash.now[:error].should =~ /invalid/i
      end

    end
    
    describe "successful signin" do

      before(:each) do
        tempUser = {:name => "John Doe", :email => "jdoe@example.com"}
        @user = User.create!(tempUser)
        @attr = {:email => "jdoe@example.com"}
      end

      it "should sign in the user" do
          post :create, :session => @attr
          controller.current_user.should == @user
          #controller.should be_signed_in
      end

      it "should display the user profile (i.e., the user 'show' page)" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end

    end

  end
  
  describe "DELETE 'destroy'" do
    before(:each) do
        tempUser = {:name => "John Doe", :email => "jdoe@example.com"}
        @user = User.create!(tempUser)
        @attr = {:email => "jdoe@example.com"}
    end
    
    it "should sign a user out" do
      controller.sign_in(@user)
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end

end
