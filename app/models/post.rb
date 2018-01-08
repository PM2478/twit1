class Post < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 100} # Questions are capped at 100 chars.
  validates :post_is_unique,presence: true
  
    private
  
    def post_is_unique
      # Select all posts where the id does not match current id and fetch the contents
      other_post_contents = self.class.where.not(id: id).pluck(:content)
      # Split each content by space (**NOTE:** Other data cleaning may be needed -- remove non-alphanumeric characters)
      other_post_contents = other_post_contents.map{ |c| c.split(" ").uniq }
      # Now we need to compare the current content with all the other contents and see if they match
      current_content = content.split(" ").uniq
      other_post_contents.each do |other_content|
        # words in common
        common_words = other_content & current_content
        # If the ratio of common words exceeds 0.8 (80%)
        if (common_words.length / other_content.length) > 0.8
          # Add an error and exit early
          errors.add(:base, "current review is too similar to another review")
          return false
        end
      end
    end
  end
