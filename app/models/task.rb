# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :assigned_user, foreign_key: "assigned_user_id", class_name: "User"
  before_validation :set_title, if: :title_not_present
  before_validation :print_set_title
  validates :title, presence: true, length: { maximum: 125 }
  validates :slug, uniqueness: true
  validate :slug_not_changed

  before_create :set_slug
  # before_save :change_title

  private

    def set_title
      self.title = "Pay electricity bill"
    end

    def print_set_title
      puts self.title
    end

    def title_not_present
      self.title.blank?
    end

    def change_title
      self.title = "Pay electricity & TV bill"
    end

    def set_slug
      title_slug = title.parameterize
      regex_pattern = "slug #{Constants::DB_REGEX_OPERATOR} ?"
      latest_task_slug = Task.where(
        regex_pattern,
        "#{title_slug}$|#{title_slug}-[0-9]+$"
      ).order(slug: :desc).first&.slug
      slug_count = 0
      if latest_task_slug.present?
        slug_count = latest_task_slug.split("-").last.to_i
        only_one_slug_exists = slug_count == 0
        slug_count = 1 if only_one_slug_exists
      end
      slug_candidate = slug_count.positive? ? "#{title_slug}-#{slug_count + 1}" : title_slug
      self.slug = slug_candidate
    end

    def slug_not_changed
      if slug_changed? && self.persisted?
        errors.add(:slug, t("task.slug.immutable"))
      end
    end
end
