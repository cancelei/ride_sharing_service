class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]

    # Basic phone number format validation
    unless value.match?(/\A\+?[\d\s-]{10,}\z/)
      record.errors.add(attribute, options[:message] || "is not a valid phone number")
    end
  end
end
