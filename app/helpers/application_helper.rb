module ApplicationHelper

  def flash_class(type)
    case type
    when 'success' then 'alert-success'
    when 'error' then 'alert-danger'
    when 'notice' then 'alert-success'
    when 'alert' then 'alert-danger'
    else
      "alert-#{type}"
    end
  end

  def cart_counter(user_id)
    Cart.cart_counter(user_id)
  end

  def admin?(user)
    user && user.admin?
  end

end
