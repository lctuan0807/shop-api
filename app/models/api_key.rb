class ApiKey < ApplicationRecord
  AVAILABLE_PERMISSIONS = %w[
    read
    write
    editor
    admin
  ].freeze

  validates :key, presence: true, uniqueness: true
  validates :permissions, presence: true

  validate :validate_permissions

  private

  def validate_permissions
    invalid_permissions = Array(permissions) - AVAILABLE_PERMISSIONS

    return if invalid_permissions.empty?

    errors.add(
      :permissions,
      "contains invalid permissions: #{invalid_permissions.join(', ')}"
    )
  end
end
