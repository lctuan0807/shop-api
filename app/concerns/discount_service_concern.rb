module DiscountServiceConcern
  extend ActiveSupport::Concern

  private

  def validate_dates!
    return unless start_date && end_date

    return if start_date < end_date

    raise BadRequestError, "End date must be after start date"
  end

  def validate_products!
    return if product_ids.blank?

    missing_ids = product_ids - products.pluck(:id)
    return if missing_ids.empty?

    raise NotFoundError, "Products not found: #{missing_ids.join(', ')}"
  end

  def product_ids
    params[:product_ids]
  end

  def start_date
    return unless params.key?(:start_date)
    @start_date ||= parse_datetime(params[:start_date])
  end

  def end_date
    return unless params.key?(:end_date)
    @end_date ||= parse_datetime(params[:end_date])
  end

  def parse_datetime(value)
    return if value.blank?
    Time.zone.parse(value)
  end

  def discount_attributes
    params.except(:product_ids).compact
  end

  def discount_attributes_with_dates
    params.except(:product_ids).merge(
      start_date: start_date,
      end_date: end_date
    )
  end
end
