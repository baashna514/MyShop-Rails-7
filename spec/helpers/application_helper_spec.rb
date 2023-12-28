require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context "#flash_class" do
    it "returns 'alert-success' for 'success' type" do
      expect(helper.flash_class('success')).to eq('alert-success')
    end

    it "returns 'alert-danger' for 'error' type" do
      expect(helper.flash_class('error')).to eq('alert-danger')
    end

    it "returns 'alert-type' for unknown type" do
      expect(helper.flash_class('custom')).to eq('alert-custom')
    end
  end

  context "#cart_counter" do
    it "calls Cart.cart_counter with the provided user_id" do
      user = create(:user)
      allow(Cart).to receive(:cart_counter).with(user.id)
      helper.cart_counter(user.id)
      expect(Cart).to have_received(:cart_counter).with(user.id)
    end
  end

  context '#admin' do
    it 'returns true if the user is an admin' do
      user = create(:user, admin: true)
      expect(helper.admin(user.id)).to be_truthy
    end

    it 'returns false if the user is not an admin' do
      user = create(:user, admin: false)
      expect(helper.admin(user.id)).to be_falsy
    end
  end
end
