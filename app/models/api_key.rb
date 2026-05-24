class ApiKey < ApplicationRecord
  # enum :permissions, { read: "read", write: "write", admin: "admin" }

  AVAILABLE_PERMISSIONS = %w[
    read
    write
    admin
  ].freeze

  validates :key, presence: true, uniqueness: true
  validates :permissions, presence: true

  private

  def validate_permissions
    invalid_permissions = permissions - AVAILABLE_PERMISSIONS

    return if invalid_permissions.empty?

    errors.add(
      :permissions,
      "contains invalid permissions: #{invalid_permissions.join(', ')}"
    )
  end
end
