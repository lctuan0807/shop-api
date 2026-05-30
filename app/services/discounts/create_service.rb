module Discounts
  class CreateService
    def initialize(shop_id, params)
      @shop_id = shop_id
      @params = params
    end

    def call
      existing_discount = Discount.find_by(code: @params[:code], shop_id: @shop_id, is_active: true)
      raise BadRequestError, "Discount with this code already exists" if existing_discount

      Discount.create!(params_to_create)
    end

    private

    def params_to_create
      {}.tap do |h|
        h[:shop_id] = @shop_id
        h[:name] = @params[:name]
        h[:description] = @params[:description]
        h[:kind] = @params[:kind]
        h[:value] = @params[:value]
        h[:code] = @params[:code]
        h[:start_date] = @params[:start_date] ? Time.zone.strptime(@params[:start_date], "%d/%m/%Y %H:%M:%S") : nil
        h[:end_date] = @params[:end_date] ? Time.zone.strptime(@params[:end_date], "%d/%m/%Y %H:%M:%S") : nil
        h[:max_uses] = @params[:max_uses]
        h[:max_uses_per_user] = @params[:max_uses_per_user]
        h[:min_order_value] = @params[:min_order_value] || 0
        h[:max_order_value] = @params[:max_order_value]
        h[:is_active] = @params[:is_active] || true
        h[:applies_to] = @params[:applies_to]
        h[:product_ids] = @params[:applies_to] == 'specific_products' ? @params[:product_ids] : []
      end
    end
  end
end
