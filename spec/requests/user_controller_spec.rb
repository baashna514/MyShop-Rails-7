require 'rails_helper'

RSpec.describe UserController, type: :controller do

  describe 'Login form show' do
    it 'should return 200 response' do
      get :user_login
      expect(response).to have_http_status(200)
      expect(response).to render_template('users/login')
    end
  end


  describe 'POST #check_credentials' do
    let(:valid_user) { create(:user, email: 'users@example.com', password: 'password') }

    context 'with valid credentials' do
      it 'should logs in the users and redirects to root_path' do
        post :check_credentials, params: { email: valid_user.email, password: 'password' }

        expect(session[:user_id]).to eq(valid_user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to be_present
      end

      it 'should logs admin users in and redirects to admin_dashboard_path' do
        valid_user.update(admin: true)

        post :check_credentials, params: { email: valid_user.email, password: 'password' }

        expect(session[:user_id]).to eq(valid_user.id)
        expect(response).to redirect_to(admin_dashboard_path)
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'should redirects to login_path with an error message' do
        post :check_credentials, params: { email: 'invalid@example.com', password: 'invalid' }

        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(login_path)
        expect(flash[:error]).to be_present
      end
    end
  end



  describe 'GET #logout' do
    context 'when users is logged in' do
      let(:user) { create(:user) }
      before do
        session[:user_id] = user.id
      end

      it 'should logs the logout action' do
        expect(UserActivityLoggerJob).to receive(:perform_later).with(user.id, 'Logout Action')
        get :logout
      end

      it 'should logs out the users and redirects to root_path' do
        get :logout
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to be_present
      end
    end
  end



  describe 'GET #profile' do
    context 'when users is logged in' do
      let(:user) { create(:user) }
      let(:orders) { create_list(:order, 3, user: user) }

      before do
        session[:user_id] = user.id
      end

      it 'should should assigns the users and their orders and renders the profile template' do
        get :profile
        expect(assigns(:user)).to eq(user)
        expect(assigns(:orders)).to eq(orders)
        expect(response).to render_template('users/profile')
      end
    end

    context 'when users is not logged in' do
      it 'should redirects to login_path with an error message' do
        get :profile
        expect(response).to redirect_to(login_path)
        expect(flash[:error]).to be_present
      end
    end

  end




  describe 'GET #edit_profile' do
    context 'when users is logged in' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'should assigns the users and renders the edit template' do
        get :edit_profile
        expect(assigns(:user)).to eq(user)
        expect(response).to render_template('users/edit')
      end
    end

    context 'when users is not logged in' do
      it 'should redirects to login_path with an error message' do
        get :edit_profile
        expect(response).to redirect_to(login_path)
        expect(flash[:error]).to be_present
      end
    end
  end



  describe 'PATCH #update_profile' do
    context 'when users is logged in' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      context 'with valid parameters' do
        it 'should updates the users profile and redirects to user_profile_path' do
          post :update_profile, params: { id: user.id, user: { name: 'Updated Name' } }
          user.reload
          expect(user.name).to eq('Updated Name')
          expect(response).to redirect_to(user_profile_path)
          expect(flash[:success]).to be_present
        end
      end

      context 'with invalid parameters' do
        it 'does not update the users profile and redirects to edit_profile_path' do
          post :update_profile, params: { id: user.id, user: { email: 'invalid_email' } }
          expect(response).to redirect_to(edit_profile_path)
          expect(flash[:error]).to be_present
        end
      end
    end

    context 'when users is not logged in' do
      it 'should redirects to login_path with an error message' do
        post :update_profile, params: { id: 1, user: { name: 'Updated Name' } }
        expect(response).to redirect_to(login_path)
        expect(flash[:error]).to be_present
      end
    end
  end


  describe 'GET #sign_up_form' do
    it 'should renders the sign up form template and assigns a new users' do
      get :sign_up_form
      expect(response).to render_template('users/signup')
      expect(assigns(:user)).to be_a_new(User)
    end
  end




  describe 'POST #create_user' do
    let(:valid_user_params) { attributes_for(:user) }

    context 'with valid parameters' do
      it 'should creates a new users, sends a welcome email, and redirects to login_path' do
        expect do
          post :create_user, params: { user: valid_user_params }
        end.to change(User, :count).by(1)
        user = User.last
        expect(user.email).to eq(valid_user_params[:email])

        expect(response).to redirect_to(login_path)
        expect(flash[:success]).to be_present
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not should create a new users and redirects to sign_up_path with an error message' do
        invalid_user_params = { email: 'invalid_email' }

        expect do
          post :create_user, params: { user: invalid_user_params }
        end.not_to change(User, :count)

        expect(response).to redirect_to(sign_up_path)
        expect(flash[:error]).to be_present
      end
    end
  end


  describe 'GET #new_password_reset' do
    it 'should renders the password reset form template' do
      get :new_password_reset
      expect(response).to render_template('users/reset/new')
    end
  end


  describe 'POST #create_password_reset' do
    let(:user) { create(:user) }
    let(:valid_email_params) { { email: user.email } }
    let(:invalid_email_params) { { email: 'nonexistent@example.com' } }

    context 'with valid email' do
      it 'should generates a password reset token, sends an email, and redirects to root_path' do
        post :create_password_reset, params: { email: user.email }

        user.reload
        expect(user.reset_password_token).to be_present
        expect(ActionMailer::Base.deliveries.count).to eq(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid email' do
      it 'does not generate a password reset token and redirects to new_password_reset_path with an error message' do
        post :create_password_reset, params: { email: 'nonexistent@example.com' }

        expect(user.reload.reset_password_token).to be_nil
        expect(ActionMailer::Base.deliveries.count).to eq(0)

        expect(response).to redirect_to(new_password_reset_path)
        expect(flash[:error]).to be_present
      end
    end
  end



  describe 'GET #edit_password_reset' do
    let(:user) { create(:user, reset_password_token: SecureRandom.urlsafe_base64) }
    let(:expired_user) { create(:user, reset_password_token: SecureRandom.urlsafe_base64, reset_password_sent_at: 2.days.ago) }

    context 'with valid token and not expired' do
      it 'should assigns the users and renders the edit_password_reset template' do
        get :edit_password_reset, params: { token: user.reset_password_token }
        expect(assigns(:user)).to eq(user)
        expect(response).to render_template('users/reset/edit_password_reset')
      end
    end

    context 'with expired token' do
      it 'should redirects to new_password_reset_path with an error message' do
        get :edit_password_reset, params: { token: expired_user.reset_password_token }
        expect(response).to redirect_to(new_password_reset_path)
        expect(flash[:error]).to be_present
        expect(response).not_to render_template('users/reset/edit_password_reset')
      end
    end

    context 'with invalid token' do
      it 'should redirects to new_password_reset_path with an error message' do
        get :edit_password_reset, params: { token: 'invalid_token' }
        expect(response).to redirect_to(new_password_reset_path)
        expect(flash[:error]).to be_present
      end
    end
  end



  describe 'PATCH #update_password_reset' do
    let(:user) { create(:user, reset_password_token: SecureRandom.urlsafe_base64) }
    let(:expired_user) { create(:user, reset_password_token: SecureRandom.urlsafe_base64, reset_password_sent_at: 2.days.ago) }

    context 'with valid token and not expired' do
      it 'should updates the users password and redirects to login_path' do
        new_password = 'new_password'
        patch :update_password_reset, params: { token: user.reset_password_token, user: { password: new_password } }
        user.reload
        expect(user.authenticate(new_password)).to eq(user)
        expect(response).to redirect_to(login_path)
        expect(flash[:success]).to be_present
      end
    end

    context 'with expired token' do
      it 'should renders the edit_password_reset template with an error message' do
        patch :update_password_reset, params: { token: expired_user.reset_password_token, user: { password: 'new_password' } }
        expect(response).to render_template(:edit_password_reset)
        expect(flash[:error]).to be_present
      end
    end

    context 'with invalid token' do
      it 'should renders the edit_password_reset template with an error message' do
        patch :update_password_reset, params: { token: 'invalid_token', user: { password: 'new_password' } }
        expect(response).to render_template(:edit_password_reset)
        expect(flash[:error]).to be_present
      end
    end

    context 'with invalid password' do
      it 'should renders the edit_password_reset template with an error message' do
        patch :update_password_reset, params: { token: user.reset_password_token, user: { password: 'short' } }
        expect(response).to render_template(:edit_password_reset)
        expect(flash[:error]).to be_present
      end
    end
  end




end
