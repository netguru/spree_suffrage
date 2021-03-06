module Spree
  class PollAnswer < ActiveRecord::Base
    belongs_to :poll
    has_many :poll_votes, dependent: :destroy
    has_one :image, as: :viewable, class_name: "Spree::Image"
    accepts_nested_attributes_for :image
    #validates :answer, presence: true
    before_destroy :ensure_poll_answers_count

    def tally
      poll_votes.count
    end

    def image_for_form
      self.image || self.build_image
    end

    def vote_list_name
      if answer.empty?
        return image.attachment_file_name unless image.nil?
        'empty answer'
      else
        answer
      end
    end

    private
      def ensure_poll_answers_count
        return false if poll.poll_answers.count <= 2 # the count does not yet reflect this deletion
      end
  end
end
